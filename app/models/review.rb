class Review < ApplicationRecord
  belongs_to :professor
  belongs_to :course
  validates :professor_id, presence: true
  validates :course_id, presence: true
  validates :rating, presence: true, inclusion: { in: (1..5).to_a }

  def formatted_rating
    '%.2f' % [rating.to_f]
  end
end
