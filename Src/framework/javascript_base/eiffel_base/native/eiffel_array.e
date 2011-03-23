note
	description : "JavaScript implementation of EiffelBase class ARRAY."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: ARRAY"
class
	EIFFEL_ARRAY[G]

create
	make_filled

feature {NONE} -- Initialization

	make_filled (a_default_value: G; min_index, max_index: INTEGER)
		external "C" alias "#runtime.make_array_filled($a_default_value, $min_index, $max_index)" end

feature -- Basic Operation

	count: INTEGER
		external "C" alias "($TARGET.length-1)" end

	item alias "[]" (i: INTEGER): G
		external "C" alias "$TARGET[$i-$TARGET[0]+1]" end

	lower: INTEGER
		external "C" alias "$TARGET[0]" end

	put (v: G; i: INTEGER)
		external "C" alias "$TARGET[$i-$TARGET[0]+1] = $v" end

	upper: INTEGER
		external "C" alias "($TARGET.length-1+$TARGET[0])" end

end
