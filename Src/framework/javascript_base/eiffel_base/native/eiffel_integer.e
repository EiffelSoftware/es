note
	description : "JavaScript implementation of EiffelBase class INTEGER and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: INTEGER, INTEGER_8, INTEGER_16, INTEGER_32, INTEGER_64"
class
	EIFFEL_INTEGER

inherit
	ANY
		redefine out end

feature -- Basic Operation

	abs: INTEGER
		external "C" alias "Math.abs($TARGET)" end

	max (other: INTEGER): INTEGER
		external "C" alias "Math.max($TARGET,$other)" end

	min (other: INTEGER): INTEGER
		external "C" alias "Math.min($TARGET,$other)" end

	out: attached STRING
		external "C" alias "($TARGET).toString()" end

	to_double: DOUBLE
		external "C" alias "$TARGET" end

	to_real: REAL
		external "C" alias "$TARGET" end

end
