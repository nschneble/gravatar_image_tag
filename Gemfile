source 'https://rubygems.org'

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
when "master"
  {github: "rails/rails"}
when "default"
  "~> 7.1.0"
else
  "~> #{rails_version}"
end

group :development, :test do
  gem 'activesupport', rails
  gem 'actionview', rails
  gem 'rexml', '~> 3.2'
  gem 'rspec'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9'
  gem 'jeweler'
end
