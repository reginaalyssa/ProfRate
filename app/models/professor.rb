class Professor < ApplicationRecord
  has_many :course_professor_associations
  has_many :courses, through: :course_professor_associations
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
