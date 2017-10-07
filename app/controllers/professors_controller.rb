class ProfessorsController < ApplicationController
  before_action :set_professor, only: [:show, :edit, :update, :destroy]

  # GET /professors
  # GET /professors.json
  def index
    @professors = Professor.all
  end

  # GET /professors/1
  # GET /professors/1.json
  def show
    @courses = @professor.courses
    @other_courses = Course.all - @courses
  end

  # GET /professors/new
  def new
    @professor = Professor.new

    if params[:course_id]
      if Course.exists?(params[:course_id])
        course = Course.find(params[:course_id])
        @course_title = course.title
        @course_id = course.id
      else
        @professor.errors[:course] << ["Couldn't find Course with 'id'=#{params[:course_id]}"]
        @course_id = -1
      end
    end
  end

  # GET /professors/1/edit
  def edit
  end

  # POST /professors
  # POST /professors.json
  def create
    @professor = Professor.new(professor_params)

    # no course_id given, save only Professor
    if params[:professor][:course_id].nil?
      save_professor = true

    # course_id exists, save Professor and create association with Course
    elsif Course.exists?(params[:professor][:course_id])
      save_professor = true
      create_association = true

    # course_id is invalid, return error
    else
      @professor.errors[:course] << ["Not found, submitting this form will add a new professor but will not add an association with any course"]
      return_error = true
    end

    respond_to do |format|
      if save_professor
        if @professor.save
          format.html { redirect_to @professor, notice: 'Professor was successfully created.' }
          format.json { render :show, status: :created, location: @professor }
        else
          return_error = true
        end
      end

      if return_error
        format.html { render :new }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end

    if create_association
      course = Course.find(params[:professor][:course_id])
      @professor.courses << course
    end
  end

  # PATCH/PUT /professors/1
  # PATCH/PUT /professors/1.json
  def update
    respond_to do |format|
      if @professor.update(professor_params)
        format.html { redirect_to @professor, notice: 'Professor was successfully updated.' }
        format.json { render :show, status: :ok, location: @professor }
      else
        format.html { render :edit }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professors/1
  # DELETE /professors/1.json
  def destroy
    @professor.destroy
    respond_to do |format|
      format.html { redirect_to professors_url, notice: 'Professor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /add_course
  # Add existing course to professor
  def add_course
    professor_id = params[:add_course][:professor_id]
    course_id = params[:add_course][:course_id]

    if Professor.exists?(professor_id) and Course.exists?(course_id)
      course = Course.find(course_id)
      @professor = Professor.find(professor_id)
      @professor.courses << course
      create_association = true
    else
      return_error = true
    end

    if create_association
      respond_to do |format|
        if @professor.save
          format.html { redirect_to @professor, notice: 'Course was successfully added to professor.' }
          format.json { head :no_content }
        else
          return_error = true
        end
      end
    end

    if return_error
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def display_reviews_of_subject
    if Professor.exists?(params[:id]) and Course.exists?(params[:course_id])
      @reviews = Review.where(professor_id: params[:id], course_id: params[:course_id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professor
      @professor = Professor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def professor_params
      params.require(:professor).permit(:first_name, :last_name)
    end
end
