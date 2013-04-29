require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { FactoryGirl.build(:user) }
  
  should "include devise call" do
    assert_respond_to subject.class, :devise
  end

  should "not update user password without password confirmation" do
    user = FactoryGirl.create(:user)
    result = user.update_with_password(:first_name => "Bill", :password => "admin", :current_password => "user")
    assert_equal false, result
  end

  should "update user attributes without password and password confirmation" do
    user = FactoryGirl.create(:user)
    result = user.update_with_password(:first_name => "Bill", :last_name => "Hopkins", :current_password => "user")
    assert_equal true, result
  end

  context "testing attr_accessible" do
    should allow_mass_assignment_of :email
    should allow_mass_assignment_of :password
    should allow_mass_assignment_of :password_confirmation
    should allow_mass_assignment_of :remember_me
    should allow_mass_assignment_of :first_name
    should allow_mass_assignment_of :last_name
    should allow_mass_assignment_of :avatar
    should allow_mass_assignment_of :avatar_file_name
    should allow_mass_assignment_of :avatar_content_type
    should allow_mass_assignment_of :avatar_file_size
    should allow_mass_assignment_of :avatar_updated_at
  end
  
  should validate_presence_of :first_name
  should validate_presence_of :last_name

  should "papercliped" do
    assert User.ancestors.include?(Paperclip::InstanceMethods)
  end

  should have_attached_file :avatar
  should validate_attachment_content_type(:avatar).allowing("image/pjpeg", "image/jpeg", "image/x-png", "image/png", "image/gif")

  should "create a new instance given valid attributes" do
    puts "Have Errors: \n"+subject.errors.full_messages.join("\n ") unless subject.valid?
    assert subject.save
  end
  
end
