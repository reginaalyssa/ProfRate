class Professor < ApplicationRecord
  has_and_belongs_to_many :courses

  def full_name
    "#{first_name} #{last_name}"
  end
end
