indexing
	description: "Objects that represent a conference"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	CONFERENCE

inherit
	APPLICATION_CONSTANT
	redefine
			is_equal
	end

create
	make

feature -- Access
	name: STRING
	starting_date:DATE
	ending_date: DATE
	city: STRING
	country: STRING
	papers_submission_deadline: DATE
	main_sponsor: STRING
	url: STRING
	contact_name: STRING
	contact_email: STRING
	contact_role: STRING
	keywords: ARRAYED_LIST[STRING]
	additional_sponsors: ARRAYED_LIST[STRING]
	short_description: STRING
	conference_chair_1: STRING
	conference_chair_2: STRING
	program_committee_chair_1: STRING
	program_committee_chair_2: STRING
	organizing_chair: STRING
	status_of_approval: INTEGER -- See the State Pattern (GoF) for a more flexible and complex solution, in this case not needed in my opinion
	proceedings_at_conference: BOOLEAN
	proceedings_publisher: STRING
	additional_deadline_1:DATE
	additional_deadline_2:DATE
	additional_deadline_3:DATE
	additional_deadline_specification_1:STRING
	additional_deadline_specification_2:STRING
	additional_deadline_specification_3:STRING
	additional_notes:STRING
	id: NATURAL_64 --conference unique id

feature -- default creation
	make
		local
			index:INTEGER
		do
			name:=""
			create starting_date.make_now
			create ending_date.make_now
			city:=""
			country:=""
			create papers_submission_deadline.make_now
			main_sponsor:=""
			url:=""
			contact_name:=""
			contact_email:=""
			contact_role:=""
			create keywords.make (5)
			from
				index:=1
			until
				index>5
			loop
				keywords.extend ("")
				index:=index+1
			end
			create additional_sponsors.make (5)
			from
				index:=1
			until
				index>5
			loop
				additional_sponsors.extend ("")
				index:=index+1
			end
			short_description:=""
			conference_chair_1:=""
			conference_chair_2:=""
			program_committee_chair_1:=""
			program_committee_chair_2:=""
			organizing_chair:=""
			status_of_approval:= Undefined
			proceedings_publisher:=""
			create additional_deadline_1.make_now
			create additional_deadline_2.make_now
			create additional_deadline_3.make_now
			additional_deadline_specification_1:=""
			additional_deadline_specification_2:=""
			additional_deadline_specification_3:=""
			additional_notes:=""
		end
-----------------------------------------------------------------------------------------
feature --Redefinitions

		is_equal (other: like Current): BOOLEAN
				--	two conferences are considered equal is they have the same id
			do
				Result := Current.id = other.id
			end
-----------------------------------------------------------------------------------------
feature -- Status setting

	set_name (a_name: STRING)
			--sets conference name
		require
			name_has_meaning: a_name/=Void AND THEN (NOT a_name.is_empty)
		do
			name:=a_name
		ensure
			name_is_set: name=a_name
		end
---------------------------------------------------------------------------------------
	set_starting_date (a_starting_date:DATE)
			--sets conference starting date
		require
			starting_date_has_meaning: a_starting_date/=Void
		do
			starting_date:=a_starting_date

		ensure
			starting_date_is_set: starting_date=a_starting_date
		end
---------------------------------------------------------------------------------------
	set_ending_date (an_ending_date:DATE)
			--sets conference ending date
		require
			ending_date_has_meaning: an_ending_date/=Void
		do
			ending_date:=an_ending_date

		ensure
			ending_date_is_set: ending_date=an_ending_date
		end
---------------------------------------------------------------------------------------
	set_city (a_city: STRING)
			--sets conference city
		require
			city_has_meaning: a_city/=Void AND THEN (NOT a_city.is_empty)
		do
			city:=a_city
		ensure
			city_is_set: city=a_city
		end
---------------------------------------------------------------------------------------
	set_country (a_country: STRING)
			--sets conference country
		require
			country_has_meaning: a_country/=Void AND THEN (NOT a_country.is_empty)
		do
			country:=a_country
		ensure
			country_is_set: country=a_country
		end
---------------------------------------------------------------------------------------
	set_papers_submission_deadline (a_papers_submission_deadline:DATE)
			--sets papers submission deadline
		require
			papers_submission_deadline_has_meaning: a_papers_submission_deadline/=Void
		do
			papers_submission_deadline:=a_papers_submission_deadline

		ensure
			papers_submission_deadline_is_set: papers_submission_deadline=a_papers_submission_deadline
		end
