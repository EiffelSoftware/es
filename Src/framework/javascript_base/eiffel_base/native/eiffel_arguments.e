note
	description : "JavaScript implementation of EiffelBase class ARGUMENTS."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub: ARGUMENTS"
class
	EIFFEL_ARGUMENTS

feature -- Basic Operation

	argument (i: INTEGER)
		external "C" alias "#eiffel_arguments[$i-1]" end

end
