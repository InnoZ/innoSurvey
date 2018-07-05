class SurveysController < ApplicationController
  before_action :set_survey, only: [:ident, :setup_qr_codes_export, :export]

  def index
    @surveys = Survey.all
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def ident
    @stations = @survey.stations.all.map do |s|
      {
        id: s.id,
        name: s.name,
        topics: s.topics.map(&:to_json)
      }
    end
  end

  def setup_qr_codes_export
  end

  def export
    require 'qr_code_export'

    qr_exporter = QRCodeExporter.new({ role_qr_setup: export_setup_params, survey: @survey.id })
    begin
      qr_exporter.export
      serve qr_exporter
    rescue
      flash[:error] = "Something went wrong! Please check that you've supplied a valid front and back layout for each role you want to have QR codes exported"
      redirect_to :setup_qr_codes_export
    end
  end

  private

  def serve(qr_exporter)
    file = qr_exporter.merged_full_path
    File.open(file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => qr_exporter.merged_file_name, :type => "application/pdf", :disposition => "attachment"
    end
    File.delete(file)
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def export_setup_params
    # Skip validations, simply pass ActionDispatch::HTTP::FileUpload objects
    export_params = params.require(:survey).permit('roles' => {}).to_h
    export_params["roles"]
  end
end
