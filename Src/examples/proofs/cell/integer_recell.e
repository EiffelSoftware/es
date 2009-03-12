indexing
	description: "Summary description for {INTEGER_RECELL}."
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGER_RECELL

inherit
	INTEGER_CELL
		redefine
			set_value
		end

feature -- Access

	last_value: INTEGER

feature -- Element change

	set_value (a_value: INTEGER)
		do
			last_value := value
			Precursor {INTEGER_CELL} (a_value)
		ensure then
			last_value = old value
		end

end
