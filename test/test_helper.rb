ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "paperclip/matchers"

# TODO: remove this if fixed in newer shoulda release
Shoulda.autoload_macros(File.dirname(__FILE__) + '/..')

class ActiveSupport::TestCase
  extend Paperclip::Shoulda::Matchers
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Test::Unit
#class Test::Unit::TestCase
#  include FactoryGirl::Syntax::Methods
#end

class ActionController::TestCase
  # include devise test helpers
  include Devise::TestHelpers

  def admin_sign_in
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end
end

class Test::Unit::TestCase #:nodoc:
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)
  extend Devise::Shoulda
end