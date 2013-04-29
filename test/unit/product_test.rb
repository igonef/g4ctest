require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  subject { FactoryGirl.build(:product) }

  should validate_presence_of :title

  should "papercliped" do
    assert User.ancestors.include?(Paperclip::InstanceMethods)
  end

  should have_attached_file :image
  should validate_attachment_content_type(:image).allowing("image/pjpeg", "image/jpeg", "image/x-png", "image/png", "image/gif")

  should "create a new instance given valid attributes" do
    puts "Have Errors: \n"+subject.errors.full_messages.join("\n ") unless subject.valid?
    assert subject.save
  end

end
