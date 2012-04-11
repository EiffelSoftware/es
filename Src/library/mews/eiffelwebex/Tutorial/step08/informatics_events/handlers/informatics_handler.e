indexing
	description: "Generic parent handler for this informatics_events application, defined common initialization and processing routines."
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

deferred class
	INFORMATICS_HANDLER

inherit
	REQUEST_HANDLER
	redefine
		make, initialize
	end
	APPLICATION_CONSTANTS

feature -- Attribute

	user_manager: USER_MANAGER
		-- access registered user information

	encryptor: ENCRYPTOR
		-- used encryptor implementation

	return_view: HTML_TEMPLATE_VIEW
		-- result html page

	actual_user: INFORMATICS_USER
		-- actual user

	my_session: INFORMATICS_SESSION
		-- wrapped session related operations

feature -- Creation

	make is
			-- creation
		do
			PRECURSOR

			create my_session.make (session)

			create {ENIGMA}encryptor.make(5)
		end

	initialize(env: REQUEST_DISPATCHER) is
			-- init references to dispatcher and session object
		do
			PRECURSOR(env)

			create my_session.make (session)

			create {ENIGMA}encryptor.make(5)
		end

feature {NONE} -- add admin user

	add_admin_user is
			-- create an administrator account in user_manager
	require
		admin_not_defined: not user_manager.username_defined (admin_email)
	local
		admin: INFORMATICS_USER
		do
			create admin.make
			admin.set_username (admin_email)
			admin.set_first_name (admin_first_name)
			admin.set_last_name (admin_last_name)
			admin.set_email (admin_email)
			admin.set_password (admin_password)
			admin.set_organization (admin_organization)
			admin.set_telephone (admin_telephone)

			admin.set_role (role_administrator)

			user_manager.add_user(admin)
			user_manager.persist_data
		end

