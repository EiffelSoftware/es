note
	description: "Iteration cursor over the result of a query."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RESULT_SET [G -> ANY]

inherit
	ITERATION_CURSOR [G]
	PS_EIFFELSTORE_EXPORT

create {PS_QUERY}
	make

feature -- Access

	item: G
			-- Item at current cursor position.
		do
			Result := int_item.as_attached
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?

feature -- Cursor movement

	forth
			-- Move cursor to next position.
		do
			query.transaction.repository.next_entry (query.as_attached)
		end

feature {PS_EIFFELSTORE_EXPORT}

	set_entry (object: detachable ANY)
			-- Set `object' as item if not Void, otherwise set after to True
		require
			actual_type_is_G: (object /= Void) implies (attached {G} object)
		do
			if attached {G} object as new_item then
				int_item := new_item
				after := False
			else
				after:=True
			end
		end


feature {PS_QUERY} -- Creation

	set_query (a_query: PS_QUERY [G])
			-- Set query to `a_query'. Part of initialization process
		do
			query := a_query
		end

	query: detachable PS_QUERY [G]

	make
			-- Create a new result set.
		do
			after := true
		end

feature {NONE} -- Implementation

	int_item: detachable G


invariant
	attached_item_or_after: int_item /= Void or after

end
