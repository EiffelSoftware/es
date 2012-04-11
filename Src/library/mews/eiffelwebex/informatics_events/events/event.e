indexing
	description: "Objects that represent a event"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	EVENT

inherit
	APPLICATION_CONSTANTS
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
	event_status: INTEGER -- See the State Pattern (GoF) for a more flexible and complex solution, in this case not needed in my opinion
	proceeding_type: STRING
	proceedings_publisher: STRING
	additional_deadline_1:DATE
	additional_deadline_2:DATE
	additional_deadline_3:DATE
	additional_deadline_specification_1:STRING
	additional_deadline_specification_2:STRING
	additional_deadline_specification_3:STRING
	additional_notes:STRING
	id: NATURAL_64 --conference unique id

	submitted_by: STRING

feature -- default creation
	make
		local
			index:INTEGER
		do
			name:=""
			create starting_date.make_day_month_year (1,1,1111) -- initialize with '1111.1.1' as default, indicates that no input has been made
			create ending_date.make_day_month_year (1,1,1111)
			city:=""
			country:=""
			create papers_submission_deadline.make_day_month_year (1,1,1111)
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
			event_status:= Proposed
			proceedings_publisher:=""
			create additional_deadline_1.make_day_month_year (1,1,1111)
			create additional_deadline_2.make_day_month_year (1,1,1111)
			create additional_deadline_3.make_day_month_year (1,1,1111)
			additional_deadline_specification_1:=""
			additional_deadline_specification_2:=""
			additional_deadline_specification_3:=""
			additional_notes:=""

			proceeding_type:=""
			submitted_by :=""

		end
-----------------------------------------------------------------------------------------
feature --Redefinitions

		is_equal (other: like Current): BOOLEAN
				--	two events are considered equal is they have the same id
			do
				Result := Current.id = other.id
			end
-----------------------------------------------------------------------------------------
feature -- Status setting

	set_name (a_name: STRING)
			--sets event name
		require
			name_has_meaning: a_name/=Void AND THEN (NOT a_name.is_empty)
		do
			name:=a_name
		ensure
			name_is_set: name=a_name
		end
---------------------------------------------------------------------------------------
	set_starting_date (a_starting_date:DATE)
			--sets event starting date
		require
			starting_date_has_meaning: a_starting_date/=Void
		do
			starting_date:=a_starting_date

		ensure
			starting_date_is_set: starting_date=a_starting_date
		end
---------------------------------------------------------------------------------------
	set_ending_date (an_ending_date:DATE)
			--sets event ending date
		require
			ending_date_has_meaning: an_ending_date/=Void
		do
			ending_date:=an_ending_date

		ensure
			ending_date_is_set: ending_date=an_ending_date
		end
---------------------------------------------------------------------------------------
	set_city (a_city: STRING)
			--sets event city
		require
			city_has_meaning: a_city/=Void AND THEN (NOT a_city.is_empty)
		do
			city:=a_city
		ensure
			city_is_set: city=a_city
		end
---------------------------------------------------------------------------------------
	set_country (a_country: STRING)
			--sets event country
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
			--sets event main sponsor
		require
			main_sponsor_has_meaning: the_main_sponsor/=Void AND THEN (NOT the_main_sponsor.is_empty)
		do
			main_sponsor:=the_main_sponsor
		ensure
			main_sponsor_is_set: main_sponsor=the_main_sponsor
		end
---------------------------------------------------------------------------------------
	set_url (an_url:STRING)
			--sets event url
		require
			url_has_meaning: an_url/=Void AND THEN (NOT an_url.is_empty)
		do
			url:=an_url
		ensure
			url_is_set: url=an_url
		end
---------------------------------------------------------------------------------------
	set_contact_name (a_contact_name: STRING)
			--sets event contact_name
		require
			contact_name_has_meaning: a_contact_name/=Void AND THEN (NOT a_contact_name.is_empty)
		do
			contact_name:=a_contact_name
		ensure
			contact_name_is_set: contact_name=a_contact_name
		end
---------------------------------------------------------------------------------------
	set_contact_email (an_email: STRING)
			--sets event contact email
		require
			contact_email_has_meaning: an_email/=Void AND THEN (NOT an_email.is_empty)
		do
			contact_email:=an_email
		ensure
			contact_email_is_set: contact_email=an_email
		end
---------------------------------------------------------------------------------------
	set_contact_role (a_contact_role: STRING)
			--sets event contact_role
		require
			contact_role_has_meaning: a_contact_role/=Void AND THEN (NOT a_contact_role.is_empty)
		do
			contact_role:=a_contact_role
		ensure
			contact_role_is_set: contact_role=a_contact_role
		end
---------------------------------------------------------------------------------------
	set_keywords (some_keywords:ARRAYED_LIST[STRING])
			--sets event keywords
		do
			keywords:=some_keywords

		ensure
			keywords_are_set: keywords=some_keywords
		end
