json.extract! review, :id, :rating, :description, :professor_id, :course_id, :created_at, :updated_at
json.url review_url(review, format: :json)
