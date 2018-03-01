desc "Generate set of n QR codes"
task :gen_qr_codes do
  # Controller
  require "rqrcode"

  # GENERATE QR CODE
  def gen_qrcode(**args)
    qr_content = {
      uuid: args[:uuid],
      role_id: args[:role_id]
    }.to_json

    qr = RQRCode::QRCode.new(qr_content, level: :h, mode: :byte_8bit)

    qr.as_svg(
      offset: 0, color: '000', 
      shape_rendering: 'crispEdges', 
      module_size: 11
    )
  end

  def styling
    <<-EOF
    <style>
    </style>
    EOF
  end

  def qr_code(**opts)
    role = Role.find(opts[:role_id])

    <<-EOF
      <div class="qr-code">
        <div class"heading-url">
          <h3>https://survey.innoz.space</h3>
        </div>
        <div class="image">
          <img src="#{opts[:path_to_qr_svg]}"></img>
        </div>
        <div class"footer">
          <table>
            <tr>
              <td class="qr-footer-descr-cell"><strong>Deine Rolle</strong></td>
              <td> #{role.name}</td>
            </tr>
          </table>
        </div>
      </div>
    EOF
  end


  def gen_html(**opts)
    <<-EOF
      <html>
      <head>
      #{styling}
      </head>
      <body>
      #{qr_code(opts)}
      </body>
      </html>
    EOF


  end

  # HTML templating
  def gen_qr_pdf(role_id:, uuid:, id:)
    begin
      path = Rails.root.to_s + "/tmp/cache/qr_codes/foo_#{id}"
      opts = {
        role_id: role_id,
        uuid: uuid,
        id: id,
        path_to_qr_svg: path + '.svg',
        path_to_html: path + '.html'
      }

      # Generate and write intermediate QR code
      tmp_svg = gen_qrcode(**opts)
      tmp_svg_file = File.open(path + '.svg', 'w') do |f|
        f.write(tmp_svg)
        f.close
      end

      # Generate HTML template
      tmp_html = gen_html(**opts)
      tmp_html_file = File.open(path + '.html', 'w') do |f|
        f.write(tmp_html)
        f.close
      end

      # Generate PDF
      pdf = WickedPdf.new.pdf_from_html_file(path + '.html')
      File.open(path + '.pdf', 'w:ASCII-8BIT') do |f|
        f << pdf
      end

      # Remove temporary files
      %w[.html].each do |extension|
        File.delete path + extension
      end

    rescue IOError => e
      puts "File system error!"
    end
  end

  # GENERATE N QR_CODES PER ROLE
  i = 0
  Role.pluck(:id).each do |role_id|
    4.times do
      gen_qr_pdf(role_id: role_id, uuid: SecureRandom.urlsafe_base64(7), id: i += 1)
    end
  end
end
