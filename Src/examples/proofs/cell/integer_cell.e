indexing
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGER_CELL

create
	set_value

feature -- Access

	value: INTEGER

feature -- Element change

	set_value (a_value: INTEGER)
		do
			value := a_value
		ensure
			get_value = a_value
		end

feature -- Test

	get_value: INTEGER
		indexing
			pure: True
		do
			Result := value
		ensure
			Result = value
		end

end
