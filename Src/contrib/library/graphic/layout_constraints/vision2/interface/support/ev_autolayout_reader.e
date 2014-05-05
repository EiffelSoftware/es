note
	description: "Summary description for {EV_AUTOLAYOUT_READER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT_READER

create
	make

feature {NONE} -- Initialization

    make (a_layout: STRING)
            -- Initialize Reader
        do
            set_representation (a_layout)
        end

feature -- Commands

	 set_representation (a_layout: STRING)
            -- Set `representation'.
        do
        	a_layout.left_adjust
        	a_layout.right_adjust
			representation := a_layout
            index := 1
        end

	read: CHARACTER
			-- Read character
		do
			if not representation.is_empty then
				Result := representation.item (index)
			end
		end

	next
			-- Move to next index
		require
			has_more_elements: has_next
		do
			index := index + 1
		ensure
			incremented: old index + 1 = index
		end

	previous
			-- Move to previous index
		require
			not_is_first: has_previous
		do
			index := index - 1
		ensure
			incremented: old index - 1 = index
		end

	layout_substring (start_index, end_index: INTEGER_32): STRING
			-- layout representation between `start_index' and `end_index'
		do
			Result := representation.substring (start_index, end_index)
		end

feature -- Status report

	has_next: BOOLEAN
			-- Has a next character?
		do
			Result := index <= representation.count
		end

	has_previous: BOOLEAN
			-- Has a previous character?
		do
			Result := index >= 1
		end

feature -- Access

	representation: STRING
			-- Serialized representation of the original layout string

feature {NONE} -- Implementation

	actual: CHARACTER
			-- Current character or '%U' if none
		do
			if index > representation.count then
				Result := '%U'
			else
				Result := representation.item (index)
			end
		end

	index: INTEGER
			-- Actual index

invariant
	representation_not_void: representation /= Void

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
