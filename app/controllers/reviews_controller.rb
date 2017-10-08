class ReviewsController < ApplicationController

  # GET /reviews/new
  def new
    @review = Review.new

    # if course_id was passed as parameter, limit choices of courses
    if params[:course_id]
      @courses = [Course.find(params[:course_id])]
    else
      @courses = Course.all
    end

    # if professor_id was passed as parameter, limit choices of professors
    if params[:professor_id]
      @professors = [Professor.find(params[:professor_id])]
    else
      @professors = Professor.all
    end

  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    if Course.exists?(params[:review][:course_id]) and Professor.exists?(params[:review][:professor_id])
      course = Course.find(params[:review][:course_id])
      professor = Professor.find(params[:review][:professor_id])
      if !professor.courses.exists?(course.id)
        professor.courses << course
        professor.save
      end
      reviews = Review.where(course_id: params[:review][:course_id], professor_id: params[:review][:professor_id])
      average = (reviews.sum(:rating) + @review.rating)/(reviews.count.to_f + 1)
      course_professor_association = CourseProfessorAssociation.find_by(course_id: params[:review][:course_id], professor_id: params[:review][:professor_id])
      course_professor_association.average_rating = average
      course_professor_association.save
    end
    respond_to do |format|
      if @review.save
        format.html { redirect_to reviews_professors_path(id: params[:review][:professor_id], course_id: params[:review][:course_id]),
                                  notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        @professors = Professor.all
        @courses = Course.all
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :description, :professor_id, :course_id)
    end
end
