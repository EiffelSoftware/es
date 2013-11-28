class F_I_ITERATOR

create
	make

feature

	target: F_I_COLLECTION

	before, after: BOOLEAN

	make (t: F_I_COLLECTION)
		note
			status: creator
		require
			t /= Void
			across t.observers as ic all ic.item.generating_type = {F_I_ITERATOR} end

			modify (Current)
			modify_field (["observers", "closed"], t)
		do
			target := t
			before := True
			t.unwrap
			t.set_observers (t.observers & Current)
			t.wrap
			set_subjects ([t])
		ensure
			target = t
			t.observers = old t.observers & Current

			t.elements = old t.elements -- t modified, t.elements in domain of t
			t.elements.count = old t.elements.count -- t modified, t.elements in domain of t

			before and not after
		end

	item: INTEGER
		require
			not (before or after)
			target.is_wrapped
		do
			Result := target.elements [index]
		ensure
			target.is_wrapped
		end

	forth
		require
			not after
		do
			index := index + 1
			before := False
			if index > target.count then
				after := True
			end
		ensure
			not before
			target = old target
			index = old index + 1
		end

feature -- Implementation

	index: INTEGER

invariant
	target /= Void
	0 <= index and index <= target.count + 1
	before = (index < 1)
	after = (index > target.count)
	subjects = [target]

end
