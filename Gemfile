source 'https://rubygems.org'

gem 'roda', '~> 2.18'
gem 'rack-indifferent', '~> 1.2', require: 'rack/indifferent'

gem 'haml', '~> 4.0', '>= 4.0.7' # Use HAML for html templating
gem 'sass', '~> 3.4', '>= 3.4.22' # SASS for CSS yields
gem 'uglifier', '~> 3.0' # JS compressor

gem 'mongoid', '~> 6.0'

gem 'thin', '~> 1.7', require: false # Use Thin as the webserver
gem 'rake', '> 10.0'

group :development do
  gem 'shotgun', '~> 0.9.2'
end

group :development, :test do
  gem 'pry-nav', '~> 0.2.4'
  gem 'database_cleaner', '~> 1.5'
end

group :test do
  gem 'rspec', '~> 3.5'
end
