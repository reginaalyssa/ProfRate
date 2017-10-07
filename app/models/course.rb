class Course < ApplicationRecord
  has_and_belongs_to_many :professors
  validates :title, presence: true
end
