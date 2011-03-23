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

	code: INTEGER
		external "C" alias "charCodeAt(0)" end

	out: attached STRING
		external "C" alias "$TARGET" end

end
