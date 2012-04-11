indexing
	description	: "System's root class: dispatches administrator HTTP requests to different classes that take care of them"
	date: "$Date$"
	revision: "$0.3.1$"

class
	ADMIN_REQUEST_DISPATCHER

	inherit
	CGI_INTERFACE

	redefine make
	end

	APPLICATION_CONSTANTS

create
	make

feature

	-- Basic Operations
 	execute
 		--executes the main application flow depending on the request received
 		local
 			a_conference:CONFERENCE
 			a_conference_list_to_sort: CONFERENCE_LIST
		do
			if  Request_method.is_equal ("GET") AND query_string.is_empty then
				--builds conferences list page, loading data about conferences if available
				return_page := html_builder_delegate.build_login_page(form_validation_errors)

	--*** control flow coming from event list page, one of the "accepted conference" hyperlinks pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (1,6).is_equal ("aindex") then
				a_conference:=conference_dao.get_accepted_conference_by_id(query_string.substring (8,query_string.count).to_natural_64)
				return_page:=html_builder_delegate.build_event_submission_page (a_conference, form_validation_errors)

	--*** control flow coming from event list page, one of the "proposed conference" hyperlinks pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring(1,6).is_equal ("pindex") then
				a_conference:=conference_dao.get_proposed_conference_by_id (query_string.substring (8,query_string.count).to_natural_64)
				return_page:=html_builder_delegate.build_event_submission_page (a_conference, form_validation_errors)

	--*** control flow coming from event list page, hyperlink  "Conference name" on the column header pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,9).is_equal ("name") then
				--sorts a copy of the accepted event list by name
				conference_dao.accepted_conference_list.start
				a_conference_list_to_sort:=conference_dao.accepted_conference_list.duplicate (conference_dao.accepted_conference_list.count)
				sorter.sort_conference_list_by_name (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, a_conference_list_to_sort)

	--*** control flow coming from event list page, hyperlink  "Date" on the accepted conference list column header pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,14).is_equal ("startdate") then
				--sorts a copy of the accepted event list by starting date
				conference_dao.accepted_conference_list.start
				a_conference_list_to_sort:=conference_dao.accepted_conference_list.duplicate (conference_dao.accepted_conference_list.count)
				sorter.sort_conference_list_by_starting_date (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, a_conference_list_to_sort)

	--*** control flow coming from event list page, hyperlink  "Country" on the column header pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,12).is_equal ("country") then
				--sorts a copy of the accepted event list by country
				conference_dao.accepted_conference_list.start
				a_conference_list_to_sort:=conference_dao.accepted_conference_list.duplicate (conference_dao.accepted_conference_list.count)
				sorter.sort_conference_list_by_country (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, a_conference_list_to_sort)

	--*** control flow coming from event list page, hyperlink  "Paper deadline" on the column header pressed ***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,19).is_equal ("papersdeadline") then
				--sorts a copy of the accepted event list by papers submission deadline
				conference_dao.accepted_conference_list.start
				a_conference_list_to_sort:=conference_dao.accepted_conference_list.duplicate (conference_dao.accepted_conference_list.count)
				sorter.sort_conference_list_by_papers_submission_deadline (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, a_conference_list_to_sort)

	--*** control flow coming from event list page, hyperlink  "Conference name" on the proposed event list column header pressed***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,10).is_equal ("pname") then
				--sorts a copy of the proposed event list by name
				conference_dao.proposed_conference_list.start
				a_conference_list_to_sort:=conference_dao.proposed_conference_list.duplicate (conference_dao.proposed_conference_list.count)
				sorter.sort_conference_list_by_name (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (a_conference_list_to_sort, conference_dao.accepted_conference_list)

	--*** control flow coming from event list page, hyperlink  "Date" on the proposed event list column header pressed***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,15).is_equal ("pstartdate") then
				--sorts a copy of the proposed event list by starting date
				conference_dao.proposed_conference_list.start
				a_conference_list_to_sort:=conference_dao.proposed_conference_list.duplicate (conference_dao.proposed_conference_list.count)
				sorter.sort_conference_list_by_starting_date(a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page(a_conference_list_to_sort, conference_dao.accepted_conference_list)

	--*** control flow coming from event list page, hyperlink  "Country" on the proposed event list column header pressed***
			elseif  Request_method.is_equal ("GET") AND query_string.substring (6,13).is_equal ("pcountry") then
				--sorts a copy of the proposed event list by country
				conference_dao.proposed_conference_list.start
				a_conference_list_to_sort:=conference_dao.proposed_conference_list.duplicate (conference_dao.proposed_conference_list.count)
				sorter.sort_conference_list_by_country (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (a_conference_list_to_sort, conference_dao.accepted_conference_list)

	--*** control flow coming from event list page, hyperlink  "Papers submission deadline" on the proposed event list column header pressed***
			elseif  Request_method.is_equal ("GET") AND query_string.substring(6,20).is_equal ("ppapersdeadline") then
				--sorts a copy of the proposed event list by papers submission deadline
				conference_dao.proposed_conference_list.start
				a_conference_list_to_sort:=conference_dao.proposed_conference_list.duplicate (conference_dao.proposed_conference_list.count)
				sorter.sort_conference_list_by_papers_submission_deadline (a_conference_list_to_sort)
				--returns the same page
				return_page:=html_builder_delegate.build_conference_list_admin_page (a_conference_list_to_sort, conference_dao.accepted_conference_list)

	--*** control flow coming from the final page, button 'Back to event list' pressed ***
--			elseif Request_method.is_equal ("POST") AND button_value ("generic_button", "Back to event list") then
				--builds event list page, loading data about conferences if available		
--				return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)

	--*** control flow coming from the login page, button 'Login' pressed ***
			elseif Request_method.is_equal ("POST") AND THEN button_value ("generic_button","Login") then
				if validator.is_administrator_validated(text_field_value ("userid"),text_field_value("password")) then
						if conference_dao.proposed_conference_list.count=0 then
							form_validation_errors.extend ("Administrator message: there are no conferences to manage. ", "no-conferences")
							return_page:=html_builder_delegate.build_login_page (form_validation_errors)
						else
							--the administrator event list page is sent
							return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)
						end
				else
						form_validation_errors.extend ("Username or Password not valid", "login_error")
						--sends back the submission page, with an error message
						return_page:=html_builder_delegate.build_login_page (form_validation_errors)
				end

	--*** control flow coming from event list page, button 'Update' pushed ***
			elseif Request_method.is_equal ("POST") AND button_value ("generic_button", "Update") then
				perform_form_details_validation
				a_conference:=conference_dao.get_accepted_conference_by_id (text_field_value ("id").to_natural_64)
				if form_validation_errors.is_empty then
					initialize_conference (a_conference, Accepted)
					--add the conference to the accepted conference list
					conference_dao.update_conference_in_accepted_list (a_conference)
					--persists application data
					conference_dao.persist_data
					--the administrator event list page is sent
					return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)
				else --send the form back with error messages displayed
					initialize_conference (a_conference, Accepted)
					return_page:=html_builder_delegate.build_event_submission_page (a_conference, form_validation_errors)
				end

	--*** control flow coming from conference list page, button 'Accept' pushed ***
			elseif Request_method.is_equal ("POST") AND button_value ("generic_button", "Accept") then
				perform_form_details_validation
				a_conference:=conference_dao.get_proposed_conference_by_id (text_field_value ("id").to_natural_64)
				if form_validation_errors.is_empty then
					initialize_conference (a_conference, Accepted)
					--add the conference to the accepted conference list
					conference_dao.add_conference (a_conference)
					--send an email to the contact person to confirm conference acceptance
					an_email_handler.send_email (a_conference.contact_email, Admin_email, Event_accepted_email_subject, Event_accepted_email_message)
					--delete the conference from the proposed conference list
					conference_dao.delete_conference_from_proposed_list (a_conference)
					--persists application data
					conference_dao.persist_data
					--the administrator event list page is sent
					return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)
				else --send the form back with error messages displayed
					initialize_conference (a_conference, Proposed)
					return_page:=html_builder_delegate.build_event_submission_page (a_conference,form_validation_errors)
				end

	--*** control flow coming from conference proposal page, button 'Reject' pushed***
			elseif Request_method.is_equal ("POST") AND button_value ("generic_button", "Reject") then
				perform_form_details_validation
				a_conference:=conference_dao.get_proposed_conference_by_id (text_field_value ("id").to_natural_64)
				if form_validation_errors.is_empty then
					initialize_conference(a_conference, Rejected)
					--add the conference to the appropriate conference list
					conference_dao.add_conference (a_conference)
					--delete the conference from the proposed conference list
					conference_dao.delete_conference_from_proposed_list (a_conference)
					--persists application data
					conference_dao.persist_data
					--the administrator event list page is sent
					return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)
				else --send the form back with error messages displayed
					initialize_conference (a_conference, Proposed)
					return_page:=html_builder_delegate.build_event_submission_page (a_conference,form_validation_errors)
			end

	--*** control flow coming from conference proposal page, button 'Defer' pushed***
			elseif Request_method.is_equal ("POST") AND button_value ("generic_button", "Defer") then
				perform_form_details_validation
				a_conference:=conference_dao.get_proposed_conference_by_id (text_field_value ("id").to_natural_64)
				if form_validation_errors.is_empty then
					initialize_conference (a_conference, Delayed)
					--update the conference in the proposed conference list
					conference_dao.update_conference_in_proposed_list (a_conference)
					--persists application data
					conference_dao.persist_data
					--the administrator event list page is sent
					return_page:=html_builder_delegate.build_conference_list_admin_page (conference_dao.proposed_conference_list, conference_dao.accepted_conference_list)
				else --send the form back with error messages displayed
					initialize_conference (a_conference, Proposed)
					return_page:=html_builder_delegate.build_event_submission_page (a_conference, form_validation_errors)
			end

	--*** if something went wrong...***
			else
				return_page:=html_builder_delegate.build_exit_page ("Something unexpected has happened. Please have a look at the application main flow and at the server log.")
		end
		--generates response header and sends web page to the browser
		response_header.generate_text_header
		response_header.send_to_browser
		response_header.Output.put_string (return_page.out)
		rescue
		io.error.putstring ("crash in `compute' from DOWNLOAD_INTERACTION%N")
		end
