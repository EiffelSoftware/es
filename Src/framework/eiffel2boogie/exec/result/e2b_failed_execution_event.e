note
	description: "Summary description for {E2B_FAILED_EXECUTION_EVENT}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FAILED_EXECUTION_EVENT

inherit

	EVENT_LIST_ITEM_I
		redefine
			data
		end

create
	make

feature {NONE} -- Initialization

	make (a_data: like data)
			-- Initialize event item.
		do
			data := a_data
			category := {ENVIRONMENT_CATEGORIES}.none
			priority := {PRIORITY_LEVELS}.normal
		ensure
			data_set: data = a_data
		end

feature -- Access

	data: STRING
			-- <Precursor>

	description: STRING_32
			-- <Precursor>
		do
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
			Result := data /= Void
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

end
