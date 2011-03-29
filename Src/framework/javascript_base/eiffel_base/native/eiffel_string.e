note
	description : "JavaScript implementation of EiffelBase class STRING and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: STRING, STRING_8, READABLE_STRING_8, STRING_32, READABLE_STRING_32"
class
	EIFFEL_STRING
inherit
	ANY
		redefine is_equal, out end

create
	make_empty,
	make_from_string

feature {NONE} -- Initialization

	make_from_string (other: attached STRING)
		external "C" alias "#$other" end

	make_empty
		external "C" alias "#%"%"" end

feature -- Basic Operation

	append (other: attached STRING)
		external "C" alias "$TARGET += $other" end

	append_character (other: CHARACTER)
		external "C" alias "$TARGET += $other" end

	as_lower: attached STRING
		external "C" alias "toLowerCase()" end

	at alias "@" (i: INTEGER): CHARACTER
		external "C" alias "charAt($i-1)" end

	count : INTEGER
		external "C" alias "length" end

	index_of (other: CHARACTER; start_index: INTEGER): INTEGER
		external "C" alias "indexOf($other, $start_index - 1) + 1" end

	is_equal (other: like Current): BOOLEAN
		external "C" alias "$TARGET === $other" end

	item alias "[]" (i: INTEGER): CHARACTER
		external "C" alias "charAt($i-1)" end

	left_adjust
		external "C" alias "$TARGET = $TARGET.replace(/^\s+/,%"%")" end

	out: attached STRING
		external "C" alias "$TARGET" end

	plus alias "+" (other: attached STRING) : attached STRING
		external "C" alias "$TARGET + $other" end

	right_adjust
		external "C" alias "$TARGET = $TARGET.replace(/\s+$/,%"%")" end

	split (separator: CHARACTER): attached LIST[attached STRING]
		external "C" alias "new EIFFEL_LIST(%"make_from_array%", $TARGET.split($separator))" end

	starts_with (other: attached STRING) : BOOLEAN
		external "C" alias "indexOf($other) === 0" end

	substring (a_from, a_to: INTEGER): attached STRING
		external "C" alias "substring($a_from-1, $a_to)" end

	substring_index (other: attached STRING; start_index: INTEGER): INTEGER
		external "C" alias "indexOf($other, $start_index - 1) + 1" end

	to_integer: INTEGER
		external "C" alias "#parseInt($TARGET, 10)" end

	to_lower
		external "C" alias "$TARGET=$TARGET.toLowerCase()" end

end
