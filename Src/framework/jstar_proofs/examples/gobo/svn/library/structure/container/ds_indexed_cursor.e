indexing

	description:

		"Indexed cursors for data structure traversals"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_INDEXED_CURSOR [G]

inherit

	DS_CURSOR [G]

feature -- Access

	index: INTEGER is
			-- Index of current position
		require
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		deferred
		ensure
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * Index(_ds,{index:Result;ref:Current;iters:_i;content:_c})
			--valid_index: valid_index (Result)
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' a valid index value?
		require
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		deferred
		ensure
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsValidIndex(_ds,{res:Result;index:i;content:_c})
		end

feature -- Cursor movement

	go_i_th (i: INTEGER) is
			-- Move cursor to `i'-th position.
		require
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1}) * IsValidIndex(_ds,{res:true();index:i;content:_c})
			--valid_index: valid_index (i)
		deferred
		ensure
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * WentToIndex(_ds,{ref:Current;index:i;newiters:_i2;olditers:_i1;content:_c})
			--moved: index = i
		end

end
