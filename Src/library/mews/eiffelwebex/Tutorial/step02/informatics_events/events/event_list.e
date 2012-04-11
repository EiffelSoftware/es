indexing
	description: "Objects that represent a list of events."
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	EVENT_LIST

inherit
	ARRAYED_LIST[EVENT]

create
	make

---------------------------------------------------------------------------------------------------------------------------------------
feature --basic operations

	add_event (an_event:EVENT)
			--adds an_event to the current list
		require
			event_exists: an_event /= Void
		do
			extend (an_event)
		ensure
			one_event_added: count = old count + 1
		end
--------------------------------------------------------------------------------------------------------------------------------------------
	delete_event (an_event:EVENT)
			--deletes an_event from the current list
		require
			event_exists: an_event /= Void
		do
			compare_objects
			start
			prune (an_event)
		ensure
			one_event_deleted: count= old count - 1
		end
----------------------------------------------------------------------------------------------------------------------------------
	search_by_id (id:NATURAL_64):EVENT
			--searches and returns an event with given id from the current list
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
			one_event_always_found: Result/=Void --we can state this because of the way the application is built
		end
----------------------------------------------------------------------------------------------------------------------------------
	update_event (an_event:EVENT)
			--updates an_event in the current list
		require
			event_exists: an_event /= Void
		local
			temp_event:EVENT
		do
			temp_event:=an_event
			compare_objects
			start
			--comparison is by id, so this trick works
			prune (an_event)
			put_left (temp_event)
		ensure
			same_event_count: count= old count
		end
----------------------------------------------------------------------------------------------------------------
end
