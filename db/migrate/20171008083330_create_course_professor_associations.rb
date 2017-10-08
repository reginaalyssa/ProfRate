class CreateCourseProfessorAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :course_professor_associations do |t|
      t.integer :course_id
      t.integer :professor_id
      t.float :average_rating

      t.timestamps
    end
  end
end
