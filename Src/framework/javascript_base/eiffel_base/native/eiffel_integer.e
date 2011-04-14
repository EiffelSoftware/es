note
	description : "JavaScript implementation of EiffelBase class INTEGER and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: INTEGER, INTEGER_8, INTEGER_16, INTEGER_32, INTEGER_64, NATURAL, NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64"
class
	EIFFEL_INTEGER

inherit
	ANY
		redefine out end

feature -- Basic Operation

	abs: INTEGER
		external "C" alias "Math.abs($TARGET)" end

	divisible (other: INTEGER): BOOLEAN
		external "C" alias "($TARGET%%$other===0)" end

	hash_code: INTEGER
		external "C" alias "$TARGET" end

	max (other: INTEGER): INTEGER
		external "C" alias "Math.max($TARGET,$other)" end

	max_value: INTEGER
		external "C" alias "#Math.floor(Number.MAX_VALUE)" end

	min (other: INTEGER): INTEGER
		external "C" alias "Math.min($TARGET,$other)" end

	min_value: INTEGER
		external "C" alias "#Math.ceil(Number.MIN_VALUE)" end

	one: INTEGER
		external "C" alias "#1" end

	out: attached STRING
		external "C" alias "($TARGET).toString()" end

	sign: INTEGER
		external "C" alias "#($TARGET > 0 ? 1 : ($TARGET < 0 ? -1 : 0))" end

	to_double: DOUBLE
		external "C" alias "$TARGET" end

	to_natural_32: DOUBLE
		external "C" alias "$TARGET" end

	to_real: REAL
		external "C" alias "$TARGET" end

	zero: INTEGER
		external "C" alias "#0" end

end
