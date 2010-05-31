note
	description: "Summary description for {SEM_BOOST_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BOOST_CALCULATOR
inherit
	SEM_FIELD_NAMES
		export
			{NONE} all
		end
create
	make_with_boost_function

feature -- Operation

	compute_boosts (a_queryable_set: LIST[SEM_QUERYABLE])
			-- Compute boosts for `a_queryable_set'
		local
			l_eq: EPA_EQUATION
		do
			boost_function.set_queryables (a_queryable_set)
			from
				a_queryable_set.start
			until
				a_queryable_set.after
			loop
				if attached {SEM_FEATURE_CALL_TRANSITION}a_queryable_set.item as l_trans then
					-- Set boosts for preconditions
					from
						l_trans.precondition.start
					until
						l_trans.precondition.after
					loop
						l_eq := l_trans.precondition.item_for_iteration
						l_trans.precondition_boosts.force (boost_function.boost (l_trans, l_eq, precondition_field_prefix), l_eq)
						l_trans.precondition.forth
					end

					-- Set boosts for postconditions
					from
						l_trans.postcondition.start
					until
						l_trans.postcondition.after
					loop
						l_eq := l_trans.postcondition.item_for_iteration
						l_trans.postcondition_boosts.force (boost_function.boost (l_trans, l_eq, postcondition_field_prefix), l_eq)
						l_trans.postcondition.forth
					end
				end
				a_queryable_set.forth
			end
		end

	set_boost_function, make_with_boost_function (a_boost_function: like boost_function)
			-- Set `boost_function' to `a_boost_function'.
		do
			boost_function := a_boost_function
		ensure
			boost_function_set: boost_function = a_boost_function
		end

feature -- Access

	boost_function: SEM_BOOST_FUNCTION assign set_boost_function

end