---------------------------------------------------------------------------------------
	set_main_sponsor (the_main_sponsor: STRING)
			--sets conference main sponsor
		require
			main_sponsor_has_meaning: the_main_sponsor/=Void AND THEN (NOT the_main_sponsor.is_empty)
		do
			main_sponsor:=the_main_sponsor
		ensure
			main_sponsor_is_set: main_sponsor=the_main_sponsor
		end
---------------------------------------------------------------------------------------
	set_url (an_url:STRING)
			--sets conference url
		require
			url_has_meaning: an_url/=Void AND THEN (NOT an_url.is_empty)
		do
			url:=an_url
		ensure
			url_is_set: url=an_url
		end
---------------------------------------------------------------------------------------
	set_contact_name (a_contact_name: STRING)
			--sets conference contact_name
		require
			contact_name_has_meaning: a_contact_name/=Void AND THEN (NOT a_contact_name.is_empty)
		do
			contact_name:=a_contact_name
		ensure
			contact_name_is_set: contact_name=a_contact_name
		end
---------------------------------------------------------------------------------------
	set_contact_email (an_email: STRING)
			--sets conference contact email
		require
			contact_email_has_meaning: an_email/=Void AND THEN (NOT an_email.is_empty)
		do
			contact_email:=an_email
		ensure
			contact_email_is_set: contact_email=an_email
		end
---------------------------------------------------------------------------------------
	set_contact_role (a_contact_role: STRING)
			--sets conference contact_role
		require
			contact_role_has_meaning: a_contact_role/=Void AND THEN (NOT a_contact_role.is_empty)
		do
			contact_role:=a_contact_role
		ensure
			contact_role_is_set: contact_role=a_contact_role
		end
---------------------------------------------------------------------------------------
	set_keywords (some_keywords:ARRAYED_LIST[STRING])
			--sets conference keywords
		require
			some_keywords_have_meaning: some_keywords/=Void AND THEN (NOT some_keywords.is_empty)
		do
			keywords:=some_keywords

		ensure
			keywords_are_set: keywords=some_keywords
		end
---------------------------------------------------------------------------------------
	set_additional_sponsors (some_other_sponsors:ARRAYED_LIST[STRING])
			--sets conference additional_sponsors
		require
			some_other_sponsors_have_meaning: some_other_sponsors/=Void AND THEN (NOT some_other_sponsors.is_empty)
		do
			additional_sponsors:=some_other_sponsors

		ensure
			additional_sponsors_are_set: additional_sponsors=some_other_sponsors
		end
---------------------------------------------------------------------------------------
	set_short_description (a_description: STRING)
			--sets conference short description
		require
			description_has_meaning: a_description/=Void AND THEN (NOT a_description.is_empty)
		do
			short_description:=a_description
		ensure
			country_is_set: short_description=a_description
		end
---------------------------------------------------------------------------------------
	set_conference_chair_1 (a_conference_chair: STRING)
			--sets conference_chair_1
		require
			conference_chair_1_has_meaning: a_conference_chair/=Void AND THEN (NOT a_conference_chair.is_empty)
		do
			conference_chair_1:=a_conference_chair
		ensure
			conference_chair_1_is_set: conference_chair_1=a_conference_chair
		end
---------------------------------------------------------------------------------------
	set_conference_chair_2 (a_conference_chair: STRING)
			--sets conference_chair_2
		require
			conference_chair_2_has_meaning: a_conference_chair/=Void AND THEN (NOT a_conference_chair.is_empty)
		do
			conference_chair_2:=a_conference_chair
		ensure
			conference_chair_2_is_set: conference_chair_2=a_conference_chair
		end
---------------------------------------------------------------------------------------	
	set_program_committee_chair_1 (a_program_committee_chair: STRING)
			--sets program_committee_chair_1
		require
			program_committee_chair_1_has_meaning: a_program_committee_chair/=Void AND THEN (NOT a_program_committee_chair.is_empty)
		do
			program_committee_chair_1:=a_program_committee_chair
		ensure
			program_committee_chair_1_is_set: program_committee_chair_1=a_program_committee_chair
		end
