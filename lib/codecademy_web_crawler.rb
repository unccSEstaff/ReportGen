require 'rubygems'
require 'nokogiri'
require 'open-uri'
 
class CodecademyWebCrawler
	def initialize(codecademy_username)
		@lesson_urls = get_ruby_track_urls
		@is_404 = false
		
		find_achievements(codecademy_username)
	end
	
	def get_achievements
	  return @earned_achievements
	end
	
	def is_404?
	  return @is_404
	end
	
	private

  # Returns an 2D array of all of a user's Ruby achievements:
  # [ [Lesson 1, Lesson 1 Project],
  #   [Lesson 2, Lesson 2 Project],
  #   [Lesson 3, Lesson 3 Project],
  #   [Lesson 4, Lesson 4 Project],
  #   [Lesson 5, Lesson 5 Project],
  #   [Lesson 6, Lesson 6 Project],
  #   [Lesson 7, Lesson 7 Project],
  #   [Lesson 8],
  #   [Lesson 9, Lesson 9 Project],
  #   [Lesson 10, Lesson 10 Project] ]
  def find_achievements(codecademy_username)
    achievement_urls = get_user_achievement_urls(codecademy_username)
    @earned_achievements = Array.new(10) { Array.new }
    
    if achievement_urls != false
      @lesson_urls.each_index do |lesson_number|
        @lesson_urls[lesson_number].each_index do |url_number|
          has_achievement = false
          lesson_url = @lesson_urls[lesson_number][url_number]
      
          achievement_urls.each do |achievement_url|
            if lesson_url.eql?(achievement_url)
              has_achievement = true
            end
          end
        
          @earned_achievements[lesson_number][url_number] = has_achievement
        end
      end
    else
      @is_404 = true
    end
  end

	# Look at the Ruby track page to get URLs to all of the lessons & projects
	def get_ruby_track_urls
		lesson_urls = [
			["/courses/ruby-beginner-en-d1Ylq","/courses/ruby-beginner-en-MxXx5"],
			["/courses/ruby-beginner-en-NFCZ7","/courses/ruby-beginner-en-JdNDe"],
			["/courses/ruby-beginner-en-XYcN1","/courses/ruby-beginner-en-mzrZ6"],
			["/courses/ruby-beginner-en-F3loB","/courses/ruby-beginner-en-693PD"],
			["/courses/ruby-beginner-en-ET4bU","/courses/ruby-beginner-en-nOho7"],
			["/courses/ruby-beginner-en-Qn7Qw","/courses/ruby-beginner-en-0i8v1"],
			["/courses/ruby-beginner-en-1o8Mb","/courses/ruby-beginner-en-Zjd2y"],
			["/courses/ruby-beginner-en-L3ZCI"],
			["/courses/ruby-beginner-en-MFiQ6","/courses/ruby-beginner-en-X5wcR"],
			["/courses/ruby-beginner-en-zfe3o","/courses/ruby-beginner-en-32cN3"],
		]

#		page = Nokogiri::HTML(open('http://www.codeacademy.com/tracks/ruby'))
#		lessons_list = page.css('ul.units li.unit_item')
#		
#		current_lesson = 0
#		lesson_urls = Array.new(10) { Array.new }
#		
#		lessons_list.each do |lesson|
#			lesson_anchors = lesson.css('a')
#			
#			lesson_anchors.each do |anchor|
#				question_mark_index = anchor['href'].index('?') == nil ? anchor['href'].length - 1 : anchor['href'].index('?')
#			
#				lesson_urls[current_lesson].push(anchor['href'][0, question_mark_index])
#			end
#			
#			current_lesson += 1
#		end	

		return lesson_urls
	end

	# Get all of the URLs for the Ruby achievements a user has earned
	def get_user_achievement_urls(username)
		achievement_urls = Array.new
		
		begin
			#page = Nokogiri::HTML(open('https://www.codecademy.com/users/' + username.gsub(' ', '%20') + '/achievements'))
			#achievements = page.css('div.achievement-card')

			# Start Page
			agent = Mechanize.new
			agent.get('https://www.codecademy.com/users/' + username.gsub(' ', '%20') + '/achievements')
			
			# Login
			form = agent.page.forms[0]
			form.field_with(:name => "user[login]").value = "unccSEstaff@gmail.com"
			form.field_with(:name => "user[password]").value = "itcs3155!"
			form.submit
			
			# Convert to nokogiri 
			html = agent.page.body
			page = Nokogiri::HTML(html)
			achievements = page.css('div.achievement-card') 
			
		  # compare for badges
			achievements.each do |achievement|
				#badge_div = achievement.css('div.badge')[0]
			
				# Check only Ruby specific achievements
				#if badge_div['style'].eql?('background-image:url(/assets/badges/RubyAchievement.png)')
				#	achievement_urls.push(achievement.css('a')[0]['href'])
				#end
				
				badge_div = achievement.css('span.cc-achievement')[0]
				
				# Check only Ruby specific achievements
				if badge_div['class'].match '--ruby-achievement'
					if achievement.css('a')[0] # Make sure the Achievement contains a link
						achievement_urls.push(achievement.css('a')[0]['href'])
					end
				end
			end
		rescue OpenURI::HTTPError
			achievement_urls = false
		end

		return achievement_urls
	end
end

