indexing
	description: "Objects that provide HTML pages for application"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	USER_HTML_DELEGATE

inherit
	HTML_DELEGATE
	INLINE_ELEMENT

create
	make

feature -- page building routines

	build_registration_page (a_user:USER;errors:HASH_TABLE[STRING,STRING]): VIEW_HTML
			--registration form
		require
			errors_exists:errors/=Void
			a_user_exists:a_user/=Void
		local
			error_list : HTML_UNORDERED_LIST
			form : HTML_FORM
			input_name1 : HTML_FORM_INPUT
			input_name2 : HTML_FORM_INPUT
			organisation:HTML_FORM_INPUT
			email : HTML_FORM_INPUT
			pass1 : HTML_FORM_INPUT
			pass2 : HTML_FORM_INPUT
			button :HTML_FORM_INPUT
		do
			Result := create {HTML_TEMPLATE}.make

			-- Add the <title> tag
			Result.put_title ("Informatics Europe: Registration Page")
			--add the CSS
			Result.put_link_css (css_path)

			--Add the container table, the logo and the title
			Result.content_header.put_paragraph ("Registration")

			if  NOT errors.is_empty then
				--Add the errors info
				Result.content_middle.put_paragraph ("Please check the following:")
				from
					errors.start
					create error_list.make
					error_list.add_class("style10")
				until
					errors.after
				loop
					error_list.add_element (errors.item_for_iteration)
					errors.forth
				end
				Result.content_middle.put_html(error_list.out)
			end
			--Add the form start
			create form.make
			form.set_action (Form_action)
			form.set_method ("post")

			Result.content_middle.put_h2("ALL FIELDS MUST BE FILLED:")

			--Add user first name
			create input_name1.make
			input_name1.set_type ("text")
			input_name1.set_name ("first_name")
			input_name1.set_value (a_user.first_name)
			input_name1.set_maxlength (50)
			form.add_option ("<span class=%"heading2%">First Name:&nbsp;</span>" + input_name1.out)
			--Add user last name
			create input_name2.make
			input_name2.set_type ("text")
			input_name2.set_name ("last_name")
			input_name2.set_value (a_user.last_name.out)
			input_name2.set_maxlength (50)
			form.add_option ("<span class=%"heading2%">Last Name:&nbsp;</span>" + input_name2.out)
			--Add user organization
			create organisation.make
			organisation.set_type ("text")
			organisation.set_name ("organisation")
			organisation.set_value (a_user.organization)
			organisation.set_maxlength (50)
			form.add_option ("<span class=%"heading2%">Organization:&nbsp;</span>" + organisation.out)
			--Add user email
			create email.make
			email.set_type ("text")
			email.set_name ("email")
			email.set_value (a_user.email)
			email.set_maxlength (50)
			form.add_option ("<span class=%"heading2%">Email (will serve as your userid):&nbsp;</span>" + email.out)
			--Add user password and password doublecheck field
			create pass1.make
			pass1.set_type ("password")
			pass1.set_name ("password1")
			pass1.set_size (15)
			form.add_option ("<span class=%"heading2%">Password:&nbsp;</span>" + pass1.out)
			create pass2.make
			pass2.set_type ("password")
			pass2.set_name ("password2")
			pass2.set_size (15)
			form.add_option ("<span class=%"heading2%">Retype password:&nbsp;</span>" + pass2.out)
			-- Add Confirm Submission user button
			create button.make
			button.set_type ("submit")
			button.set_name ("generic_button")
			button.set_value ("Register now")
			form.add_option (button.out)
			--Add the form end
			Result.content_middle.put_html (form.out)

			ensure
				page_created:Result /=Void
	end
