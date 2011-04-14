note
	description : "JavaScript implementation of EiffelBase class INTEGER_INTERVAL."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: INTEGER_INTERVAL"

class
	EIFFEL_INTEGER_INTERVAL

feature -- Basic Operation

	lower: INTEGER
	upper: INTEGER
	count: INTEGER
		do
			Result := upper - lower + 1
		end

end
