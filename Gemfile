source 'https://rubygems.org'

############################
# Gems required by mtk code

gem "midilib", "~> 2.0"
gem "gamelan", "= 0.3" # TODO remove the monkey patch in midi_output.rb and upgrade when a new version is available
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
  gem "kramdown", "~> 1.1"

  platforms :ruby do
    gem "cover_me","~> 1.2"
  end
end

group :test do
  gem "rake",    "~> 10.1"
  gem "rspec",   "~> 2.14"
end
