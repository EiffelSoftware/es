indexing
	description: "handler for all zengarden testing site requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$21.12.2007$"
	revision: "$0.3.1$"

class
	ZENGARDEN_HANDLER

inherit
	REQUEST_HANDLER
	redefine
		make, initialize
	end
	SYSTEM_CONSTANTS


create
	make

feature -- Attribute
	zen_session: ZEN_SESSION
		-- wrapped system session object

	user_dao: USER_MANAGER
		-- user db

	encryptor: ENCRYPTOR
		-- used for encryption

	return_view: HTML_TEMPLATE_VIEW
		-- result html page

feature -- Creation

	make is
		-- creation
	do
		PRECURSOR

		create {ENIGMA}encryptor.make(5)
		create {USER_MANAGER_FILE_IMPL}user_dao.make(app_db_folder, users_file_name, encryptor)

	end

	initialize(env: REQUEST_DISPATCHER) is
		-- init references to dispatcher and session object
	do
		PRECURSOR(env)

		check
			session_object_valid: session /= void and then not session.session_id.is_empty
		end

		create zen_session.make (session)

		check
			got_session_valid: zen_session /= void
		end
	end


feature -- processing request

	get_stylesheet_id: INTEGER is
			-- parsing and get actual stylesheet should be used
		local
			css_index: INTEGER
			css_sheet: STRING
		do
			-- set actual style sheet based on given parameter, or take default
			if context.field_defined("css") then
				create css_sheet.make_from_string(context.text_field_value("css"))
			else
				create css_sheet.make_from_string(zen_session.css_id.out)
			end

			css_index := css_sheet.to_integer
			if css_index < 1 then css_index := 1 end
			if css_index > 220 then css_index := 220 end

			Result := css_index
		end

	get_page: INTEGER is
			-- get displayed stylesheets page
		local
			page: INTEGER
		do
			if context.field_defined("page") then
				page := context.text_field_value("page").to_integer
			else
				page := zen_session.page
			end

			if page < 1 then page := 1 end
			if page > 40 then page := 40 end

			Result := page
		end

	process_register_command is
			-- process register command
		local
			error_string: STRING
			validation_error_table: HASH_TABLE[STRING, STRING]
		do
			validation_error_table := validate_registrationform
			if validation_error_table.count = 0 then

				zen_session.set_username (context.text_field_value ("name"))
				zen_session.set_email (context.text_field_value ("mail"))

				return_view.enable_alternative_section ("PATICIPATION_FORM", 3)

				return_view.replace_marker_with_string("NAME", zen_session.username)
				return_view.replace_marker_with_string("MAIL", zen_session.email)
				return_view.replace_marker_with_string("CSS_ID", zen_session.css_id.out)
				return_view.replace_marker_with_string("PAGE", zen_session.page.out)

				return_view.replace_marker_with_string("PASSWORD", context.text_field_value ("pass1"))

				return_view.replace_marker_with_string("FORM_DATA_ERROR", "")

				return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=logout%" title=%"Logout of community%">Logout</a>")

				save_user_account(zen_session.username, context.text_field_value ("pass1"), zen_session.email)

			else
				error_string := expand_error_string(validation_error_table)
				return_view.replace_marker_with_string("FORM_DATA_ERROR", error_string)

				return_view.replace_marker_with_string("NAME", context.text_field_value ("name"))
				return_view.replace_marker_with_string("MAIL", context.text_field_value ("mail"))

				return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=loginform%" title=%"Login into community%">Logout</a>")

			end
		end

	process_login_command is
			-- process login command
		local
			error_string: STRING
			validation_error_table: HASH_TABLE[STRING, STRING]
		do

			validation_error_table := validate_login_form
			if validation_error_table.count = 0 then
				if authenticate_user(context.text_field_value("name"), context.text_field_value("password")) then

					return_view.enable_alternative_section ("PATICIPATION_FORM", 2)
					return_view.replace_marker_with_string("NAME", zen_session.username)
					return_view.replace_marker_with_string("MAIL", zen_session.email)
					return_view.replace_marker_with_string("CSS_ID", zen_session.css_id.out)
					return_view.replace_marker_with_string("PAGE", zen_session.page.out)

					return_view.replace_marker_with_string("FORM_DATA_ERROR", "")

					return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=logout%" title=%"Logout of community%">Logout</a>")
				else
					return_view.enable_alternative_section ("PATICIPATION_FORM", 1)
					error_string := "Login: Username/Password failed"
					return_view.replace_marker_with_string("FORM_DATA_ERROR", error_string)

					return_view.replace_marker_with_string("NAME", context.text_field_value ("name"))

					return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=loginform%" title=%"Login into community%">Login</a>")
				end
			else
				return_view.enable_alternative_section ("PATICIPATION_FORM", 1)
				error_string := expand_error_string(validation_error_table)
				return_view.replace_marker_with_string("FORM_DATA_ERROR", error_string)

				return_view.replace_marker_with_string("NAME", context.text_field_value ("name"))

				return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=loginform%" title=%"Login into community%">Login</a>")
			end
		end

	update_login_form is
			-- enable login form
		do
			return_view.enable_alternative_section ("PATICIPATION_FORM", 1)
			return_view.replace_marker_with_string("NAME", "")
			return_view.replace_marker_with_string("MAIL", "")
			return_view.replace_marker_with_string("FORM_DATA_ERROR", "")
			return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=loginform%" title=%"Login into community%">Login</a>")
		end

	update_paticipation_form is
			-- enable paticipation form
		do
			return_view.enable_alternative_section ("PATICIPATION_FORM", 2)
			return_view.replace_marker_with_string("NAME", zen_session.username)
			return_view.replace_marker_with_string("MAIL", zen_session.email)
			return_view.replace_marker_with_string("CSS_ID", zen_session.css_id.out)
			return_view.replace_marker_with_string("PAGE", zen_session.page.out)

			return_view.replace_marker_with_string("FORM_DATA_ERROR", "")

			return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=logout%" title=%"Logout of community%">Logout</a>")
		end

	update_default_page is
			-- enable default form
		do
			if context.command_string.is_equal("logout") then
				zen_session.set_username ("Guest")
				zen_session.set_email ("")
			end

			return_view.replace_marker_with_string("NAME", "")
			return_view.replace_marker_with_string("MAIL", "")
			return_view.replace_marker_with_string("FORM_DATA_ERROR", "")
			if 	not zen_session.authenticated then
				return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=loginform%" title=%"Login into community%">Login</a>")
			else
				return_view.replace_marker_with_string ("FORM_MENU", "<a href=%"" + context.script_name + "?zengarden&amp;cmd=registerform%" title=%"Create an account%">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href=%"" + context.script_name + "?zengarden&amp;cmd=logout%" title=%"Logout of the community%">Logout</a>")
			end
		end

	handling_request is
			-- processing request
		require else
			context /= void
		local
			css_sheet: STRING
			i, css_index, page: INTEGER
			int_formatter: FORMAT_INTEGER
			style_sheet_string: STRING
			sheets_list_string: STRING
			more_styles_string: STRING
		do
			 create return_view.make(context.config.template)

			-- parsing and set actual style sheet based on given parameter, or take default
			css_index := get_stylesheet_id

			zen_session.set_css_id(css_index)

			create int_formatter.make (css_index)
			int_formatter.set_fill ('0')
			int_formatter.set_width (3)

			create css_sheet.make_from_string (int_formatter.formatted (css_index))
			create style_sheet_string.make_from_string("@import %"http://www.csszengarden.com/" + css_sheet + "/" + css_sheet + ".css%";");
			return_view.replace_marker_with_string("STYLE_SHEET", style_sheet_string);

			-- get actual page number
			page := get_page
			zen_session.set_page(page)

			-- 'next/prev sheet' links
			create sheets_list_string.make_from_string("<li><a href=%"" + context.script_name + "?zengarden&amp;cmd=styling&amp;css=" + int_formatter.formatted (css_index+1) + "%" title=%"View next design.  AccessKey: n%" accesskey=%"n%"><span class=%"accesskey%">n</span>ext design</a> by Dave Shea&nbsp;</li>")
	        sheets_list_string.append("<li><a href=%"" + context.script_name + "?zengarden&amp;cmd=styling&amp;css=" + int_formatter.formatted (css_index-1) + "%" title=%"View previous design. AccessKey: p%" accesskey=%"p%"><span class=%"accesskey%">p</span>rev. design</a> by Dave Shea&nbsp;</li>")

			-- 'style 1/2/3...' links
			from i:= (page-1)*6+1  until i > (page-1)*6+6
			loop
		        sheets_list_string.append("<li><a href=%"" + context.script_name + "?zengarden&amp;cmd=styling&amp;css=" + int_formatter.formatted (i) + "%">Style #" + int_formatter.formatted (i) + "</a> by Dave Shea &nbsp;</li>")
				i:=i+1
			end
			return_view.replace_marker_with_string ("STYLE_LIST", sheets_list_string);

			-- replace paticipate form mark
			if not context.command_string.is_empty then

				if context.command_string.is_equal("register") then
				 	process_register_command

				elseif context.command_string.is_equal("login") then
					process_login_command

				elseif context.command_string.is_equal("loginform") then
						update_login_form

				elseif zen_session.authenticated and then not context.command_string.is_equal("logout") and then not context.command_string.is_equal("registerform") then
						update_paticipation_form
				else
					update_default_page
				end

			elseif zen_session.authenticated then
				update_paticipation_form
			else
				update_default_page
			end

			return_view.replace_marker_with_string("FORM_DATA_ERROR", "")
			return_view.replace_marker_with_string("NAME", "")
			return_view.replace_marker_with_string("MAIL", "")

			-- update "more styles" marker
			create more_styles_string.make_from_string("<li><a href=%"" + context.script_name + "?zengarden&amp;cmd=styling&amp;page=" + int_formatter.formatted (page+1) + "%" title=%"View next set of designs.%">next designs &raquo;</a>&nbsp;</li>")
	        more_styles_string.append("<li><a href=%"" + context.script_name + "?zengarden&amp;cmd=styling&amp;page=" + int_formatter.formatted (page-1) + "%" title=%"View previous set of designs.%">&laquo; previous designs</a></li>")
			return_view.replace_marker_with_string ("MORE_STYLES", more_styles_string);

--			-- SID tags, now it's automatically updated by calling url_rewritting
--			if cookie_enabled then
--				return_view.replace_marker_with_string("SID", "")
--			else
--				return_view.replace_marker_with_string("SID", "sid=" + session_id)
--			end
--			return_view.replace_marker_with_string("SID_ONLY", session_id)

			return_view.replace_marker_with_string("SCRIPT_NAME", context.script_name)

		 	return_page ?= return_view

			check
				result_page_set: return_page /= void
			end

		end

	pre_processing is
			-- common tasks to be executed before starting process user request
		do
		end

	post_processing is
			-- common tasks to be executed after request processed
		do
--			session := zen_session.session
		end


feature {NONE} -- form validation

	validate_registrationform: HASH_TABLE[STRING, STRING] is
		--
		require
			environment_set: context /= void
		local
			validator: FORM_VALIDATOR
			error_string_table: HASH_TABLE[STRING, STRING]
		do
			create validator.make(context)
			create error_string_table.make (100)

			if not validator.is_must_field_filled ("name") then
				error_string_table.put ("an username must be specified", "Username")
			else
				if user_dao.username_defined (validator.get_field_string ("name")) then
					error_string_table.put ("given username already registered", "Username")
				end
			end

			if not validator.is_must_field_filled ("mail") then
				error_string_table.put ("an email address must be specified", "Email")
			elseif not validator.is_email_valid (validator.get_field_string ("mail")) then
				error_string_table.put ("not a valid mail address", "Email")
			end

			if not validator.is_must_field_filled ("pass1") or not validator.is_must_field_filled ("pass2") then
				error_string_table.put ("password should be typed in both fields", "Password")
			elseif not validator.are_fields_equal ("pass1", "pass2") then
				error_string_table.put ("typed passwords not match each other", "Password")
			end

			Result := error_string_table

		end

	validate_login_form: HASH_TABLE[STRING, STRING] is
		--
		require
			environment_set: context /= void
		local
			validator: FORM_VALIDATOR
			error_string_table: HASH_TABLE[STRING, STRING]
		do
			create validator.make(context)
			create error_string_table.make (100)

			if not validator.is_must_field_filled ("name") then
				error_string_table.put ("please give your login name", "Username")
			end

			if not validator.is_must_field_filled ("password") then
				error_string_table.put ("please give your password", "Password")
			end

			Result := error_string_table

		end

	save_user_account(username, pass, mail: STRING) is
			--
		local
			user: ZEN_USER
		do
			create user.make
			user.set_username(username)
			user.set_password(pass)
			user.set_email(mail)

			if not user_dao.username_defined (username) then
				user_dao.add_user(user)
			else
				user_dao.update_user(user)
			end
			user_dao.persist_data
		end


	authenticate_user(username, pass: STRING): BOOLEAN is
			--
		local
			user: ZEN_USER
		do
			if user_dao.is_user_authentication_valid(username, pass) then
		       	zen_session.set_username (username)
		       	user ?= user_dao.get_user_by_name (username)
		       	if user /= void then
			       	zen_session.set_email(user.email)
		       	end
		 		Result:= True
			end
		end

	expand_error_string(string_table:HASH_TABLE[STRING, STRING]): STRING is
			--
		local
			err_string: STRING

		do
			create err_string.make(1024)
			from string_table.start  until  string_table.after
			loop
		        err_string.append (string_table.key_for_iteration)
		        err_string.append (": ")
		        err_string.append (string_table.item_for_iteration)
		        err_string.append ("<br/>")
				string_table.forth
			end
			Result := err_string
		end

invariant
	invariant_clause: True -- Your invariant here

end