---------------------------------------------------------------------------------------
	set_program_committee_chair_2 (a_program_committee_chair: STRING)
			--sets program_committee_chair_2
		require
			program_committee_chair_2_has_meaning: a_program_committee_chair/=Void AND THEN (NOT a_program_committee_chair.is_empty)
		do
			program_committee_chair_2:=a_program_committee_chair
		ensure
			program_committee_chair_2_is_set: program_committee_chair_2=a_program_committee_chair
		end
---------------------------------------------------------------------------------------
	set_organizing_chair (an_organizing_chair: STRING)
			--sets organizing_chair
		require
			organizing_chair_has_meaning: an_organizing_chair/=Void AND THEN (NOT an_organizing_chair.is_empty)
		do
			organizing_chair:=an_organizing_chair
		ensure
			organizing_chair_is_set: organizing_chair=an_organizing_chair
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_1 (an_additional_deadline:DATE)
			--sets conference first additional deadline
		require
			additional_deadline_has_meaning: an_additional_deadline/=Void
		do
			additional_deadline_1:=an_additional_deadline
		ensure
			additional_deadline_1_is_set: additional_deadline_1=an_additional_deadline
		end
---------------------------------------------------------------------------------------
	set_additional_deadline_2 (an_additional_deadline:DATE)
			--sets conference second additional deadline
		require
			additional_deadline_has_meaning: an_additional_deadline/=Void
		do
			additional_deadline_2:=an_additional_deadline
		ensure
			additional_deadline_2_is_set: additional_deadline_2=an_additional_deadline
		end
---------------------------------------------------------------------------------------
	set_additional_deadline_3 (an_additional_deadline:DATE)
			--sets conference third additional deadline
		require
			additional_deadline_has_meaning: an_additional_deadline/=Void
		do
			additional_deadline_3:=an_additional_deadline
		ensure
			additional_deadline_3_is_set: additional_deadline_3=an_additional_deadline
		end
-----------------------------------------------------------------------------------------
	set_additional_deadline_specification_1 (an_additional_deadline_specification: STRING)
			--sets first additional_deadline_specification
		require
			additional_deadline_specification_has_meaning: an_additional_deadline_specification/=Void AND THEN (NOT an_additional_deadline_specification.is_empty)
		do
			additional_deadline_specification_1:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_1_is_set: additional_deadline_specification_1=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_specification_2 (an_additional_deadline_specification: STRING)
			--sets second additional_deadline_specification
		require
			additional_deadline_specification_has_meaning: an_additional_deadline_specification/=Void AND THEN (NOT an_additional_deadline_specification.is_empty)
		do
			additional_deadline_specification_2:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_2_is_set: additional_deadline_specification_2=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_specification_3 (an_additional_deadline_specification: STRING)
			--sets third additional_deadline_specification
		require
			additional_deadline_specification_has_meaning: an_additional_deadline_specification/=Void AND THEN (NOT an_additional_deadline_specification.is_empty)
		do
			additional_deadline_specification_3:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_3_is_set: additional_deadline_specification_3=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_notes (some_additional_notes: STRING)
			--sets third additional_deadline_specification
		require
			some_additional_notes_have_meaning: some_additional_notes/=Void AND THEN (NOT some_additional_notes.is_empty)
		do
			additional_notes:=some_additional_notes
		ensure
			additional_notes_are_set: additional_notes=some_additional_notes
		end
---------------------------------------------------------------------------------------	
	set_state_of_approval (a_status_of_approval: INTEGER)
		--sets conference status of approval
		require
			a_status_of_approval_has_meaning: a_status_of_approval=Accepted OR a_status_of_approval=Proposed OR a_status_of_approval=Rejected OR a_status_of_approval=Delayed OR a_status_of_approval=Undefined

		do
			status_of_approval:=a_status_of_approval
		ensure
			status_of_approval_is_set: status_of_approval=a_status_of_approval
		end
---------------------------------------------------------------------------------------	
	set_proceedings_at_conference (are_proceedings_at_conference: BOOLEAN)
			--sets conference proceedings to be at conference (True) or post conference (False)
		do
			proceedings_at_conference:=are_proceedings_at_conference
		ensure
			proceedings_are_set: proceedings_at_conference=are_proceedings_at_conference
		end
