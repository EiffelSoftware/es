note
	explicit: "all"

class F_I_COLLECTION

create
	make

feature

	count: INTEGER

	capacity: INTEGER
		require
			is_wrapped -- default: public
--			across observers as o all o.item.is_wrapped end -- default: public

			reads (Current)

			modify ([]) -- default: query
		do
			Result := elements.count
		ensure
			Result = elements.count

			is_wrapped -- default: public
--			across observers as o all o.item.is_wrapped end -- default: public
		end

	make (cap: INTEGER)
		note
			status: creator
		require
			is_open -- default: creator
			cap >= 0

			modify (Current) -- default: creator
		do
			create elements.make (1, cap)
			set_owns ([elements]) -- default: ???
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
			is_wrapped
			across observers as o all o.item.is_wrapped end

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
			observers = []
			across old observers as o all o.item.is_open end
			elements.count = old elements.count
			capacity = old capacity
			is_wrapped
		end

feature {F_I_ITERATOR}

	elements: F_I_ARRAY

invariant
	elements /= Void
	0 <= count and count <= elements.count
	owns = [elements]
	subjects = [] -- default
	not observers[Current] and not observers[elements]

note
  explicit: observers

end
