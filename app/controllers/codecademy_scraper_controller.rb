require 'codecademy_web_crawler.rb'
require 'output_xml_template.rb'

class CodecademyScraperController < ApplicationController
	def process_students
	    @xml = OutputXmlTemplate.get_template_beginning(Student.where("length(codecademy) > 1").count + 2)
	    @xml += OutputXmlTemplate.get_template_middle
	    
	  Student.where("length(codecademy) > 1").order("lower(name)").each do |student|
	  	x = 0
	  	if student.codecademy != "" and student.codecademy.length > 1
	  		student_crawler = CodecademyWebCrawler.new(student.codecademy)
				student_achievements = student_crawler.get_achievements
				
				row_content = OutputXmlTemplate.format_string(student.name)
				row_content += OutputXmlTemplate.format_string(student.canvasID)
				row_content += OutputXmlTemplate.format_string(student.section)
				row_content += OutputXmlTemplate.format_string(student.SISid)
				row_content += OutputXmlTemplate.format_string(student.niner_net)
				row_content += OutputXmlTemplate.format_string(student.codecademy)

      		unless student_crawler.is_404?
	  			student_achievements.flatten.each do |has_achievement|
	  				row_content += OutputXmlTemplate.format_boolean(has_achievement)
					
	  				if has_achievement == true
	  					x = x + 1
	  				end
	  			end

				else
				  row_content += OutputXmlTemplate.get_404
				end
				
				row_content += OutputXmlTemplate.format_string(x.to_s)
				@xml += OutputXmlTemplate.get_template_row(row_content)
				
		end
  	end
  	
    @xml += OutputXmlTemplate.get_template_end_first(Student.where("length(codecademy) > 1").count + 2)
    @xml += OutputXmlTemplate.get_template_end_last
  end
end
