class Course < ApplicationRecord
  has_many :course_professor_associations
  has_many :professors, through: :course_professor_associations
  validates :title, presence: true
end
