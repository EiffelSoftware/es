class F_I_COLLECTION

create
	make

feature

	count: INTEGER

	capacity: INTEGER
		note
			status: ghost
		require
			reads ([Current])
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
			observers.is_empty -- default: explicit class note
		end

	add (v: INTEGER)
		require
			is_wrapped -- default: ?
			count < capacity
			across observers as o all o.item.is_wrapped end

			modify (Current)
			modify (observers)
		do
			unwrap -- default: ?
			across observers as o loop o.item.unwrap end -- across over ghost
			set_observers ([])
			count := count + 1
			elements.put (v, count)
			wrap -- default: ?
		ensure
			count = old count + 1
			observers.is_empty
			across old observers as o all o.item.is_open end
		end

feature {F_I_ITERATOR}

	elements: ARRAY [INTEGER]

invariant
	elements /= Void
	0 <= count and count <= elements.count
	owns = [ elements ]
	subjects = [] -- default

note
  explicit: observers
end
