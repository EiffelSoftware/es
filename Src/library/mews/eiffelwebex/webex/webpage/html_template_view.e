indexing
	description: "a template based HTML page view, implement a rich set of routines to help generating a result HTML page based on a predefined HTML template."
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "12.01.2007"
	revision: "$0.6$"

class
	HTML_TEMPLATE_VIEW
inherit
	VIEW
	rename
		make as	make_empty
	export
		{ANY} make_empty
	end

create
	make, make_empty

feature --Set

	replace_marker_with_string(mark_string, content: STRING) is
		 -- replace marker with content
		local
			marker: STRING
		do
			create marker.make_from_string("{#" + mark_string + "#}")
			replace_marker(marker, content)
		end

	replace_marker_with_file(mark_string, filename: STRING) is
		 -- replace marker with the content of a text file
		local
			contentfile: PLAIN_TEXT_FILE
			content: STRING
		do
			create contentfile.make_open_read (filename)
			create content.make_empty
			from contentfile.start until contentfile.after loop
				contentfile.read_line
				content.append (contentfile.last_string + "%N")
			end
			contentfile.close

			replace_marker_with_string(mark_string, content)

		end


feature -- Commands

	enable_alternative_section (marker_string: STRING; a_number: INTEGER) is
			-- turns an alternative marker section of the html code on, and the default off.
			-- a_number indicates which alternative section to use, starting with 1.
			-- the default section labeled with number 0 is already turned on and cannot be enabled again.
		require
			marker_string_valid: marker_string /= void and then not marker_string.is_empty
			number_valid: a_number > 0
		do
--			remove_section(marker_string + "_0")
			comment_out_section(marker_string + "_0")
			enable_section(marker_string + "_" + a_number.out)
		end

	enable_section (marker_string: STRING) is
			-- turns an alternative marker section of the html code on, and the default off.
			-- a_number indicates which alternative section to use, starting with 1.
			-- the default section labeled with number 0 is already turned on and cannot be enabled again.
		require
			marker_string_valid: marker_string /= void and then not marker_string.is_empty
		do
			-- in case section already enabled
			replace_marker ("<!--##" + marker_string + "##-->", "")
			replace_marker ("<!--##/" + marker_string + "##-->", "")

			-- enable a commented section
			replace_marker ("<!--##" + marker_string + "##", "")
			replace_marker ("##/" + marker_string + "##-->", "")
		end

	comment_out_section (marker_string: STRING) is
			-- turns an alternative marker section of the html code on, and the default off.
			-- a_number indicates which alternative section to use, starting with 1.
			-- the default section labeled with number 0 is already turned on and cannot be enabled again.
		require
			marker_string_valid: marker_string /= void and then not marker_string.is_empty
		do
			replace_marker ("<!--##" + marker_string + "##-->", "<!--##" + marker_string + "##")
			replace_marker ("<!--##/" + marker_string + "##-->", "##/" + marker_string + "##-->")
		end

	cleanup_unused_sections is
			-- remove the comments from the html code.
		local
			start_index, end_index, marker_start, marker_end, enabled_marker_start: INTEGER
			marker_string: STRING
			end_tag_string: STRING
		do
			from
				start_index := 1
			until
				start_index = 0
			loop
				start_index := image.substring_index ("<!--##", start_index)
				if start_index > 0 then
					marker_start := start_index + 6
					marker_end := image.substring_index ("##", marker_start)
					if marker_end > marker_start then
						marker_string := image.substring (marker_start, marker_end-1)
					end

					check
						identified_marker: marker_string /= void and then not marker_string.is_empty
					end

					enabled_marker_start := image.substring_index ("<!--##" + marker_string + "##-->", start_index)
					if  enabled_marker_start = start_index then  -- this section is enabled, cleanup section marker
						replace_marker ("<!--##" + marker_string + "##-->", "")
						replace_marker ("<!--/##" + marker_string + "##-->", "")
					else
						end_tag_string := "##/" + marker_string + "##-->"

						end_index := image.substring_index (end_tag_string, start_index)
						if end_index < 1 then
							end_index := image.count - end_tag_string.count + 1
						end
						image.remove_substring (start_index, end_index + end_tag_string.count - 1)
					end
				end
			end
--			f.close
		end

	cleanup_tags is
			-- remove the comments from the html code.
		local
			start_index, end_index: INTEGER
		do
			from
				start_index := 1
			until
				start_index = 0
			loop
				start_index := image.substring_index ("{#", start_index)
				if start_index > 0 then
					end_index := image.substring_index ("#}", start_index+2)
					if end_index > 0 then
						image.remove_substring (start_index, end_index + 1)
					else
						start_index := start_index + 2
					end
				end
			end
		end

	remove_section(marker_string: STRING) is
			-- remove the comments from the html code.
		local
			start_index, end_index: INTEGER
			end_tag_string: STRING
		do
			from
				start_index := 1
			until
				start_index = 0
			loop
				start_index := image.substring_index ("<!--##" + marker_string + "##", start_index)
				if start_index > 0 then
					end_tag_string := "##/" + marker_string + "##-->"
					end_index := image.substring_index (end_tag_string, start_index)
					if end_index < 1 then
						end_index := image.count - end_tag_string.count + 1
					end
					image.remove_substring (start_index, end_index + end_tag_string.count - 1)

				end
			end
		end


feature -- Creation
make(template: STRING) is
	require else
		template_file_name_valid: template /= void and then not template.is_empty
	do
		make_from_template(template)
	end


invariant

	invariant_clause: True -- Your invariant here

end
