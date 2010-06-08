indexing

	description:

		"Data structures that can hold zero or more items"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "DS(x,{content:c}) = undefined()" -- Here such that the prover generates default rules.
	sl_predicate: "IsEmpty(x,{res:r;content:c}) = undefined()"
	sl_predicate: "IsCount(x,{res:r;content:c}) = undefined()"
	sl_axioms: "[

	]"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_CONTAINER [G]

inherit

	ANY
		undefine
			copy,
			is_equal
		redefine
			is_equal
		end

	KL_CLONABLE
		undefine
			copy,
			is_equal
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default is
			-- Create an empty container.
			-- sl_ignore
		require
			--SL-- True
		deferred
		ensure
			--SL-- DS(Current,{content:_c}) * IsEmpty(Current,{res:true();content:_c})
			--empty: is_empty
		end

feature -- Measurement

	count: INTEGER is
			-- Number of items in container
		require
			--SL-- DS(Current,{content:_c})
		deferred
		ensure
			--SL-- DS(Current,{content:_c}) * IsCount(Current,{res:Result;content:_c})
		end

feature -- Status report

	is_empty: BOOLEAN is
			-- Is container empty?
		require
			--SLS-- DS(Current,{content:_c})
		do
			Result := count = 0
		ensure
			--SLS-- DS(Current,{content:_c}) * IsEmpty(Current,{res:Result;content:_c})
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is current container equal to `other'?
			-- sl_ignore
		deferred
		ensure then
			same_count: Result implies count = other.count
		end

feature -- Removal

	wipe_out is
			-- Remove all items from container.
			-- sl_ignore
		deferred
		ensure
			wiped_out: is_empty
		end

feature -- Iteration

	do_all (an_action: PROCEDURE [ANY, TUPLE [G]]) is
			-- Apply `an_action' to every item.
			-- (Semantics not guaranteed if `an_action' changes the structure.)
			-- sl_ignore
		require
			an_action_not_void: an_action /= Void
		deferred
		end

	do_if (an_action: PROCEDURE [ANY, TUPLE [G]]; a_test: FUNCTION [ANY, TUPLE [G], BOOLEAN]) is
			-- Apply `an_action' to every item that satisfies `a_test'.
			-- (Semantics not guaranteed if `an_action' or `a_test' change the structure.)
			-- sl_ignore
		require
			an_action_not_void: an_action /= Void
			a_test_not_void: a_test /= Void
		deferred
		end

	there_exists (a_test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Is `a_test' true for at least one item?
			-- (Semantics not guaranteed if `a_test' changes the structure.)
			-- sl_ignore
		require
			a_test_not_void: a_test /= Void
		deferred
		end

	for_all (a_test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Is `a_test' true for all items?
			-- (Semantics not guaranteed if `a_test' changes the structure.)
			-- sl_ignore
		require
			a_test_not_void: a_test /= Void
		deferred
		end

invariant

	positive_count: count >= 0
	empty_definition: is_empty = (count = 0)

end
