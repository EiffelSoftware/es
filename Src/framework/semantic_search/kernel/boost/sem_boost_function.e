note
	description: "Summary description for {SEM_BOOST_FUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_BOOST_FUNCTION
inherit
	SEM_FIELD_NAMES
		export
			{NONE} all
		end
	SEM_UTILITY
		export
			{NONE} all
		end

feature -- Constants

	default_boost: DOUBLE = 1.0
			-- Default boost value for a field

	written_boost: DOUBLE = 10.0
			-- Default boost value for written contracts

feature {SEM_BOOST_FUNCTION, SEM_BOOST_CALCULATOR} -- Operation

	boost (a_queryable: SEM_QUERYABLE; a_equation: EPA_EQUATION; a_field: STRING): DOUBLE
			-- Boost value of `a_equation' of `a_queryable' when used in `a_field'
		require
			queryables_set: queryables /= void
		deferred
		end

	set_queryables (a_queryables: like queryables)
			-- Set `queryables' to `a_queryables'.
		do
			queryables := a_queryables
		ensure
			queryables_set: queryables = a_queryables
		end

feature {SEM_BOOST_FUNCTION, SEM_BOOST_CALCULATOR} -- Access

	queryables: LIST[SEM_QUERYABLE] assign set_queryables

end
