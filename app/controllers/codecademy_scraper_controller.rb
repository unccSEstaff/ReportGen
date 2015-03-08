require 'codecademy_web_crawler.rb'
require 'output_xml_template.rb'

class CodecademyScraperController < ApplicationController
	def process_students
	    @xml = OutputXmlTemplate.get_template_beginning(Student.count + 2)
	    @xml += OutputXmlTemplate.get_template_middle
      
	  Student.order("lower(niner_net)").each do |student|
	  	if student.codecademy != ""
	  		student_crawler = CodecademyWebCrawler.new(student.codecademy)
				student_achievements = student_crawler.get_achievements
	
				row_content = OutputXmlTemplate.format_string(student.name)
				row_content += OutputXmlTemplate.format_string(student.niner_net)
				row_content += OutputXmlTemplate.format_string(student.codecademy)

      		unless student_crawler.is_404?
	  			student_achievements.flatten.each do |has_achievement|
	  				row_content += OutputXmlTemplate.format_boolean(has_achievement)
	  			end
				else
				  row_content += OutputXmlTemplate.get_404
				end
	
				@xml += OutputXmlTemplate.get_template_row(row_content)
		end
  	end
  	
    @xml += OutputXmlTemplate.get_template_end_first(Student.count + 2)
    @xml += OutputXmlTemplate.get_template_end_last
  end
end
