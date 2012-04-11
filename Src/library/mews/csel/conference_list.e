indexing
	description: "Objects that represent a list of conferences."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	CONFERENCE_LIST

inherit
	APPLICATION_CONSTANTS

	undefine
		copy,
		is_equal
	end

	ARRAYED_LIST[CONFERENCE]

create
	make

feature --status report
-----------------------------------------------------------
	conference_list_type:INTEGER
			-- returns the conference list type
		do
			if count > 0 then
				Result:=i_th (1).status_of_approval
			else
				Result:=Undefined
			end
		ensure
			conference_list_type_is_consistent:Result= Undefined OR Result= Accepted OR Result= Proposed OR Result=Rejected OR Result=Delayed
		end
---------------------------------------------------------------------------------------------------------------------------------------
feature --basic operations

	add_conference (a_conference:CONFERENCE)
			--adds a_conference to the current list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent:a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Rejected OR a_conference.status_of_approval=Accepted
		do
			extend (a_conference)
		ensure
			one_conference_added: count = old count + 1
		end
--------------------------------------------------------------------------------------------------------------------------------------------
	delete_conference (a_conference:CONFERENCE)
			--deletes a_conference from the current list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent:a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Rejected OR a_conference.status_of_approval=Accepted
		do
			compare_objects
			start
			prune (a_conference)
		ensure
			one_conference_deleted: count= old count - 1
		end
----------------------------------------------------------------------------------------------------------------------------------
	search_by_id (id:NATURAL_64):CONFERENCE
			--searches and returns a conference with given id from the current list
		require
			id_consistent:id>0
		do
			compare_objects
			from
				start
			until
				after
			loop
				if item.id=id then
					Result:=item
				end
				forth
			end
		ensure
			one_conference_always_found: Result/=Void --we can state this because of the way the application is built
		end
----------------------------------------------------------------------------------------------------------------------------------
	update_conference (a_conference:CONFERENCE)
			--updates a_conference in the current list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent:a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Delayed OR a_conference.status_of_approval=Accepted
		local
			temp_conference:CONFERENCE
		do
			temp_conference:=a_conference
			compare_objects
			start
			--comparison is by id, so this trick works
			prune (a_conference)
			put_left (temp_conference)
		ensure
			same_conference_count: count= old count
		end
----------------------------------------------------------------------------------------------------------------
end