---------------------------------------------------------------------------------------			
	set_proceedings_publisher (a_proceedings_publisher: STRING)
			--sets proceedings_publisher name
		require
			proceedings_publisher_has_meaning: a_proceedings_publisher/=Void AND THEN (NOT a_proceedings_publisher.is_empty)
		do
			proceedings_publisher:=a_proceedings_publisher
		ensure
			proceedings_publisher_is_set: proceedings_publisher=a_proceedings_publisher
		end
----------------------------------------------------------------------------------------
	set_id (an_id: NATURAL_64)
			--sets conference id
		require
			an_id_has_meaning: an_id>0
		do
			id:=an_id
		ensure
			id_is_set: id=an_id
		end
----------------------------------------------------------------------------------------
feature	-- view functions, useful for returning a particular view of the conference

	user_arrayed_conference_data: ARRAY[STRING]
			--returns this conference data as an array of strings: useful for presenting conference data as a line of an html table
		require current_conference_is_accepted: status_of_approval = Accepted

		local
			string_array:ARRAY[STRING]
			temp_date:DATE
		do
			create string_array.make (1,Conference_list_number_of_columns)
			string_array[1]:="<a href=%""+Form_action+"?aindex="
			string_array[1].append (id.out)
			string_array[1].append ("%">"+name+"</a>")
			string_array[2]:=starting_date.formatted_out ("[0]dd/[0]mm/yyyy") + "-" +ending_date.formatted_out ("[0]dd/[0]mm/yyyy")
			--we need the following checks because otherwise the corresponding HTML table cell doesn't display nicely (the cell border is not displayed)
			if  city /= Void then
				city.left_adjust
				city.right_adjust
				if (NOT city.is_empty) then
					string_array[3]:=city
				else
				string_array[3]:="&nbsp;"
				end
			end

			if  country /= Void then
				country.left_adjust
				country.right_adjust
				if (NOT country.is_empty) then
					string_array[4]:=country
				else
				string_array[4]:="&nbsp;"
				end
			end

			create temp_date.make_day_month_year (1, 1, 1111)
			if temp_date.is_equal(papers_submission_deadline) then
				string_array[5]:="n/a"
			else
				string_array[5]:=papers_submission_deadline.formatted_out ("[0]dd/[0]mm/yyyy")
			end
			if  main_sponsor /= Void then
				main_sponsor.left_adjust
				main_sponsor.right_adjust
				if (NOT main_sponsor.is_empty) then
					string_array[6]:=main_sponsor
				else
				string_array[6]:="&nbsp;"
				end
			end

			if  proceedings_publisher /= Void then
				proceedings_publisher.left_adjust
				proceedings_publisher.right_adjust
				if (NOT proceedings_publisher.is_empty) then
					string_array[7]:=proceedings_publisher
				else
				string_array[7]:="&nbsp;"
				end
			end

			Result:=string_array

			ensure
				Result /=Void AND THEN (NOT Result.is_empty)
		end
-----------------------------------------------------------------------------------------------------------------
	admin_arrayed_conference_data: ARRAY[STRING]
			--returns this conference data as an array of strings: useful for presenting conference data as a line of an html table
		local
			string_array:ARRAY[STRING]
			temp_date:DATE
		do
			create string_array.make (1,Conference_list_number_of_columns)
			if status_of_approval = Accepted then
				string_array[1]:="<a href=%""+Form_action_admin+"?aindex="
			elseif status_of_approval = Proposed OR status_of_approval = Delayed then
				string_array[1]:="<a href=%""+Form_action_admin+"?pindex="
			else
				check state_of_conference_not_consistent:False end
			end
			string_array[1].append(id.out)
			string_array[1].append("%">"+name+"</a>")
			string_array[2]:=starting_date.formatted_out ("[0]dd/[0]mm/yyyy") + "-" +ending_date.formatted_out ("[0]dd/[0]mm/yyyy")
			--we need the following checks because otherwise the corresponding HTML table cell doesn't display nicely (the cell border is not displayed)
			if  city /= Void then
				city.left_adjust
				city.right_adjust
				if (NOT city.is_empty) then
					string_array[3]:=city
				else
				string_array[3]:="&nbsp;"
				end
			end

			if  country /= Void then
				country.left_adjust
				country.right_adjust
				if (NOT country.is_empty) then
					string_array[4]:=country
				else
				string_array[4]:="&nbsp;"
				end
			end
			create temp_date.make_day_month_year (1, 1, 1111)
			if temp_date.is_equal(papers_submission_deadline) then
				string_array[5]:="n/a"
			else
				string_array[5]:=papers_submission_deadline.formatted_out ("[0]dd/[0]mm/yyyy")
			end
			if  main_sponsor /= Void then
				main_sponsor.left_adjust
				main_sponsor.right_adjust
				if (NOT main_sponsor.is_empty) then
					string_array[6]:=main_sponsor
				else
				string_array[6]:="&nbsp;"
				end
			end

			if  proceedings_publisher /= Void then
				proceedings_publisher.left_adjust
				proceedings_publisher.right_adjust
				if (NOT proceedings_publisher.is_empty) then
					string_array[7]:=proceedings_publisher
				else
				string_array[7]:="&nbsp;"
				end
			end

			Result:=string_array
			ensure
				Result /=Void AND THEN (NOT Result.is_empty)
		end
-----------------------------------------------------------------------------------------------------------------
	user_arrayed_conference_metadata: ARRAY[STRING]
			--returns this conference metadata as an array of strings: useful for setting up the header of an html table
		require
			status_consistent: status_of_approval = Accepted OR status_of_approval = Undefined
		local
			string_array:ARRAY[STRING]
		do
			create string_array.make (1,Conference_list_number_of_columns)
			string_array[1]:="<span class=%"heading2%">Conference name<a href=%""+Form_action+"?sort=name%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" alt=%"%" /></a></span>"
			string_array[2]:="<span class=%"heading2%">Date<a href=%""+Form_action+"?sort=startdate%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" alt=%"%" /></a></span>"
			string_array[3]:="<span class=%"heading2%">City</span>"
			string_array[4]:="<span class=%"heading2%">Country<a href=%""+Form_action+"?sort=country%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" alt=%"%" /></a></span>"
			string_array[5]:="<span class=%"heading2%">Paper deadline<a href=%""+Form_action+"?sort=papersdeadline%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" alt=%"%" /></a></span>"
			string_array[6]:="<span class=%"heading2%">Main sponsor</span>"
			string_array[Conference_list_number_of_columns]:="<span class=%"heading2%">Publisher</span>"
			Result:=string_array
			ensure
				Result /=Void AND THEN (NOT Result.is_empty)
		end

	admin_arrayed_conference_metadata: ARRAY[STRING]
			--returns this conference metadata as an array of strings: useful for setting up the header of an html table
		local
			string_array:ARRAY[STRING]
		do
			create string_array.make (1,Conference_list_number_of_columns)
			--different hyperlinks will trigger different conference lists
			if status_of_approval = Accepted OR status_of_approval = Undefined then
				string_array[1]:="<span class=%"heading2%">Conference name<a href=%""+Form_action_admin+"?sort=name%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[2]:="<span class=%"heading2%">Date<a href=%""+Form_action_admin+"?sort=startdate%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[3]:="<span class=%"heading2%">City</span>"
				string_array[4]:="<span class=%"heading2%">Country<a href=%""+Form_action_admin+"?sort=country%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[5]:="<span class=%"heading2%">Paper deadline<a href=%""+Form_action_admin+"?sort=papersdeadline%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
			elseif status_of_approval = Proposed OR status_of_approval = Delayed then
				string_array[1]:="<span class=%"heading2%">Conference name<a href=%""+Form_action_admin+"?sort=pname%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[2]:="<span class=%"heading2%">Date<a href=%""+Form_action_admin+"?sort=pstartdate%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[3]:="<span class=%"heading2%">City</span>"
				string_array[4]:="<span class=%"heading2%">Country<a href=%""+Form_action_admin+"?sort=pcountry%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				string_array[5]:="<span class=%"heading2%">Paper deadline<a href=%""+Form_action_admin+"?sort=ppapersdeadline%">"+"<img src=%""+Img_path+"UpTriangle.gif%" height=%"12%" width=%"9%" border=%"0%"/></a></span>"
				else
					check state_of_conference_not_consistent:False end
			end
			string_array[6]:="<span class=%"heading2%">Main sponsor</span>"
			string_array[Conference_list_number_of_columns]:="<span class=%"heading2%">Publisher</span>"
			Result:=string_array
			ensure
				Result /=Void AND THEN (NOT Result.is_empty)
		end

invariant
	conference_id_non_negative: id >= 0
end
