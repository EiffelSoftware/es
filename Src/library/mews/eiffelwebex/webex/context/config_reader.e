indexing
	description: "read the website configuration file, initialize handler-mapping, actual session class name and expiration time information."
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "20.12.2008"
	revision: "$0.6$"

class
	CONFIG_READER

create
	make

feature -- attribute

	config_file_name: STRING
			-- full path to the config file

	application_path: STRING
			-- path to eiffel application

	default_request: STRING
	default_command: STRING
			-- default request and command string in case client hasn't specified a request

	notfound_request: STRING
	notfound_command: STRING
			-- in case of an unknown request, request/command string used to identify a handler

	stylesheet: STRING
			-- stylesheet path
	javascript: STRING
			-- javascript path
	image_path: STRING
			-- path to image files
	error_template_page: STRING
			-- a template page will be used for HTML error pages (4xx errors)

	database_server: STRING
	database_port: INTEGER
	database_socket_file: STRING
	database_name: STRING
	database_username: STRING
	database_password: STRING

	session_files_folder: STRING
			-- folder that all session files will be saved in
	session_expiration: INTEGER
			-- session expirated (in hours)
	session_id_length: INTEGER
			-- length of generated session id

	variables: HASH_TABLE[STRING, STRING]
			-- application constants as strings

	handler: STRING
			-- handler class name for given request/action
	template: STRING
			-- html template file for given request/action


feature {NONE} -- creation
	make(file_name: STRING) is
			-- initialize objects / default values
		do
			create config_file_name.make_from_string (file_name)

			create application_path.make_empty
			create default_request.make_empty
			create default_command.make_empty

			create stylesheet.make_empty
			create javascript.make_empty
			create image_path.make_empty
			create error_template_page.make_empty

			create database_server.make_empty
			database_port := 3306
			create database_socket_file.make_empty
			create database_name.make_empty
			create database_username.make_empty
			create database_password.make_empty

			create session_files_folder.make_from_string ("")
			session_expiration := 600  -- 10 minutes
			session_id_length := 12

			create variables.make (100)

			create handler.make_empty
			create template.make_empty

		end

feature -- access

	read_configuration(request, command: STRING) is
			-- parse config file to get configurations for sepcified request/command
		require
			config_file_name /= void
		local
			configfile: PLAIN_TEXT_FILE
		do

		create configfile.make_open_read (config_file_name)

		from configfile.start until configfile.after loop
			configfile.read_line

			if not configfile.last_string.is_empty and then configfile.last_string.item(1) /= '#' then
				if configfile.last_string.has_substring ("[general]") then
				   parse_general_section(configfile)
				end

				if configfile.last_string.has_substring ("[database]") then
				   parse_database_section(configfile)
				end

				if configfile.last_string.has_substring ("[session]") then
				   parse_session_section(configfile)
				end

				if configfile.last_string.has_substring ("[constants]") then
				   parse_constants_section(configfile)
				end

				if (not request.is_empty or not default_request.is_empty) and then configfile.last_string.has_substring ("[RequestHandler]") then
				   parse_requesthandler_section(configfile, request, command)
				end
			end

		end --loop

		configfile.close
	end

	has_constant(name: STRING): BOOLEAN is
			-- check whether a specified constant is defined in config file
		require
			valid_name_is_given: name /= void and not name.is_empty
		do
			Result := variables.has (name)
		end

	get_constant(name: STRING): STRING is
			-- retrieve a constant string defined in configuration file, return "" if not exists
		require
			valid_name_is_given: name /= void and not name.is_empty
		do
			if variables.has (name) then
				Result := variables.item(name)
			else
				Result := ""
			end
		end

	get_handler_type(request: STRING): STRING is
			-- parse config file to get the handler id string for specified request/command
		require
			config_file_name /= void
		local
			configfile: PLAIN_TEXT_FILE
		do

		create Result.make_empty

		create configfile.make_open_read (config_file_name)

		from configfile.start until configfile.after loop
			configfile.read_line
			if not configfile.last_string.is_empty and then configfile.last_string.item(1) /= '#' and then Result.is_empty then
				if (not request.is_empty or not default_request.is_empty) and then configfile.last_string.has_substring ("[RequestHandler]") then
				   Result := lookup_handler_type(configfile, request)
				end
			end

		end --loop

		configfile.close
	end


	get_template_file(request, command: STRING): STRING is
			-- parse config file to get template file for specified request/command
		require
			config_file_name /= void
		local
			configfile: PLAIN_TEXT_FILE
		do

		create Result.make_empty

		create configfile.make_open_read (config_file_name)

		from configfile.start until configfile.after loop
			configfile.read_line
			if not configfile.last_string.is_empty and then configfile.last_string.item(1) /= '#' and then Result.is_empty then
				if (not request.is_empty or not default_request.is_empty) and then configfile.last_string.has_substring ("[RequestHandler]") then
				   Result := lookup_template_file(configfile, request, command)
				end
			end

		end --loop

		configfile.close
	end
