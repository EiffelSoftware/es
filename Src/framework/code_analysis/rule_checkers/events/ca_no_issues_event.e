note
	description: "Event representing that no rule violation event has occurred."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_NO_ISSUES_EVENT

inherit
	EVENT_LIST_ITEM_I

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end


feature -- Access

	data: detachable ANY
			-- Is not needed here so will stay Void.

	description: STRING_32
			-- <Precursor>
		local
			l_string_formatter: YANK_STRING_WINDOW
		do
			if not attached internal_description then
				create l_string_formatter.make
				internal_description := l_string_formatter.stored_output
			end
			Result := internal_description
		end

	frozen type: NATURAL_8
			-- <Precursor>
		once
			Result := {EVENT_LIST_ITEM_TYPES}.unknown
		end

	frozen category: NATURAL_8
			-- <Precursor>

	frozen priority: INTEGER_8
			-- <Precursor>

feature -- Status report

	is_invalidated: BOOLEAN
			-- <Precursor>

	is_valid_data (a_data: ANY): BOOLEAN
			-- <Precursor>
		do
			Result := True
		end

feature -- Element change

	set_category (a_category: like category)
			-- <Precursor>
		do
			category := a_category
		end

	set_priority (a_priority: like priority)
			-- <Precursor>
		do
			priority := a_priority
		end

feature -- Basic operations

	invalidate
			-- <Precursor>
		do
			is_invalidated := True
		end

feature {NONE} -- Implementation

	internal_description: detachable STRING_32
			-- Internal buffer for description.

end
