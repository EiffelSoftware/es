indexing
	description: "Objects that provide HTML pages for application"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	ADMIN_HTML_DELEGATE

inherit
	HTML_DELEGATE

create
	make

feature -- page building routines

	build_event_submission_page(the_conference:CONFERENCE; errors:HASH_TABLE[STRING,STRING]):HTML_PAGE
			--This page is displayed when an administrator wants to check a conference proposal
		require
			the_conference_exists:the_conference /= Void
			errors_exists:errors/=Void
		local
			html_page:HTML_PAGE
			index:INTEGER --index for the countries array
			not_applicable: BOOLEAN
			temp_date:DATE
		do
			create html_page.make
			-- Add the <head> and <meta> tags
			html_page.add_html_code ("<HEAD>"+get_meta_tag)
			-- Add the <title> tag
			html_page.add_html_code ("<TITLE>Informatics Europe: Event submission page</TITLE>%N")
			--add the CSS
			html_page.add_html_code (get_css)
			html_page.add_html_code ("</HEAD><BODY>")
			--Add the form start
			html_page.add_html_code ("<FORM action=%""+form_action_admin+"%" method=%"POST%">%N")
			--Add the container table, the logo and the title
			html_page.add_html_code ("<table width=%"1024%" border=%"0%" cellspacing=%"0%" cellpadding=%"0%">%N<tbody>")
			html_page.add_html_code ("<tr>%N<td width=%"1024%" align=%"left%" valign=%"top%">%N")
			html_page.add_html_code ("<table align=%"left%" border=%"0%" cellpadding=%"0%" cellspacing=%"2%" width=%"98%%%"><tbody>")
			html_page.add_html_code ("%N<tr><td>&nbsp;</td><td width=%"15%">&nbsp;</td><td>&nbsp;</td></tr>%N")
			html_page.add_html_code ("<tr><td width=%"100%"><table><tr><td><a href=%"http://www.informatics-europe.org%">"+get_logo+ "</a></td></tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N</table>%N</td>")
			html_page.add_html_code ("%N<td>&nbsp;</td><td width=%"700%" valign=%"center%">"+ get_common_header+"</td></tr>")
			html_page.add_html_code ("<tr><td>&nbsp;</td><td>&nbsp;</td><td><div><p><span class=%"style2%">Event submission details</span></p></div>%N")
			html_page.add_html_code ("</td>%N</tr>%N</tbody>%N</table>%N")
			--Add hidden field for conference id
			html_page.add_html_code ("<tr><td><INPUT TYPE=HIDDEN NAME=%"id%" value=%""+the_conference.id.out+"%">")
			html_page.add_html_code ("</td>%N</tr>%N")
			if  NOT errors.is_empty then
				--Add the errors info
				html_page.add_html_code ("<tr>%N<td>%N")
				html_page.add_html_code ("<span class=%"style10%">Please check the following:</span><BR>%N")
				from
					errors.start
					html_page.add_html_code ("<ul class=%"style10%">")
				until
					errors.after
				loop
					html_page.add_html_code ("<li>")
					html_page.add_html_code (errors.item_for_iteration)
					html_page.add_html_code ("</li>")
					html_page.add_html_code ("%N<BR>")
					errors.forth
				end
				html_page.add_html_code ("</ul>")
				html_page.add_html_code ("<br>%N")
				html_page.add_html_code ("</td>%N</tr>%N")
			end
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
			html_page.add_html_code("%N<tr>%N<td align=%"center%" colspan=%"2%">")
			if the_conference.status_of_approval=Proposed OR the_conference.status_of_approval=Delayed then
				-- Add admin buttons
				html_page.add_html_code("<br><br><br><INPUT type=%"submit%" name=%"generic_button%" value=%"Accept%"><INPUT type=%"submit%" name=%"generic_button%" value=%"Reject%">%N<INPUT type=%"submit%" name=%"generic_button%" value=%"Defer%">%N")
			elseif the_conference.status_of_approval=Accepted then
				-- Add Update, Move to past events and Delete buttons	
				html_page.add_html_code("<br><br><br><INPUT type=%"submit%" name=%"generic_button%" value=%"Update%">%N")
			else
				check conference_state_of_approval_not_consistent:False end
			end
			--Add the footer
			html_page.add_html_code ("<tr><td align=%"center%" colspan=%"2%"><br><br><br><br><br><br><br><br><br>%N")
			html_page.add_html_code (get_footer+"</td></tr>")
			--Add the tables end
			html_page.add_html_code ("</td>%N</tr>%N</table>%N</td>%N</tr>%N</table>%N")
			--Add the form end
			html_page.add_html_code ("</FORM></BODY>%N")
			Result:=html_page

			ensure
				page_created:Result /=Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_conference_list_admin_page(the_proposed_conference_list, the_accepted_conference_list:CONFERENCE_LIST): HTML_PAGE
			--This page is displayed when the administrator logs in; shows two lists:
	--1) The proposed and deferred (delayed) conference list, with hyperlinks for details
	--2) The accepted conference list, with hyperlinks for details
		require
			the_proposed_conference_list_exists:the_proposed_conference_list /= Void
			the_accepted_conference_list_exists:the_accepted_conference_list /= Void
		local
			html_page:HTML_PAGE
			html_table_conferences_data:HTML_TABLE
		do
			create html_page.make
			-- Add the <head> and <meta> tags
			html_page.add_html_code ("<HEAD>"+get_meta_tag)
			-- Add the <title> tag
			html_page.add_html_code ("<TITLE>Informatics Europe: Event List Page</TITLE>%N")
			--add the CSS
			html_page.add_html_code (get_css)
			html_page.add_html_code ("</HEAD><BODY>")
			--Add the form start
			html_page.add_html_code ("<FORM action=%""+form_action_admin+"%" method=%"POST%">%N")
			--Add the container table, the logo and the title
			html_page.add_html_code ("<table width=%"1024%" border=%"0%" cellspacing=%"0%" cellpadding=%"0%">%N<tbody>")
			html_page.add_html_code ("<tr>%N<td width=%"1024%" align=%"left%" valign=%"top%">%N")
			html_page.add_html_code ("<table align=%"left%" border=%"0%" cellpadding=%"0%" cellspacing=%"2%" width=%"98%%%"><tbody>")
			html_page.add_html_code ("%N<tr><td>&nbsp;</td><td width=%"15%">&nbsp;</td><td>&nbsp;</td></tr>%N")
			html_page.add_html_code ("<tr><td width=%"100%"><table><tr><td><a href=%"http://www.informatics-europe.org%">"+get_logo+ "</a></td></tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N</table>%N</td>")
			html_page.add_html_code ("%N<td>&nbsp;</td><td width=%"700%" valign=%"center%">"+ get_common_header+"</td></tr>")
			html_page.add_html_code ("%N</tbody>%N</table>%N")
			html_page.add_html_code ("<br><br><br><br><br><br><br><br><br>%N</td>%N</tr>%N")
			--Add the administrator general info
			html_page.add_html_code ("<tr>%N<td width=%"1024%" valign=%"top%">%N")
			html_page.add_html_code("&nbsp;<p>This page contains two lists: the <i>proposed/deferred event list</i> and the<i> accepted event list</i>.</p>")
			html_page.add_html_code("<p> By clicking on an hyperlink you can have access to the event details page where you can perform actions on the event itself.</p>%N")
			html_page.add_html_code("<h2>Proposed and deferred event list; current and recent events<br></h2>%N</td>%N</tr>%N")
			--Add the container table conferences list info row
			html_page.add_html_code ("<tr>%N<td width=%"1024%" valign=%"top%">%N")
			-- Prepare and add the table with the proposed/deferred conferences list info
			html_table_conferences_data:=prepare_html_conference_list_table (the_proposed_conference_list)
			html_page.add_html_code (html_table_conferences_data.out)
			html_page.add_html_code ("<tr>%N<td width=%"1024%" valign=%"top%"><br><br><br><br>%N")
			html_page.add_html_code("<h2>Accepted event list; current and recent events<br></h2>%N</td>%N</tr>%N")
			--Add the container table conferences list info row
			html_page.add_html_code ("<tr>%N<td width=%"1024%" valign=%"top%">%N")
			-- Prepare and add the table with the accepted conferences list info
			html_table_conferences_data:=prepare_html_conference_list_table (the_accepted_conference_list)
			html_page.add_html_code (html_table_conferences_data.out)
			--Add the footer
			html_page.add_html_code ("<tr><td align=%"center%"><br><br><br><br><br><br><br><br><br>%N")
			html_page.add_html_code (get_footer+"</td></tr>")
			--Add the container table end
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("%N</tbody></table>%N")
			--Add the form end
			html_page.add_html_code("</FORM></BODY>%N")
			Result:=html_page

			ensure
				page_created: Result /=Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_login_page(errors:HASH_TABLE[STRING,STRING]): HTML_PAGE
			--This page is the login page, valid for both user and administrator login
		require
			errors_exists:errors/=Void
		local
			html_page:HTML_PAGE
		do
			create html_page.make
			-- Add the <head> and <meta> tags
			html_page.add_html_code ("<HEAD>"+get_meta_tag)
			-- Add the <title> tag
			html_page.add_html_code ("<TITLE>Informatics Europe: Administrator login Page</TITLE>%N")
			--add the CSS
			html_page.add_html_code (get_css)
			html_page.add_html_code ("</HEAD><BODY>")
			--Add the form start
			html_page.add_html_code ("<FORM action=%""+form_action_admin+"%" method=%"POST%">%N")
			--Add the container table, the logo and the title
			html_page.add_html_code ("<table width=%"1024%" border=%"0%" cellspacing=%"0%" cellpadding=%"0%">%N<tbody>")
			html_page.add_html_code ("<tr>%N<td width=%"1024%" align=%"left%" valign=%"top%">%N")
			html_page.add_html_code ("<table align=%"left%" border=%"0%" cellpadding=%"0%" cellspacing=%"2%" width=%"98%%%"><tbody>")
			html_page.add_html_code ("%N<tr><td>&nbsp;</td><td width=%"15%">&nbsp;</td><td>&nbsp;</td></tr>%N")
			html_page.add_html_code ("<tr><td width=%"100%"><table><tr><td><a href=%"http://www.informatics-europe.org%">"+get_logo+ "</a></td></tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N</table>%N</td>")
			html_page.add_html_code ("%N<td>&nbsp;</td><td width=%"700%" valign=%"center%">"+ get_common_header+"</td></tr>")
			html_page.add_html_code ("<tr><td>&nbsp;</td><td>&nbsp;</td><td><div><p><span class=%"style2%">Administrator login</span></p></div>%N")
			html_page.add_html_code ("</td>%N</tr>%N</tbody>%N</table>%N")
			html_page.add_html_code ("<br><br><br><br><br><br><br><br><br>%N</td>%N</tr>%N")
			if  NOT errors.is_empty then
				--Add the errors info
				html_page.add_html_code("<tr><td width=%"1024%" align=%"center%"><span class=%"style10%">Please check the following:</span><BR>%N")
				from
					errors.start
					html_page.add_html_code ("<ul class=%"style10%">")
				until
					errors.after
				loop
					html_page.add_html_code ("<li>")
					html_page.add_html_code (errors.item_for_iteration)
					html_page.add_html_code ("</li>")
					html_page.add_html_code ("%N<BR>")
					errors.forth
				end
				html_page.add_html_code ("</ul>")
				html_page.add_html_code("</td></tr>%N")
			end
		--	 Add userid and password textfields and submit conference proposal button
			html_page.add_html_code ("<tr><td align=%"center%"><br><br><br><br><br><br><br><br><br>%N<p><span class=%"heading2%">User id: </span><INPUT type=%"text%" name=%"userid%" size=%"20%">%N")
			html_page.add_html_code ("<span class=%"heading2%">Password</span><INPUT type=%"password%" name=%"password%" size=%"20%">%N")
			html_page.add_html_code ("<INPUT type=%"submit%" name=%"generic_button%" value=%"Login%"></p>%N")
			--Add the footer
			html_page.add_html_code ("<tr><td><br><br><br><br><br><br><br><br><br>%N")
			html_page.add_html_code (get_footer+"</td></tr>")
			--Add the container table end
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("<tr><td align=%"left%">&nbsp;</td></tr>")
			html_page.add_html_code ("%N</tbody></table>%N")
			--Add the form end
			html_page.add_html_code("</FORM></BODY>%N")
			Result:=html_page

			ensure
				page_created: Result /= Void
		end
-----------------------------------------------------------------------------------------------------------------------
	build_exit_page(message:STRING): HTML_PAGE
	--This is a simple exit page that displays a message that depends on which operation has been consolidated
		require
			message_exists:message/=Void
		local
			html_page:HTML_PAGE
		do
			create html_page.make
			-- Add the <head> and <meta> tags
			html_page.add_html_code ("<HEAD>"+get_meta_tag)
			-- Add the <title> tag
			html_page.add_html_code ("<TITLE>Informatics Europe: Exit Page</TITLE>%N")
			--add the CSS
			html_page.add_html_code (get_css)
			html_page.add_html_code ("</HEAD><BODY>")
			--Add the form start
			html_page.add_html_code ("<FORM action=%""+Form_action_admin+"%" method=%"POST%">%N")
			--Add the container table, the logo and the title
			html_page.add_html_code ("<table width=%"1024%" border=%"0%" cellspacing=%"0%" cellpadding=%"0%">%N<tbody>")
			html_page.add_html_code ("<tr>%N<td width=%"1024%" align=%"left%" valign=%"top%">%N")
			html_page.add_html_code ("<table align=%"left%" border=%"0%" cellpadding=%"0%" cellspacing=%"2%" width=%"98%%%"><tbody>")
			html_page.add_html_code ("%N<tr><td>&nbsp;</td><td width=%"15%">&nbsp;</td><td>&nbsp;</td></tr>%N")
			html_page.add_html_code ("<tr><td width=%"100%"><table><tr><td><a href=%"http://www.informatics-europe.org%">"+get_logo+ "</a></td></tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N<tr>%N<td>&nbsp;</td>%N</tr>%N</table>%N</td>")
			html_page.add_html_code ("%N<td>&nbsp;</td><td width=%"700%" valign=%"center%">"+ get_common_header+"</td></tr>")
			html_page.add_html_code ("<tr><td>&nbsp;</td><td>&nbsp;</td><td><div align=%"left%" class=%"style2%"><p>Exit page</p></div>%N")
			html_page.add_html_code ("</td>%N</tr>%N</tbody>%N</table>%N")
			html_page.add_html_code ("<br><br><br><br><br><br><br><br><br>%N</td>%N</tr>%N")
			--Add the exit message
			html_page.add_html_code ("<tr><td><br><br><br><br><br><br><br><DIV ALIGN=%"CENTER%">"+message+"</DIV>")
			html_page.add_html_code ("<br><br><br><br>%N")
			html_page.add_html_code ("%N</td>%N</tr>")
			--Add the container table button row
			html_page.add_html_code ("%N<tr>%N<td align=%"center%" colspan=%"2%">")
			-- Add button
			html_page.add_html_code ("<INPUT type=%"submit%" name=%"generic_button%" value=%"Back to event list%">%N")
			html_page.add_html_code ("%N</td>%N</tr>")
			--Add the footer
			html_page.add_html_code ("<tr><td><br><br><br><br><br><br><br><br><br>%N")
			html_page.add_html_code (get_footer+"</td></tr>")
			--Add the tables end
			html_page.add_html_code ("</td></tr></table>%N")
			--Add the form end
			html_page.add_html_code("</FORM></BODY>%N")
			Result:=html_page

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
			create Result.make(the_conference_list.count+1,Conference_list_number_of_columns)
			if the_conference_list.count =0 then
				--adds the header
				Result.add_row (a_fake_conference.admin_arrayed_conference_metadata)
			else
				--takes the first conference of the list and reads the metadata
				the_conference_list.start
				--adds the header
				Result.add_row (the_conference_list.item.admin_arrayed_conference_metadata)
				from
					the_conference_list.start
				until
					the_conference_list.after
				loop
					Result.add_row (the_conference_list.item.admin_arrayed_conference_data)
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
