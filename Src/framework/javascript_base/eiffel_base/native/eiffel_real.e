note
	description : "JavaScript implementation of EiffelBase class REAL and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript: "EiffelBaseNativeStub: REAL, REAL_32, REAL_64"
class
	EIFFEL_REAL
inherit
	ANY
		redefine out end

feature -- Basic Operation

	abs: REAL
		external "C" alias "Math.abs($TARGET)" end

	ceiling: INTEGER
		external "C" alias "Math.ceil($TARGET)" end

	divisible (other: INTEGER): BOOLEAN
		external "C" alias "($TARGET%%$other===0)" end

	floor: INTEGER
		external "C" alias "Math.floor($TARGET)" end

	hash_code: INTEGER
		external "C" alias "$TARGET" end

	is_nan: BOOLEAN
		external "C" alias "isNaN($TARGET)" end

	is_negative_infinity: BOOLEAN
		external "C" alias "$TARGET===Number.NEGATIVE_INFINITY" end

	is_positive_infinity: BOOLEAN
		external "C" alias "$TARGET===Number.POSITIVE_INFINITY" end

	max (other: REAL): REAL
		external "C" alias "Math.max($TARGET,$other)" end

	max_value: REAL
		external "C" alias "#Number.MAX_VALUE" end

	min (other: REAL): REAL
		external "C" alias "Math.min($TARGET,$other)" end

	min_value: REAL
		external "C" alias "#Number.MIN_VALUE" end

	nan: REAL
		external "C" alias "#Number.NaN" end

	negative_infinity: REAL
		external "C" alias "#Number.NEGATIVE_INFINITY" end

	one: INTEGER
		external "C" alias "#1" end

	out: attached STRING
		external "C" alias "($TARGET).toString()" end

	positive_infinity: REAL
		external "C" alias "#Number.POSITIVE_INFINITY" end

	rounded: INTEGER
		external "C" alias "Math.round($TARGET)" end

	sign: INTEGER
		external "C" alias "#($TARGET > 0 ? 1 : ($TARGET < 0 ? -1 : 0))" end

	to_double: DOUBLE
		external "C" alias "$TARGET" end

	truncated_to_real: REAL
		external "C" alias "$TARGET" end

	zero: INTEGER
		external "C" alias "#0" end

end
