require 'optparse'
require 'rqrcode'
require 'fileutils'
require 'ruby-progressbar'
require 'encrypt_decrypt'

desc 'Generate set of n QR codes'
task gen_qr_codes: :environment do
  ARGUMENTS = {
    languages: ['de','en'],
    iterations: 2,
    roles: [['user','1']],
    survey_name: 'innoSurvey',
    survey_id: 0,
    pdf_dest: '/tmp/qrcodes',
    survey_url: 'localhost:3000'
  }

  o = OptionParser.new
  o.banner = 'Usage: rake gen_qr_codes -- [options]'
  o.on('-i ARG', '--iterations ARG', Integer, 'Amount of generated cards per role and lang') { |iterations| ARGUMENTS[:iterations] = iterations.to_i }
  o.on('-r ARG', '--roles ARG', 'Survey roles like sample_user1:1,sample_user2:2') do | roles| 
    new_role = []
    roles.split(",").each do |role|
      new_role.push([role.split(":")[0], role.split(":")[1]])
    end
    ARGUMENTS[:roles] = new_role
  end
  o.on('-l ARG', '--languages ARG', 'Available languages en,de,fr,..') { |lang| ARGUMENTS[:languages] =  lang.split(",")}
  o.on('-d ARG', '--destination ARG', 'Destination folder for generated qr_codes') { |dest| ARGUMENTS[:pdf_dest] =  ARGUMENTS[:pdf_dest] = dest}
  o.on('-u ARG', '--url ARG', 'URL of the survey, default is localhost:3000') { |url| ARGUMENTS[:survey_url] =  url}
  o.on('-s ARG', '--survey_num ARG', 'Num of the survey, default is 0') { |survey_id| ARGUMENTS[:survey_id] = survey_id}
  o.on('-n ARG', '--survey_name ARG', 'Name of the survey, default is InnoSurvey') { |survey_name| ARGUMENTS[:survey_name] = survey_name}
  args = o.order!(ARGV) {}
  o.parse!(args)

  # GENERATE QR CODE
  def gen_qrcode(**opts)
    qr_content = "#{opts[:survey_url]}/surveys/#{opts[:survey_id]}?uuid=#{opts[:uuid]}&role_id=#{opts[:role_id]}&locale=#{opts[:lang]}&token=#{opts[:uuid].encrypt}"
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
        margin-top: 50mm;
        margin-left: 40mm;
      }
      .qr-code > .id {
        margin-top: 3mm;
        text-align: center;
      }
      .qr-img > img {
        margin-bottom: 2mm;
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
          <img class="qr-img" src="#{opts[:path_to_qr_svg]}"></img>
          <div class='id'>ID: #{opts[:uuid]}</div>
        </div>
      </div>
    EOF
  end

  def gen_html_back(**opts)
    role_path = "#{Rails.root}/public/#{opts[:survey_name]}/#{opts[:template_file_name]}_back.svg"
    <<-EOF
      <html>
        <head>
        #{styling(role_path)}
        </head>
        <body>
        #{qr_code(opts)}
        </body>
      </html>
    EOF
  end

  def gen_html_front(**opts)
    role_path = "#{Rails.root}/public/#{opts[:survey_name]}/#{opts[:template_file_name]}_front.svg"
    <<-EOF
      <html>
        <head>
        #{styling(role_path)}
        </head>
        <body>
        </body>
      </html>
    EOF
  end
  def stfu
    begin
      orig_stderr = $stderr.clone
      orig_stdout = $stdout.clone
      $stderr.reopen File.new('/dev/null', 'w')
      $stdout.reopen File.new('/dev/null', 'w')
      retval = yield
    rescue Exception => e
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
      raise e
    ensure
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
    end
    retval
  end

  # HTML templating
  def gen_qr_pdf(role_name:, role_id:, lang:, survey_name:, survey_id:, survey_url:, uuid:, iteration:, path:, file_name:)
    qrcode_file_name = 'qrcode_' + file_name + '.svg'
    file_path = path + file_name 

    opts = {
      role_id: role_id,
      lang: lang,
      uuid: uuid,
      survey_name: survey_name,
      survey_id: survey_id,
      survey_url: survey_url,
      path_to_qr_svg: path + qrcode_file_name,
      template_file_name: "#{lang}_#{survey_name}_#{role_name}"
    }
    puts 'Start PDF generation for ' + file_name
    # Generate and write intermediate QR code
    puts '-> Generate qrcode svg'

    svg = gen_qrcode(**opts)
    File.open(path + qrcode_file_name, 'w') do |f|
      f.write(svg)
      f.close
    end

    %w[front back].each do |side|
      # Generate HTML role
      puts "-> Generate html for " + side
      html = FileUtils.send("gen_html_#{side}", opts)
      File.open(file_path + "_#{side}.html", 'w') do |f|
        f.write(html)
        f.close
      end

      # Generate PDF
      puts "-> Generate pdf with front and back from html"
      pdf = nil
      stfu do
        pdf = WickedPdf.new.pdf_from_html_file(file_path + "_#{side}.html", {
          margin: { top: 0, bottom: 0, left: 0, right: 0 },
          page_height: 118,
          page_width: 118,
        })
      end
      File.open(file_path + "_#{side}.pdf", 'w:ASCII-8BIT') do |f|
        f << pdf
      end
    end
  end

  # CREATE FOLDER BASED ON UNIX TIMESTAMP

  # GENERATE N QR_CODES PER ROLE
  n = ARGUMENTS[:iterations]
  roles = ARGUMENTS[:roles]
  languages = ARGUMENTS[:languages]
  base_path = FileUtils::mkdir_p(Rails.root.to_s + ARGUMENTS[:pdf_dest] + "/#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}/").first

  begin
    puts "Startin PDF Generation #{n} x #{roles} / #{languages} / #{ARGUMENTS[:survey_name]}:#{ARGUMENTS[:survey_id]} / #{ARGUMENTS[:survey_url]}"
    puts "Results saved at: #{ARGUMENTS[:pdf_dest]}"
    sleep(5)

    progressbar = ProgressBar.create(format: "%a %b\u{15E7}%i %p%% %t",
                                     progress_mark: ' ',
                                     remainder_mark: "\u{FF65}",
                                     total: n*roles.size*languages.size)

    languages.each do |lang|
      roles.each do |role|
        path =  FileUtils::mkdir_p( base_path + "#{lang}_#{role[0]}/" ).first
        puts "---------------------------------------------"
        merged_pdf = CombinePDF.new
        i = 0
        n.times do
          file_name = "#{i}_#{lang}_#{ARGUMENTS[:survey_name]}_#{role[0]}"
          puts "Starting generation: " + lang + '/' + role[0] + '/' + i.to_s
          i += 1
          # Increment progressbar
          progressbar.increment

          # Generate gr code per Role
          gen_qr_pdf(role_name: role[0],
                     role_id: role[1],
                     lang: lang,
                     survey_name: ARGUMENTS[:survey_name],
                     survey_id: ARGUMENTS[:survey_id],
                     survey_url: ARGUMENTS[:survey_url],
                     uuid: SecureRandom.urlsafe_base64(6),
                     iteration: i,
                     path: path,
                     file_name: file_name)

          merged_pdf << CombinePDF.load(path + file_name + '_front.pdf')
          merged_pdf << CombinePDF.load(path + file_name + '_back.pdf')
        end
        puts '-> Merge Pdf pages to one pdf'
        merged_pdf.save  base_path + "/#{n}_#{lang}_#{role[0]}.pdf"
      end
    end
  end
end
