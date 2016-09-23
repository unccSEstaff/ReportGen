require 'csv'
class StudentsController < ApplicationController
  def index
    if params[:import]
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/Book1.csv") do |row|
        Student.create(:niner_net => row[0], :name => row[1], :codecademy => row[2])
      end     
    end
    
    if params[:clear]
      Student.delete_all    
    end    
  
    if params[:sort_by]
      @sortUsing = params[:sort_by]
    else
      @sortUsing = "name"
    end
    
    @students = Student.order(@sortUsing, :name) 
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
      params.require(:student).permit(:name, :niner_net, :codecademy, :github_username, :ch4_repo_name, :RailsTutorialHeroku)
    end
end