-----------------------------------------------------------------------------------------------------------------------
	build_event_details_page(the_conference:CONFERENCE):VIEW_HTML
			--This page, which is readonly, is shown when a user wants to browse the details of a specific event and has pressed one of the hyperlinks in the event list page
		require
			the_conference_exists:the_conference /= Void
		local
			temp_date:DATE
			ts : STRING
			form:HTML_FORM
			button:HTML_FORM_INPUT
		do
			Result := create {HTML_TEMPLATE}.make
			-- Add the <title> tag
			Result.put_title ("Informatics Europe: Event details page%N")
			--add the CSS
			Result.put_link_css (css_path)
			--Add the container table, the logo and the title
			Result.content_header.put_h2 ("Event detauls")
			--Add conference name
			Result.content_middle.put_paragraph (strong("Event name:")+" "+the_conference.name)
			--Add starting and ending date
			Result.content_middle.put_paragraph (strong("Starting date (dd/mm/yyyy):")+" "+the_conference.starting_date.formatted_out("[0]dd/[0]mm/yyyy")+"&nbsp;&nbsp;&nbsp;"+
				strong("Ending date (dd/mm/yyyy):")+" "+the_conference.ending_date.formatted_out("[0]dd/[0]mm/yyyy"))
			--Add city and country
			Result.content_middle.put_paragraph (strong("City:")+" "+the_conference.city+"&nbsp;&nbsp;&nbsp;"+
				strong("Country:")+" "+the_conference.country)
			--Add papers submission deadline
			create temp_date.make_day_month_year (1, 1, 1111)
			create ts.make_from_string (strong("Papers submission deadline (dd/mm/yyyy):"))
			if temp_date.is_equal(the_conference.papers_submission_deadline) then
				ts.append ("n/a")
			else
				ts.append (the_conference.papers_submission_deadline.formatted_out("[0]dd/[0]mm/yyyy"))
			end
			Result.content_middle.put_paragraph (ts)
			--Add main sponsor & conference url
			Result.content_middle.put_paragraph (strong("Main sponsor:")+" "+the_conference.main_sponsor+"&nbsp;&nbsp;&nbsp;" +
				strong("Conference url:")+" "+link_to (the_conference.url, the_conference.url))
			--Add contact data
			Result.content_middle.put_paragraph (strong("Contact name:")+" "+the_conference.contact_name+"&nbsp;&nbsp;&nbsp;" +
				strong("Contact email:")+" "+the_conference.contact_email +
				strong("Contact role:")+" "+the_conference.contact_role)
			--Add optional information section: keywords and additional sponsors
			Result.content_middle.put_line
			Result.content_middle.put_paragraph (strong("Keywords:")+the_conference.keywords[1]+"&nbsp;&nbsp;&nbsp;"+the_conference.keywords[2]+"&nbsp;&nbsp;&nbsp;"+the_conference.keywords[3]+"&nbsp;&nbsp;&nbsp;"+the_conference.keywords[4]+"&nbsp;&nbsp;&nbsp;"+the_conference.keywords[5])
			Result.content_middle.put_paragraph (strong("Additional sponsors:")+the_conference.additional_sponsors[1]+"&nbsp;&nbsp;&nbsp;"+the_conference.additional_sponsors[2]+"&nbsp;&nbsp;&nbsp;"+the_conference.additional_sponsors[3]+"&nbsp;&nbsp;&nbsp;"+the_conference.additional_sponsors[4]+"&nbsp;&nbsp;&nbsp;"+the_conference.additional_sponsors[5])
			--Add short description
			Result.content_middle.put_paragraph (strong("Short description:")+" "+the_conference.short_description)
			--Add additional notes
			Result.content_middle.put_paragraph (strong("Additional notes:")+" "+the_conference.additional_notes)
			--Add conference chairs
			Result.content_middle.put_paragraph (strong("Event chair 1:")+" "+the_conference.conference_chair_1)
			Result.content_middle.put_paragraph (strong("Event chair 2:")+" "+the_conference.conference_chair_2)
			--Add pc chairs
			Result.content_middle.put_paragraph (strong("Program committee chair 1:")+" "+the_conference.program_committee_chair_1)
			Result.content_middle.put_paragraph (strong("Program committee chair 2:")+" "+the_conference.program_committee_chair_2)
			--Add organizing chair
			Result.content_middle.put_paragraph (strong("Organizing chair:")+" "+the_conference.organizing_chair)
			--Add proceedings info and proceedings publisher
			if the_conference.proceedings_at_conference then
				Result.content_middle.put_paragraph (strong("Proceedings:")+" At conference&nbsp;&nbsp;&nbsp;" +
					strong("Proceedings publisher:")+the_conference.proceedings_publisher)
			else
				Result.content_middle.put_paragraph (strong("Proceedings:")+" Post conference&nbsp;&nbsp;&nbsp;" +
					strong("Proceedings publisher:")+the_conference.proceedings_publisher)
			end
			--Add additional deadlines and the related info
			if temp_date.is_equal(the_conference.additional_deadline_1) then
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" n/a&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_1)
			else
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" "+the_conference.additional_deadline_1.formatted_out("[0]dd/[0]mm/yyyy")+"&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_1)
			end
				Result.content_middle.put_paragraph (strong("")+" ")
				Result.content_middle.put_paragraph (strong("")+" ")
				Result.content_middle.put_paragraph (strong("")+" ")
				Result.content_middle.put_paragraph (strong("")+" ")

			if temp_date.is_equal(the_conference.additional_deadline_2) then
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" n/a&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_2)
			else
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" "+the_conference.additional_deadline_2.formatted_out("[0]dd/[0]mm/yyyy")+"&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_2)
			end
			if temp_date.is_equal(the_conference.additional_deadline_3) then
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" n/a&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_3)
			else
				Result.content_middle.put_paragraph (strong("Additional deadline (dd/mm/yyyy):")+" "+the_conference.additional_deadline_3.formatted_out("[0]dd/[0]mm/yyyy")+"&nbsp;&nbsp;&nbsp;" +
					strong("Details:")+the_conference.additional_deadline_specification_3)
			end
			-- Add the form
			create form.make
			form.set_action (form_action)
			form.set_method ("post")
			create button.make
			button.set_type ("submit")
			button.set_name ("generic_button")
			button.set_value ("Back to event list")
			form.add_option (button.out)
			Result.content_middle.put_html (form.out)

		ensure
			page_created:Result /=Void
	end
