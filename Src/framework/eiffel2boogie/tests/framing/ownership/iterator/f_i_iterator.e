class F_I_ITERATOR

create make

feature

	target: F_I_COLLECTION

	before, after: BOOLEAN

	make (t: F_I_COLLECTION)
		note
			status: creator
		require
			is_open -- default: creator
			t.is_wrapped -- default: ?
			t /= Void

			modify (Current)
			--modify (t, "observers")
			modify (t)
		do
			target := t
			before := True
			t.unwrap
			t.set_observers (t.observers + [Current])
			t.wrap
			set_subjects ([t]) -- default: implicit
			wrap -- default: creator
		ensure
			target = t
			before and not after
			is_wrapped -- default: creator
		end

	item: INTEGER
		require
			not (before or after)
			target.is_wrapped
			is_wrapped -- default: ?

			modify ([]) -- default: query
		do
			Result := target.elements [index]
		end
    
	forth
		require
			not after
			is_wrapped -- default: ?
			modify ([Current])
		do
			unwrap -- default: ?
			index := index + 1
			wrap -- default: ?
		ensure
			not before
			target = old target
			is_wrapped -- default: ?
		end
    
feature {NONE}

	index: INTEGER
  
invariant
	target /= Void
	0 <= index and index <= target.count + 1
	before = (index < 1)
	after = (index > target.count)
	subjects = [target]
	across subjects as s all s.item.observers.has (Current) end -- default: ?
	observers = [] -- default: ?
	owns = [] -- default: ?

end
