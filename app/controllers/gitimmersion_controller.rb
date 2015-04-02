require 'octokit_wrapper'
class GitimmersionController < ApplicationController

  def index

  end

  def process_students
	debugger
	int score=0
    client = Octokit::Client.new login: params[:username], password: params[:password]
  end


  

end
