note
	description: "Class to execute a query using Solr engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_SOLR_QUERY_EXECUTOR

inherit
	IR_QUERY_EXECUTOR

	IR_QUERY_VISITOR

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			set_host_name ("localhost")
			set_port (8983)
		end

feature -- Access

	host_name: STRING
			-- Host name of the Solr server
			-- Default is "localhost"

	port: INTEGER
			-- Port of the Solr server
			-- Default is 8983

feature -- Setting

	set_host_name (a_name: STRING)
			-- Set `host_name' with `a_name'
		do
			host_name := a_name.twin
		ensure
			host_name_set: host_name ~ a_name
		end

	set_port (a_port: INTEGER)
			-- Set `port' with `a_port'.
		do
			port := a_port
		ensure
			port_set: port = a_port
		end

feature -- Basic operations

	execute (a_query: IR_QUERY)
			-- Execute `a_query'.
		do
			a_query.process (Current)
		end

feature{NONE} -- Query

	process_boolean_query (a_query: IR_BOOLEAN_QUERY)
			-- Process `a_query'.
		local
			l_query: STRING
			l_result: STRING
			l_file: PLAIN_TEXT_FILE
			l_xml_parser: IR_VERY_SIMPLE_XML_PARSER
			l_time1, l_time2: DATE_TIME
			l_file2: PLAIN_TEXT_FILE

		do
			create l_time1.make_now
			l_query := query_request (query_syntax_from_query (a_query))
			io.put_string ("------------------%N")
			io.put_string (l_query)
			create l_file2.make_create_read_write ("/tmp/query.txt")
			l_file2.put_string (l_query)
			l_file2.close
			io.put_string ("------------------%N")

				-- Execute query.
			l_result := raw_result_from_query (l_query)
			io.put_string (l_result)

				-- Store data in a file so it can be used by the XML parser.
			create l_file.make_create_read_write ("/tmp/result.xml")
			l_file.put_string (l_result)
			l_file.close

				-- Parse xml file to get result.
			create l_xml_parser.make ("/tmp/result.xml")
			l_xml_parser.analyze_file
			last_result := l_xml_parser.last_result
			create l_time2.make_now
			io.put_string (last_result.text)
			io.put_string (l_time1.out + "%N")
			io.put_string (l_time2.out + "%N")

		end

feature{NONE} -- Implementation

	query_request (a_query_syntax: STRING): STRING
			-- HTTP GET request URL to execute query in `a_query_syntax'
		do
			create Result.make (a_query_syntax.count + 64)
			Result.append ("http://")
			Result.append (host_name)
			Result.append_character (':')
			Result.append (port.out)
			Result.append ("/solr/select?indent=on&version=2.2&q=")
			Result.append (a_query_syntax)
		end

	query_syntax_from_query (a_query: IR_BOOLEAN_QUERY): STRING
			-- Query syntax from `a_query' in Solr format
		local
			l_term_syntax: STRING
			l_cursor: DS_HASH_SET_CURSOR [IR_TERM]
			i: INTEGER
			c: INTEGER
			l_returned_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			create Result.make (2048)

				-- Add all searchable terms into the query syntax.
			from
				l_cursor := a_query.terms.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_term_syntax := escaped_term_syntax (term_syntax_generator.field_syntax (l_cursor.item))
				if not l_cursor.is_last then
					l_term_syntax.append (once "%%0D%%0A")
				end
				Result.append (l_term_syntax)
				l_cursor.forth
			end

				-- Add all returned fields
			Result.append ("&fl=score")
			from
				l_returned_cursor := a_query.returned_fields.new_cursor
				l_returned_cursor.start
			until
				l_returned_cursor.after
			loop
				l_term_syntax := escaped_term_syntax (l_returned_cursor.item)
				Result.append_character (',')
				Result.append (l_term_syntax)
				l_returned_cursor.forth
			end

				-- Add meta options
			across a_query.meta as l_options loop
				Result.append_character ('&')
				Result.append (l_options.key)
				Result.append_character ('=')
				Result.append (l_options.item)
			end
		end

	escaped_term_syntax (a_term_string: STRING): STRING
			-- Term string in excaped format
		do
			create Result.make_from_string (a_term_string)
			Result.replace_substring_all (once "%%", once "%%25")
			Result.replace_substring_all (once "+", once "%%2B")
			Result.replace_substring_all (once " ", once "+")
		end

	term_syntax_generator: IR_SOLR_QUERY_FIELD_SYNTAX_GENERATOR
			-- Term query generator
		once
			create Result
		end

feature{NONE} -- cURL

	curl: CURL_EXTERNALS
			-- cURL externals
		once
			create Result
		end

	curl_easy: CURL_EASY_EXTERNALS
			-- cURL easy externals
		once
			create Result
		end

	curl_handle: POINTER;
			-- cURL handle

	raw_result_from_query (a_query_url: STRING): STRING
			-- Raw text result from executing the query specified by `a_query_url'
		local
			l_result: INTEGER
			l_curl_string: CURL_STRING
		do
			if curl.is_dynamic_library_exists then
				create l_curl_string.make_empty

				curl.global_init

					-- Init the curl session
				curl_handle := curl_easy.init

					-- Specify URL to get
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, a_query_url)

					-- Send all data to default Eiffel curl write function
				curl_easy.set_write_function (curl_handle)

					-- We pass our `l_curl_string''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)

					-- Get it!
				l_result := curl_easy.perform (curl_handle)

					--  Cleanup curl stuff
				curl_easy.cleanup (curl_handle)

				Result := l_curl_string.out

					--You don't need to be aware of memory management issue since Eiffel will handle all of them for you.
				curl.global_cleanup
			end
		end

end
