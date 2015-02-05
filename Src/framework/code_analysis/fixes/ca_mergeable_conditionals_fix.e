note
	description: "Fixes violations of rule #87 ('Mergeable conditionals')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_MERGEABLE_CONDITIONALS_FIX

inherit
	CA_FIX
		redefine
			execute
		end

create
	make_with_ifs

feature {NONE} -- Initialization
	make_with_ifs (a_class: attached CLASS_C; a_if_1: attached IF_AS; a_if_2: attached IF_AS)
			-- Initializes `Current' with class `a_class'. `a_if_1' and `a_if_2' are the if blocks to be merged.
		do
			make (ca_names.mergeable_conditionals_fix, a_class)
		end

feature {NONE} -- Implementation

	execute (a_class: attached CLASS_AS)
		do
				-- Combine then-parts.


				-- Combine else-parts.


				-- Remove second if block.
			second.remove_text (matchlist)
		end

	first: IF_AS
		-- The first if block to be merged.

	second: IF_AS
		-- The second if block to be merged.

end
