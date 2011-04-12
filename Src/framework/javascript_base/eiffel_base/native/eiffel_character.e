note
	description : "JavaScript implementation of EiffelBase class CHARACTER and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: CHARACTER, CHARACTER_8, CHARACTER_32"
class
	EIFFEL_CHARACTER

inherit
	ANY
		redefine out end

feature -- Basic Operation

	as_lower: attached STRING
		external "C" alias "toLowerCase()" end

	as_upper: attached STRING
		external "C" alias "toUpperCase()" end

	code: INTEGER
		external "C" alias "charCodeAt(0)" end

	lower: attached STRING
		external "C" alias "toLowerCase()" end

	out: attached STRING
		external "C" alias "$TARGET" end

	to_character_32: CHARACTER_32
		external "C" alias "$TARGET" end

	upper: attached STRING
		external "C" alias "toUpperCase()" end

end
