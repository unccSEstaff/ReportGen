require 'octokit_wrapper'
require 'octokit'
class GitimmersionController < ApplicationController

  def index

  end

  def process_students
	
	score=0
	csv_array = []
    	csv_array<< ['Name', 'NinerNet ID', 'GitHub Username', 'Number of Commits', 'Number of Branches', 'Score']
    client = Octokit::Client.new login: params[:username], password: params[:password]

	Student.order(:name).all.each do |student|
		
		
		if student.github_username != ""
		then
		octokit = OctokitWrapper.new(client, student.github_username, '/gitimmersion')
		end
		
		if (octokit!=nil)
		then 
		score=score+5
		end
	
		begin
			
			commits=[]
			begin
				commits= octokit.get_commits
				rescue Octokit::Conflict
				rescue Octokit::NotFound
				
			end
			numberOfCommits=commits.length
				unless 
numberOfCommits==0
		end
		if numberOfCommits>9
			then
			score=score+30
			elsif numberOfCommits>6
				then
				score=score+20
				elsif numberOfCommits>3
					then
					score=score+10
				end
			end
		
	
	branchCount=0
		#if branches.length > 1
		#then
		#score=score+15
		#end
		
	csv_array << [student.name,student.niner_net,student.github_username,numberOfCommits,branchCount,score]
	@csv =""

	csv_array.each_with_index do |row, row_i|
	  		@csv += "\n" unless row_i == 0
	  		row.each_with_index do |value, val_i|
	  			@csv += "," unless val_i == 0
	  			@csv += value.to_s
	  		end
		end
	end

  end 

end
