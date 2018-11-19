require 'optparse'
require 'rqrcode'
require 'fileutils'
require 'ruby-progressbar'
# require 'config/initializers/string'

desc 'Generate set of n QR codes'
task gen_qr_codes: :environment do
  ARGUMENTS = {
    iterations: 2,
    layout: 'innoz_feedback_feedback_energie',
    role: 1,
    survey: 3
  }.freeze

  o = OptionParser.new
  o.banner = 'Usage: rake gen_qr_codes -- [options]'
  o.on('-i ARG', '--iterations ARG', Integer) { |iterations| ARGUMENTS[:iterations] = iterations.to_i }
  args = o.order!(ARGV) {}
  o.parse!(args)

  # GENERATE QR CODE
  def gen_qrcode(**args)
    qr_content = "https://survey.innoz.space/surveys/#{ARGUMENTS[:survey]}?uuid=#{args[:uuid]}&role_id=#{args[:role_id]}&token=#{args[:uuid].encrypt}"
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

  def gen_html_back(**opts)
    layout_path = "#{Rails.root}/public/#{ARGUMENTS[:layout]}_back.svg"
    <<-EOF
      <html>
        <head>
        #{styling(layout_path)}
        </head>
        <body>
        #{qr_code(opts)}
        </body>
      </html>
    EOF
  end

  def gen_html_front(**_opts)
    layout_path = "#{Rails.root}/public/#{ARGUMENTS[:layout]}_front.svg"
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
  def gen_qr_pdf(role_id:, uuid:, id:, path:)
    file_path = path + id.to_s
    opts = {
      role_id: role_id,
      uuid: uuid,
      id: id,
      path_to_qr_svg: file_path + '.svg'
    }

    # Generate and write intermediate QR code
    svg = gen_qrcode(**opts)
    File.open(file_path + '.svg', 'w') do |f|
      f.write(svg)
      f.close
    end

    %w[front back].each do |site|
      # Generate HTML template
      html = FileUtils.send("gen_html_#{site}", **opts)
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

  # CREATE FOLDER BASED ON UNIX TIMESTAMP
  path = FileUtils::mkdir_p(Rails.root.to_s + "/tmp/cache/qr_codes/#{ARGUMENTS[:layout]}_survey_#{ARGUMENTS[:survey]}_role_#{ARGUMENTS[:role]}_#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}/").first

  # GENERATE N QR_CODES PER ROLE
  i = 0
  n = ARGUMENTS[:iterations]

  begin
    progressbar = ProgressBar.create(format: "%a %b\u{15E7}%i %p%% %t",
                                     progress_mark: ' ',
                                     remainder_mark: "\u{FF65}",
                                     total: n)

    merged_pdf = CombinePDF.new
    n.times do
      i += 1
      # Increment progressbar
      progressbar.increment

      # Generate gr code per Role
      gen_qr_pdf(role_id: ARGUMENTS[:role],
                 uuid: SecureRandom.urlsafe_base64(6),
                 id: i,
                 path: path)

      merged_pdf << CombinePDF.load(path + i.to_s + '_front.pdf')
      merged_pdf << CombinePDF.load(path + i.to_s + '_back.pdf')
    end
    merged_pdf.save path + "/#{ARGUMENTS[:layout]}.pdf"
  end
end
