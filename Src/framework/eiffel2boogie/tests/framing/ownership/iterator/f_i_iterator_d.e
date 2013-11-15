note
	explicit: "all"

class F_I_ITERATOR_D

create
	make

feature

	target: F_I_COLLECTION_D

	before, after: BOOLEAN

	make (t: F_I_COLLECTION_D)
		note
			status: creator
		require
			is_open -- default: creator
			t.is_wrapped -- default: creator
			across t.observers as o all o.item.is_wrapped end -- default: creator
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
			t.observers = old t.observers & Current

			t.elements = old t.elements -- t modified, t.elements in domain of t
			t.elements.count = old t.elements.count -- t modified, t.elements in domain of t

			before and not after
			is_wrapped -- default: creator
			across observers as o all o.item.is_wrapped end -- default: creator
			t.is_wrapped -- default: creator
			across t.observers as o all o.item.is_wrapped end -- default: creator
		end

	item: INTEGER
		require
			not (before or after)
			target.is_wrapped
			not is_open -- default: public
			across observers as o all not o.item.is_open end -- default: public

			modify ([]) -- default: query
		do
			Result := target.elements [index]
		ensure
			not is_open -- default: public
			across observers as o all not o.item.is_open end -- default: public
			target.is_wrapped
		end

	forth
		require
			not after
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public

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
			index = old index + 1
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
		end

feature -- Implementation

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
