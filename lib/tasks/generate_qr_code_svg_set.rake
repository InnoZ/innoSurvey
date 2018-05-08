require 'optparse'
require 'rqrcode'
require 'fileutils'
require 'ruby-progressbar'

desc 'Generate set of n QR codes'
task gen_qr_codes: :environment do
  arguments = {
    iterations: 3
  }
  o = OptionParser.new

  o.banner = 'Usage: rake gen_qr_codes -- [options]'
  o.on('-i ARG', '--iterations ARG', Integer) { |iterations| arguments[:iterations] = iterations.to_i }

  args = o.order!(ARGV) {}
  o.parse!(args)

  # GENERATE QR CODE
  def gen_qrcode(**args)
    qr_content = {
      uuid: args[:uuid],
      role_id: args[:role_id]
    }.to_json

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
        background-size: 110mm 110mm;
        width: 110mm;
        height: 110mm;
      }
      .qr-code > img {
        height: 30mm;
        width: 30mm;
        margin-top: 45mm;
        margin-left: 39mm;
      }
      .qr-code > .id {
        margin-top: 3mm;
        text-align: center;
      }
    </style>
    EOF
  end

  def qr_code(**opts)
    role = Role.find(opts[:role_id])

    <<-EOF
      <div class="qr-code">
        <div class"heading-url">
        </div>
        <div class="qr-code">
          <img src="#{opts[:path_to_qr_svg]}"></img>
          <div class='id'>Deine ID: #{opts[:uuid]}</div>
        </div>
      </div>
    EOF
  end

  def gen_html_front(**opts)
    <<-EOF
      <html>
        <head>
        #{styling(Rails.root.to_s + "/public/qr_code_layout_front.png")}
        </head>
        <body>
        #{qr_code(opts)}
        </body>
      </html>
    EOF
  end


  def gen_html_back(**opts)
    <<-EOF
      <html>
        <head>
        #{styling(Rails.root.to_s + "/public/qr_code_layout_back.png")}
        </head>
        <body>
        </body>
      </html>
    EOF
  end

  # HTML templating
  def gen_qr_pdf(role_id:, uuid:, id:, base_path:)
    file_path = base_path + id.to_s
    opts = {
      role_id: role_id,
      uuid: uuid,
      id: id,
      path_to_qr_svg: file_path + '.svg',
      path_to_html: file_path + '.html'
    }

    # Generate and write intermediate QR code
    svg = gen_qrcode(**opts)
    svg_file = File.open(file_path + '.svg', 'w') do |f|
      f.write(svg)
      f.close
    end

    # Generate HTML template
    File.open(file_path + '_front.html', 'w') do |f|
      f.write(gen_html_front(**opts))
      f.close
    end

    # Generate PDF
    pdf = WickedPdf.new.pdf_from_html_file(file_path + '_front.html', {
      margin:  { top: 3, bottom: 3, left: 3, right: 3 },
      page_height: 118,
      page_width: 118,
    })
    File.open(file_path + '_front.pdf', 'w:ASCII-8BIT') do |f|
      f << pdf
    end

    # Generate HTML template
    File.open(file_path + '_back.html', 'w') do |f|
      f.write(gen_html_back(**opts))
      f.close
    end

    # Generate PDF
    pdf = WickedPdf.new.pdf_from_html_file(file_path + '_back.html', {
      margin:  { top: 3, bottom: 3, left: 3, right: 3 },
      page_height: 118,
      page_width: 118,
    })
    File.open(file_path + '_back.pdf', 'w:ASCII-8BIT') do |f|
      f << pdf
    end
  end

  # CREATE FOLDER BASED ON UNIX TIMESTAMP
  base_path = FileUtils::mkdir_p(Rails.root.to_s + "/tmp/cache/qr_codes/#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}/").first

  # GENERATE N QR_CODES PER ROLE
  i = 0
  n = arguments[:iterations]

  begin
    progressbar = ProgressBar.create(format: "%a %b\u{15E7}%i %p%% %t",
                                     progress_mark: ' ',
                                     remainder_mark: "\u{FF65}",
                                     total: n * Role.count)

    Role.all.each do |role|
      n.times do
        # Increment progressbar
        progressbar.increment

        # Create subdirectory for each role
        role_path = FileUtils::mkdir_p(base_path + "/#{role.name}/").first

        # Generate gr code per Role
        gen_qr_pdf(role_id: role.id,
                   uuid: SecureRandom.urlsafe_base64(7),
                   id: i += 1,
                   base_path: role_path)
      end
    end
    p "#{n * Role.count} QR-Codes generated. Find them in #{base_path}"
  rescue
    p 'Something went wrong!'
  end
end
