indexing
	description: "Deferred Class that is a template for all event Data Access Classes."
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

deferred class
	EVENT_DAO

feature -- Access

	event_list:EVENT_LIST
	event_id_generator:ID_GENERATOR --id generator, used to identify each event rerdless of its status

feature --basic operations

	add_event (an_event:EVENT)
			--adds a event to the appropriate list, based on its status
		require
			event_exists: an_event /= Void
			event_list_exists: event_list /= Void
		do
			event_list.add_event (an_event)
		ensure
			one_event_added: event_list.count= old event_list.count +1
		end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	delete_event (an_event:EVENT)
			--deletes an accepted, delayed or rejected event from the proposed event list
		require
			event_exists: an_event /= Void
			event_list_exists: event_list /= Void
		do
				event_list.delete_event (an_event)
		ensure
			one_event_deleted: event_list.count= old event_list.count-1
		end

-----------------------------------------------------------------------------------------------------------------------------------
	update_event (an_event:EVENT)
			--updates an accepted event in the accepted event list
		require
			event_exists: an_event /= Void
			event_list_exists: event_list /= Void
		do
				event_list.update_event (an_event)
		ensure
			same_event_count: event_list.count= old event_list.count
		end
-----------------------------------------------------------------------------------------------------------------------------------
	get_event_by_id (id:NATURAL_64):EVENT
			--returns an accepted event with given id
		require
			id_has_meaning:id>0
		do
					Result:=event_list.search_by_id(id)
		ensure
			event_found: Result/=Void
		end
-----------------------------------------------------------------------------------------------------------------------------------
	delete_event_by_id (id:NATURAL_64)
			--returns an accepted event with given id
		require
			id_has_meaning:id > 0
		local
			event: EVENT
		do
			event:=event_list.search_by_id(id)
			event_list.delete_event (event)
		end
-----------------------------------------------------------------------------------------------------------------------------------
	persist_data deferred
			--persists data in different ways depending on the implementation
		end

invariant
	invariant_clause: True -- Your invariant here

end