---------------------------------------------------------------------------------------------------------------------------
feature
--access
	Debug_mode: BOOLEAN is True -- Should exception trace be displayed in case a crash occurs?	

	return_page: HTML_PAGE -- Page which is sent back to the browser.

	html_builder_delegate: ADMIN_HTML_DELEGATE 	-- helper class for building the HTML pages for this application

	conference_dao: CONFERENCE_DAO --reference to the specific data access object used for implementation (see make)

	user_dao: USER_DAO --reference to the specific data access object used for implementation (see make)

	validator:VALIDATOR --used to validate user input

	form_validation_errors: HASH_TABLE[STRING,STRING] --form validation errors

	sorter:SORT_HELPER --helper class used to sort list elements

	an_email_handler: EMAIL_HANDLER --helper class used to send emails
---------------------------------------------------------------------------------------------------------------------------
feature
	--initialization
	make
	do
		create html_builder_delegate.make
		--you can substitute an implementation DAO class name here if you need different storage behaviours		
		create {CONFERENCE_DAO_FILE_IMPL} conference_dao.make
		create {USER_DAO_FILE_IMPL} user_dao.make
		create validator.make (user_dao)
		create form_validation_errors.make(10)
		create an_email_handler
		Precursor --starts default template method
	end
---------------------------------------------------------------------------------------------------------------------------
	initialize_conference (a_conference:CONFERENCE; target_state_of_approval:INTEGER)
		--initializes conference with data from input form, in case of validation errors too
		require
			a_conference_exists: a_conference/=Void
			conference_status_is_consistent:a_conference.status_of_approval=Undefined OR a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Rejected OR a_conference.status_of_approval=Accepted OR a_conference.status_of_approval=Delayed
			target_state_is_consistent: target_state_of_approval=Proposed OR target_state_of_approval=Accepted OR target_state_of_approval=Rejected OR target_state_of_approval=Undefined OR target_state_of_approval=Delayed
		local
			temp_date:DATE
			temp_keywords,temp_additional_sponsors:ARRAYED_LIST[STRING]
		do
			if validator.is_field_value_valid (text_field_value ("conference_name")) then
				a_conference.set_name (text_field_value ("conference_name"))
			end
			if validator.is_field_value_valid (text_field_value ("start_date_day")) AND validator.is_field_value_valid (text_field_value ("start_date_month")) AND validator.is_field_value_valid (text_field_value ("start_date_year"))
			AND validator.is_date_valid (text_field_value ("start_date_day"), text_field_value ("start_date_month"), text_field_value ("start_date_year")) then
				create temp_date.make_day_month_year (text_field_value ("start_date_day").to_integer,text_field_value ("start_date_month").to_integer,text_field_value ("start_date_year").to_integer)
				a_conference.set_starting_date (temp_date)
			end
			if validator.is_field_value_valid (text_field_value ("end_date_day")) AND validator.is_field_value_valid (text_field_value ("end_date_month")) AND validator.is_field_value_valid (text_field_value ("end_date_year"))
			AND validator.is_date_valid (text_field_value ("end_date_day"), text_field_value ("end_date_month"), text_field_value ("end_date_year")) then
				create temp_date.make_day_month_year (text_field_value ("end_date_day").to_integer,text_field_value ("end_date_month").to_integer,text_field_value ("end_date_year").to_integer)
				a_conference.set_ending_date (temp_date)
			end
			if validator.is_field_value_valid (text_field_value ("conference_city")) then
				a_conference.set_city (text_field_value ("conference_city"))
			end

			if validator.is_country_valid(text_field_value ("conference_country")) then
				a_conference.set_country (text_field_value ("conference_country"))
			end
			if validator.is_date_valid (text_field_value ("paper_sub_deadline_day"), text_field_value ("paper_sub_deadline_month"), text_field_value ("paper_sub_deadline_year")) then
				create temp_date.make_day_month_year (text_field_value ("paper_sub_deadline_day").to_integer,text_field_value ("paper_sub_deadline_month").to_integer,text_field_value ("paper_sub_deadline_year").to_integer)
			elseif	text_field_value ("paper_sub_deadline_day").is_equal("n/a") OR text_field_value ("paper_sub_deadline_month").is_equal("n/a") OR text_field_value ("paper_sub_deadline_year").is_equal("n/a") then
				create temp_date.make_day_month_year (1, 1, 1111)
			end
			a_conference.set_papers_submission_deadline (temp_date)
			if validator.is_field_value_valid (text_field_value ("main_sponsor")) then
				a_conference.set_main_sponsor (text_field_value ("main_sponsor"))
			end
			if validator.is_field_value_valid (text_field_value ("conference_url")) then
				a_conference.set_url (text_field_value ("conference_url"))
			end
			if validator.is_field_value_valid (text_field_value ("contact_name")) then
				a_conference.set_contact_name (text_field_value ("contact_name"))
			end
			if validator.is_email_valid (text_field_value ("contact_email")) then
				a_conference.set_contact_email (text_field_value ("contact_email"))
			end
			if validator.is_field_value_valid (text_field_value ("contact_role")) then
				a_conference.set_contact_role (text_field_value ("contact_role"))
			end
			--optional fields checks
			create temp_keywords.make_filled (5)
			if validator.is_field_value_valid (text_field_value ("keyword1")) then
				temp_keywords[1]:=text_field_value ("keyword1")
			else
				temp_keywords[1]:=""
			end
			if validator.is_field_value_valid (text_field_value ("keyword2")) then
				temp_keywords[2]:=text_field_value ("keyword2")
			else
				temp_keywords[2]:=""
			end
			if validator.is_field_value_valid (text_field_value ("keyword3")) then
				temp_keywords[3]:=text_field_value ("keyword3")
			else
				temp_keywords[3]:=""
			end
			if validator.is_field_value_valid (text_field_value ("keyword4")) then
				temp_keywords[4]:=text_field_value ("keyword4")
			else
				temp_keywords[4]:=""
			end
			if validator.is_field_value_valid (text_field_value ("keyword5")) then
				temp_keywords[5]:=text_field_value ("keyword5")
			else
				temp_keywords[5]:=""
			end
			a_conference.set_keywords (temp_keywords)
			create temp_additional_sponsors.make_filled (5)
			if validator.is_field_value_valid (text_field_value ("additional_sponsor_1")) then
				temp_additional_sponsors[1]:=text_field_value ("additional_sponsor_1")
			else
				temp_additional_sponsors[1]:=""
			end
			if validator.is_field_value_valid (text_field_value ("additional_sponsor_2")) then
				temp_additional_sponsors[2]:=text_field_value ("additional_sponsor_2")
			else
				temp_additional_sponsors[2]:=""
			end
			if validator.is_field_value_valid (text_field_value ("additional_sponsor_3")) then
				temp_additional_sponsors[3]:=text_field_value ("additional_sponsor_3")
			else
				temp_additional_sponsors[3]:=""
			end
			if validator.is_field_value_valid (text_field_value ("additional_sponsor_4")) then
				temp_additional_sponsors[4]:=text_field_value ("additional_sponsor_4")
			else
				temp_additional_sponsors[4]:=""
			end
			if validator.is_field_value_valid (text_field_value ("additional_sponsor_5")) then
				temp_additional_sponsors[5]:=text_field_value ("additional_sponsor_5")
			else
				temp_additional_sponsors[5]:=""
			end
			a_conference.set_additional_sponsors (temp_additional_sponsors)
			if  validator.is_field_value_valid (text_field_value ("short_description")) then
				a_conference.set_short_description (text_field_value ("short_description"))
			end
			if  validator.is_field_value_valid (text_field_value ("conference_chair_1")) then
				a_conference.set_conference_chair_1 (text_field_value ("conference_chair_1"))
			end
			if validator.is_field_value_valid (text_field_value ("conference_chair_2")) then
				a_conference.set_conference_chair_2 (text_field_value ("conference_chair_2"))
			end
			if validator.is_field_value_valid (text_field_value ("pc_chair_1")) then
				a_conference.set_program_committee_chair_1 (text_field_value ("pc_chair_1"))
			end
			if validator.is_field_value_valid (text_field_value ("pc_chair_2")) then
				a_conference.set_program_committee_chair_2 (text_field_value ("pc_chair_2"))
			end
			if validator.is_field_value_valid (text_field_value ("organizing_chair")) then
				a_conference.set_organizing_chair (text_field_value ("organizing_chair"))
			end

			if button_value("conference_proceedings","at_conference") then
				a_conference.set_proceedings_at_conference(True)
			end

			if validator.is_field_value_valid (text_field_value ("proceedings_publisher")) then
				a_conference.set_proceedings_publisher (text_field_value ("proceedings_publisher"))
			end

			if validator.is_field_value_valid (text_field_value ("additional_deadline_1_day")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_1_month")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_1_year"))
			AND validator.is_date_valid (text_field_value ("additional_deadline_1_day"), text_field_value ("additional_deadline_1_month"), text_field_value ("additional_deadline_1_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_1_day").to_integer,text_field_value ("additional_deadline_1_month").to_integer,text_field_value ("additional_deadline_1_year").to_integer)
				a_conference.set_additional_deadline_1 (temp_date)
			end

			if validator.is_field_value_valid (text_field_value ("additional_deadline_2_day")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_3_month")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_3_year"))
			AND validator.is_date_valid (text_field_value ("additional_deadline_2_day"), text_field_value ("additional_deadline_3_month"), text_field_value ("additional_deadline_3_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_2_day").to_integer,text_field_value ("additional_deadline_3_month").to_integer,text_field_value ("additional_deadline_3_year").to_integer)
				a_conference.set_additional_deadline_2 (temp_date)
			end

			if validator.is_field_value_valid (text_field_value ("additional_deadline_3_day")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_2_month")) AND validator.is_field_value_valid (text_field_value ("additional_deadline_2_year"))
			AND validator.is_date_valid (text_field_value ("additional_deadline_3_day"), text_field_value ("additional_deadline_2_month"), text_field_value ("additional_deadline_2_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_3_day").to_integer,text_field_value ("additional_deadline_2_month").to_integer,text_field_value ("additional_deadline_2_year").to_integer)
				a_conference.set_additional_deadline_3 (temp_date)
			end

			if validator.is_date_valid (text_field_value ("additional_deadline_1_day"), text_field_value ("additional_deadline_1_month"), text_field_value ("additional_deadline_1_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_1_day").to_integer,text_field_value ("additional_deadline_1_month").to_integer,text_field_value ("additional_deadline_1_year").to_integer)
			elseif text_field_value ("additional_deadline_1_day").is_equal("n/a") OR text_field_value ("additional_deadline_1_month").is_equal ("n/a") OR text_field_value ("additional_deadline_1_year").is_equal ("n/a") then
				create temp_date.make_day_month_year (1, 1, 1111)
			else
				create temp_date.make_now
			end
			a_conference.set_additional_deadline_1 (temp_date)

			if validator.is_date_valid (text_field_value ("additional_deadline_2_day"), text_field_value ("additional_deadline_2_month"), text_field_value ("additional_deadline_2_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_2_day").to_integer,text_field_value ("additional_deadline_2_month").to_integer,text_field_value ("additional_deadline_2_year").to_integer)
			elseif text_field_value ("additional_deadline_2_day").is_equal("n/a") OR text_field_value ("additional_deadline_2_month").is_equal ("n/a") OR text_field_value ("additional_deadline_2_year").is_equal ("n/a") then
				create temp_date.make_day_month_year (1, 1, 1111)
			else
				create temp_date.make_now
			end
			a_conference.set_additional_deadline_2 (temp_date)

			if validator.is_date_valid (text_field_value ("additional_deadline_3_day"), text_field_value ("additional_deadline_3_month"), text_field_value ("additional_deadline_3_year")) then
				create temp_date.make_day_month_year (text_field_value ("additional_deadline_3_day").to_integer,text_field_value ("additional_deadline_3_month").to_integer,text_field_value ("additional_deadline_3_year").to_integer)
			elseif text_field_value ("additional_deadline_3_day").is_equal("n/a") OR text_field_value ("additional_deadline_3_month").is_equal ("n/a") OR text_field_value ("additional_deadline_3_year").is_equal ("n/a") then
				create temp_date.make_day_month_year (1, 1, 1111)
			else
				create temp_date.make_now
			end
			a_conference.set_additional_deadline_3 (temp_date)

			if validator.is_field_value_valid (text_field_value ("additional_deadline_specification_1")) then
				a_conference.set_additional_deadline_specification_1 (text_field_value ("additional_deadline_specification_1"))
			end

			if validator.is_field_value_valid (text_field_value ("additional_deadline_specification_2")) then
				a_conference.set_additional_deadline_specification_2 (text_field_value ("additional_deadline_specification_2"))
			end

			if validator.is_field_value_valid (text_field_value ("additional_deadline_specification_3")) then
				a_conference.set_additional_deadline_specification_3 (text_field_value ("additional_deadline_specification_3"))
			end

			if  validator.is_field_value_valid (text_field_value ("additional_notes")) then
				a_conference.set_additional_notes (text_field_value ("additional_notes"))
			end

			a_conference.set_state_of_approval (target_state_of_approval)
	end

feature{NONE}
---------------------------------------------------------------------------------------------------------------------------
	perform_form_details_validation
	--basic form validation for the details page: checks all required fields adding their names to the empty_fields list if applicable
	local
		start_date:DATE
		end_date:DATE
		papers_submission_date:DATE
	do
		if NOT field_defined ("conference_name") OR ELSE NOT validator.is_field_value_valid (text_field_value ("conference_name")) then
			form_validation_errors.extend ("Conference Name", "conference_name")
		end

		if (NOT field_defined ("start_date_day") OR NOT field_defined ("start_date_month") OR NOT field_defined ("start_date_year")) OR ELSE NOT validator.is_date_valid(text_field_value ("start_date_day"),text_field_value ("start_date_month"),text_field_value ("start_date_year")) then
			form_validation_errors.extend ("Wrong Starting Date: "+text_field_value ("start_date_day")+"/"+text_field_value ("start_date_month")+"/"+text_field_value ("start_date_year"), "start_date_day")
		else
			create start_date.make_day_month_year (text_field_value ("start_date_day").to_integer, text_field_value ("start_date_month").to_integer, text_field_value ("start_date_year").to_integer)
		end

		if NOT field_defined ("end_date_day") OR ELSE NOT field_defined ("end_date_month") OR ELSE NOT field_defined ("end_date_year") OR ELSE NOT validator.is_date_valid(text_field_value ("end_date_day"),text_field_value ("end_date_month"),text_field_value ("end_date_year")) then
			form_validation_errors.extend ("Wrong Ending Date: "+text_field_value ("end_date_day")+"/"+text_field_value ("end_date_month")+"/"+text_field_value ("end_date_year"), "end_date_day")
		else
			create end_date.make_day_month_year (text_field_value ("end_date_day").to_integer, text_field_value ("end_date_month").to_integer, text_field_value ("end_date_year").to_integer)
		end

		if NOT field_defined ("conference_city") OR ELSE NOT validator.is_field_value_valid (text_field_value ("conference_city")) then
			form_validation_errors.extend ("City", "conference_city")
		end

		if NOT validator.is_country_valid (text_field_value ("conference_country")) then
			form_validation_errors.extend ("Country", "conference_country")
		end

		if NOT field_defined ("paper_sub_deadline_day") OR ELSE NOT field_defined ("paper_sub_deadline_month") OR ELSE NOT field_defined ("paper_sub_deadline_year") OR ELSE NOT validator.is_non_required_date_valid(text_field_value ("paper_sub_deadline_day"),text_field_value ("paper_sub_deadline_month"),text_field_value ("paper_sub_deadline_year")) then
			form_validation_errors.extend ("Wrong Papers Submission Deadline: "+text_field_value ("paper_sub_deadline_day")+"/"+text_field_value ("paper_sub_deadline_month")+"/"+text_field_value ("paper_sub_deadline_year"),"paper_sub_deadline_day")
		elseif	text_field_value ("paper_sub_deadline_day").is_equal("n/a") OR text_field_value ("paper_sub_deadline_month").is_equal("n/a") OR text_field_value ("paper_sub_deadline_year").is_equal("n/a") then
			create papers_submission_date.make_day_month_year (1, 1, 1111)
		else
			create papers_submission_date.make_day_month_year (text_field_value ("paper_sub_deadline_day").to_integer, text_field_value ("paper_sub_deadline_month").to_integer, text_field_value ("paper_sub_deadline_year").to_integer)
		end
		--	cross checks among dates
		if start_date /= Void AND end_date /= Void AND papers_submission_date/= Void then
			if end_date < start_date then
				form_validation_errors.extend("Starting Date greater than Ending Date", "start_end_date_comparison")
			end
			if  start_date < papers_submission_date then
				form_validation_errors.extend ("Papers Submission Date greater than Starting Date", "papers_submissions_start_date_comparison")
			end
		end

		if NOT field_defined ("main_sponsor") OR ELSE NOT validator.is_field_value_valid (text_field_value ("main_sponsor")) then
			form_validation_errors.extend ("Main Sponsor", "main_sponsor")
		end

		if NOT field_defined ("conference_url") OR ELSE NOT validator.is_field_value_valid (text_field_value ("conference_url")) then
			form_validation_errors.extend ("Conference URL", "conference_url")
		end

		if NOT field_defined ("contact_name") OR ELSE NOT validator.is_field_value_valid(text_field_value ("contact_name")) then
			form_validation_errors.extend ("Contact Name", "contact_name")
		end

		if NOT field_defined ("contact_email") OR ELSE NOT validator.is_email_valid (text_field_value ("contact_email")) then
			form_validation_errors.extend ("Wrong Contact Email: "+text_field_value ("contact_email"), "contact_email")
		end

		if NOT field_defined ("id") OR ELSE NOT validator.is_field_value_valid (text_field_value ("id")) then
			form_validation_errors.extend ("Conference internal id not valid: please contact administrator", "id")
		end
	end
---------------------------------------------------------------------------------------------------------------------------
	perform_form_registration_validation (a_user:USER)
	--basic form validation for the registration page: checks all required fields and eventually initializes the user
	require
		a_user_exists: a_user/=Void
	do
		if NOT field_defined ("first_name") OR ELSE NOT validator.is_field_value_valid (text_field_value ("first_name")) then
			form_validation_errors.extend ("First Name", "first_name")
		else
			a_user.set_first_name (text_field_value ("first_name"))
		end

		if NOT field_defined ("last_name") OR ELSE NOT validator.is_field_value_valid (text_field_value ("last_name")) then
			form_validation_errors.extend ("Last Name", "last_name")
		else
			a_user.set_last_name (text_field_value ("last_name"))
		end

		if NOT field_defined ("organization") OR ELSE NOT validator.is_field_value_valid (text_field_value ("organization")) then
			form_validation_errors.extend ("Organization", "organization")
		else
			a_user.set_organization (text_field_value ("organization"))
		end

		if NOT field_defined ("email") OR ELSE NOT validator.is_email_valid (text_field_value ("email")) then
			form_validation_errors.extend ("Email", "email")
		elseif validator.is_existing_username(text_field_value ("email")) then
			form_validation_errors.extend ("Email (user) already present: please choose another", "existing_email")
			else
				a_user.set_email (text_field_value ("email"))
				a_user.set_username (text_field_value ("email"))
		end

		if NOT field_defined ("password1") OR ELSE NOT validator.is_field_value_valid(text_field_value ("password1")) then
			form_validation_errors.extend ("Password (1st field)", "password1")
		elseif NOT field_defined ("password2") OR ELSE NOT validator.is_field_value_valid(text_field_value ("password2")) then
			form_validation_errors.extend ("Password (2nd field)", "password2")
		elseif NOT text_field_value ("password1").is_equal(text_field_value ("password2")) then
			form_validation_errors.extend ("The two passwords do not match each other", "password_mismatch")
		else
			a_user.set_password (text_field_value ("password1"))
		end
	end

---------------------------------------------------------------------------------------------------------------------------
		build_basic_info_page (conference:CONFERENCE):HTML_PAGE
		--feature used for debug: prints some basic information
		local
			html_page:HTML_PAGE
		do
			create html_page.make
			html_page.add_html_code ("<HEAD><meta http-equiv=%"Content-Type%" content=%"text/html; charset=iso-8859-1%">%N")
			html_page.add_html_code ("<TITLE>Informatics Europe: Debug Page</TITLE>%N</HEAD><BODY>")
			html_page.add_html_code ("Conference id:"+conference.id.out+"<BR>")
			html_page.add_html_code ("Auth_type:"+Auth_type+"<BR>")
			html_page.add_html_code ("Remote_ident:"+Remote_ident+"<BR>")
			html_page.add_html_code ("Remote_user:"+Remote_user+"<BR>")
			html_page.add_html_code ("Request_method:"+Request_method +"<BR>")
			html_page.add_html_code ("Query String:"+query_string+"<BR>")
			html_page.add_html_code ("Number of conferences:"+conference_dao.accepted_conference_list.count.out+"<BR>")
			html_page.add_html_code ("Conference info:<br>")
			html_page.add_html_code ("<br>name:"+conference.name)
			html_page.add_html_code ("<br>starting_date:"+conference.starting_date.out)
			html_page.add_html_code ("<br>ending_date:"+conference.ending_date.out)
			html_page.add_html_code ("<br>city:"+conference.city)
			html_page.add_html_code ("<br>country:"+conference.country)
			html_page.add_html_code ("<br>papers_submission_deadline:"+conference.papers_submission_deadline.out)
			html_page.add_html_code ("<br>main_sponsor:"+conference.main_sponsor)
			html_page.add_html_code ("<br>url:"+conference.url)
			html_page.add_html_code ("<br>contact_name:"+conference.contact_name)
			html_page.add_html_code ("<br>contact_email:"+conference.contact_email)
			html_page.add_html_code ("<br>contact_role:"+conference.contact_role)
			html_page.add_html_code ("<br>short_description:"+conference.short_description)
			html_page.add_html_code ("<br>conference_chair_1:"+conference.conference_chair_1)
			html_page.add_html_code ("<br>conference_chair_2:"+conference.conference_chair_2)
			html_page.add_html_code ("<br>program_committee_chair_1:"+conference.program_committee_chair_1)
			html_page.add_html_code ("<br>program_committee_chair_2:"+conference.program_committee_chair_2)
			html_page.add_html_code ("<br>organizing_chair:"+conference.organizing_chair)
			html_page.add_html_code ("<br>proceedings_publisher:"+conference.proceedings_publisher)
			html_page.add_html_code ("<br>keywords[1]:"+conference.keywords[1])
			html_page.add_html_code ("<br>additional_sponsors[1]:"+conference.additional_sponsors[1])
			html_page.add_html_code ("</FORM></BODY>%N")
			Result:=html_page
		ensure
			Result /=Void
		end

end -- class REQUEST_DISPATCHER
