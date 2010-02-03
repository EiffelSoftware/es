indexing
	description : "AutoFixStats application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_extractor: STAT_EXTRACTOR
		do
			if argument_array.count<3 then
				io.putstring ("Usage: autofixstats <source dir> <target dir>")
			else
				create l_extractor
				l_extractor.extract(argument (1),argument (2))
			end
		rescue
			io.putstring ("Usage: autofixstats <source dir> <target dir>")
		end

end
