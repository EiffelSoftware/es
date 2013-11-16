note
	explicit: "all"

class F_I_ARRAY

create
	make

feature

	make (a_lower, a_upper: INTEGER)
		note
			skip: True
		require
			is_open
			a_lower = 1
			a_upper >= 0
			modify (Current)
		do
		ensure
			count = a_upper
			is_wrapped
		end

	count: INTEGER

	put (a_value, a_index: INTEGER)
		note
			skip: True
		require
			is_wrapped
			a_index > 0
			a_index <= count

			modify (Current)
		do
		ensure
			is_wrapped
			count = old count
		end

	item alias "[]" (a_index: INTEGER): INTEGER
		note
			skip: True
		require
			not is_open

			modify ([])
		do
		ensure
			not is_open
		end

invariant
	owns = [] -- default
	observers = [] -- default
	subjects = [] -- default
	across subjects as sc all sc.item.observers.has (Current) end -- default

end
