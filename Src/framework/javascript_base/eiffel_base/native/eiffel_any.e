note
	description : "JavaScript implementation of EiffelBase class ANY."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBaseNativeStub:ANY"
class
	EIFFEL_ANY

inherit
	ANY
		redefine out end

feature -- Basic Operation

	out: attached STRING
		external "C" alias "toString()" end

end
