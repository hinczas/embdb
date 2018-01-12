class Photo < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "368>x270>", thumb: "512x60>" }
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  belongs_to :project

end
