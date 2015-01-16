class OutputXmlTemplate
	# Returns the beginning part of the XML template as a string
	def self.get_template_beginning(number_of_xml_rows)
		return self.get_template_file("xml_template_beginning.txt") + "\"#{number_of_xml_rows}\"\n"
	end

	# Returns the middle part of the XML template as a string
	def self.get_template_middle
		return self.get_template_file("xml_template_middle.txt") + "\n";
	end

	# Returns the end part of the XML template as a string
	def self.get_template_end_first(number_of_xml_rows)
		return self.get_template_file("xml_template_end_first.txt") + "R3C4:R#{number_of_xml_rows}C22"+ "\n";
	end
  
  # Returns the end part of the XML template as a string
  def self.get_template_end_last
    return self.get_template_file("xml_template_end_last.txt") + "\n";
  end

	# Returns an XML node that contains information for an Excel row
	def self.get_template_row(row_content)
		return "   <Row ss:AutoFitHeight=\"0\">\n" + row_content + "   </Row>\n"
	end

	# Returns a formatted string as an XML cell
	def self.format_string(string)
		return self.get_cell("String", string)
	end

	# Returns a formatted string as an XML cell
	def self.format_boolean(boolean)
		return self.get_cell("Boolean", (boolean ? 1.to_s : 0.to_s))
	end

	def self.format_number(number)
		return self.get_cell("Number", number.to_s)
	end
	
	def self.get_404
    return "    <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s69\"><Data ss:Type=\"Number\">404</Data></Cell>\n"
	end

	private

	# Reads the template file and returns it as a string
	def self.get_template_file(filename)
		template = ""

		File.open(Rails.root.join('app', 'assets', 'xml', filename), 'r') do |file|
			file.each_line do |line|
				template += line
			end
		end

		return template.chomp
	end

	# Returns an Excel XML Node for a cell in the table
	def self.get_cell(data_type, data)
		return "    <Cell><Data ss:Type=\"" + data_type + "\">" + data + "</Data></Cell>\n"
	end
end
