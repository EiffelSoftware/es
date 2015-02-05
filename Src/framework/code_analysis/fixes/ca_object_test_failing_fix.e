note
	description: "Fixes violations of rule #07 ('Object test always failing')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_OBJECT_TEST_FAILING_FIX

inherit
	CA_FIX
		redefine
			execute
		end

create
	make_with_if

feature {NONE} -- Initialization
	make_with_if (a_class: attached CLASS_C; a_if: attached IF_AS)
		-- Initializes `Current' with class `a_class'. `a_if' is the if statement containing the violation.
		do
			make (ca_names.object_test_failing_fix, a_class)
			if_to_change := a_if
		end

feature {NONE} -- Implementation

	execute (a_class: CLASS_AS)
		local
			l_new: STRING
		do
			create l_new.make_empty
			if attached if_to_change.else_part as l_else then
				l_new.append (l_else.text_32 (matchlist))
			end
				-- TODO: Add indentation.
			if_to_change.replace_text (l_new, matchlist)
		end

	if_to_change: IF_AS
			-- The Object Test node this fix will change.

end
