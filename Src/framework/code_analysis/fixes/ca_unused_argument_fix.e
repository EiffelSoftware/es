note
	description: "Summary description for {CA_UNUSED_ARGUMENT_FIX}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_FIX

inherit
	CA_FIX
		rename
			make as make_fix
		redefine
			process_body_as
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C)
			-- Initialization for `Current'.
		do
			make_fix (ca_names.unused_argument_fix, a_class)
		end

feature {NONE} -- Implementation

feature -- Iteration

	process_body_as (a_body: BODY_AS)
		do

		end

end
