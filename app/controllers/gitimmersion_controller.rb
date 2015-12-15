
require 'octokit_wrapper'

class GitimmersionController < ApplicationController

  def index

  end

  def process_students
	csv_array = []
    	csv_array<< ['Name', 'NinerNet ID', 'GitHub Username', 'Number of Commits', 'Number of Branches', 'Score']
    client = Octokit::Client.new login: params[:username], password: params[:password]

	Student.order(:name).all.each do |student|
		score=0
		
		if student.github_username != ""
			octokit= OctokitWrapper.new(client, student.github_username, '/gitimmersion')
			repo=student.github_username+'/gitimmersion'
		end
		
		if client.repository?(repo) == true
			score=score+5
		end
	

begin
	numberOfCommits=0
	commits=[]
	commits=client.commits(repo)
rescue
     continue = 0
end

		
		unless continue == 0
			numberOfCommits=commits.length unless commits.length==0
			
			if numberOfCommits>9
				score=score+30
			elsif numberOfCommits>6
				score=score+20
			elsif numberOfCommits>3
				score=score+10
			end
		else
			numberOfCommits = 0
		end	
		
	
	branchCount=0
	begin
		branches=client.branches(repo)
		rescue Octokit::NotFound
	end
	branchCount=branches.length unless branches== nil
		if branchCount > 1
		then
		score=score+15
		end
		
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
