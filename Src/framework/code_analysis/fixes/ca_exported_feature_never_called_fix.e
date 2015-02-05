note
	description: "Fixes violations of rule #75 ('Exported feature never called outside class')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EXPORTED_FEATURE_NEVER_CALLED_FIX

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
			make (ca_names.exported_feature_never_called_fix, a_class)
		end

feature {NONE} -- Implementation

	execute (a_class: attached CLASS_AS)
		do
			-- TODO: Implement me.
			check False end
		end
end
