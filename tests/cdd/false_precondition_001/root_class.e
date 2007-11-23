indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

--	make is
--		local
--			x: CDD_TEST_ROOT_CLASS_01
--		do
--			create x
--			x.set_up
--			x.run
--		end

	make is
		do
			bar
		end

	bar is
			-- Fail with a precondition violation.
		require
			false_precondition: False
		do
		end

end
