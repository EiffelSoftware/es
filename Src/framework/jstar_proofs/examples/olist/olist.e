note
	description: "An ordered list of integers."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "olist.logic"
	js_abstraction: "olist.abs"

deferred class
	OLIST

feature

	insert (i: INTEGER)
		require
			--SL-- OL(Current,{l:_a})
			True
		deferred
		ensure
			--SL-- OL(Current,{l:app(_c,cons(i,_d))}) * _a=app(_c,_d)
			has (i)
			count = old count + 1
		end

	remove_first
		require
			--SL-- OL(Current,{l:cons(_e,_a)})
			not is_empty
		deferred
		ensure
			--SL-- OL(Current,{l:_a})
			count = old count - 1
		end

	first: INTEGER
		require
			--SL-- OL(Current,{l:cons(_e,_a)})
			not is_empty
		deferred
		ensure
			--SL-- OL(Current,{l:cons(_e,_a)}) * Result=_e
			not is_empty
		end

	has (i: INTEGER): BOOLEAN
		require
			--SL-- OL(Current,{l:_a})
		deferred
		ensure
			--SL-- OL(Current,{l:_a}) * Result=elem(i,_a)
		end

	count: INTEGER
		require
			--SL-- OL(Current,{l:_a})
		deferred
		ensure
			--SL-- OL(Current,{l:_a}) * Result=len(_a)
		end

	is_empty: BOOLEAN
		require
			--SL-- OL(Current,{l:_a})
		deferred
		ensure
			--SL-- OL(Current,{l:_a}) * Result=builtin_eq(_a,empty())
		end

feature -- INVARIANTS

	count_non_negative
		require
			--SL-- OL(Current,{l:_a})
			count >= 0
		deferred
		ensure
			--SL-- OL(Current,{l:_a})
		end

	empty_definition
		require
			--SL-- OL(Current,{l:_a})
			is_empty = (count = 0)
		deferred
		ensure
			--SL-- OL(Current,{l:_a})
		end

end
