note
	description: "Fixes violations of rule #75 ('Feature export can be restricted')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EXPORT_CAN_BE_RESTRICTED_FIX

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
			make (ca_names.export_can_be_restricted_fix, a_class)
		end

feature {NONE} -- Implementation

	execute (a_class: attached CLASS_AS)
		do
			-- TODO: Implement me.
			check False end
		end
end
