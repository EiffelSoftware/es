note
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	TUTORIAL_APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			tut: TUTORIAL
		do
			create tut.make
		end

end
