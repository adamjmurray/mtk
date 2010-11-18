require 'kreet'
include Kreet

# I needed this to make things shared examples work in TextMate without breaking Rake
# If this code causes something to blow up, the body of this method can be commented out.
def load_shared_examples_for type
  begin
    ensure_shared_example_group_name_not_taken "any #{type.capitalize}"   
    require "kreet/#{type}_spec"
  rescue 
  end
end