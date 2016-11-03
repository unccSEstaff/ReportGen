require 'octokit_wrapper'

class Ch4WalkthroughController < ApplicationController
	def index
	
	end
	
	def process_students
		csv_array = []
	  	csv_array << ['Student', 'ID', 'SIS User ID', 'SIS Login ID', 'Section', 'score', 'GitHub Username', 'Repository Name',
	  		'Number of Commits', 'Migration Date',
	  		'Has Movies Controller?', 'Has Movies Model?', 'Has Index View?', 'Has Show View?', 'Has New View?', 'Has Edit View?']
	  		
  		client = Octokit::Client.new login: params[:username], password: params[:password]
	  	
	  	Student.order(:name).all.each do |student|
	  	#Student.where("canvasID >= 24420").each do |student|
	  		
	  		if student.github_username != "" and !(student.github_username.nil?) 
		  		#octokit = OctokitWrapper.new(client, student.github_username, "ch4_wt")

				if client.repository?(student.github_username+'/chapter-4') == true
					octokit = OctokitWrapper.new(client, student.github_username, "chapter-4")
					repoName = "chapter-4"
				else
					octokit = OctokitWrapper.new(client, student.github_username, "ch4_wt")
					repoName = "ch4_wt"
					
				end		  		
		  		
		  		begin
		  			commits = []
		  			
		  			begin
				  		commits = octokit.get_commits
				  	rescue Octokit::Conflict
				  	end
				  	
			  		number_of_commits = commits.length
			  		
			  		unless number_of_commits == 0
					  		score = 30
					  		if number_of_commits >= 3
					  			score = score + 5
					  		end

					  		migration_regex = /(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})(?<hour>\d{2})(?<min>\d{2})(?<sec>\d{2})_create_movies.rb$/
					  		has_migration = migration_filename = octokit.get_filename(migration_regex)
					  		migration_date = "No Migration File."
					  		score = score + 5 if has_migration
					  		
					  		unless migration_filename == ""
						  		groups = migration_filename.match(migration_regex)
						  		migration_date = DateTime.new(groups['year'].to_i, groups['month'].to_i, groups['day'].to_i,
						  			groups['hour'].to_i, groups['min'].to_i, groups['sec'].to_i)
						  	end
					  		
					  		#test = octokit.get_gemfile
					  		#score = score + 100 if test.include? "c291cmNlICdodHRwczovL3J1YnlnZW1zLm9yZyc"
					  		#byebug 
					  		
					  		has_controller = octokit.get_filename(/movies_controller.rb$/) != ""
					  			score = score + 10 if has_controller
					  			
					  		has_model = octokit.get_filename(/movie.rb$/) != ""
					  			score = score + 10 if has_model
					  			
					  		has_index_view = octokit.get_filename(/index.html.haml$/) != ""
					  			score = score + 10 if has_index_view
					  			
					  		has_show_view = octokit.get_filename(/show.html.haml$/) != ""
					  			score = score + 10 if has_show_view
					  			
					  		has_new_view = octokit.get_filename(/new.html.haml$/) != ""
					  			score = score + 10 if has_new_view
					  			
					  		has_edit_view = octokit.get_filename(/edit.html.haml$/) != ""
					  			score = score + 10 if has_edit_view
					  		
					  		csv_array << [student.name, student.canvasID, student.SISid,  student.niner_net, student.section, score, student.github_username, repoName,
					  			number_of_commits, migration_date,
					  			has_controller, has_model, has_index_view, has_show_view, has_new_view, has_edit_view]
				  	else
				  		csv_array << [student.name, student.canvasID, student.SISid,  student.niner_net, student.section, 0, student.github_username, repoName,
				  			number_of_commits, "No Migration File.", false, false, false, false, false, false]
				  	end
			  	rescue Octokit::NotFound
			  		csv_array << [student.name, student.canvasID, student.SISid,  student.niner_net, student.section, 0, student.github_username, "404 for #{student.github_username}/ch4_wt",
			  			0, "No Migration File.", false, false, false, false, false, false]
			  	end
		  	end
	  	end
	  	
	  	@csv = ""
	  	
	  	csv_array.each_with_index do |row, row_i|
	  		@csv += "\n" unless row_i == 0
	  		row.each_with_index do |value, val_i|
	  			@csv += "," unless val_i == 0
	  			@csv += value.to_s
	  		end
	  	end
	end
end