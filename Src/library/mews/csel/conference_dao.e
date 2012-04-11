indexing
	description: "Deferred Class that is a template for all Conference Data Access Classes."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

deferred class
	CONFERENCE_DAO

	inherit APPLICATION_CONSTANTS

feature -- Access

	accepted_conference_list:CONFERENCE_LIST
	proposed_conference_list:CONFERENCE_LIST --it contains the delayed (or deferred) conferences too
	rejected_conference_list:CONFERENCE_LIST
	conference_id_generator:ID_GENERATOR --id generator, used to identify each conference rerdless of its status

feature --basic operations

	add_conference (a_conference:CONFERENCE)
			--adds a conference to the appropriate list, based on its status
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent:a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Rejected OR a_conference.status_of_approval=Accepted
			accepted_conference_list_exists: accepted_conference_list/=Void
			proposed_conference_list_exists: proposed_conference_list/=Void
			rejected_conference_list_exists: rejected_conference_list/=Void
		do
			inspect a_conference.status_of_approval
			when Accepted then
				accepted_conference_list.add_conference (a_conference)
			when Proposed then
				proposed_conference_list.add_conference (a_conference)
			when Rejected then
				rejected_conference_list.add_conference (a_conference)
			else
				check inconsistent_conference_state_of_approval:False end
			end
		ensure
			one_conference_added: accepted_conference_list.count= old accepted_conference_list.count +1 OR proposed_conference_list.count= old proposed_conference_list.count+1 OR rejected_conference_list.count=old rejected_conference_list.count+1
		end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	delete_conference_from_proposed_list (a_conference:CONFERENCE)
			--deletes an accepted, delayed or rejected conference from the proposed conference list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent: a_conference.status_of_approval=Rejected OR a_conference.status_of_approval=Accepted OR a_conference.status_of_approval=Delayed
			proposed_conference_list_exists: proposed_conference_list/=Void
		do
				proposed_conference_list.delete_conference (a_conference)
		ensure
			one_conference_deleted: proposed_conference_list.count= old proposed_conference_list.count-1
		end
--------------------------------------------------------------------------------------------------------------------------------------
	update_conference_in_proposed_list (a_conference:CONFERENCE)
			--updates a proposed or delayed conference in the proposed conference list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent: a_conference.status_of_approval=Proposed OR a_conference.status_of_approval=Delayed
			proposed_conference_list_exists: proposed_conference_list/=Void
		do
				proposed_conference_list.update_conference (a_conference)
		ensure
			same_conference_count: proposed_conference_list.count= old proposed_conference_list.count
		end
-----------------------------------------------------------------------------------------------------------------------------------
	update_conference_in_accepted_list (a_conference:CONFERENCE)
			--updates an accepted conference in the accepted conference list
		require
			conference_exists: a_conference /= Void
			conference_status_is_consistent: a_conference.status_of_approval=Accepted
			accepted_conference_list_exists: accepted_conference_list/=Void
		do
				accepted_conference_list.update_conference (a_conference)
		ensure
			same_conference_count: accepted_conference_list.count= old accepted_conference_list.count
		end
-----------------------------------------------------------------------------------------------------------------------------------
	get_accepted_conference_by_id (id:NATURAL_64):CONFERENCE
			--returns an accepted conference with given id
		require
			id_has_meaning:id>0
		do
					Result:=accepted_conference_list.search_by_id(id)
		ensure
			Result/=Void AND THEN Result.status_of_approval=Accepted
		end
-----------------------------------------------------------------------------------------------------------------------------------
	get_proposed_conference_by_id (id:NATURAL_64):CONFERENCE
			--returns a proposed conference with given id
		require
			id_has_meaning:id>0
		do
			Result:=proposed_conference_list.search_by_id(id)
		ensure
			Result/=Void AND THEN (Result.status_of_approval=Proposed OR Result.status_of_approval=Delayed)
		end
-----------------------------------------------------------------------------------------------------------------------------------
	persist_data deferred
			--persists data in different ways depending on the implementation
		end

invariant
	invariant_clause: True -- Your invariant here

end
