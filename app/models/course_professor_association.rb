class CourseProfessorAssociation < ApplicationRecord
  belongs_to :course
  belongs_to :professor

  def formatted_average_rating
    '%.2f' % [average_rating.to_f]
  end
end
