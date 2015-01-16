class StudentsController < ApplicationController
  def index
    @students = Student.order(:name)
    @total_students = Student.count
  end
  
  def create
    student = Student.create(student_params)
    flash[:message] = "Student '#{student.name}' was successfully created."
    redirect_to students_path
  end
  
  def new
    @student = Student.new
    @url = students_path
    @method = "post"
    @button_text = "Add Student"
    render :edit
  end
  
  def edit
    @student = Student.find(params[:id])
    @url = student_path(@student)
    @method = "patch"
    @button_text = "Edit Student"
  end
  
  def update
    student = Student.find(params[:id])
    student.update(student_params)
    flash[:message] = "Student '#{student.name}' was successfully updated."
    redirect_to students_path
  end
  
  def destroy
    student = Student.find(params[:id])
    student.destroy
    flash[:message] = "Student '#{student.name}' was successfully deleted."
    redirect_to students_path
  end
  
  private
    def student_params
      params.require(:student).permit(:name, :niner_net, :codecademy)
    end
end
