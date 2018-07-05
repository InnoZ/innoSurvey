class AvailableQrCodeDownloadBroadcastJob < ApplicationJob
  queue_as :default

  def perform(uui)
    # Generate PDF output, assign file handler and serve
    qr_codes = DownloadQR.call
    ApplicationCable.server.broadcast(
      "download_qr_codes_channel_#{uuid}", csv: qr_codes
    )
  end
end
