class Professor < ApplicationRecord
  has_and_belongs_to_many :courses

  def self.full_name
    "#{self.first_name} #{self.last_name}"
  end
end
