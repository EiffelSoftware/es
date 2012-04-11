indexing
	description: "handler for event related requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	EVENT_HANDLER

inherit
	INFORMATICS_HANDLER
	redefine
		make
	end
	APPLICATION_CONSTANTS

create
	make

feature -- access

	event_dao: EVENT_DAO
		-- all events

feature -- creation
	make is
			-- handler initialization
		do
			PRECURSOR {INFORMATICS_HANDLER}

		end

feature -- process request

	handling_request is
			-- dispatching requests to relevant handling routines, processing request
		require else
			context /= void
		do
			create {EVENT_DAO_FILE_IMPL}event_dao.make(context.config.get_constant ("app_data_folder"), context.config.get_constant ("event_list_data_file_name"), context.config.get_constant ("event_id_generator_data_file_name") )

			create return_view.make(context.config.template)

			-- loginform, login, logout, userform, saveuser
			if context.command_string.is_equal ("eventform") then
				display_event_form

			elseif context.command_string.is_equal ("save") then
				validate_and_save_event

			elseif context.command_string.is_equal ("delete") then
				delete_event
				display_event_list

			elseif context.command_string.is_equal ("approve") then
				approve_event
				display_event_list

			elseif context.command_string.is_equal ("reject") then
				reject_event
				display_event_list

			elseif context.command_string.is_equal ("details") then
				display_event_details

			elseif context.command_string.is_equal ("logout") then
				logout_user
				display_event_list

			elseif context.command_string.is_equal ("list") then
				display_event_list

			elseif context.command_string.is_equal ("ownevents") then
				display_event_list

			else
				redirect_to_invalid_request_page
			end
		end