---------------------------------------------------------------------------------------
	set_additional_sponsors (some_other_sponsors:ARRAYED_LIST[STRING])
			--sets event additional_sponsors
		do
			additional_sponsors:=some_other_sponsors

		ensure
			additional_sponsors_are_set: additional_sponsors=some_other_sponsors
		end
---------------------------------------------------------------------------------------
	set_short_description (a_description: STRING)
			--sets event short description
		do
			short_description:=a_description
		ensure
			country_is_set: short_description=a_description
		end
---------------------------------------------------------------------------------------
	set_conference_chair_1 (a_conference_chair: STRING)
			--sets conference_chair_1
		do
			conference_chair_1:=a_conference_chair
		ensure
			conference_chair_1_is_set: conference_chair_1=a_conference_chair
		end
---------------------------------------------------------------------------------------
	set_conference_chair_2 (a_conference_chair: STRING)
			--sets conference_chair_2
		do
			conference_chair_2:=a_conference_chair
		ensure
			conference_chair_2_is_set: conference_chair_2=a_conference_chair
		end
---------------------------------------------------------------------------------------	
	set_program_committee_chair_1 (a_program_committee_chair: STRING)
			--sets program_committee_chair_1
		do
			program_committee_chair_1:=a_program_committee_chair
		ensure
			program_committee_chair_1_is_set: program_committee_chair_1=a_program_committee_chair
		end
---------------------------------------------------------------------------------------
	set_program_committee_chair_2 (a_program_committee_chair: STRING)
			--sets program_committee_chair_2
		do
			program_committee_chair_2:=a_program_committee_chair
		ensure
			program_committee_chair_2_is_set: program_committee_chair_2=a_program_committee_chair
		end
---------------------------------------------------------------------------------------
	set_organizing_chair (an_organizing_chair: STRING)
			--sets organizing_chair
		do
			organizing_chair:=an_organizing_chair
		ensure
			organizing_chair_is_set: organizing_chair=an_organizing_chair
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_1 (an_additional_deadline:DATE)
			--sets event first additional deadline
		do
			additional_deadline_1:=an_additional_deadline
		ensure
			additional_deadline_1_is_set: additional_deadline_1=an_additional_deadline
		end
---------------------------------------------------------------------------------------
	set_additional_deadline_2 (an_additional_deadline:DATE)
			--sets event second additional deadline
		do
			additional_deadline_2:=an_additional_deadline
		ensure
			additional_deadline_2_is_set: additional_deadline_2=an_additional_deadline
		end
---------------------------------------------------------------------------------------
	set_additional_deadline_3 (an_additional_deadline:DATE)
			--sets event third additional deadline
		do
			additional_deadline_3:=an_additional_deadline
		ensure
			additional_deadline_3_is_set: additional_deadline_3=an_additional_deadline
		end
-----------------------------------------------------------------------------------------
	set_additional_deadline_specification_1 (an_additional_deadline_specification: STRING)
			--sets first additional_deadline_specification
		do
			additional_deadline_specification_1:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_1_is_set: additional_deadline_specification_1=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_specification_2 (an_additional_deadline_specification: STRING)
			--sets second additional_deadline_specification
		do
			additional_deadline_specification_2:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_2_is_set: additional_deadline_specification_2=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_deadline_specification_3 (an_additional_deadline_specification: STRING)
			--sets third additional_deadline_specification
		do
			additional_deadline_specification_3:=an_additional_deadline_specification
		ensure
			additional_deadline_specification_3_is_set: additional_deadline_specification_3=an_additional_deadline_specification
		end
---------------------------------------------------------------------------------------	
	set_additional_notes (some_additional_notes: STRING)
			--sets third additional_deadline_specification
		do
			additional_notes:=some_additional_notes
		ensure
			additional_notes_are_set: additional_notes=some_additional_notes
		end
---------------------------------------------------------------------------------------	
	set_status (a_status: INTEGER)
		--sets event status of approval
		do
			event_status:=a_status
		ensure
			status_of_approval_is_set: event_status=a_status
		end
---------------------------------------------------------------------------------------	
	set_proceeding_type (a_type: STRING)
			--sets conference proceedings to be at conference (True) or post conference (False)
		do
			proceeding_type:=a_type
		ensure
			proceeding_type_is_set: proceeding_type=a_type
		end
---------------------------------------------------------------------------------------			
	set_proceedings_publisher (a_proceedings_publisher: STRING)
			--sets proceedings_publisher name
		do
			proceedings_publisher:=a_proceedings_publisher
		ensure
			proceedings_publisher_is_set: proceedings_publisher=a_proceedings_publisher
		end
----------------------------------------------------------------------------------------
	set_id (an_id: NATURAL_64)
			--sets event id
		require
			an_id_has_meaning: an_id>0
		do
			id:=an_id
		ensure
			id_is_set: id=an_id
		end
----------------------------------------------------------------------------------------
	set_submitter (an_author: STRING)
			--sets author
		do
			submitted_by := an_author
		ensure
			submitter_is_set: submitted_by = an_author
		end
----------------------------------------------------------------------------------------

invariant
	event_id_non_negative: id >= 0
end
