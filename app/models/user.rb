class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :avatar,
                  :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at,
                  :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_attached_file :avatar,
                    styles: {medium: "800x600>", small: "148x148>", thumb: "75x75>", fb_thumb: "50x50>"},
                    url: "/uploads/users/:id/:style/:basename.:extension",
                    path: ":rails_root/public/uploads/users/:id/:style/:basename.:extension"

  validates :first_name, :last_name, :presence => true

  validates_attachment_content_type :avatar,
      content_type: ["image/pjpeg", "image/jpeg", "image/x-png", "image/png", "image/gif"]

  validates_attachment_size :avatar, :less_than => 50.megabytes

end
