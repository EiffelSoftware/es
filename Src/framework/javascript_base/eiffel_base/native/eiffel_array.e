note
	description : "JavaScript implementation of EiffelBase class ARRAY."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: ARRAY"
class
	EIFFEL_ARRAY [G]

create
	make_filled

feature {NONE} -- Initialization

	make_empty
		external "C" alias "#[1]" end

	make_filled (a_default_value: G; min_index, max_index: INTEGER)
		external "C" alias "#runtime.make_array_filled($a_default_value, $min_index, $max_index)" end

feature -- Basic Operation

	at alias "@" (i: INTEGER): G
		external "C" alias "$TARGET[$i-$TARGET[0]+1]" end

	count: INTEGER
		external "C" alias "($TARGET.length-1)" end

	do_all (action: PROCEDURE [ANY, TUPLE [G]])
		external "C" alias "eiffelForEach($action)" end

	do_all_with_index (action: PROCEDURE [ANY, TUPLE [G, INTEGER]])
		external "C" alias "eiffelForEach($action)" end

	do_if (action: PROCEDURE [ANY, TUPLE [G]]; test: FUNCTION [ANY, TUPLE [G], BOOLEAN])
		external "C" alias "eiffelForEach(function(elem) { if($test(elem)) $action(elem); })" end

	do_if_with_index (action: PROCEDURE [ANY, TUPLE [G, INTEGER]]; test: FUNCTION [ANY, TUPLE [G, INTEGER], BOOLEAN])
		external "C" alias "eiffelForEach(function(elem, index) { if($test(elem, index)) $action(elem, index); })" end

	enter (v: G; i: INTEGER)
		external "C" alias "$TARGET[$i-$TARGET[0]+1] = $v" end

	entry (i: INTEGER): G
		external "C" alias "$TARGET[$i-$TARGET[0]+1]" end

	for_all (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
		external "C" alias "(!$TARGET.some(function(elem) { return !$test(elem); }))" end

	force (v: G; i: INTEGER)
		external "C" alias "$TARGET[$i-$TARGET[0]+1] = $v" end

	has (v: G): BOOLEAN
		external "C" alias "($TARGET.indexOf($v,1)>=0)" end

	keep_head (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.slice(0,$n+1)" end

	keep_tail (n: INTEGER)
		external "C" alias "$TARGET.splice(1,-$TARGET[0]+($TARGET[0]+=$TARGET.length-1-$n))" end

	item alias "[]" (i: INTEGER): G
		external "C" alias "$TARGET[$i-$TARGET[0]+1]" end

	is_empty: BOOLEAN
		external "C" alias "($TARGET.length===1)" end

	is_inserted (v: G): BOOLEAN
		external "C" alias "($TARGET.indexOf($v,1)>=0)" end

	lower: INTEGER
		external "C" alias "$TARGET[0]" end

	put (v: G; i: INTEGER)
		external "C" alias "$TARGET[$i-$TARGET[0]+1] = $v" end

	rebase (a_lower: INTEGER)
		external "C" alias "$TARGET[0]=$a_lower" end

	remove_head (n: INTEGER)
		external "C" alias "$TARGET.splice(1,($TARGET[0]=$n+1)-1)" end

	remove_tail (n: INTEGER)
		external "C" alias "$TARGET = $TARGET.slice(0, $TARGET.length-$n)" end

	subarray (start_pos, end_pos: INTEGER): ARRAY [G]
			-- Talk about a smart alias :D
		external "C" alias "[$start_pos].concat ($TARGET.slice ($start_pos-$TARGET[0]+1, $end_pos-$TARGET[0]+2))" end

	there_exists (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
		external "C" alias "eiffelSome($test)" end

	upper: INTEGER
		external "C" alias "($TARGET.length+$TARGET[0]-2)" end

end
