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

	ceiling: INTEGER
		external "C" alias "Math.ceil($TARGET)" end

	floor: INTEGER
		external "C" alias "Math.floor($TARGET)" end

	out: attached STRING
		external "C" alias "($TARGET).toString()" end

	rounded: INTEGER
		external "C" alias "Math.round($TARGET)" end

end
