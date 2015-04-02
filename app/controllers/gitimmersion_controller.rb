require 'octokit_wrapper'
class GitimmersionController < ApplicationController

  def index

  end

  def process_students
	int score=0
    csv_array = []
    csv_array<< ['Name', 'NinerNet ID', 'GitHub Username', 'Repository Name','Number of Commits', 'Number of Branches', 'Score']
  end

  client = Octokit::Client.new login: params[:username], password: params[:password]

  Student.order(:name).all.each do |student|
	
  if (Octokit.repository? ENV['student.github_username']+'/gitimmersion') 
  then 
	score=score+5
  end
end
