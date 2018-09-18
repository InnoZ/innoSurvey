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
    roles: [['innoSurvey_nutzer','1'], 
#             ['innoSurvey_politik','2'], 
#             ['innoSurvey_hersteller','3'], 
#             ['innoSurvey_mobidienst', '4'], 
             ['innoSurvey_energie','5']],
    survey_id: 3,
    pdf_dest: '/tmp/qrcodes',
    #survey_url: 'localhost:3000'
    survey_url: 'https://survey.innoz.space'
  }

  o = OptionParser.new
  o.banner = 'Usage: rake gen_qr_codes -- [options]'
  o.on('-i ARG', '--iterations ARG', Integer) { |iterations| ARGUMENTS[:iterations] = iterations.to_i }
  o.on('-r ARG', '--roles ARG', 'Survey roles like role_name;role_id,role_name;role_id') do | roles| 
    new_role = []
    roles.split(",").each do |role|
      new_role.push([role.split(";")[0], role.split(";")[1]])
    end
    ARGUMENTS[:roles] = new_role
  end
  o.on('-l ARG', '--languages ARG', 'Avaible role languages en,de,fr,..') { |lang| ARGUMENTS[:languages] =  lang.split(",")}
  o.on('-d ARG', '--destination ARG', 'Destination folder for generated qr_codes') { |dest| ARGUMENTS[:pdf_dest] =  ARGUMENTS[:pdf_dest] = dest}
  o.on('-u ARG', '--url ARG', 'URL of the survey, default is localhost:3000') { |url| ARGUMENTS[:survey_url] =  url}
  o.on('-s ARG', '--survey_num ARG', 'Num of the survey, default is 3') { |survey_id| ARGUMENTS[:survey_id] = survey_id}
  args = o.order!(ARGV) {}
  o.parse!(args)

  # GENERATE QR CODE
  def gen_qrcode(**opts)
    qr_content = "https://survey.innoz.space/surveys/#{opts[:survey_id]}?uuid=#{opts[:uuid]}&role_id=#{opts[:role_id]}&token=#{opts[:uuid].encrypt}"
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
          <div class='id'>ID: #{opts[:uuid]}</div>
        </div>
      </div>
    EOF
  end

  def gen_html_back(**opts)
    role_path = "#{Rails.root}/public/#{opts[:template_file_name]}_back.svg"
    puts "CHECK #{role_path}"
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
    role_path = "#{Rails.root}/public/#{opts[:template_file_name]}_front.svg"
    puts "CHECK #{role_path}"
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

  # HTML templating
  def gen_qr_pdf(role_name:, role_id:, lang:, survey_id:, uuid:, iteration:, path:)
    file_name = "#{iteration}_#{lang}_#{role_name}"
    qrcode_file_name = 'qrcode_' + file_name + '.svg'
    file_path = path + file_name 

    opts = {
      role_id: role_id,
      uuid: uuid,
      survey_id: survey_id,
      path_to_qr_svg: path + qrcode_file_name,
      template_file_name: "#{lang}_#{role_name}"
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
      pdf = WickedPdf.new.pdf_from_html_file(file_path + "_#{side}.html", {
        margin: { top: 0, bottom: 0, left: 0, right: 0 },
        page_height: 118,
        page_width: 118,
      })
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
  survey_id = ARGUMENTS[:survey_id]
  base_path = FileUtils::mkdir_p(Rails.root.to_s + ARGUMENTS[:pdf_dest] + "/#{Time.now.strftime('%d.%m.%Y-%H:%M:%S')}/").first

  begin
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
          puts "Starting generation: " + lang + '/' + role[0] + '/' + i.to_s
          i += 1
          # Increment progressbar
          progressbar.increment

          # Generate gr code per Role
          gen_qr_pdf(role_name: role[0],
                     role_id: role[1],
                     lang: lang,
                     survey_id: survey_id,
                     uuid: SecureRandom.urlsafe_base64(6),
                     iteration: i,
                     path: path)

          merged_pdf << CombinePDF.load(path + "#{i}_#{lang}_#{role[0]}" + '_front.pdf')
          merged_pdf << CombinePDF.load(path + "#{i}_#{lang}_#{role[0]}" + '_back.pdf')
        end
        puts '-> Merge Pdf pages to one pdf'
        merged_pdf.save  base_path + "/#{n}_#{lang}_#{role[0]}.pdf"
      end
    end
  end
end