feature {INFORMATICS_HANDLER} -- processing request

	is_request_authorized: BOOLEAN is
			-- check whether actual request is allowed
		require
			actual_user_valid: actual_user /= void
		do
			Result := true

			if actual_user.role /= role_administrator  then -- normal user, no "edit event", no "list user"
				if context.handler_id_string.is_equal ("userlist") then Result := false end
				if context.handler_id_string.is_equal ("event") and then context.command_string.is_equal ("edit") then Result:= false end
			elseif actual_user.role = role_guest then -- guest
				Result := false
	   			if context.handler_id_string.is_equal ("eventlist") or context.handler_id_string.is_equal ("other") then Result := true end
	   			if context.handler_id_string.is_equal ("user") then
	   				if context.command_string.is_equal ("userform") or context.command_string.is_equal ("loginform") then result := true end
	   			end
				if context.handler_id_string.is_equal ("event") then
	   				if context.command_string.is_equal ("details") then result := true end
				end
			end
		end

	pre_processing is
			-- common tasks to be executed before starting process user request
			-- try authentice user, and filter out unauthorized request
		do
			create {USER_MANAGER_FILE_IMPL}user_manager.make(context.config.get_constant ("app_data_folder"), context.config.get_constant ("users_file_name"), encryptor)

			if not user_manager.username_defined (admin_email) then
				add_admin_user
			end

			if not my_session.username.is_empty and then user_manager.username_defined (my_session.username) then
				actual_user ?= user_manager.get_user_by_name (my_session.username)
			else
				create actual_user.make
			end

			if not is_request_authorized then
				redirect_to_permission_denied_page
			end

		end

	post_processing is
			-- common tasks to be executed after request processed
		do
			check
				script_name_valid: context.config.application_path /= void and not context.config.application_path.is_empty
			end

			update_menu

			-- application configuration tags
			return_view.replace_marker_with_string ("STYLESHEET", context.config.stylesheet)
			return_view.replace_marker_with_string ("JAVASCRIPT", context.config.javascript)
			return_view.replace_marker_with_string ("IMAGE_PATH", context.config.image_path)

			return_view.replace_marker_with_string ("APP_PATH", context.config.application_path)
			return_view.replace_marker_with_string ("ADMIN_EMAIL", Admin_email)

			-- common tags
			return_view.replace_marker_with_string ("FIRST_NAME", actual_user.first_name)
			return_view.replace_marker_with_string ("LAST_NAME", actual_user.last_name)
			return_view.replace_marker_with_string ("USER_NAME", actual_user.first_name + " " + actual_user.last_name)
			return_view.replace_marker_with_string ("USER_ID", actual_user.email)
			return_view.replace_marker_with_string ("EMAIL_ADDRESS", actual_user.email)

			-- cleanup when necessary
			return_view.cleanup_tags
			return_view.cleanup_unused_sections

			return_page ?= return_view

			check
				result_page_set: return_view /= void and then return_page /= void
			end
		end

	update_menu is
		 -- Set the menu according to the user
		local
			s_username: STRING
			s_menu: STRING
		do
			if actual_user.role = role_normal_user then
				create s_menu.make_from_string("{
	        					<span><a href="{#APP_PATH#}?event&amp;cmd=list">Home</a></span>
	              				<span><a href="{#APP_PATH#}?event&amp;cmd=eventform&amp;mode=add">Submit Event</a></span>
	              				<span><a href="{#APP_PATH#}?event&amp;cmd=ownevents">Submitted Events</a></span>
				}")
				create s_username.make_from_string("{
								<a href="{#APP_PATH#}?user&amp;cmd=details">{#USER_NAME#}</a>&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?user&amp;cmd=userform&amp;mode=update">Edit Profile</a>&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?event&amp;cmd=logout">Logout</a>
				}")

			elseif actual_user.role = role_administrator then
				create s_menu.make_from_string("{
	        					<span><a href="{#APP_PATH#}?event&amp;cmd=list">Home</a></span>
	              				<span><a href="{#APP_PATH#}?event&amp;cmd=eventform&amp;mode=add">Submit Event</a></span>
	              				<span><a href="{#APP_PATH#}?user&amp;cmd=list">View Users</a></span>
	              				<span><a href="{#APP_PATH#}?user&amp;cmd=userform&amp;mode=add">Add User</a></span>
				}")
				create s_username.make_from_string("{
								<a href="{#APP_PATH#}?user&amp;cmd=details">{#USER_NAME#}</a>&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?user&amp;cmd=userform&amp;mode=update">Edit Profile</a>&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?event&amp;cmd=logout">Logout</a>
				}")
			else
				create s_menu.make_from_string("{
								<span><a href="{#APP_PATH#}?event&amp;cmd=list">Home</a></span>
				}")
				create s_username.make_from_string("{
								Welcome, Guest&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?user&amp;cmd=userform&amp;mode=register">Register</a>&nbsp;|&nbsp;
								<a href="{#APP_PATH#}?user&amp;cmd=loginform">Login</a>
				}")
			end

			return_view.replace_marker_with_string ("MAIN_MENU", s_menu)
			return_view.replace_marker_with_string ("USER_MENU", s_username)

		end


feature {INFORMATICS_HANDLER} -- form validation

	expand_error_string(string_table:HASH_TABLE[STRING, STRING]): STRING is
			-- extract validation failure message string from table, added a <br /> between for the notification message
		local
			err_string: STRING

		do
			create err_string.make(2048)
			from string_table.start  until  string_table.after
			loop
--		        err_string.append (string_table.key_for_iteration)
--		        err_string.append (": ")
		        err_string.append (string_table.item_for_iteration)
		        err_string.append ("<br />")
				string_table.forth
			end

			Result := err_string
		end

feature {INFORMATICS_HANDLER} -- error pages

	redirect_to_permission_denied_page is
			-- premature processing, redirect reqeust to a "Permission denied" page
		do
			create return_view.make (context.config.error_template_page)
			return_view.replace_marker_with_string ("ERROR_TITLE", "Permission denied")
			return_view.replace_marker_with_string ("ERROR_DESCRIPTION", "403 Forbidden - You are not authorized to access the requested URL.")

			-- still execute post_processing
			post_processing

			processing_finished := true
		end

	redirect_to_invalid_request_page is
			-- premature processing, redirect reqeust to a "Invalid Request" page
		do
			create return_view.make(context.config.error_template_page)
			return_view.replace_marker_with_string ("ERROR_TITLE", "Invalid Request")
			return_view.replace_marker_with_string ("ERROR_DESCRIPTION", "Specified request/command cannot be handled.")

			-- still execute post_processing
			post_processing

			processing_finished := true
		end

invariant
	invariant_clause: True -- Your invariant here

end
