require 'csv'
class StudentsController < ApplicationController
  def index
    if params[:import] == "students"
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/Students.csv", :headers => true) do |row|
        Student.create(:canvasID => row['canvasID'], :name => row['name'], :section => row['section'], :SISid => row['SISid'], :niner_net => row['SISlogin'])
      end 
    elsif params[:import] == "cc"
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/Codecademy.csv", :headers => true) do |row|
        Student.where(:canvasID => row['canvasID']).update_all(:codecademy => row['codeacademy'])
      end
    elsif params[:import] == "github"
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/Github.csv", :headers => true) do |row|
        Student.where(:canvasID => row['canvasID']).update_all(:github_username=> row['GitHubUsername'])
      end   
    elsif params[:import] == "ch4"
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/Ch4.csv", :headers => true) do |row|
        Student.where(:canvasID => row['canvasID']).update_all(:ch4_repo_name=> row['ch4Repo'])
      end  
    elsif params[:import] == "rails"
      CSV.foreach("/home/ubuntu/workspace/ReportGen/app/assets/RailsTutorial.csv", :headers => true) do |row|
        Student.where(:canvasID => row['canvasID']).update_all(:RailsTutorialHeroku=> row['herokuURL'])
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
    @githubCount = Student.where("length(github_username) > 1").count
    @tutorialCount = Student.where("length(RailsTutorialHeroku) > 1").count
    @CodeCadCount = Student.where("length(codecademy) > 1").count
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
      params.require(:student).permit(:name, :niner_net, :codecademy, :github_username, :ch4_repo_name, :RailsTutorialHeroku, :canvasID, :SISid, :section)
    end
end
