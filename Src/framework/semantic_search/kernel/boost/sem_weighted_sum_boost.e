note
	description: "Calculates the boost as a combination other boost functions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_WEIGHTED_SUM_BOOST
inherit
	SEM_BOOST_FUNCTION
		redefine
			set_queryables
		end
create
	make_with_boost_functions

feature {NONE} -- Creation

	make_with_boost_functions (a_boost_functions: like boost_functions)
			-- Set `boost_functions' to `a_boost_functions'.
		do
			boost_functions := a_boost_functions
		end

feature {SEM_BOOST_FUNCTION, SEM_BOOST_CALCULATOR} -- Operation

	boost (a_queryable: SEM_QUERYABLE; a_equation: EPA_EQUATION; a_field: STRING): DOUBLE
			-- <precursor>
		do
			from
				boost_functions.start
			until
				boost_functions.after
			loop
				Result := Result + boost_functions.item.boost (a_queryable, a_equation, a_field)
				boost_functions.forth
			end

			if not boost_functions.is_empty then
				Result := Result / boost_functions.count
			else
				Result := default_boost
			end
		end

	set_queryables (a_queryables: like queryables)
			-- Set `queryables' to `a_queryables'.
		do
			Precursor (a_queryables)
			from
				boost_functions.start
			until
				boost_functions.after
			loop
				boost_functions.item.set_queryables (a_queryables)
				boost_functions.forth
			end
		end

feature -- Access

	boost_functions: LIST[SEM_BOOST_FUNCTION]

end
