class OctokitWrapper
	def initialize(client, github_username, repository_name)
		@client = client
		@repo = Octokit::Repository.from_url("https://github.com/#{github_username}/#{repository_name}")
		@individual_commits = {}
	end
	
	def get_commits
		@commits = @client.commits(@repo) if @commits.nil?
		@commits
	end
	
	def get_commit(sha)
		@individual_commits[sha] = @client.commit(@repo, sha) unless @individual_commits.has_key? sha
		@individual_commits[sha]
	end
	
	def get_filename(regex)
		commits = get_commits
		
		commits.each do |commit|
			commit = get_commit(commit.sha)
			commit.files.each do |file|
				return file.filename if file.filename =~ regex
			end
		end
		
		return ""
	end
	
	def get_gemfile
		return @client.contents(@repo, path:"Gemfile")
	end
end
