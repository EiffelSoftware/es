note
	explicit: "all"

class F_I_COLLECTION

create
	make

feature

	count: INTEGER

	capacity: INTEGER
		require
			reads (Current)

			modify ([]) -- default: query
		do
			Result := elements.count
		end

	make (cap: INTEGER)
		note
			status: creator
		require
			is_open -- default: creator
			cap >= 0
		do
			create elements.make (1, capacity)
			set_owns ([elements]) -- default: ?
			wrap -- default: creator
		ensure
			is_wrapped -- default: creator
			capacity = cap
			count = 0
			observers = []
		end

	add (v: INTEGER)
		note
			explicit: contracts
		require
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public

			count < capacity

			modify (Current)
			modify (observers)
		do
			unwrap -- default: public
			unwrap_all (observers)

			set_observers ([])
			count := count + 1
			elements.put (v, count)
			wrap -- default: public
		ensure
			count = old count + 1
			observers.is_empty
			across old observers as o all o.item.is_open end
		end

feature {F_I_ITERATOR}

	elements: F_I_ARRAY

invariant
	elements /= Void
	0 <= count and count <= elements.count
	owns = [elements]
	subjects = [] -- default

note
  explicit: observers

end