-----------------------------------------------------------------------------------------------------------------------
	build_event_submission_page(the_conference:CONFERENCE; errors:HASH_TABLE[STRING,STRING]):VIEW_HTML
			--This page is displayed when an administrator wants to update/delete/accept/reject/defer a conference proposal
		require
			the_conference_exists:the_conference /= Void
			errors_exists:errors/=Void
		local
			index:INTEGER --index for the building combo boxes
			not_applicable:BOOLEAN
			temp_date:DATE
			form:HTML_FORM
			e:HTML_UNORDERED_LIST
			i_1, i_2, i_3, i_4, i_5:HTML_FORM_INPUT
			i_6, i_7, i_8, i_9, i_10:HTML_FORM_INPUT
			html_page : HTML_PAGE --- depreciated!
		do
			Result := create {HTML_TEMPLATE}.make
			-- Add the <title> tag
			Result.put_title ("Informatics Europe: Event submission page")
			--add the CSS
			Result.put_link_css(css_path)
			Result.content_header.put_h2 ("Event submission details")
			--Add the errors info
			if  NOT errors.is_empty then
				Result.content_middle.put_paragraph ("Please check the following:")
				from
					errors.start
					create e.make
					e.add_class ("style10")
				until
					errors.after
				loop
					e.add_element (errors.item_for_iteration)
					errors.forth
				end
				Result.content_middle.put_html(e.out)
			end
			--Add the form start
			create form.make
			form.set_action (form_action)
			form.set_method ("post")
			--Add hidden field for conference id
			create i_1.make
			i_1.set_type ("hidden")
			i_1.set_name ("id")
			i_1.set_value (the_conference.id.out)
			form.add_option (i_1.out)
			--Add a message
			html_page.add_html_code ("<tr><td><br><br><br><br><br>%N<div align=%"justify%"><p>If your event is accepted for inclusion, it will appear within 1 to 3 working days.</p>")
			html_page.add_html_code ("<p>Note: <b> there is no simple way to update information once it has been submitted</b>. Make sure to enter all the information in final form.</p></div>%N</td>%N</tr>")
			--Add conference name
			html_page.add_html_code ("<tr>%N<td><table border=%"0%"><tr>%N<td><br><span class=%"heading2%">REQUIRED INFORMATION:</span><br><br></td></tr>%N")
			html_page.add_html_code ("<tr>%N<td colspan=%"2%"><span class=%"heading2%">Event name (as it should appear in the roster):&nbsp;</span><input type=%"text%" name=%"conference_name%" value=%""+the_conference.name+"%" size=%"50%"><br><br>%N</td>%N</tr>%N")
			--Add starting date
			html_page.add_html_code ("<tr>%N<td colspan=%"2%"><span class=%"heading2%">Starting date (dd/mm/yyyy):&nbsp;</span>%N<select name=%"start_date_day%">%N")
			from
				index:=1
			until
				index>days.count
			loop
				if the_conference.starting_date.day.out.is_equal(days[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"start_date_month%">%N")
			from
				index:=1
			until
				index>months.count
			loop
				if the_conference.starting_date.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"start_date_year%">%N")
			from
				index:=1
			until
				index>years.count
			loop
				if the_conference.starting_date.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select>&nbsp;%N")
			--Add ending date
			html_page.add_html_code ("<span class=%"heading2%">Ending date (dd/mm/yyyy):&nbsp;</span>%N<select name=%"end_date_day%">%N")
			from
				index:=1
			until
				index>days.count
			loop
				if the_conference.ending_date.day.out.is_equal(days[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"end_date_month%">%N")
			from
				index:=1
			until
				index>months.count
			loop
				if the_conference.ending_date.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"end_date_year%">%N")
			from
				index:=1
			until
				index>years.count
			loop
				if the_conference.ending_date.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select></td>%N</tr>")
			--Add city and country
			html_page.add_html_code ("<tr>%N<td><br>%N<span class=%"heading2%">City:&nbsp;</span><input type=%"text%" name=%"conference_city%" value=%""+the_conference.city+"%">%N")
			html_page.add_html_code ("</td><td><br>%N<span class=%"heading2%">Country:&nbsp;</span>")
			--Add select box with all 192 UN Countries + default
			html_page.add_html_code ("<select name=%"conference_country%"%N>")
			from
				index:=0
			until
				index>=countries.count
			loop
				if the_conference.country.is_equal(countries[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+countries[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+countries[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select></td>%N</tr>")
			create temp_date.make_day_month_year (1, 1, 1111)
			--Add papers submission deadline
			if
				the_conference.papers_submission_deadline.is_equal (temp_date)
			then
				not_applicable:=true
			end
			html_page.add_html_code ("<tr>%N<td colspan=%"2%"><br>%N<span class=%"heading2%">Papers submission deadline (dd/mm/yyyy):&nbsp;</span><select name=%"paper_sub_deadline_day%">%N")
			from
				index:=1
			until
				index>days.count-1
			loop
				if the_conference.papers_submission_deadline.day.out.is_equal(days[index]) then
						html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+days[days.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+days[days.count]+"</option>")
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"paper_sub_deadline_month%">%N")
			from
				index:=1
			until
				index>months.count-1
			loop
				if the_conference.papers_submission_deadline.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+months[months.count]+"</option>")
			else
					html_page.add_html_code ("%N<option>"+months[months.count]+"</option>")
			end
			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"paper_sub_deadline_year%">%N")
			from
				index:=1
			until
				index>years.count-1
			loop
				if the_conference.papers_submission_deadline.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+years[years.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+years[years.count]+"</option>")
			end
			html_page.add_html_code ("</select>&nbsp;(for other deadlines see below)</td>%N</tr>%N")

			--Add main sponsor
			html_page.add_html_code ("<tr>%N<td><br>%N<span class=%"heading2%">Main sponsor:&nbsp;</span><input type=%"text%" name=%"main_sponsor%" size=%"55%" value=%""+the_conference.main_sponsor+"%">%N</td>")
			--Add conference url
			html_page.add_html_code ("<td>%N<br><span class=%"heading2%">Conference url:&nbsp;</span><input type=%"text%" name=%"conference_url%" size=%"35%" value=%""+the_conference.url+"%">%N</td>%N</tr>%N")
			--Add contact data
			html_page.add_html_code ("<tr><td colspan=%"2%"><br>%N<span class=%"heading2%">Contact name:&nbsp;</span><input type=%"text%" name=%"contact_name%" value=%""+the_conference.contact_name+"%">")
			html_page.add_html_code ("%N<span class=%"heading2%">Contact email:&nbsp;</span><input type=%"text%" name=%"contact_email%" value=%""+the_conference.contact_email+"%">")
			html_page.add_html_code ("%N<span class=%"heading2%">Contact role:</span>")
			html_page.add_html_code ("%N<select name=%"contact_role%">%N")
			from
				index:=1
			until
				index>contact_roles.count
			loop
				if the_conference.contact_role.is_equal(contact_roles[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+contact_roles[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+contact_roles[index]+"</option>")
				end
				index:=index+1
			end
			html_page.add_html_code ("</select></td>%N</tr>")
			html_page.add_html_code ("<tr><td colspan=%"2%"><hr></td></tr>")
			--Add optional information section: keywords and additional sponsors
			html_page.add_html_code ("<tr><td colspan=%"2%"><span class=%"heading2%">OPTIONAL INFORMATION:</span><br><br></td>%N</tr>%N")
			html_page.add_html_code ("<tr>%N<td><span class=%"heading2%">Keywords:&nbsp;</span></td><td><span class=%"heading2%">Additional sponsors:&nbsp;</span>%N</td>%N</tr>")
			html_page.add_html_code ("<tr>%N<td><input type=%"text%" name=%"keyword1%" size=%"50%" value=%""+the_conference.keywords[1]+"%"></td><td><input type=%"text%" name=%"additional_sponsor_1%" size=%"50%" value=%""+the_conference.additional_sponsors[1]+"%">%N</td>%N</tr>")
			html_page.add_html_code ("<tr>%N<td><input type=%"text%" name=%"keyword2%" size=%"50%" value=%""+the_conference.keywords[2]+"%"></td><td><input type=%"text%" name=%"additional_sponsor_2%" size=%"50%" value=%""+the_conference.additional_sponsors[2]+"%">%N</td>%N</tr>")
			html_page.add_html_code ("<tr>%N<td><input type=%"text%" name=%"keyword3%" size=%"50%" value=%""+the_conference.keywords[3]+"%"></td><td><input type=%"text%" name=%"additional_sponsor_3%" size=%"50%" value=%""+the_conference.additional_sponsors[3]+"%">%N</td>%N</tr>")
			html_page.add_html_code ("<tr>%N<td><input type=%"text%" name=%"keyword4%" size=%"50%" value=%""+the_conference.keywords[4]+"%"></td><td><input type=%"text%" name=%"additional_sponsor_4%" size=%"50%" value=%""+the_conference.additional_sponsors[4]+"%">%N</td>%N</tr>")
			html_page.add_html_code ("<tr>%N<td><input type=%"text%" name=%"keyword5%" size=%"50%" value=%""+the_conference.keywords[5]+"%"></td><td><input type=%"text%" name=%"additional_sponsor_5%" size=%"50%" value=%""+the_conference.additional_sponsors[5]+"%">%N</td>%N</tr>")
			--Add short description
			html_page.add_html_code ("<tr><td WIDTH=%"1024%" ALIGN=%"left%"><span class=%"heading2%">Short event description:&nbsp;</span><br><textarea rows=%"10%" cols=%"50%" name=%"short_description%">"+ the_conference.short_description+"</textarea><br>%N</td>%N")
			--Add additional notes
			html_page.add_html_code ("<td WIDTH=%"1024%" ALIGN=%"left%"><span class=%"heading2%">Additional notes:&nbsp;</span><br><textarea rows=%"10%" cols=%"50%" name=%"additional_notes%">"+ the_conference.additional_notes+"</textarea><br>%N</td></tr>%N")
			--Add conference chairs
			html_page.add_html_code ("<tr><td><br><span class=%"heading2%">Event chair 1:&nbsp;</span><input type=%"text%" name=%"conference_chair_1%" value=%""+the_conference.conference_chair_1+"%"></td>%N<td>%N")
			html_page.add_html_code ("<br><span class=%"heading2%">Event chair 2:&nbsp;</span><input type=%"text%" name=%"conference_chair_2%" value=%""+the_conference.conference_chair_2+"%">%N</td>%N</tr>%N")
			--Add pc chairs
			html_page.add_html_code ("<tr><td><br><span class=%"heading2%">Program committee chair 1:&nbsp;</span><input type=%"text%" name=%"pc_chair_1%" value=%""+the_conference.program_committee_chair_1+"%"></td>%N<td>%N")
			html_page.add_html_code ("<br><span class=%"heading2%">Program committee chair 2:&nbsp;</span><input type=%"text%" name=%"pc_chair_2%" value=%""+the_conference.program_committee_chair_2+"%">%N</td>%N</tr>%N")
			--Add organizing chair
			html_page.add_html_code ("<tr><td colspan=%"2%"><br><span class=%"heading2%">Organizing chair:&nbsp;</span><input type=%"text%" name=%"organizing_chair%" value=%""+the_conference.organizing_chair+"%">%N</td>%N</tr>%N")
			--Add proceedings info and proceedings publisher
			if the_conference.proceedings_at_conference then
				html_page.add_html_code ("<tr><td><br><span class=%"heading2%">Proceedings: at conference</span><input type=%"radio%" name=%"conference_proceedings%" value=%"at_conference%" checked=%"checked%"><span class=%"heading2%">&nbsp;post conference</span><input type=%"radio%" name=%"conference_proceedings%" value=%"post_conference%"></td>")
			else
				html_page.add_html_code ("<tr><td><br><span class=%"heading2%">Proceedings: at conference</span><input type=%"radio%" name=%"conference_proceedings%" value=%"at_conference%"><span class=%"heading2%">Post conference</span><input type=%"radio%" name=%"conference_proceedings%" value=%"post_conference%" checked=%"checked%"></td>")
			end
			html_page.add_html_code ("<td><br><span class=%"heading2%">Proceedings Publisher:&nbsp;</span><input type=%"text%" name=%"proceedings_publisher%" value=%""+the_conference.proceedings_publisher+"%">%N</td>%N</tr>%N")
			--Add 3 additional deadlines
			if
				the_conference.additional_deadline_1.is_equal (temp_date)
			then
				not_applicable:=True
			else
				not_applicable:=False
			end
			html_page.add_html_code ("<tr>%N<td><br>%N<span class=%"heading2%">Other deadline (dd/mm/yyyy):&nbsp;</span><select name=%"additional_deadline_1_day%">%N")
			from
				index:=1
			until
				index>days.count-1
			loop
				if the_conference.additional_deadline_1.day.out.is_equal(days[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+days[days.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+days[days.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_1_month%">%N")
			from
				index:=1
			until
				index>months.count-1
			loop
				if the_conference.additional_deadline_1.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+months[months.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+months[months.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_1_year%">%N")
			from
				index:=1
			until
				index>years.count-1
			loop
				if the_conference.additional_deadline_1.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+years[years.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+years[years.count]+"</option>")
			end
			html_page.add_html_code ("</select>&nbsp;%N")

			html_page.add_html_code ("</td><td><br><span class=%"heading2%">Deadline for:&nbsp;</span><input type=%"text%" name=%"additional_deadline_specification_1%" value=%""+the_conference.additional_deadline_specification_1+"%">%N</td>%N</tr>%N")

			if
				the_conference.additional_deadline_2.is_equal (temp_date)
			then
				not_applicable:=True
			else
				not_applicable:=False
			end

			html_page.add_html_code ("<tr>%N<td><br>%N<span class=%"heading2%">Other deadline (dd/mm/yyyy):&nbsp;</span><select name=%"additional_deadline_2_day%">%N")
			from
				index:=1
			until
				index>days.count-1
			loop
				if the_conference.additional_deadline_2.day.out.is_equal(days[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+days[days.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+days[days.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_2_month%">%N")
			from
				index:=1
			until
				index>months.count-1
			loop
				if the_conference.additional_deadline_2.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+months[months.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+months[months.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_2_year%">%N")
			from
				index:=1
			until
				index>years.count-1
			loop
				if the_conference.additional_deadline_2.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+years[years.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+years[years.count]+"</option>")
			end

			html_page.add_html_code ("</select>&nbsp;%N")
			html_page.add_html_code ("</td><td><br><span class=%"heading2%">Deadline for:&nbsp;</span><input type=%"text%" name=%"additional_deadline_specification_2%" value=%""+the_conference.additional_deadline_specification_2+"%">%N</td>%N</tr>%N")

			if
				the_conference.additional_deadline_3.is_equal (temp_date)
			then
				not_applicable:=True
			else
				not_applicable:=False
			end

			html_page.add_html_code ("<tr>%N<td><br>%N<span class=%"heading2%">Other deadline (dd/mm/yyyy):&nbsp;</span><select name=%"additional_deadline_3_day%">%N")
			from
				index:=1
			until
				index>days.count-1
			loop
				if the_conference.additional_deadline_3.day.out.is_equal(days[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+days[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+days[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+days[days.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+days[days.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_3_month%">%N")
			from
				index:=1
			until
				index>months.count-1
			loop
				if the_conference.additional_deadline_3.month.out.is_equal(months[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+months[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+months[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+months[months.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+months[months.count]+"</option>")
			end

			html_page.add_html_code ("</select>/%N")

			html_page.add_html_code ("%N<select name=%"additional_deadline_3_year%">%N")
			from
				index:=1
			until
				index>years.count-1
			loop
				if the_conference.additional_deadline_3.year.out.is_equal(years[index]) then
					html_page.add_html_code ("%N<option selected=%"selected%">"+years[index]+"</option>")
				else
					html_page.add_html_code ("%N<option>"+years[index]+"</option>")
				end
				index:=index+1
			end
			if not_applicable then
				html_page.add_html_code ("%N<option selected=%"selected%">"+years[years.count]+"</option>")
			else
				html_page.add_html_code ("%N<option>"+years[years.count]+"</option>")
			end

			html_page.add_html_code ("</select>&nbsp;%N")
			html_page.add_html_code ("</td><td><br><span class=%"heading2%">Deadline for:&nbsp;</span><input type=%"text%" name=%"additional_deadline_specification_3%" value=%""+the_conference.additional_deadline_specification_3+"%">%N</td>%N</tr>%N")

			-- Add buttons
			html_page.add_html_code ("%N<tr>%N<td align=%"center%" colspan=%"2%"><br><br><br><INPUT type=%"submit%" name=%"generic_button%" value=%"Confirm submission%">%N</td></tr>")
			--Add the footer
			html_page.add_html_code ("<tr><td align=%"center%" colspan=%"2%"><br><br><br><br><br><br><br><br><br>%N")
			html_page.add_html_code (get_footer+"</td></tr>")
			--Add the tables end
			html_page.add_html_code ("</td>%N</tr>%N</table>%N</td>%N</tr>%N</table>%N")
			--Add the form end
			html_page.add_html_code ("</FORM></BODY>%N")
			--Result:=html_page

			ensure
				page_created:Result /=Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_conference_list_page(the_conference_list:CONFERENCE_LIST): VIEW_HTML
			--This page shows to a user the accepted event list, the hyperlinks to the different event details and to the event submission page
		require
			conference_list_exists:the_conference_list /= Void
		local
			html_page:HTML_PAGE
			html_table_conferences_data:HTML_TABLE
		do
			Result := create {HTML_TEMPLATE}.make
			create html_page.make
			-- Add the <title> tag
			Result.put_title("Informatics Europe: Event List Page")
			--add the CSS
			Result.put_link_css (css_path)
			--Add the user general info
			Result.content_middle.put_paragraph("This page is a repository of conferences and other events in "+emphasize("computer science")+", "+emphasize("information technology")+" and related fields. Events from any country are eligible.")
			Result.content_middle.put_paragraph("You can sort data by event name, date, country or deadline by clicking the "+image(Img_path+"UpTriangle.gif", "")+" symbol in the corresponding column header.")
			Result.content_middle.put_paragraph("To submit an event for inclusion go to the "+link_to(Submission_link, "submission page")+" and be sure to observe the criteria for inclusion. All submissions are reviewed; inclusion is at the discretion of the site's editors.")
			Result.content_middle.put_h2("Current and recent events")
			--Add the container table conferences list info row
			-- Prepare and add the table with the conferences list info
			html_table_conferences_data:=prepare_html_conference_list_table (the_conference_list)
			Result.content_middle.put_html(html_table_conferences_data.out)

			ensure
				page_created: Result /=Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_login_page (errors:HASH_TABLE[STRING,STRING]): VIEW_HTML
			--builds the login page
		require
			errors_exists:errors/=Void
		local
			ul:HTML_UNORDERED_LIST
			um:HTML_UNORDERED_LIST
			form, f2:HTML_FORM
			i1, i2, i3, i4:HTML_FORM_INPUT
		do
			Result := create {HTML_TEMPLATE}.make
			-- Add the <title> tag
			Result.put_title("Informatics Europe: Submission Page")
			--add the CSS
			Result.put_link_css (css_path)
			Result.content_header.put_h2 ("Event submission")
			--Add the general info
			Result.content_middle.put_h2 ("Criteria")
			Result.content_middle.put_paragraph ("All event submissions are subject to review by the editors of this site; inclusion is at their sole discretion.")
			Result.content_middle.put_paragraph("Criteria include:")
			create ul.make
			ul.add_class ("style11")
			ul.add_element("The event's topic must be in computer science, information technology or a neighboring field.")
			ul.add_element("The event must have a strong technical content and a transparent selection process. Purely commercial events are not eligible.")
			ul.add_element("It must be sponsored by a recognized institution.")
			Result.content_middle.put_html (ul.out)
			Result.content_middle.put_paragraph ("Regularly offered courses are not eligible, but specific educational events such as summer schools may be included if they have an advanced scientific content.")
			Result.content_middle.put_h2 ("Submission")
			Result.content_middle.put_paragraph ("If you are not a registered user please register first (see below).")
			Result.content_middle.put_paragraph ("If you are a registered user and want to submit a conference proposal, fill in your user id and password below, and click &quot;Submit event&quot;:")
			if  NOT errors.is_empty then
				--Add the errors info
				Result.content_middle.put_paragraph ("Please check the following:")
				from
					errors.start
					create um.make
					um.add_class ("style10")
				until
					errors.after
				loop
					um.add_element (errors.item_for_iteration)
					errors.forth
				end
				Result.content_middle.put_html (um.out)
			end
			--Add the form start
			create form.make
			form.set_action (form_action)
			form.set_method ("post")
			--	 Add userid and password textfields and submit conference proposal button
			create i1.make
			i1.set_type ("text")
			i1.set_name ("userid")
			i1.set_size (20)
			form.add_option (strong("User id:")+i1.out)
			create i2.make
			i2.set_type ("password")
			i2.set_name ("password")
			i2.set_size (20)
			form.add_option (strong("Password:")+i2.out)
			create i3.make
			i3.set_type ("submit")
			i3.set_name ("generic_button")
			i3.set_value ("Submit event")
			form.add_option (i3.out)
			Result.content_middle.put_html (form.out)
			Result.content_middle.put_paragraph ("If your event is accepted for inclusion, it will appear within 1 to 3 working days.")
			Result.content_middle.put_paragraph ("Note: "+strong("there is no simple way to update information once it has been submitted")+". Make sure to enter all the information in final form.")
			--Add the explanation text for registration
			Result.content_middle.put_h2 ("Registering")
			Result.content_middle.put_paragraph ("To submit an event you must be registered on this site. If you are not yet registered, please click below.")
			Result.content_middle.put_paragraph ("You will be asked for a user id (your email address) and a password, which you can then use to submit an event below.")
			--Add register button
			create f2.make
			f2.set_action (form_action)
			f2.set_method ("post")
			create i4.make
			i4.set_type ("submit")
			i4.set_name ("generic_button")
			i4.set_value ("Register")
			f2.add_option (i4.out)
			Result.content_middle.put_html (f2.out)

			ensure
				page_created: Result /=Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_exit_page(message:STRING): VIEW_HTML
			-- Builds a simple exit page that displays a message that depends on which operation has been consolidated
		require
			message_exists:message/=Void
		local
			button : HTML_FORM_INPUT
			form : HTML_FORM
		do
			Result := create {HTML_TEMPLATE}.make
			-- Add the <title> tag
			Result.put_title ("Informatics Europe: Exit Page")
			--add the CSS
			Result.put_link_css (css_path)
			--Add the exit message
			Result.content_middle.put_paragraph (message)
			--Add the form start
			create form.make
			form.set_action (form_action)
			form.set_method ("post")
			create button.make
			button.set_type ("submit")
			button.set_name ("generic_button")
			button.set_value ("Back to event list")
			form.add_option (button.out)
			Result.content_middle.put_html (form.out)

			ensure
				page_created: Result /=Void
		end

feature {NONE} -- Implementation
-----------------------------------------------------------------------------------------------------------------------
	prepare_html_conference_list_table(the_conference_list:CONFERENCE_LIST):HTML_TABLE
			--helper routine that builds and returns the html table initialized with conferences data
		require
			the_conference_list_exists:the_conference_list /= Void
		local
			a_fake_conference:CONFERENCE
		do
			create a_fake_conference.make
			--creates the table with the right number of rows (+ 1 for the header) and the right number of columns
			create Result.make (the_conference_list.count+1,Conference_list_number_of_columns)
			if the_conference_list.count =0 then
				--adds the header
				Result.add_row (a_fake_conference.user_arrayed_conference_metadata)
			else
				--takes the first conference of the list and read the metadata
				the_conference_list.start
				--adds the header
				Result.add_row (the_conference_list.item.user_arrayed_conference_metadata)
				from
					the_conference_list.start
				until
					the_conference_list.after
				loop
					Result.add_row (the_conference_list.item.user_arrayed_conference_data)
					the_conference_list.forth
				end
			end
			Result.set_border (1)

			ensure
				table_created:Result /=Void
		end


invariant
	invariant_clause: True -- Your invariant here

end
