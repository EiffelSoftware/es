indexing
	description: "handler for user related requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	USER_HANDLER

inherit
	INFORMATICS_HANDLER
	redefine
		post_processing
	end
	APPLICATION_CONSTANTS

create
	make

feature -- process request

	handling_request is
			-- dispatching requests to relevant handling routines, processing request
		require else
			context /= void
		do
			create return_view.make(context.config.template)

			-- login, submit, userform, loginform, details, list, delete, suspend, activate
			if context.command_string.is_equal ("login") then
				authenticate_user

			elseif context.command_string.is_equal ("submit") then
				create_update_user_account

			elseif context.command_string.is_equal ("userform") then
				display_user_form

			elseif context.command_string.is_equal ("loginform") then
				-- cleanup smarttags: USER_ID
				return_view.replace_marker_with_string ("USER_ID", "")

			elseif context.command_string.is_equal ("details") then
				display_user_details

			elseif context.field_defined ("user_id") and then context.command_string.is_equal ("delete") then
				delete_user_account(context.text_field_value ("user_id"))
				admin_user_list

			elseif context.field_defined ("user_id") and then context.command_string.is_equal ("suspend") then
				suspend_user_account(context.text_field_value ("user_id"))
				admin_user_list

			elseif context.field_defined ("user_id") and then context.command_string.is_equal ("activate") then
				activate_user_account(context.text_field_value ("user_id"))
				admin_user_list

			elseif context.command_string.is_equal ("list") then
				admin_user_list

			else
				redirect_to_invalid_request_page

			end

		end

	post_processing is
			-- common tasks for user related pages
		do
			return_view.replace_marker_with_string ("ORGANIZATION", actual_user.organization)
			return_view.replace_marker_with_string ("TELEPHONE", actual_user.telephone)

			return_view.replace_marker_with_string ("PASSWORD", actual_user.password)
			return_view.replace_marker_with_string ("CONFIRM_PASSWORD", actual_user.password)

			PRECURSOR

		end



