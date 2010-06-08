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

	model: MML_SEQUENCE
		require
			--SL-- OL(Current,{l:_a})
		deferred
		ensure
			--SL-- OL(Current,{l:_a}) * SEQ(Result,{s:_a})
		end

	remove_first
		require
			--SL-- OL(Current,{l:cons(_e,_a)})
			not model.is_nil
		deferred
		ensure
			--SL-- OL(Current,{l:_a})
			model.eq ((old model).tail)
		end

	is_empty: BOOLEAN
		require
			--SL-- OL(Current,{l:_a})
		deferred
		ensure
			--SL-- OL(Current,{l:_a}) * Result = builtin_eq(_a,empty())
		end

feature -- INVARIANTS

	empty_inv
		require
			--SL-- OL(Current,{l:_a})
			is_empty = model.is_nil
		deferred
		ensure
			--SL-- OL(Current,{l:_a})
		end

end
