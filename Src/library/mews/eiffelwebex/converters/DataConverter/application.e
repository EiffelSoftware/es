indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	APPLICATION_CONSTANTS

create
	make

feature -- Initialization

	make is
			-- Run application.
		local
			userfile1, file1, file2, file3, idfile1: STRING
			userfile, eventfile, idfile: STRING
			conf: CONFERENCE
			conf_dao: CONFERENCE_DAO_FILE_IMPL
			event: EVENT
			event_dao: EVENT_DAO_FILE_IMPL
			user1: USER
			user1_dao: USER_DAO_FILE_IMPL
			user2: MID_USER
			user2_dao: MID_USER_DAO_FILE_IMPL

			conf_list: CONFERENCE_LIST
			i, j, k, count1, count2: INTEGER
		do

			-- read original conference data
			create conf_dao.make

			-- init new event file
			create event_dao.make ("D:\Li\DataConverter\EIFGENs\dataconverter\W_code\", "events", "events_id")

			-- convert to new format

			-- accepted list

			from i := 1
			until i = 4
			loop
				inspect i
				when  1 then
					conf_list := conf_dao.accepted_conference_list
				when 2 then
					conf_list := conf_dao.proposed_conference_list
				else
					conf_list := conf_dao.rejected_conference_list
				end

				from conf_list.start
				until conf_list.after
				loop
					conf := conf_list.item

					create event.make

					event.set_name (conf.name)
					event.set_starting_date (conf.starting_date)
					event.set_ending_date (conf.ending_date)
					event.set_city (conf.city)
					event.set_country (conf.country)
					event.set_papers_submission_deadline (conf.papers_submission_deadline)
					event.set_main_sponsor (conf.main_sponsor)
					event.set_url (conf.url)
					event.set_contact_name (conf.contact_name)
					event.set_contact_email (conf.contact_email)
					event.set_contact_role (conf.contact_role)
					event.set_keywords (conf.keywords)
					event.set_additional_sponsors (conf.additional_sponsors)
					event.set_short_description (conf.short_description)
					event.set_conference_chair_1 (conf.conference_chair_1)
					event.set_conference_chair_2 (conf.conference_chair_2)
					event.set_program_committee_chair_1 (conf.program_committee_chair_1)
					event.set_program_committee_chair_2 (conf.program_committee_chair_2)
					event.set_organizing_chair (conf.organizing_chair)
					event.set_additional_deadline_1 (conf.additional_deadline_1)
					event.set_additional_deadline_2 (conf.additional_deadline_2)
					event.set_additional_deadline_3 (conf.additional_deadline_3)
					event.set_additional_deadline_specification_1 (conf.additional_deadline_specification_1)
					event.set_additional_deadline_specification_2 (conf.additional_deadline_specification_2)
					event.set_additional_deadline_specification_3 (conf.additional_deadline_specification_3)
					event.set_additional_notes (conf.additional_notes)

					inspect i
					when 1 then
						event.set_status (Accepted)
					when 2 then
						event.set_status (Proposed)
					else
						event.set_status (Rejected)
					end

					if conf.proceedings_at_conference then
						event.set_proceeding_type ("At conference")
					else
						event.set_proceeding_type ("Post conference")
					end
					event.set_proceedings_publisher (conf.proceedings_publisher)
					event.set_id (conf.id)
					event.set_submitter ("conferences@informatics-europe.org")

					event_dao.add_event (event)

					conf_list.forth
				end
				i := i+1
			end

			event_dao.persist_data

			create user1_dao.make
			create user2_dao.make

			count1 := user1_dao.user_list.count

			from
				user1_dao.user_list.start
			until
				user1_dao.user_list.after
			loop
				user1 := user1_dao.user_list.item_for_iteration

				create user2.make

				user2.set_email (user1.email)
				user2.set_first_name (user1.first_name)
				user2.set_last_name (user1.last_name)
				user2.set_organization (user1.organization)
				user2.set_password (user1.password)
--				user2.set_role (role_normal_user)
--				user2.set_status (User_Active)
--				user2.set_telephone ("-")
				user2.set_username (user1.username)

				user2_dao.add_user (user2)

				user1_dao.user_list.forth
			end

			count2 := user2_dao.user_list.count
			user2_dao.persist_data


		end

end -- class APPLICATION