feature {NONE} -- implementation

	parse_general_section(configfile: PLAIN_TEXT_FILE) is
			-- parsing [general] section
		local
			value: STRING
		do
			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("app_path") and then value /= void then
					   application_path := value
					elseif configfile.last_string.has_substring ("default_request") and then value /= void then
					   default_request := value
					elseif configfile.last_string.has_substring ("default_command") and then value /= void then
					   default_command := value
					elseif configfile.last_string.has_substring ("notfound_request") and then value /= void then
					   notfound_request := value
					elseif configfile.last_string.has_substring ("notfound_command") and then value /= void then
					   notfound_command := value
					elseif configfile.last_string.has_substring ("stylesheet") and then value /= void then
					   stylesheet := value
					elseif configfile.last_string.has_substring ("javascript") and then value /= void then
					   javascript := value
					elseif configfile.last_string.has_substring ("image_path") and then value /= void then
					   image_path := value
					elseif configfile.last_string.has_substring ("error_template_page") and then value /= void then
					   error_template_page := value
					end
				end

				configfile.read_line
			end --loop
		end

	parse_database_section(configfile: PLAIN_TEXT_FILE) is
			-- parsing [database] section
		local
			value: STRING
		do

			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("host") and then value /= void then
					   database_server := value
					elseif configfile.last_string.has_substring ("port") and then value /= void and then not value.is_empty then
					   database_port := value.to_integer
					elseif configfile.last_string.has_substring ("socketfile") and then value /= void then
					   database_socket_file := value
					elseif configfile.last_string.has_substring ("database") and then value /= void then
					   database_name := value
					elseif configfile.last_string.has_substring ("username") and then value /= void then
					   database_username := value
					elseif configfile.last_string.has_substring ("password") and then value /= void then
					   database_password := value
					end
				end

				configfile.read_line

			end --loop
		end

	parse_session_section(configfile: PLAIN_TEXT_FILE) is
			-- parsing [session] section
		local
			value: STRING
		do
			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("session_files_folder") and then value /= void then
					   session_files_folder := value
					   if session_files_folder.item(session_files_folder.count) /= '/' then
					   		session_files_folder.extend ('/')
					   end
					elseif configfile.last_string.has_substring ("expiration") and then value /= void and then not value.is_empty then
					   session_expiration := value.to_integer
					elseif configfile.last_string.has_substring ("session_id_length") and then value /= void and then not value.is_empty then
					   session_id_length := value.to_integer
					end
				end

				configfile.read_line
			end --loop
		end

	parse_constants_section(configfile: PLAIN_TEXT_FILE) is
			-- parsing [constants] section
		local
			name: STRING
			value: STRING
		do
			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						name := configfile.last_string.split ('=').i_th (1)
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							name.left_adjust
							name.right_adjust
							value.left_adjust
							value.right_adjust
						end
					end

					if not name.is_empty and then not value.is_empty then
					   variables.extend(value, name)
					end
				end

				configfile.read_line
			end --loop
		end



	parse_requesthandler_section(configfile: PLAIN_TEXT_FILE; request, command: STRING) is
			-- parsing [requesthandler] section
		require
			not request.is_empty or not default_request.is_empty
		local
			right_section: BOOLEAN
			actual_request: STRING
			command_template: STRING
			value: STRING
		do
			right_section := false
			if request.is_empty then
				create actual_request.make_from_string (default_request)
			else
				create actual_request.make_from_string (request)
			end

			if command.is_empty then
				create command_template.make_from_string(default_command + "_template")
			else
				create command_template.make_from_string(command + "_template")
			end

			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("request") and then value /= void and then value.is_equal(actual_request) then
					   right_section := true
					end

					if right_section then
						if configfile.last_string.has_substring ("handler") and then value /= void then
						   handler := value
						end

						if configfile.last_string.has_substring ("default_template") and then value /= void then
						   template := value
						end

						if (not command.is_empty or not default_command.is_empty) and then configfile.last_string.has_substring (command_template) and then value /= void then
						   template := value
						end
					end
				end

				configfile.read_line
			end --loop
		end

	lookup_template_file(configfile: PLAIN_TEXT_FILE; request, command: STRING): STRING is
			-- parsing [requesthandler] section for template file for specified request/command
		require
			not request.is_empty or not default_request.is_empty
		local
			right_section: BOOLEAN
			command_template: STRING
			value: STRING
		do
			Result := ""

			right_section := false

			if command.is_empty then
				create command_template.make_empty
			else
				create command_template.make_from_string(command + "_template")
			end

			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("request") and then value /= void and then value.is_equal(request) then
					   right_section := true
					end

					if right_section then
						if configfile.last_string.has_substring ("default_template") and then value /= void then
						   Result := value
						end

						if not command_template.is_empty and then configfile.last_string.has_substring (command_template) and then value /= void then
						   Result := value
						end
					end
				end

				configfile.read_line
			end --loop
		end

	lookup_handler_type(configfile: PLAIN_TEXT_FILE; request: STRING): STRING is
			-- parsing [requesthandler] section for handler id string for specified request/command
		require
			not request.is_empty or not default_request.is_empty
		local
			right_section: BOOLEAN
			value: STRING
		do
			Result := ""

			right_section := false

			from configfile.read_line until configfile.last_string.is_empty or configfile.last_string.item(1) = '[' or not Result.is_empty loop

				if configfile.last_string.item(1) /= '#' then
					if configfile.last_string.has('=') then
						value := configfile.last_string.split ('=').i_th (2)
						if value /= void then
							value.left_adjust
							value.right_adjust
						end
					end

					if configfile.last_string.has_substring ("request") and then value /= void and then value.is_equal(request) then
					   right_section := true
					end

					if right_section then
						if configfile.last_string.has_substring ("handler") and then value /= void then
						   Result := value
						end
					end
				end

				configfile.read_line
			end --loop
		end


invariant
	invariant_clause: True -- Your invariant here

end
