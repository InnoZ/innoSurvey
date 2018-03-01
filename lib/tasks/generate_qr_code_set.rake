desc "Generate set of n QR codes"
task :gen_qr_codes do
  # Controller
  require "rqrcode"

  # GENERATE QR CODE
  def gen_qrcode(role_id:)
    qr_text = {
      uuid: SecureRandom.uuid,
      role_id: role_id
    }.to_json

    qr = RQRCode::QRCode.new(qr_text)
    return qr.as_png(
      coding: "utf8",
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 120,
      border_modules: 4,
      module_px_size: 6,
      file: nil # path to write
    )
  end

  # HTML
  template_start = [
    "<html>",
    "<body>",
    "<div class=\"qr-code\">"]

  template_end = [
    "</div>",
    "</body>",
    " </html>"]

  i = 0
  Role.pluck(:id).each do |role_id|
    10.times do
      i += 1
      begin
        # Generate and write intermediate QR code
        png = gen_qrcode(role_id: role_id)
        png.save("./tmp/cache/qr_codes/foo_#{i}.png", interlace: true)
      rescue IOError => e
        puts "Oh no! Sth went wrong"
      end
    end
  end
end
