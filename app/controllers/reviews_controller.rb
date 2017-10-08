class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

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

  # GET /reviews/1/edit
  def edit
    @professors = Professor.all
    @courses = Course.all
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

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        @professors = Professor.all
        @courses = Course.all
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
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
