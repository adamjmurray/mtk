source 'https://rubygems.org'

############################
# Gems required by mtk code

gem "midilib", "~> 2.0"
gem "gamelan", "~> 0.3"
gem "citrus",  "~> 2.4"

platforms :jruby do
  gem "jsound", "~> 0.1"
end
platforms :ruby do
  gem "unimidi", ">= 0.3"
end


############################
# Gems for development

group :development do
  gem "yard", "~> 0.8"
  gem "redcarpet", "~> 2.1"

  platforms :ruby do
    gem "cover_me","~> 1.2"
  end
end

group :test do
  gem "rake",    "~> 0.9"
  gem "rspec",   "~> 2.10"
end
