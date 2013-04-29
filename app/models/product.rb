class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image, :price, :is_digital, :is_subscription,
      :image_file_name, :image_content_type, :image_file_size, :image_updated_at

  has_attached_file :image,
                    styles: {medium: "800x600>", small: "148x148>", thumb: "75x75>", fb_thumb: "50x50>"},
                    url: "/uploads/products/:id/:style/:basename.:extension",
                    path: ":rails_root/public/uploads/products/:id/:style/:basename.:extension"

  validates :title, :presence => true
  validates :price, :numericality => true

  validates_attachment_content_type :image,
      content_type: ["image/pjpeg", "image/jpeg", "image/x-png", "image/png", "image/gif"]

  validates_attachment_size :image, :less_than => 50.megabytes

end
