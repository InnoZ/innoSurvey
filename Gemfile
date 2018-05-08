source 'https://rubygems.org'

git_source(:github) do |repo_name|
end


gem 'bcrypt'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'rqrcode'
gem 'ruby-progressbar'
gem 'sass-rails', '~> 5.0'
gem 'sqlite3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'combine_pdf'

# haml template DSL
gem 'haml'

group :development, :test do
	#e gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
	gem 'pry-byebug'
end

group :test do
	# checks ruby code for sec flaws
	gem 'brakeman', require: false
	# DSL for frontend testing used poltergeist/selenium
	gem 'capybara'
	gem 'capybara-screenshot'
	# resets database bevor every test
	gem 'database_cleaner'
	# defines seed data for test runtime env
	gem 'factory_bot_rails'
	# auto runs parts of test suits
	gem 'guard'
	# auto runs brackman over new code
	gem 'guard-brakeman', require: false
	# guard for rspec
	gem 'guard-rspec'
	gem 'poltergeist' # headless javascript testing
	# test suite for ...
	gem 'rspec-rails'
	# testing model assosiations
  gem 'rails-controller-testing'
	gem 'shoulda'
  # Helper for generating funny rnd data
  gem 'faker'
end
group :development do
	gem 'web-console', '>= 3.3.0'
	gem 'listen', '>= 3.0.5', '< 3.2'
	gem 'spring'
	gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