feature {NONE} -- implementation

 ------------------------------------------------------------------------------------------------
	approve_event is
			-- handling a "Approve Event" request, check permission and event_id parameter, update event status as "Approved" if ok, display notification message.
		local
			id: NATURAL_64
			the_event: EVENT
		do
			if actual_user.role /= role_administrator then
				redirect_to_permission_denied_page
			elseif not context.field_defined ("event_id") then
				redirect_to_invalid_request_page
			else
				id := context.text_field_value ("event_id").to_natural_64
				the_event := event_dao.get_event_by_id (id)
				if the_event /= void then
					the_event.set_status (Accepted)
					event_dao.update_event (the_event)
					event_dao.persist_data
				end
			end

			return_view.enable_section ("EVENT_UPDATED")
			return_view.replace_marker_with_string ("UPDATE_MESSAGE", "Successfully deleted event.")

		end

 ------------------------------------------------------------------------------------------------
	reject_event is
			-- handling a "reject Event" request, check permission and event_id parameter, update event status as "Rejected" if ok, display notification message.
		local
			id: NATURAL_64
			the_event: EVENT
		do
			if actual_user.role /= role_administrator then
				redirect_to_permission_denied_page
			elseif not context.field_defined ("event_id") then
				redirect_to_invalid_request_page
			else
				id := context.text_field_value ("event_id").to_natural_64
				the_event := event_dao.get_event_by_id (id)
				if the_event /= void then
					the_event.set_status (Rejected)
					event_dao.update_event (the_event)
					event_dao.persist_data
				end

				return_view.enable_section ("EVENT_UPDATED")
				return_view.replace_marker_with_string ("UPDATE_MESSAGE", "Successfully deleted event.")

			end
		end

 ------------------------------------------------------------------------------------------------
	delete_event is
			-- handling a "delete event" request, check permission and "event_id" parameter, update event status as "Deleted" if ok, display notification message.
		local
			id: NATURAL_64
			the_event: EVENT
		do
			if not context.field_defined ("event_id") then
				redirect_to_invalid_request_page
			else
				id := context.text_field_value ("event_id").to_natural_64
				the_event := event_dao.get_event_by_id (id)

				if actual_user.role /= role_administrator and then not (the_event /= void and then the_event.submitted_by.is_equal (actual_user.username) and then the_event.event_status = proposed) then
					redirect_to_permission_denied_page
				else
					if the_event /= void then
						the_event.set_status (Deleted)
						event_dao.update_event (the_event)
						event_dao.persist_data
					end

					return_view.enable_section ("EVENT_UPDATED")
					return_view.replace_marker_with_string ("UPDATE_MESSAGE", "Successfully deleted event.")

				end
			end
		end

 ------------------------------------------------------------------------------------------------
	display_event_details is
			-- Handling request, generate "Event Details" page
		local
			id: NATURAL_64
			the_event: EVENT
			admin_command: STRING
		do
			if context.field_defined ("event_id") then
				id := context.text_field_value ("event_id").to_natural_64
				the_event := event_dao.get_event_by_id (id)
				check
					found_event: the_event /= void
				end

				if actual_user.role = role_administrator or (the_event.submitted_by.is_equal (actual_user.username) and then the_event.event_status = proposed) then
					admin_command := "{
						<td style="padding: 0px 10px 0px 0px">
	                      <a href="{#CGI_FILE_NAME#}?event&amp;cmd=eventform&amp;mode=edit&amp;event_id={#event_id#}">Edit</a>
	                    </td>
	                    <td>
	                      <a href="{#CGI_FILE_NAME#}?event&amp;cmd=delete&amp;event_id={#event_id#}">Delete</a>
	                    </td>
	                    }";
					return_view.replace_marker_with_string ("ADMIN_EVENT_COMMAND", admin_command)
					return_view.replace_marker_with_string ("event_id", id.out)

				end

				restore_event_data(the_event)

			end

		end

 ------------------------------------------------------------------------------------------------
	display_event_list is
			-- generate an event-list view
		local
			table_content: STRING
			a_event: EVENT
			odd_row: BOOLEAN
			the_conference_list: EVENT_LIST
		do
			if actual_user.role = role_administrator then
				create return_view.make("..\informatics_events\adminlist.html")
			end

			create a_event.make
			create table_content.make_empty

			the_conference_list := event_dao.event_list

			if the_conference_list.count > 0 then

				the_conference_list.start
				odd_row := true
				from
					the_conference_list.start
				until
					the_conference_list.after
				loop
					if actual_user.role /= role_administrator then
						if context.command_string.is_equal ("ownevents") then
							-- in case of "ownevents" request, display user submitted events only
							if the_conference_list.item.submitted_by.is_equal (actual_user.email) then
								table_content.append (format_event_for_list(the_conference_list.item, odd_row))
							end
						elseif the_conference_list.item.event_status = accepted then
							-- normal users, display only accepted events
							table_content.append (format_event_for_list(the_conference_list.item, odd_row))
						end
					else -- administrator's view, display all events
						table_content.append (format_event_for_adminlist(the_conference_list.item, odd_row))
					end
					the_conference_list.forth
					odd_row := not odd_row
				end
			end

			return_view.replace_marker_with_string ("EVENT_LIST", table_content)

			if actual_user.role /= role_guest then
				return_view.remove_section ("GUEST_INFORMATION")
			end
		end

-----------------------------------------------------------------------------------------------
	logout_user is
			-- logout user
		do

			create actual_user.make

			my_session.set_email ("")
			my_session.set_username ("")

 		end


-----------------------------------------------------------------------------------------------
	validate_and_save_event is
			-- validate event submission form, save/update event to storage
		local
			error_messages: HASH_TABLE[STRING, STRING]
			error_string: STRING
			mode: STRING
			event_id: STRING
			new_event, tmp_event: EVENT
