require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'octokit_wrapper'

class RailstutorialController < ApplicationController

  	def index

  	end

	def process_students
		csv_array = []
    	csv_array<< ['Name', 'NinerNet ID', 'GitHub Username', 'Number of Commits', 'Number of Branches', 'Heroku Live' 'Score']
    	client = Octokit::Client.new login: params[:username], password: params[:password]

		Student.order(:name).all.each do |student|
			score=0
			
			# CHECK GITHUB REPO
			if student.github_username != ""
				#octokit= OctokitWrapper.new(client, student.github_username, '/first_app')
				
				repo=student.github_username+'/first_app'
				if client.repository?(repo) == true
					score = score + 5
				else
					repo=student.github_username+'/firstapp'
					if client.repository?(repo) == true
						score = score + 5
					else
						repo=student.github_username+'/first-app'
						if client.repository?(repo) == true
							score = score + 5
						end
					end
				end

				numberOfCommits=0
				commits=[]
				begin
					commits=client.commits(repo)
				rescue Octokit::NotFound
				end
				
				numberOfCommits = commits.length unless commits.length==0
				if numberOfCommits >= 3
					score = score + 55
				elsif numberOfCommits == 2
					score = score + 53
				elsif numberOfCommits == 1
					score = score + 45
				end
				# END REPO Ceck 
				
				# BRANCH CHECK
				branchCount=0
				begin
					branches=client.branches(repo)
				rescue Octokit::NotFound
				end
				branchCount=branches.length unless branches== nil
				if branchCount == 1
					score = score + 5
				end			
				# END BRANCH CHECK
			end
			
			# CHECK HEROKU URL
			if student.RailsTutorialHeroku != "" && student.RailsTutorialHeroku != nil
				agent = Mechanize.new
				begin
					page = agent.get(student.RailsTutorialHeroku)
				rescue Exception => e 
		 			error = 1
				end
				
				if error != 1
					if page.body.to_s =~ /hello(,|) world(!|)/i
						heroku =  "Yes"
						score = score + 35
					else
						heroku = "No match"
					end
				else
					heroko = "Read error"
				end
			else
				heroku = "No Info"
			end
			# FINISH URL CHECK
		
			# CREATE SPREADSHEET
			csv_array << [student.name,student.niner_net,student.github_username,numberOfCommits,branchCount,heroku,score]
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
