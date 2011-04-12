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

	append_boolean (b: BOOLEAN)
		external "C" alias "$TARGET += $b ? %"true%" : %"false%"" end

	append_character (other: CHARACTER)
		external "C" alias "$TARGET += $other" end

	append_code (c: CHARACTER)
		external "C" alias "$TARGET += String.fromCharCode($c)" end

	append_double (d: DOUBLE)
		external "C" alias "$TARGET += ($d).toString()" end

	append_integer (i: INTEGER)
		external "C" alias "$TARGET += ($i).toString()" end

	append_natural (n: NATURAL)
		external "C" alias "$TARGET += ($n).toString()" end

	append_real (r: REAL)
		external "C" alias "$TARGET += ($r).toString()" end

	append_string (s: STRING)
		external "C" alias "$TARGET += $s" end

	as_lower: attached STRING
		external "C" alias "toLowerCase()" end

	as_string_8: attached STRING
		external "C" alias "$TARGET" end

	as_string_32: attached STRING
		external "C" alias "$TARGET" end

	as_upper: attached STRING
		external "C" alias "toUpperCase()" end

	at alias "@" (i: INTEGER): CHARACTER
		external "C" alias "charAt($i-1)" end

	code (i: INTEGER): INTEGER
		external "C" alias "charCodeAt($i-1)" end

	count : INTEGER
		external "C" alias "length" end

	ends_with (other: attached STRING) : BOOLEAN
		external "C" alias "($TARGET.indexOf($other) + ($other).length === $TARGET.length)" end

	extend (c: CHARACTER)
		external "C" alias "$TARGET += $c" end

	false_constant: STRING
		external "C" alias "#%"false%"" end

	has (other: CHARACTER): BOOLEAN
		external "C" alias "($TARGET.indexOf($other)>=0)" end

	has_code (c: INTEGER): BOOLEAN
		external "C" alias "($TARGET.indexOf(String.fromCharCode($c))>=0)" end

	has_substring (other: attached STRING): BOOLEAN
		external "C" alias "($TARGET.indexOf($other)>=0)" end

	index_of (other: CHARACTER; start_index: INTEGER): INTEGER
		external "C" alias "($TARGET.indexOf($other, $start_index - 1) + 1)" end

	index_of_code (c: INTEGER; start_index: INTEGER): INTEGER
		external "C" alias "($TARGET.indexOf(String.fromCharCode($c), $start_index - 1) + 1)" end

	insert_character (c: CHARACTER; i: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$i-1) + $c + $TARGET.substring($i-1)" end

	insert_string (s: STRING; i: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$i-1) + $s + $TARGET.substring($i-1)" end

	is_boolean: BOOLEAN
		external "C" alias "($TARGET===%"true%" || $TARGET===%"false%")" end

	is_double: BOOLEAN
		external "C" alias "(!isNaN($TARGET))" end

	is_equal (other: like Current): BOOLEAN
		external "C" alias "$TARGET === $other" end

	is_empty: BOOLEAN
		external "C" alias "($TARGET === %"%")" end

	is_integer: BOOLEAN
		external "C" alias "(!isNaN($TARGET) && $TARGET.indexOf('.')===-1)" end

	is_natural: BOOLEAN
		external "C" alias "(!isNaN($TARGET) && $TARGET.indexOf('.')===-1)" end

	is_real: BOOLEAN
		external "C" alias "(!isNaN($TARGET))" end

	item alias "[]" (i: INTEGER): CHARACTER
		external "C" alias "charAt($i-1)" end

	item_code (i: INTEGER): INTEGER
		external "C" alias "charCodeAt($i-1)" end

	keep_head (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0, $n)" end

	keep_tail (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring($TARGET.length-$n)" end

	last_index_of (other: CHARACTER; start_index_from_end: INTEGER): INTEGER
		external "C" alias "($TARGET.lastIndexOf($other, $start_index_from_end - 1) + 1)" end

	left_adjust
		external "C" alias "$TARGET = $TARGET.replace(/^\s+/,%"%")" end

	out: attached STRING
		external "C" alias "$TARGET" end

	plus alias "+" (other: attached STRING) : attached STRING
		external "C" alias "$TARGET + $other" end

	precede (c: CHARACTER)
		external "C" alias "$TARGET = $c + $TARGET" end

	prepend (other: attached STRING)
		external "C" alias "$TARGET = $other + $TARGET" end

	prepend_boolean (b: BOOLEAN)
		external "C" alias "$TARGET = ($b ? %"true%" : %"false%") + $TARGET" end

	prepend_character (other: CHARACTER)
		external "C" alias "$TARGET = $other + $TARGET" end

	prepend_code (c: CHARACTER)
		external "C" alias "$TARGET = String.fromCharCode($c) + $TARGET" end

	prepend_double (d: DOUBLE)
		external "C" alias "$TARGET = ($d).toString() + $TARGET" end

	prepend_integer (i: INTEGER)
		external "C" alias "$TARGET = ($i).toString() + $TARGET" end

	prepend_natural (n: NATURAL)
		external "C" alias "$TARGET = ($n).toString() + $TARGET" end

	prepend_real (r: REAL)
		external "C" alias "$TARGET = ($r).toString() + $TARGET" end

	prepend_string (s: STRING)
		external "C" alias "$TARGET = $s + $TARGET" end

	put (c: CHARACTER; i: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$i-1) + $c + $TARGET.substring($i)" end

	put_code (c: NATURAL; i: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$i-1) + String.fromCharCode($c) + $TARGET.substring($i)" end

	remove (i: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$i-1) + $TARGET.substring($i)" end

	remove_head (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring($n)" end

	remove_substring (start_index, end_index: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$start_index-1) + $TARGET.substring($end_index)" end

	remove_tail (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$TARGET.length-$n)" end

	replace_substring (str: STRING; start_index, end_index: INTEGER)
		external "C" alias "$TARGET = $TARGET.substring(0,$start_index-1) + $str + $TARGET.substring($end_index-1)" end

	replace_substring_all (original, new: STRING)
		external "C" alias "replace($original, $new)" end

	right_adjust
		external "C" alias "$TARGET = $TARGET.replace(/\s+$/,%"%")" end

	same_string (other: STRING): BOOLEAN
		external "C" alias "($TARGET === $other)" end

	set (t: STRING; n1, n2: INTEGER)
		external "C" alias "$TARGET = $t.substring($n1-1, $n2)" end

	split (separator: CHARACTER): attached LIST[attached STRING]
		external "C" alias "new EIFFEL_LIST(%"make_from_array%", $TARGET.split($separator))" end

	starts_with (other: attached STRING) : BOOLEAN
		external "C" alias "indexOf($other) === 0" end

	string: STRING
		external "C" alias "$TARGET" end

	string_representation: STRING
		external "C" alias "$TARGET" end

	substring (a_from, a_to: INTEGER): attached STRING
		external "C" alias "substring($a_from-1, $a_to)" end

	substring_index (other: attached STRING; start_index: INTEGER): INTEGER
		external "C" alias "($TARGET.indexOf($other, $start_index - 1) + 1)" end

	to_boolean: BOOLEAN
		external "C" alias "($TARGET === %"true%" ? true : false)" end

	to_double: DOUBLE
		external "C" alias "parseFloat($TARGET)" end

	to_integer: INTEGER
		external "C" alias "parseInt($TARGET, 10)" end

	to_lower
		external "C" alias "$TARGET=$TARGET.toLowerCase()" end

	to_natural: INTEGER
		external "C" alias "parseInt($TARGET, 10)" end

	to_real: DOUBLE
		external "C" alias "parseFloat($TARGET)" end

	to_upper
		external "C" alias "$TARGET=$TARGET.toUpperCase()" end

	true_constant: STRING
		external "C" alias "#%"true%"" end

end
