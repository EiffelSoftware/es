note
	explicit: "all"

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
			t.is_wrapped -- default: creator
			t /= Void

			modify (Current)
			modify_field ("observers", t)
		do
			target := t
			before := True
			t.unwrap
			t.set_observers (t.observers & Current)
			t.wrap
			set_subjects ([t]) -- default: ?
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
			is_wrapped -- default: public

			modify_field ("closed", Current) -- default: query
		do
			unwrap -- default: public
			Result := target.elements [index]
			wrap -- default: public
		ensure
			is_wrapped -- default: public
		end

	forth
		require
			not after
			is_wrapped -- default: public
			modify ([Current]) -- default: command
		do
			unwrap -- default: public
			index := index + 1
			before := False
			if index > target.count then
				after := True
			end
			wrap -- default: public
		ensure
			not before
			target = old target
			is_wrapped -- default: public
		end

feature {NONE}

	index: INTEGER

invariant
	target /= Void
	0 <= index and index <= target.count + 1
	before = (index < 1)
	after = (index > target.count)
	subjects = [target]
	across subjects as s all s.item.observers.has (Current) end -- default
	observers = [] -- default
	owns = [] -- default

end
