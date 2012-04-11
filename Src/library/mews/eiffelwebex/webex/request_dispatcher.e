indexing
	description	: "System's entry class derived from CGI_INTERFACE, takes care of requests and sends back responses"
	author: "Peizhu Li <lip@student.ethz.ch>"
	date: "12.12.2007"
	revision: "0.2"

deferred class
	REQUEST_DISPATCHER

inherit
	CGI_INTERFACE

redefine
	make
end

feature -- Attributes
	cookie_enabled: BOOLEAN
			-- whether cookie is enabled by browser
	session_enabled: BOOLEAN
			-- whether session support should be enabled
	session: SESSION
			-- actual session object

	config: CONFIG_READER
			-- website configuration (handler, default stylesheet, actual session class)

	handler_id_string: STRING
			-- string identifies which handler should be instantiated for actual request

	command_string: STRING
			-- command string that handler need to process

feature {REQUEST_DISPATCHER} -- Attributes

	debug_mode: BOOLEAN is True
			-- Should exception trace be displayed in case a crash occurs?

	session_manager: SESSION_MANAGER
			-- object that responsable to retrieve/store session

	actual_handler: REQUEST_HANDLER
			-- handler that will process actual request

	processing_finished: BOOLEAN
			-- finished processing, return result

	return_page: HTML_PAGE
			-- result HTML_PAGE to be sent back to the browser

feature -- creation
	make is
			-- Initiate input data parsing and process information.
		local
			retried: BOOLEAN
		do
			session_enabled := true

			if not retried then
				parse_input
				execute
			else
				if debug_mode then
					handle_exception
				end
			end


		rescue
			retried := True
			retry
		end

feature -- dispatching

	execute is
			-- process actual request, send back result html page to the browser.
		do

			-- get handler identification string
			parse_handler_command_string

			-- read configuration
			init_configuration

			config.read_configuration (handler_id_string, command_string)
			if handler_id_string.is_empty then
				handler_id_string := config.default_request
			end

			if command_string.is_empty then
				command_string := config.default_command
			end

			-- initialized session object in case session support is expected
			if session_enabled then
				-- init session manager
				init_session_manager

				-- check and initialize session object for current connection
				init_session
			end

			-- additional common tasks
			pre_execute

			-- initialize the coresponding handler object according to actual configuration and handler_id_string
			if not processing_finished then
				instantiate_handler

				if actual_handler = void then
					process_undefined_request
					processing_finished := true
				else
					return_page := actual_handler.process_request
				end

				-- addtional common tasks to be executed after got result page
				if not processing_finished then
					post_execute
				end
			end


			-- generate header
			if not response_header.is_complete_header then
				response_header.generate_text_header
			end

			if session_enabled then
				-- save session object
				save_session

				-- setup response_header to let include session id cookie
				setup_sid_cookie
			end

			-- send response to browser
			response_header.send_to_browser
			response_header.Output.put_string (return_page.out)

		rescue
			io.error.putstring ("crash in `request_dispatcher.execute()' %N")
		end

