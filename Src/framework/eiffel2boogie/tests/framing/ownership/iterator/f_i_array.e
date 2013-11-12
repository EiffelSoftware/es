note
	explicit: "all"

class
	F_I_ARRAY

create
	make

feature

	make (a_lower, a_upper: INTEGER)
		require
			is_open

			modify (Current)
		do
		ensure
			is_wrapped
		end

	count: INTEGER

	put (a_index, a_value: INTEGER)
		require
			is_wrapped
		do
		ensure
			is_wrapped
			count = old count + 1
		end

	item alias "[]" (a_index: INTEGER): INTEGER
		require
			is_wrapped
		do
		ensure
			is_wrapped
		end


end
