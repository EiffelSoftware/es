indexing

	description:

		"Cursors for dynamically modifiable data structure traversals"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_DYNAMIC_CURSOR [G]

inherit

	DS_CURSOR [G]

feature -- Element change

	replace (v: G) is
			-- Replace item at cursor position by `v'.
		require
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c1})
			--not_off: not off
		deferred
		ensure
			--SL-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c2;pos:_p;iters:_i}) * Replaced(_ds,{ref:Current;value:v;newcontent:_c2;oldcontent:_c1;iters:_i})
			--replaced: item = v
		end

	swap (other: DS_DYNAMIC_CURSOR [G]) is
			-- Exchange items at current and `other''s positions.
			-- Note: cursors may reference two different containers.
		require
			--SLS1-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c1}) * Cursor(other,{ds:_ds}) * IsOff(_ds,{res:false();ref:other;iters:_i;content:_c1})
			--SLS2-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c1}) * Current = other
			-- TODO: Where the containers are different.
			--not_off: not off
			--other_not_void: other /= Void
			--other_not_off: not other.off
		local
			v: G
			w: G
		do
			if other /= Current then
				-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c1}) * Cursor(other,{ds:_ds}) * IsOff(_ds,{res:false();ref:other;iters:_i;content:_c1})
				v := item
				-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * ItemAt(_ds,{res:v;ref:Current;iters:_i;content:_c1}) * Cursor(other,{ds:_ds}) * IsOff(_ds,{res:false();ref:other;iters:_i;content:_c1})
				w := other.item
				-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * ItemAt(_ds,{res:v;ref:Current;iters:_i;content:_c1}) * Cursor(other,{ds:_ds}) * ItemAt(_ds,{res:w;ref:other;iters:_i;content:_c1})
				replace (w)
				-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c2;pos:_p;iters:_i}) * Replaced(_ds,{ref:Current;value:w;newcontent:_c2;oldcontent:_c1;iters:_i}) * ItemAt(_ds,{res:v;ref:Current;iters:_i;content:_c1}) * Cursor(other,{ds:_ds}) * ItemAt(_ds,{res:w;ref:other;iters:_i;content:_c1})
				other.replace (v)
			end
		ensure
			--SLS1-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c2;pos:_p;iters:_i}) * Cursor(other,{ds:_ds}) * Swapped(_ds,{ref1:Current;ref2:other;iters:_i;oldcontent:_c1;newcontent:_c2})
			--SLS2-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c1;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c1})
			--new_item: item = old (other.item)
			--new_other: other.item = old item
		end


end
