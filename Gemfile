source 'https://rubygems.org'

ruby "1.9.3"
gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'rest-client', :git => 'git://github.com/archiloque/rest-client.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  
  gem 'twitter-bootstrap-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'rspec-rails', group: [:test,:development]
group :test do
  gem 'debugger'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'vcr'
  gem 'fakeweb'
end

gem 'omniauth-twitter'
gem 'twitter'

gem 'omniauth-facebook'
gem 'koala'

group :production do
  gem 'heroku'
  gem 'pg'
end