--			an_email_handler: EMAIL_HANDLER --helper class used to send emails
		do
			create new_event.make
			error_messages := validate_event_form(new_event)

			if error_messages.count = 0 then

				if context.field_defined ("mode") then
					mode := context.text_field_value ("mode")
					if mode.is_equal ("edit") then
						if not context.field_defined ("event_id") then
							redirect_to_invalid_request_page
						else
							event_id := context.text_field_value ("event_id")
							new_event.set_id (event_id.to_natural_64)

							tmp_event := event_dao.get_event_by_id (event_id.to_natural_64)
							if actual_user.role /= role_administrator and then not (tmp_event /= void and then tmp_event.submitted_by.is_equal (actual_user.username) and then tmp_event.event_status = proposed) then
								redirect_to_permission_denied_page
							else
								-- update event
								if tmp_event /= void then
									if actual_user.role /= role_administrator then
										new_event.set_status(tmp_event.event_status)
										new_event.set_submitter (tmp_event.submitted_by)
									end
									event_dao.update_event (new_event)
								end

								event_dao.persist_data

								return_view.replace_marker_with_string ("FORM_TITLE", "Event Saved")

								return_view.remove_section ("USER_EVENT_SUBMIT_NOTICE")
								return_view.remove_section ("EVENT_UPDATE_SUCEEDED_SUBMIT")

								return_view.enable_section ("EVENT_UPDATE_SUCEEDED_EDIT")
								return_view.replace_marker_with_string ("SUCCEED_MESSAGE", "Event saved.")

								if actual_user.role = role_administrator then
									return_view.enable_section ("ADMINISTRATOR_INFORMATION")
								end
								restore_event_data (new_event)

								return_view.replace_marker_with_string ("event_id", event_id.out)

								-- set title and button text
								return_view.replace_marker_with_string ("FORM_TITLE", "Edit Event")
								return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
								return_view.replace_marker_with_string ("SAVE_MODE", "edit")
							end
						end
					else  -- add, new event
						-- 	generate conference id and set it
						event_dao.event_id_generator.generate_next_id
						new_event.set_id (event_dao.event_id_generator.id)

						--  add the conference to the appropriate conference list
						new_event.set_status (Proposed)
						new_event.set_submitter (actual_user.username)

						event_dao.add_event (new_event)

						--	persists data the application needs (HTTP protocol is stateless)
						event_dao.persist_data

						--	send an email to administrator to tell him that an event has been proposed
--						create an_email_handler
--						an_email_handler.send_email (Admin_email, Admin_email, Event_proposed_email_subject, Event_proposed_email_message)

						return_view.replace_marker_with_string ("FORM_TITLE", "Event Submitted")

						if actual_user.role = role_administrator then -- keep event submission form displayed for administrators
							return_view.remove_section ("USER_EVENT_SUBMIT_NOTICE")
							return_view.enable_section ("EVENT_UPDATE_SUCEEDED_EDIT")
							return_view.replace_marker_with_string ("SUCCEED_MESSAGE", "Event submitted.")
							return_view.replace_marker_with_string ("BUTTON_TEXT", "Submit")

						else -- normal users, display notification message
							return_view.remove_section ("USER_EVENT_SUBMIT_NOTICE")
							return_view.remove_section ("USER_EVENT_SUBMIT_FORM")

							return_view.enable_section ("EVENT_UPDATE_SUCEEDED_SUBMIT")
						end

					end
				end
			end

			if error_messages.count > 0 then
				return_view.enable_section ("VALIDATION_ERROR_MESSAGES")

				error_string := expand_error_string(error_messages)
				return_view.replace_marker_with_string ("ERROR_MESSAGES", error_string)

				restore_event_data (new_event)

				display_event_form

			end
 		end