feature {REQUEST_DISPATCHER} --  initialization

	set_session_enabled(a_enabled: BOOLEAN) is
			-- set whether session should be enabled
		do
			session_enabled := a_enabled
		end

	process_undefined_request is
			-- generate result page in case unkown request
		do
			create {ERROR_PAGE_VIEW}return_page.build_default_not_found_page
		end


	parse_handler_command_string is
		-- identify request and command strings ((http://localhost/cgi-bin/zen.cgi?zengarden&action=register -> zengarden, register)
		do
			-- no more restricted with GET/POST method
			create handler_id_string.make_empty

			if not input_data.is_empty then
				if input_data.has('&') then
					if not input_data.split ('&').i_th (1).has('=') then
						handler_id_string.append((input_data.split ('&')).i_th (1))
					end
				else
					handler_id_string.append(input_data)
				end
				if handler_id_string.is_empty and field_defined("handler_id") then
					handler_id_string.append(text_field_value("handler_id"))
				end
			end

			if field_defined("cmd") then
				create command_string.make_from_string (text_field_value("cmd"))
			else
				create command_string.make_empty
			end
		end

	init_configuration is
				-- read configuration file
		local
			istart, iend: INTEGER
		do
			istart := script_name.last_index_of ('/', script_name.count) + 1

			iend := script_name.last_index_of ('.', script_name.count) - 1
			if iend = -1 or iend <= istart then
				iend := script_name.count
			end

			create config.make("./" + script_name.substring (istart, iend) + ".conf")

		end


	instantiate_handler is
			-- based on initialized handler mapping table, lookup and initialize a handler for current request
		require
			config_is_set: config /= void
		local
			handler_type: STRING
			handler: INTERNAL
			type: INTEGER
		do
			-- lookup handler name string
			if not config.handler.is_empty then
				create handler_type.make_from_string(config.handler)
			elseif not config.notfound_request.is_empty then  -- not defined request, but 'notfound_request' defined in config file
				create handler_type.make_from_string(config.notfound_request)
				handler_id_string := config.notfound_request
				command_string := config.notfound_command
			else -- not defined request, not handled by any handlers
				create handler_type.make_empty
			end

			if not handler_type.is_empty then
				create handler
				type := handler.dynamic_type_from_string (handler_type)

				actual_handler ?= handler.new_instance_of(type)
				if actual_handler /= void then
					-- initialize handler together with current dispatcher object as environment, while INTERNAL wont call the create procedure
					actual_handler.initialize(current)
				end
			end

		rescue
			io.error.putstring ("crash in `lookup_and_instantiate_handler' %N")
		end

feature {REQUEST_DISPATCHER} -- pre/post execution

	pre_execute is
			-- common tasks to be executed before starting process user request
			-- if necessary, set 'processing_finished' tag and return_page to premature processing
		do
		end

	post_execute is
			-- common tasks to be executed after request processed
		do
		end


feature {REQUEST_DISPATCHER} -- session/cookie

	init_session_manager is
			-- init session_manager object
		do
			create {SESSION_MANAGER_FILE_IMPL}session_manager.make(config.session_files_folder, config.session_expiration, config.session_id_length)
		end

	init_session is
			-- retrieve the saved session or create a new session object
		local
			sid: STRING
		do
			-- whether cookie is enabled on client side?
			-- we are trying to set cookie on client side at every response
			-- so as a trick, as long as we cannot retrieve a valid/not expired cookie, we assume cookie is disabled, url_rewriting will be used
			create sid.make_empty

			if cookies /= void and then cookies.has("sid") then
				create sid.make_from_string(cookies.item("sid"))
				session := session_manager.get_session(sid)
				if session /= void and then not session.expired then
					cookie_enabled := true
					check
						cookie_enabled_and_sid_ok: not sid.is_empty
					end
				else
					create sid.make_empty
				end
			end

			if sid.is_empty then
				if field_defined ("sid") and not text_field_value("sid").is_empty then
					create sid.make_from_string(current.text_field_value("sid"))
				else
					check
						cookie_disabled_and_sid_empty: sid.is_empty
					end
					create sid.make_from_string (session_manager.generate_session_id)
				end
			end

			check
				sid_not_empty: not sid.is_empty
			end

			session := session_manager.get_session(sid)

			if session = void or (session /= void and then session.expired) then -- initial session new
				create session.make
				session.set_session_id (sid)
				session.set_expiration_after_seconds (config.session_expiration)
			end
		ensure
			app_session_object_initialized: session /= void and not session.session_id.is_empty
		end


save_session is
		-- save actual session to session manager
	do
		session.set_expiration_after_seconds (config.session_expiration)
		session_manager.save_session (session.session_id, session)
	end

setup_sid_cookie is
		-- update cookie in the client
		require
			session.session_id /=void and then not session.session_id.is_empty
		local
			expire: STRING
		do
			expire := session.expiration_time.formatted_out ("ddd, [0]dd-[0]mm-yyyy [0]hh:[0]mi:[0]ss") + " GMT"
			response_header.set_cookie ("sid", session.session_id.out, expire, config.application_path, void, void); -- key, value, expiration, path, domain, secure
		end




invariant
	invariant_clause: True

end -- class REQUEST_INTERFACE
