note
	description: "Fixes violations of rule #77 ('Unused inheritance')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_INHERITANCE_FIX

inherit
	CA_FIX
		redefine
			execute
		end

create
	make_

feature {NONE} -- Initialization
	make_ (a_class: attached CLASS_C)
			-- Initializes `Current' with class `a_class'.
		do
			make (ca_names.unused_inheritance_fix, a_class)
		end

feature {NONE} -- Implementation

	execute (a_class: attached CLASS_AS)
		do

		end

end
