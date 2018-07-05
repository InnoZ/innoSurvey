require 'optparse'
require 'rqrcode'
require 'fileutils'
require 'ruby-progressbar'
require 'encrypt_decrypt'

module PDFGenerator
  class << self
    # GENERATE QR CODE
    def gen_qrcode(**args)
      qr_content = "https://survey.innoz.space/surveys/#{args[:survey]}?uuid=#{args[:uuid]}&role_id=#{args[:role_id]}&token=#{args[:uuid].encrypt}"
      qr = RQRCode::QRCode.new(qr_content, level: :h, mode: :byte_8bit)
      qr.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 5)
    end

    include ActionView::Helpers
    def styling(background_image_path)
      <<-EOF
    <style>
      body {
        background-image: url("#{background_image_path}");
        background-repeat: no-repeat;
        background-size: 118mm 118mm;
        width: 118mm;
        height: 118mm;
        margin: 0;
      }
      .qr-code > img {
        height: 38mm;
        width: 38mm;
        margin-top: 60mm;
        margin-left: 40mm;
      }
      .qr-code > .id {
        margin-top: 3mm;
        text-align: center;
      }
    </style>
      EOF
    end

    def qr_code(**opts)
      <<-EOF
      <div class="qr-code">
        <div class"heading-url">
        </div>
        <div class="qr-code">
          <img src="#{opts[:path_to_qr_svg]}"></img>
          <!-- <div class='id'>Deine ID: #{opts[:uuid]}</div> -->
        </div>
      </div>
      EOF
    end

    def gen_html_back(**args)
      # layout_path = "#{Rails.root}/public/#{args[:layout]}_back.svg"
      layout_path = args[:layouts][:layout_back].path
      <<-EOF
      <html>
        <head>
        #{styling(layout_path)}
        </head>
        <body>
        #{qr_code(args)}
        </body>
      </html>
      EOF
    end

    def gen_html_front(**args)
      layout_path = args[:layouts][:layout_front].path
      <<-EOF
      <html>
        <head>
        #{styling(layout_path)}
        </head>
        <body>
        </body>
      </html>
      EOF
    end

    # HTML templating
    # def gen_qr_pdf(role_id:, uuid:, id:, path:)
    def gen_qr_pdf(**args)
      file_path = args[:path] + args[:id].to_s

      opts = {
        role_id: args[:role_id],
        layouts: args[:layouts],
        uuid: args[:uuid],
        id: args[:id],
        path_to_qr_svg: file_path + '.svg'
      }

      # Generate and write intermediate QR code
      svg = gen_qrcode(**args)
      File.open(file_path + '.svg', 'w') do |f|
        f.write(svg)
        f.close
      end

      %w[front back].each do |site|
        # Generate HTML template
        html = send("gen_html_#{site}", **opts)
        File.open(file_path + "_#{site}.html", 'w') do |f|
          f.write(html)
          f.close
        end

        # Generate PDF
        pdf = WickedPdf.new.pdf_from_html_file(file_path + "_#{site}.html", {
          margin: { top: 0, bottom: 0, left: 0, right: 0 },
          page_height: 118,
          page_width: 118
        })
        File.open(file_path + "_#{site}.pdf", 'w:ASCII-8BIT') do |f|
          f << pdf
        end
      end
    end
  end
end

class QRCodeExporter
  attr_accessor :role_qr_setup, :survey, :filepath, :merged_file_path, :merged_file_name, :merged_full_path

  def initialize(**args)
    @role_qr_setup= args[:role_qr_setup]
    @survey = args[:survey]
    @merged_file_path = Rails.root.to_s + '/tmp/cache/qr_codes/'
    @merged_file_name = "survey_#{survey}_#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}.pdf"
    @merged_full_path = merged_file_path + merged_file_name
  end

  def export
    # CREATE FOLDER BASED ON UNIX TIMESTAMP
    merged_pdf = CombinePDF.new

    role_qr_setup.each do |role_id, role_qr_params|
      iterations = role_qr_params[:iterations]
      layouts = {
        layout_front: role_qr_params[:layout_front],
        layout_back: role_qr_params[:layout_back]
      }
      path = FileUtils::mkdir_p(Rails.root.to_s + "/tmp/cache/qr_codes/survey_#{survey}_role_#{role_id}_#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}/").first

      # GENERATE N QR_CODES PER ROLE
      begin
        iterations.to_i.times do |i|
          # Generate gr code per Role
          PDFGenerator.gen_qr_pdf({
            layouts: layouts,
            survey: survey,
            role_id: role_id.to_i,
            uuid: SecureRandom.urlsafe_base64(6),
            id: i,
            path: path
          })

          merged_pdf << CombinePDF.load(path + i.to_s + '_front.pdf')
          merged_pdf << CombinePDF.load(path + i.to_s + '_back.pdf')
        end
        # SAVE MERGED PDF
        merged_pdf.save(merged_full_path)
      ensure
        # CLEANUP
        FileUtils.rm_rf path
      end
    end
    merged_pdf
  end
end
