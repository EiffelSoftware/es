note
	description : "JavaScript implementation of EiffelBase class TUPLE."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: TUPLE"
class
	EIFFEL_TUPLE

feature -- Basic Operation

	integer_item (i: INTEGER): INTEGER
		external "C" alias "[$i-1]" end

	item (i: INTEGER): ANY
		external "C" alias "[$i-1]" end

	--is_equal (

end
