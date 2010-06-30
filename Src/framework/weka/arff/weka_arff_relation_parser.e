note
	description: "This class will take an arff file and will create a WEKA_ARFF_RELATION from it."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_RELATION_PARSER
create
	make

feature -- interface

	last_relation: WEKA_ARFF_RELATION

	had_errors: BOOLEAN

	set_file_path(a_file_path: STRING)
		do
			file_path := a_file_path
		end

	parse_relation
			-- parses the arff file to generation a WEKA_ARFF_RELATION
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_has_data_passed: BOOLEAN
			l_data: ARRAYED_LIST[STRING]
		do
			had_errors := False
			create_relation
			create l_file.make_open_read (file_path)

			from until l_file.end_of_file loop
				l_file.read_line
				l_line := l_file.last_string
				if not l_line.starts_with ("%%") and not l_line.is_empty and not (l_line ~ "%N") then
					if l_has_data_passed  then
						l_data := parsed_data(l_line, last_relation.attributes.count)
						if last_relation.is_instance_valid(l_data) then
							last_relation.extend(l_data)
						else
							had_errors := True
						end
					end
					if l_line.starts_with ({WEKA_CONSTANTS}.data) then
						l_has_data_passed := True
					end
				end
			end
		end
feature{NONE} -- creation

	make(a_file_path: STRING)
		do
			file_path := a_file_path
		end

feature{NONE} -- implementation

	file_path: STRING
		-- the path to the arff file we are going to parse

	parsed_data(a_line:STRING; a_count:INTEGER):ARRAYED_LIST[STRING]
			-- parses the data lines from the file and puts them in the inherited array list
		local
			l_values: LIST[STRING]
			l_value: STRING
		do
			l_values := a_line.split (',')

			create Result.make (a_count)
			from l_values.start until l_values.after loop
				Result.extend (l_values.item_for_iteration)
				l_values.forth
			end

		end

	create_relation
			-- creates the WEKA_ARFF_RELATION, only parses the name, attributes and comment at that point
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_attr_factory: WEKA_ARFF_ATTRIBUTE_FACTORY
			l_has_attribute_passed: BOOLEAN
			l_attributes: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_name: STRING
			l_comment: STRING
		do
			create l_attr_factory
			create l_file.make_open_read (file_path)
			l_comment := ""
			l_name := ""
			create l_attributes.make (100)
			l_attributes.compare_objects

			from until l_file.end_of_file loop
				l_file.read_line
				l_line := l_file.last_string
				if not l_line.starts_with ("%%") then
					if l_line.starts_with ({WEKA_CONSTANTS}.relation) then
						l_name := l_line.substring (10, l_line.count)
					end
					if l_attr_factory.is_attribute (l_line) then
						l_has_attribute_passed := True
						l_attributes.force (l_attr_factory.create_attribute (l_line))
					end
				elseif not l_has_attribute_passed then
					l_line.remove_head (1)
					l_comment.append (l_line)
					l_comment.append ("%N")
				end
			end

			create last_relation.make(l_attributes)

			if not l_name.is_empty then
				last_relation.set_name(l_name)
			end

			if not l_comment.is_empty then
				last_relation.set_comment(l_comment)
			end
		end
end