-----------------------------------------------------------------------------------------------
	display_event_form is
			-- update and display the event submission form based on current context (administrators/users, new event/modify a existing event)
		local
			actual_event: EVENT
			event_id: STRING
		do
			if actual_user.role = role_administrator then
				return_view.remove_section ("USER_EVENT_SUBMIT_NOTICE")
			end

			-- update tag to indicate userform mode (update user or new user)
			if context.field_defined ("mode") then
				if context.text_field_value ("mode").is_equal ("add") then

					-- set title and button text
					return_view.replace_marker_with_string ("FORM_TITLE", "Submit Event")
					return_view.replace_marker_with_string ("BUTTON_TEXT", "Submit")
					return_view.replace_marker_with_string ("SAVE_MODE", "add")

				elseif context.text_field_value ("mode").is_equal ("edit") and then context.field_defined ("event_id") then

					event_id := context.text_field_value ("event_id")
					actual_event := event_dao.get_event_by_id (event_id.to_natural_64)

					check
						found_event_by_id: actual_event /= void
					end

					restore_event_data(actual_event)
					return_view.replace_marker_with_string ("event_id", event_id.out)

					-- set title and button text
					return_view.replace_marker_with_string ("FORM_TITLE", "Edit Event")
					return_view.replace_marker_with_string ("BUTTON_TEXT", "Save")
					return_view.replace_marker_with_string ("SAVE_MODE", "edit")

				end

				if actual_user.role = role_administrator then
					return_view.enable_section ("ADMINISTRATOR_INFORMATION")
				end

			end

		end


