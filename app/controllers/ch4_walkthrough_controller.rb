require 'octokit_wrapper'

class Ch4WalkthroughController < ApplicationController
	def index
	
	end
	
	def process_students
		csv_array = []
	  	csv_array << ['Name', 'NinerNet ID', 'GitHub Username', 'Repository Name',
	  		'Number of Commits', 'Migration Date',
	  		'Has Movies Controller?', 'Has Movies Model?', 'Has Index View?', 'Has Show View?', 'Has New View?', 'Has Edit View?, score']
	  		
  		client = Octokit::Client.new login: params[:username], password: params[:password]
	  	
	  	Student.order(:name).all.each do |student|
	  		if student.github_username != ""
		  		octokit = OctokitWrapper.new(client, student.github_username, "ch4_wt")
		  		begin
		  			commits = []
		  			
		  			begin
				  		commits = octokit.get_commits
				  	rescue Octokit::Conflict
				  	end
				  	
			  		number_of_commits = commits.length
			  		
			  		unless number_of_commits == 0
					  		migration_regex = /(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})(?<hour>\d{2})(?<min>\d{2})(?<sec>\d{2})_create_movies.rb$/
					  		migration_filename = octokit.get_filename(migration_regex)
					  		migration_date = "No Migration File."
					  		
					  		score = 10
					  		if number_of_commits >= 4
					  			score = score + 30
					  		elsif number_of_commits == 3
					  			score = score + 28
					  		elsif number_of_commits == 2
					  			score = score + 20
					  		end
					  		
					  		unless migration_filename == ""
						  		groups = migration_filename.match(migration_regex)
						  		migration_date = DateTime.new(groups['year'].to_i, groups['month'].to_i, groups['day'].to_i,
						  			groups['hour'].to_i, groups['min'].to_i, groups['sec'].to_i)
						  	end
					  		
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
					  		
					  		csv_array << [student.name, student.niner_net, student.github_username, student.ch4_repo_name,
					  			number_of_commits, migration_date,
					  			has_controller, has_model, has_index_view, has_show_view, has_new_view, has_edit_view, score]
				  	else
				  		csv_array << [student.name, student.niner_net, student.github_username, student.ch4_repo_name,
				  			number_of_commits, "No Migration File.",
				  			false, false, false, false, false, false, 0]
				  	end
			  	rescue Octokit::NotFound
			  		csv_array << [student.name, student.niner_net, student.github_username, "404 for #{student.github_username}/ch4_wt",
			  			0, "No Migration File.",
		  				false, false, false, false, false, false,0]
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