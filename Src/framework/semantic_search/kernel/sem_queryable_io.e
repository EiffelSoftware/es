note
	description: "Deferred class for semantic searchable object input/output"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERYABLE_IO [G -> SEM_QUERYABLE]

inherit
	SOLR_UTILITY

	SEM_UTILITY

	SEM_FIELD_NAMES

	SEM_SHARED_EQUALITY_TESTER

	ETR_CONTRACT_TOOLS

feature -- Access

	medium: IO_MEDIUM
			-- Medium used for input/output

	queryable: G
			-- Queryable

feature -- Setting

	set_medium (a_medium: like medium)
			-- Set `medium' with `a_medium'.
		do
			medium := a_medium
		ensure
			medium_set: medium = a_medium
		end

feature{NONE} -- Implementation


end