feature {NONE} -- event list

	format_event_for_list(an_event: EVENT; odd_row: BOOLEAN): STRING is
			-- format an_event into a specific row in a HTML Table as expected in the predefined HTML template (for normal user/guest's event-list view)
		local
			left_border_class, mid_class, right_border_class: STRING
		do
			if odd_row then
				left_border_class := "position_row_odd_left_border"
				mid_class := "position_row_odd"
				right_border_class := "position_row_odd_right_border"
			else
				left_border_class := "position_row_even_left_border"
				mid_class := "position_row_even"
				right_border_class := "position_row_even_right_border"
			end

			create Result.make_empty
			Result.append("<tr><td class=%"" + left_border_class + "%"><a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=details&amp;event_id="
						+ an_event.id.out + "%">" + an_event.name + "</a></td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + an_event.starting_date.out + " - " + an_event.ending_date.out + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + an_event.city + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + an_event.country + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + an_event.papers_submission_deadline.out + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%">" + an_event.main_sponsor + "</td>%N");
			Result.append("  <td class=%"" + right_border_class + "%">" + an_event.proceedings_publisher + "</td>%N</tr>%N");
		end

	format_event_for_adminlist(an_event: EVENT; odd_row: BOOLEAN): STRING is
			-- format an_event into a specific row in a HTML Table as expected in the predefined HTML template (for administrator's event-list view)
		local
			left_border_class, mid_class, right_border_class: STRING
			edit, approve, reject, delete: STRING
			img_yes, img_no, img_proposed, img_accepted, img_rejected, img_deleted: STRING
		do
			if odd_row then
				left_border_class := "position_row_odd_left_border"
				mid_class := "position_row_odd"
				right_border_class := "position_row_odd_right_border"
			else
				left_border_class := "position_row_even_left_border"
				mid_class := "position_row_even"
				right_border_class := "position_row_even_right_border"
			end

			edit := "<a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=eventform&amp;mode=edit&amp;event_id=" + an_event.id.out + "%">Edit</a>"
			if an_event.event_status.is_equal (Proposed) then
				approve := "<a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=approve&amp;event_id=" + an_event.id.out + "%">Approve</a>"
				reject := "<a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=reject&amp;event_id=" + an_event.id.out + "%">Reject</a>"
				delete := "<a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=delete&amp;event_id=" + an_event.id.out + "%">Delete</a>"
			else
				approve := ""
				reject := ""
				delete := "<a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=delete&amp;event_id=" + an_event.id.out + "%">Delete</a>"
			end

			img_yes := "<img src=%"{#IMAGE_PATH#}yes.gif%" alt=%"%" />"
			img_no := "<img src=%"{#IMAGE_PATH#}no.gif%" alt=%"%" />"
			if an_event.event_status.is_equal (Proposed) then
				img_proposed := img_yes
			else
				img_proposed := img_no
			end
			if an_event.event_status.is_equal (Accepted) then
				img_accepted := img_yes
			else
				img_accepted := img_no
			end
			if an_event.event_status.is_equal (Rejected) then
				img_Rejected := img_yes
			else
				img_Rejected := img_no
			end
			if an_event.event_status.is_equal (Deleted) then
				img_deleted := img_yes
			else
				img_deleted := img_no
			end

			create Result.make_empty
			Result.append("<tr><td class=%"" + left_border_class + "%"><a href=%"{#CGI_FILE_NAME#}?event&amp;cmd=details&amp;event_id="
						+ an_event.id.out + "%">" + an_event.name + "</a></td>%N");
			Result.append("  <td class=%"" + mid_class + "%"><a href=%"{#CGI_FILE_NAME#}?user&amp;cmd=details&amp;user_id=" + an_event.submitted_by + "%">" + an_event.submitted_by + "</a></td>%N");
--			Result.append("  <td class=%"" + mid_class + "%">" + "Submitter" + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"center%">" + img_proposed + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"center%">" + img_accepted + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"center%">" + img_rejected + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"center%">" + img_deleted + "</td>%N");

			Result.append("  <td class=%"" + mid_class + "%" align=%"right%">" + edit + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"right%">" + approve + "</td>%N");
			Result.append("  <td class=%"" + mid_class + "%" align=%"right%">" + reject + "</td>%N");
			Result.append("  <td class=%"" + right_border_class + "%">" + delete + "</td>%N</tr>%N");
		end

feature {NONE} -- event form

	parse_date_string(value: STRING): DATE is
			-- parsing a DD/MM/YYYY string, return a Date object when success or void if failed
		local
			day, month, year: INTEGER
			month_start, year_start:INTEGER
			date_checker: DATE_VALIDITY_CHECKER
		do
			if value.has ('/') then
				month_start := value.index_of ('/', 1)
				day := value.substring (1, month_start-1).to_integer
			end

			if month_start > 0 then
				year_start := value.index_of ('/', month_start + 1)
				if year_start > 0 then
					month := value.substring (month_start+1, year_start-1).to_integer
				end
			end

			if year_start > 0 then
				year := value.substring (year_start+1, value.count).to_integer
			end

			create date_checker
			if  date_checker.is_correct_date (year, month, day) then
				create Result.make_day_month_year(day, month, year)
			else
				Result := void
			end
		end


	validate_event_form(an_event: EVENT): HASH_TABLE[STRING, STRING] is
			-- validate the event submission form, save and return a [Error-Message, Form-Field] table for validation failures
			-- an_event is updated with user inputs
		require
			environment_set: context /= void
		local
			validator: FORM_VALIDATOR
			error_string_table: HASH_TABLE[STRING, STRING]
			a_date: DATE
			temp_keywords,temp_additional_sponsors:ARRAYED_LIST[STRING]
		do
			create validator.make(context)
			create error_string_table.make (100)

			-- check must fields, can be done with a loop on a defined field-name array...update later...or add such a funciton in validator
			if not validator.is_must_field_filled ("event_name") then
				error_string_table.put ("Event name must be specified.", "Event name")
			else
				an_event.set_name (validator.get_field_string ("event_name"))
			end

			if not validator.is_must_field_filled ("start_date") then
				error_string_table.put ("Starting date must be specified.", "Starting date")
			else
				a_date := parse_date_string(validator.get_field_string ("start_date"))
				if a_date /= void then
					an_event.set_starting_date (a_date)
				else
					error_string_table.put ("Starting date is invalid.", "Starting date")
				end
			end

			if not validator.is_must_field_filled ("end_date") then
				error_string_table.put ("Ending date must be specified.", "Ending date")
			else
				a_date := parse_date_string(validator.get_field_string ("end_date"))
				if a_date /= void then
					an_event.set_ending_date (a_date)
				else
					error_string_table.put ("Ending date is invalid.", "Ending date")
				end
			end

			if not validator.is_must_field_filled ("city") then
				error_string_table.put ("The city must be specified.", "City")
			else
				an_event.set_city (validator.get_field_string ("city"))
			end

			if not validator.is_must_field_filled ("country") or validator.get_field_string ("country").is_equal ("Please choose") then
				error_string_table.put ("The Country must be specified.", "Country")
			else

				an_event.set_country (validator.get_field_string ("country"))
			end

			if not validator.is_must_field_filled ("deadline") then
				error_string_table.put ("The paper submission deadline must be specified.", "Deadline")
			else
				a_date := parse_date_string(validator.get_field_string ("deadline"))
				if a_date /= void then
					an_event.set_papers_submission_deadline (a_date)
				else
					error_string_table.put ("Paper submission deadline is invalid.", "Paper submission deadline")
				end
			end

			if not validator.is_must_field_filled ("sponsor") then
				error_string_table.put ("The main sponsor must be specified.", "Main sponsor")
			else
				an_event.set_main_sponsor (validator.get_field_string ("sponsor"))
			end

			if not validator.is_must_field_filled ("conference_url") then
				error_string_table.put ("An url for the event must be specified.", "Conference url")
			else
				an_event.set_url (validator.get_field_string ("conference_url"))
			end

			if not validator.is_must_field_filled ("contact_name") then
				error_string_table.put ("A contact person must be specified.", "Contact name")
			else
				an_event.set_contact_name (validator.get_field_string ("contact_name"))
			end

			if not validator.is_must_field_filled ("contact_email") then
				error_string_table.put ("A email for contact must be specified.", "Contact email")
			else
				an_event.set_contact_email (validator.get_field_string ("contact_email"))
			end

			if not validator.is_must_field_filled ("contact_role") then
				error_string_table.put ("The role of the given contact must be specified.", "Contact role")
			else
				an_event.set_contact_role (validator.get_field_string ("contact_role"))
			end

			-- optional fields
			create temp_keywords.make_filled (5)
			temp_keywords[1]:=validator.get_field_string ("keyword_1")
			temp_keywords[2]:=validator.get_field_string ("keyword_2")
			temp_keywords[3]:=validator.get_field_string ("keyword_3")
			temp_keywords[4]:=validator.get_field_string ("keyword_4")
			temp_keywords[5]:=validator.get_field_string ("keyword_5")
			an_event.set_keywords (temp_keywords)

			create temp_additional_sponsors.make_filled (5)
			temp_additional_sponsors[1]:=validator.get_field_string ("sponsor_1")
			temp_additional_sponsors[2]:=validator.get_field_string ("sponsor_2")
			temp_additional_sponsors[3]:=validator.get_field_string ("sponsor_3")
			temp_additional_sponsors[4]:=validator.get_field_string ("sponsor_4")
			temp_additional_sponsors[5]:=validator.get_field_string ("sponsor_5")
			an_event.set_additional_sponsors (temp_additional_sponsors)

			an_event.set_short_description (validator.get_field_string ("description"))
			an_event.set_additional_notes (validator.get_field_string ("notes"))
			an_event.set_conference_chair_1 (validator.get_field_string ("chair_1"))
			an_event.set_conference_chair_2 (validator.get_field_string ("chair_2"))
			an_event.set_program_committee_chair_1 (validator.get_field_string ("committee_1"))
			an_event.set_program_committee_chair_2 (validator.get_field_string ("committee_2"))
			an_event.set_organizing_chair (validator.get_field_string ("organization"))
			an_event.set_proceeding_type (validator.get_field_string ("proceedings"))
			an_event.set_proceedings_publisher (validator.get_field_string ("publisher"))

			if actual_user.role = role_administrator then
				an_event.set_submitter (validator.get_field_string ("submitted_by"))
				if validator.get_field_string ("proposed").is_equal ("1") then
					an_event.set_status (Proposed)
				elseif validator.get_field_string ("accepted").is_equal ("1") then
					an_event.set_status (accepted)
				elseif validator.get_field_string ("rejected").is_equal ("1") then
					an_event.set_status (rejected)
				elseif validator.get_field_string ("deleted").is_equal ("1") then
					an_event.set_status (deleted)
				else
					an_event.set_status (Proposed)
				end
			end

			if validator.is_field_value_not_empty ("deadline_1") then
				a_date := parse_date_string(context.text_field_value ("deadline_1"))
				if a_date /= void then
					an_event.set_additional_deadline_1 (a_date)
				else
					error_string_table.put ("The first additional deadline is invalid.", "Additional deadline")
				end
			end
			an_event.set_additional_deadline_specification_1 (validator.get_field_string ("topic_1"))

			if validator.is_field_value_not_empty ("deadline_2") then
				a_date := parse_date_string(context.text_field_value ("deadline_2"))
				if a_date /= void then
					an_event.set_additional_deadline_2 (a_date)
				else
					error_string_table.put ("The second additional deadline is invalid.", "Additional deadline")
				end
			end
			an_event.set_additional_deadline_specification_2 (validator.get_field_string ("topic_2"))

			if validator.is_field_value_not_empty ("deadline_3") then
				a_date := parse_date_string(context.text_field_value ("deadline_3"))
				if a_date /= void then
					an_event.set_additional_deadline_3 (a_date)
				else
					error_string_table.put ("The third additional deadline is invalid.", "Additional deadline")
				end
			end
			an_event.set_additional_deadline_specification_3 (validator.get_field_string ("topic_3"))

			Result := error_string_table

		end


	restore_event_data(a_event: EVENT) is
			-- fill the event form with given event data
		local
			empty_date: DATE
			s1, s2: STRING
		do
			create empty_date.make_day_month_year (1,1,1111)
			s1 := ""
			s2 := ""

			return_view.replace_marker_with_string ("event_name", a_event.name)

			if not a_event.starting_date.is_equal (empty_date) then
				s1 := a_event.starting_date.day.out + "/" + a_event.starting_date.month.out + "/" + a_event.starting_date.year.out
				return_view.replace_marker_with_string ("start_date", s1)
			end
			if not a_event.ending_date.is_equal (empty_date) then
				s2 := a_event.ending_date.day.out + "/" + a_event.ending_date.month.out + "/" + a_event.ending_date.year.out
				return_view.replace_marker_with_string ("end_date", s2)
			end
			return_view.replace_marker_with_string ("event_date", s1 + " - " + s2)

			return_view.replace_marker_with_string ("city", a_event.city)
			return_view.replace_marker_with_string ("country", a_event.country)

			if not a_event.papers_submission_deadline.is_equal (empty_date) then
				s1 := a_event.papers_submission_deadline.day.out + "/" + a_event.papers_submission_deadline.month.out + "/" + a_event.papers_submission_deadline.year.out
				return_view.replace_marker_with_string ("deadline", s1)
			end

			return_view.replace_marker_with_string ("sponsor", a_event.main_sponsor)
			return_view.replace_marker_with_string ("conference_url", a_event.url)

			return_view.replace_marker_with_string ("contact_name", a_event.contact_name)
			return_view.replace_marker_with_string ("contact_email", a_event.contact_email)
			return_view.replace_marker_with_string ("contact_role", a_event.contact_role)

			return_view.replace_marker_with_string ("keywords", a_event.keywords[1] + " " + a_event.keywords[2] + " " + a_event.keywords[3] + " " + a_event.keywords[4] + " "+ a_event.keywords[5])
			return_view.replace_marker_with_string ("keywords_1", a_event.keywords[1])
			return_view.replace_marker_with_string ("keywords_2", a_event.keywords[2])
			return_view.replace_marker_with_string ("keywords_3", a_event.keywords[3])
			return_view.replace_marker_with_string ("keywords_4", a_event.keywords[4])
			return_view.replace_marker_with_string ("keywords_5", a_event.keywords[5])

			return_view.replace_marker_with_string ("additonal_sponsors", a_event.additional_sponsors[1] + " " + a_event.additional_sponsors[2] + " " + a_event.additional_sponsors[3] + " " + a_event.additional_sponsors[4] + " "+ a_event.additional_sponsors[5])
			return_view.replace_marker_with_string ("sponsors_1", a_event.additional_sponsors[1])
			return_view.replace_marker_with_string ("sponsors_2", a_event.additional_sponsors[2])
			return_view.replace_marker_with_string ("sponsors_3", a_event.additional_sponsors[3])
			return_view.replace_marker_with_string ("sponsors_4", a_event.additional_sponsors[4])
			return_view.replace_marker_with_string ("sponsors_5", a_event.additional_sponsors[5])

			return_view.replace_marker_with_string ("description", a_event.short_description)
			return_view.replace_marker_with_string ("notes", a_event.additional_notes)
			return_view.replace_marker_with_string ("chair_1", a_event.conference_chair_1)
			return_view.replace_marker_with_string ("chair_2", a_event.conference_chair_2)
			return_view.replace_marker_with_string ("committee_1", a_event.program_committee_chair_1)
			return_view.replace_marker_with_string ("committee_2", a_event.program_committee_chair_2)
			return_view.replace_marker_with_string ("organization", a_event.organizing_chair)
			return_view.replace_marker_with_string ("proceedings", a_event.proceeding_type)
			return_view.replace_marker_with_string ("publisher", a_event.proceedings_publisher)

			if not a_event.additional_deadline_1.is_equal (empty_date) then
				s1 := a_event.additional_deadline_1.day.out + "/" + a_event.additional_deadline_1.month.out + "/" + a_event.additional_deadline_1.year.out
				return_view.replace_marker_with_string ("deadline_1", s1)
			end
			if not a_event.additional_deadline_2.is_equal (empty_date) then
				s1 := a_event.additional_deadline_2.day.out + "/" + a_event.additional_deadline_2.month.out + "/" + a_event.additional_deadline_2.year.out
				return_view.replace_marker_with_string ("deadline_2", s1)
			end
			if not a_event.additional_deadline_3.is_equal (empty_date) then
				s1 := a_event.additional_deadline_3.day.out + "/" + a_event.additional_deadline_3.month.out + "/" + a_event.additional_deadline_3.year.out
				return_view.replace_marker_with_string ("deadline_3", s1)
			end

			return_view.replace_marker_with_string ("topic_1", a_event.additional_deadline_specification_1)
			return_view.replace_marker_with_string ("topic_2", a_event.additional_deadline_specification_2)
			return_view.replace_marker_with_string ("topic_3", a_event.additional_deadline_specification_3)

			return_view.replace_marker_with_string ("SELECTED_COUNTRY", "<option value=%"" + a_event.country + "%" selected=%"selected%">" + a_event.country+"</option>")
			return_view.replace_marker_with_string ("SELECTED_ROLE", "<option value=%"" + a_event.contact_role + "%" selected=%"selected%">" + a_event.contact_role+"</option>")
			return_view.replace_marker_with_string ("SELECTED_PROCEEDING", "<option value=%"" + a_event.proceeding_type + "%" selected=%"selected%">" + a_event.proceeding_type+"</option>")


			return_view.replace_marker_with_string ("submitted_by", a_event.submitted_by)
			if a_event.event_status.is_equal (Proposed) then
				return_view.replace_marker_with_string ("proposed", "checked=%"checked%"")
			elseif  a_event.event_status.is_equal (accepted) then
				return_view.replace_marker_with_string ("accepted", "checked=%"checked%"")
			elseif  a_event.event_status.is_equal (rejected) then
				return_view.replace_marker_with_string ("rejected", "checked=%"checked%"")
			elseif  a_event.event_status.is_equal (deleted) then
				return_view.replace_marker_with_string ("deleted", "checked=%"checked%"")
			end

		end


feature {NONE} -- implementation


invariant
	invariant_clause: True -- Your invariant here

end