feature {NONE} -- implementation

	format_user_for_adminlist(a_user: INFORMATICS_USER; odd_row: BOOLEAN): STRING is
			-- format user information into a <td> row for user administration view
		local
			left_border_class, mid_class, right_border_class: STRING
			edit, suspend, delete, role: STRING
			img_yes, img_no, img_suspended: STRING
		do
			if odd_row then
				left_border_class := "user_row_odd_left_border"
				mid_class := "user_row_odd"
				right_border_class := "user_row_odd_right_border"
			else
				left_border_class := "user_row_even_left_border"
				mid_class := "user_row_even"
				right_border_class := "user_row_even_right_border"
			end

			img_yes := "<img src=%"{#IMAGE_PATH#}yes.gif%" alt=%"%" />"
			img_no := "<img src=%"{#IMAGE_PATH#}no.gif%" alt=%"%" />"

			if not a_user.status.is_equal (user_suspended) then
				img_suspended := img_yes
				suspend := "<a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=suspend&amp;user_id=" + a_user.username + "%">Suspend</a>"
			else
				img_suspended := img_no
				suspend := "<a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=activate&amp;user_id=" + a_user.username + "%">Activate</a>"
			end

			if a_user.role = role_administrator then
				role := "Administrator"
			else
				role := "User"
			end

			edit := "<a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=userform&amp;mode=edit&amp;user_id=" + a_user.username + "%">Edit</a>"
			delete := "<a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=delete&amp;user_id=" + a_user.username + "%">Delete</a>"

			create Result.make_empty
			Result.append("<tr><td class=%"" + left_border_class + "%"><a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=details&amp;user_id="
						+ a_user.username + "%">" + a_user.first_name + " " + a_user.last_name + "</a></td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + a_user.email + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + a_user.organization + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + role + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"center%">" + img_suspended + "</td>%N");

			Result.append("  <td class=%"" + mid_class + "%" align=%"right%">" + edit + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"right%">" + suspend + "</td>%N");
			Result.append("  <td class=%"" + right_border_class + "%" align=%"right%">" + delete + "</td>%N</tr>%N");
		end

	admin_user_list is
			-- generate the user administation view
		local
			table_content: STRING
			a_user: INFORMATICS_USER
			odd_row: BOOLEAN
		do
			if actual_user.role /= role_administrator then
				redirect_to_permission_denied_page
			end

			create a_user.make
			create table_content.make_empty

			if user_manager.user_count > 0 then

				user_manager.user_list.start
				odd_row := true
				from
					user_manager.user_list.start
				until
					user_manager.user_list.after
				loop
					a_user ?= user_manager.user_list.item_for_iteration
					table_content.append (format_user_for_adminlist(a_user, odd_row))
					user_manager.user_list.forth
					odd_row := not odd_row
				end
			end

			return_view.replace_marker_with_string ("USER_LIST", table_content)

		end

-----------------------------------------------------------------------------------------------
	authenticate_user is
			-- validate "login" form and authenticate user
		local
			error_messages: HASH_TABLE[STRING, STRING]
			error_string: STRING
			a_user: INFORMATICS_USER
		do
			error_messages := validate_login_form
			if error_messages.count = 0 then
				if user_manager.is_user_authentication_valid(context.text_field_value ("user_id"), context.text_field_value ("password")) then
					a_user ?= user_manager.get_user_by_name (context.text_field_value ("user_id"))
					if a_user.status = user_suspended then
						error_messages.put("User account <b>" + context.text_field_value ("user_id") + "</b> is suspended.<br />Please contact administrator for further information.", "Account Suspended")
					else
						return_view.enable_alternative_section ("AUTHENTICATION_FORM", 1)
						actual_user ?= user_manager.get_user_by_name (context.text_field_value ("user_id"))
						check
							actual_user_updated: actual_user /= void and then actual_user.username.is_equal (context.text_field_value ("user_id"))
						end

						my_session.set_email (actual_user.email)
						my_session.set_username (actual_user.email)
					end
				else
					error_messages.put("Invalid password for " + context.text_field_value ("user_id") + ". Please try again.", "Password")
				end
			end

			if error_messages.count > 0 then
				return_view.enable_section ("VALIDATION_ERROR_MESSAGES")

				error_string := expand_error_string(error_messages)
				return_view.replace_marker_with_string ("ERROR_MESSAGES", error_string)

				if context.field_defined ("user_id") then
					return_view.replace_marker_with_string ("USER_ID", context.text_field_value ("user_id"))
				end
			end
 		end

-----------------------------------------------------------------------------------------------
	create_update_user_account is
			-- validate user form, create/update an user account if ok
		local
			error_messages: HASH_TABLE[STRING, STRING]
			error_string: STRING
			a_user: INFORMATICS_USER
			email: STRING
		do
			create a_user.make
			error_messages := validate_user_form(a_user)
			if error_messages.count = 0 then

				email := context.text_field_value ("email")

				if actual_user.role = role_guest and then user_manager.username_defined (email) then  -- guest, must be a new id
					error_messages.put ("Given email address is already registered.", "Email")
				elseif actual_user.role = role_normal_user and then (  -- normal user, must be the same id or new id
						not actual_user.username.is_equal (email) and
						user_manager.username_defined (email)
					) then
					error_messages.put ("Given email address is already registered by another user.", "Email")
				else
					if context.field_defined ("mode") then
						if context.text_field_value ("mode").is_equal ("register") or  context.text_field_value ("mode").is_equal ("add") then
							return_view.enable_alternative_section ("USER_FORM", 1)
						elseif context.text_field_value ("mode").is_equal ("edit") then
							return_view.enable_alternative_section ("USER_FORM", 2)
						end
					end

					if actual_user.role /= role_administrator then -- otherwise they're initialized in validate_user_form already
						a_user.set_role (role_normal_user)
						a_user.set_status(user_active)
					end

					if not user_manager.username_defined (a_user.username) then
						user_manager.add_user(a_user)
					else
						user_manager.update_user(a_user)
					end
					user_manager.persist_data

					if actual_user.role /= role_administrator then -- normal user, must be registered a new account, or updated profile...switch to updated account
						my_session.set_username (a_user.username)
						my_session.set_email (a_user.email)

						actual_user := a_user
					end

					return_view.replace_marker_with_string ("EMAIL_ADDRESS", a_user.email)
				end
			end

			if error_messages.count > 0 then
				return_view.enable_section ("VALIDATION_ERROR_MESSAGES")

				error_string := expand_error_string(error_messages)
				return_view.replace_marker_with_string ("ERROR_MESSAGES", error_string)

				-- set title and button text
				if context.field_defined ("mode") then
					if context.text_field_value ("mode").is_equal ("register") or  context.text_field_value ("mode").is_equal ("add") then
						if context.text_field_value ("mode").is_equal ("register") then
							return_view.replace_marker_with_string ("FORM_TITLE", "Register")
							return_view.replace_marker_with_string ("BUTTON_TEXT", "Register")
							return_view.replace_marker_with_string ("SAVE_MODE", "register")
						else
							return_view.replace_marker_with_string ("FORM_TITLE", "Add User")
							return_view.replace_marker_with_string ("BUTTON_TEXT", "Add User")
							return_view.replace_marker_with_string ("SAVE_MODE", "add")
						end
						return_view.replace_marker_with_string ("READONLY", "")
					elseif context.text_field_value ("mode").is_equal ("edit") and then context.field_defined ("user_id") then
						-- set title and button text
						return_view.replace_marker_with_string ("FORM_TITLE", "Edit User")
						return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
						return_view.replace_marker_with_string ("SAVE_MODE", "edit")
					else
						return_view.replace_marker_with_string ("FORM_TITLE", "Edit Profile")
						return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
						return_view.replace_marker_with_string ("SAVE_MODE", "update")
					end
					-- edit, update mode set email to be readonly
					return_view.replace_marker_with_string ("READONLY", "readonly=%"readonly%"")
				end

				if context.field_defined ("first_name") then
					return_view.replace_marker_with_string ("first_name", context.text_field_value ("first_name"))
				end

				if context.field_defined ("last_name") then
					return_view.replace_marker_with_string ("last_name", context.text_field_value ("last_name"))
				end

				if context.field_defined ("email") then
					return_view.replace_marker_with_string ("email_address", context.text_field_value ("email"))
					return_view.replace_marker_with_string ("email", context.text_field_value ("email"))
				end

				if context.field_defined ("organization") then
					return_view.replace_marker_with_string ("organization", context.text_field_value ("organization"))
				end

				if context.field_defined ("telephone") then
					return_view.replace_marker_with_string ("telephone", context.text_field_value ("telephone"))
				end
			end
 		end


-----------------------------------------------------------------------------------------------
	display_user_form is
			-- update and display user registration form based on actual context (register / admin / update mode)
		local
			edit_user: INFORMATICS_USER
			user_id: STRING
		do
			-- update tag to indicate userform mode (update user or new user)
			if context.field_defined ("mode") then
				if context.text_field_value ("mode").is_equal ("register") or  context.text_field_value ("mode").is_equal ("add") then
					-- set title and button text
					if context.text_field_value ("mode").is_equal ("register") then
						-- register a new user
						return_view.replace_marker_with_string ("FORM_TITLE", "Register")
						return_view.replace_marker_with_string ("BUTTON_TEXT", "Register")
						return_view.replace_marker_with_string ("SAVE_MODE", "register")
					else
						-- admin add an user account
						return_view.replace_marker_with_string ("FORM_TITLE", "Add User")
						return_view.replace_marker_with_string ("BUTTON_TEXT", "Add User")
						return_view.replace_marker_with_string ("SAVE_MODE", "add")
					end

					-- cleanup fields variables
					create edit_user.make
					restore_user_data(edit_user)
					return_view.replace_marker_with_string ("READONLY", "")

				elseif context.text_field_value ("mode").is_equal ("edit") and then context.field_defined ("user_id") then
					-- admin edit an existing user

					user_id := context.text_field_value ("user_id")
					return_view.enable_section ("ADMINISTRATOR_INFORMATION")

					-- check permission
					if actual_user.role /= role_administrator then
						redirect_to_permission_denied_page
					elseif not user_manager.username_defined (user_id) then
						redirect_to_invalid_request_page
					else
						edit_user ?= user_manager.get_user_by_name (user_id)
						if edit_user = void then
							redirect_to_invalid_request_page
						else
							-- set title and button text
							return_view.replace_marker_with_string ("FORM_TITLE", "Edit User")
							return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
							return_view.replace_marker_with_string ("SAVE_MODE", "edit")

							-- set email be readonly
							return_view.replace_marker_with_string ("READONLY", "readonly=%"readonly%"")

							restore_user_data(edit_user)
						end
					end
				else -- update own profile
					-- set title and button text
					return_view.replace_marker_with_string ("FORM_TITLE", "Edit Profile")
					return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
					return_view.replace_marker_with_string ("SAVE_MODE", "update")

					-- set title and button text
					restore_user_data(actual_user)
					return_view.replace_marker_with_string ("READONLY", "readonly=%"readonly%"")

				end
			end

		end


-----------------------------------------------------------------------------------------------
	display_user_details is
			-- update the "User details" view
		local
			s, user_id:STRING
			a_user: INFORMATICS_USER
		do

			if actual_user.role /= role_administrator and then ( context.field_defined ("user_id") and then not actual_user.username.is_equal (context.text_field_value ("user_id"))) then
				redirect_to_permission_denied_page
			else
				if actual_user.role = role_administrator then
					s := "{
						<td style="padding: 0px 10px 0px 0px">
	                      <a href="{#CGI_FILE_NAME#}?user&amp;cmd=userform&amp;mode=edit&amp;user_id={#user_id#}">Edit</a>
	                    </td>
	                    <td>
	                      <a href="{#CGI_FILE_NAME#}?user&amp;cmd=delete&amp;user_id={#user_id#}">Delete</a>
	                    </td>
	                    }";

					return_view.replace_marker_with_string ("ADMIN_USER_COMMAND", s)
				end

				if context.field_defined("user_id") then
					user_id := context.text_field_value ("user_id")
				else
					user_id := actual_user.username
				end
				a_user ?= user_manager.get_user_by_name (user_id)
				if a_user /= void then
					restore_user_data(a_user)
				end
			end
 		end
 ------------------------------------------------------------------------------------------------
 delete_user_account(user_id: STRING) is
 		-- delete an user account
 	require
 		user_exists: user_id /= void and then not user_id.is_empty and then user_manager.username_defined (user_id)
 	do
 		if actual_user.role /= role_administrator then
 			redirect_to_permission_denied_page
 		else
	 		user_manager.delete_user_by_name(user_id)
	 		user_manager.persist_data
 		end
 	end

 suspend_user_account(user_id: STRING) is
 		-- suspend an user account
 	require
 		user_exists: user_id /= void and then not user_id.is_empty and then user_manager.username_defined (user_id)
 	local
 		a_user: INFORMATICS_USER
 	do
 		if actual_user.role /= role_administrator then
 			redirect_to_permission_denied_page
 		else
	 		a_user ?= user_manager.get_user_by_name (user_id)
	 		a_user.set_status (user_suspended)
	 		user_manager.update_user(a_user)
	 		user_manager.persist_data
 		end
 	end

 activate_user_account(user_id: STRING) is
 		-- activate a suspended user account
 	require
 		user_exists: user_id /= void and then not user_id.is_empty and then user_manager.username_defined (user_id)
 	local
 		a_user: INFORMATICS_USER
 	do
 		if actual_user.role /= role_administrator then
 			redirect_to_permission_denied_page
 		else
	 		a_user ?= user_manager.get_user_by_name (user_id)
	 		a_user.set_status (user_active)
	 		user_manager.update_user(a_user)
	 		user_manager.persist_data
 		end
 	end

feature -- form processing

	restore_user_data(a_user:INFORMATICS_USER) is
			-- fill user registration form with given user information
		local
			role: STRING
		do
			return_view.replace_marker_with_string ("first_name", a_user.first_name)
			return_view.replace_marker_with_string ("last_name", a_user.last_name)
			return_view.replace_marker_with_string ("user_name", a_user.first_name + " " + a_user.last_name)
			return_view.replace_marker_with_string ("email", a_user.email)
			return_view.replace_marker_with_string ("user_id", a_user.email)
			return_view.replace_marker_with_string ("password", a_user.password)
			return_view.replace_marker_with_string ("confirm_password", a_user.password)
			return_view.replace_marker_with_string ("organization", a_user.organization)
			return_view.replace_marker_with_string ("telephone", a_user.telephone)

			if a_user.role = role_administrator then
				role := "<option selected=%"selected%" value=%"Administrator%">Administrator</option>"
			else
				role := "<option selected=%"selected%" value=%"User%">User</option>"
			end
			return_view.replace_marker_with_string ("user_role", role)

			if a_user.status.is_equal (user_suspended) then
				return_view.replace_marker_with_string ("suspend", "checked=%"checked%"")
			end

		end

	validate_login_form: HASH_TABLE[STRING, STRING] is
			-- validate login form, return a table filled with validation failure messages if any
		require
			environment_set: context /= void
		local
			validator: FORM_VALIDATOR
			error_string_table: HASH_TABLE[STRING, STRING]
		do
			create validator.make(context)
			create error_string_table.make (100)

			if not validator.is_must_field_filled ("user_id") then
				error_string_table.put ("Please enter your registered email address.", "Email")
			else
				if not validator.is_email_valid(validator.get_field_string ("user_id")) then
					error_string_table.put ("Given email address seems not valid.", "Email")
				elseif not user_manager.username_defined (context.text_field_value ("user_id")) then
					error_string_table.put ("Given email address is not registered.", "Email")
				end
			end

			if not validator.is_must_field_filled ("password") then
				error_string_table.put ("please enter the password.", "Password")
			end

			Result := error_string_table

		end

	validate_user_form(a_user: INFORMATICS_USER): HASH_TABLE[STRING, STRING] is
			-- validate user registation form, , return a table filled with validation failure messages if any
		require
			environment_set: context /= void
		local
			validator: FORM_VALIDATOR
			error_string_table: HASH_TABLE[STRING, STRING]
		do
			create validator.make(context)
			create error_string_table.make (100)

			if not validator.is_must_field_filled ("email") then
				error_string_table.put ("An email address must be specified (used as the login name).", "Email")
			else
				a_user.set_email (validator.get_field_string ("email"))
				a_user.set_username (validator.get_field_string ("email"))
				if not validator.is_email_valid(validator.get_field_string ("email")) then
					error_string_table.put ("Given email address seems not valid.", "Email")
				elseif context.field_defined ("mode")then
					if context.text_field_value ("mode").is_equal ("add") and then user_manager.username_defined (validator.get_field_string ("email")) then  -- add user cases
						error_string_table.put ("Given email address is already registered.", "Email")
--					elseif context.command_string.is_equal ("submit") and then not user_manager.username_defined (validator.get_field_string ("user_id")) then  -- update user cases
--						error_string_table.put ("Given email address is already registered.", "Email")
					end
				end
			end

			if not validator.is_must_field_filled ("first_name") then
				error_string_table.put ("Please enter your first name.", "First name")
			else
				a_user.set_first_name (validator.get_field_string ("first_name"))
			end

			if not validator.is_must_field_filled ("last_name") then
				error_string_table.put ("Please enter your family name.", "Family name")
			else
				a_user.set_last_name (validator.get_field_string ("last_name"))
			end

			if not validator.is_must_field_filled ("organization") then
				error_string_table.put ("Please specify your organization.", "Organization")
			else
				a_user.set_organization (validator.get_field_string ("organization"))
			end

			if not validator.is_must_field_filled ("password") or not validator.is_must_field_filled ("confirm_password") then
				error_string_table.put ("password should be typed in both fields", "Password")
			elseif not validator.are_fields_equal ("password", "confirm_password") then
				error_string_table.put ("typed passwords not match each other", "Password")
			else
				a_user.set_password (validator.get_field_string ("password"))
			end

			a_user.set_telephone (validator.get_field_string ("telephone"))



			if validator.get_field_string ("user_role").is_equal ("Administrator") then
				a_user.set_role(role_administrator)
			else
				a_user.set_role(role_normal_user)
			end

			if validator.get_field_string ("suspend").is_equal ("1") then
				a_user.set_status (user_suspended)
			else
				a_user.set_status (user_active)
			end


			Result := error_string_table

		end


invariant
	invariant_clause: True -- Your invariant here

end
