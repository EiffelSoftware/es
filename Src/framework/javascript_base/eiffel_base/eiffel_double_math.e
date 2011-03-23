note
	description : "JavaScript implementation of EiffelBase class DOUBLE_MATH."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: DOUBLE_MATH"
class
	EIFFEL_DOUBLE_MATH

feature -- Basic operation

	sqrt (v: DOUBLE): DOUBLE
		external "C" alias "#Math.sqrt($v)" end

end
