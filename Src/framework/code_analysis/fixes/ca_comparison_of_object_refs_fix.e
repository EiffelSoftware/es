note
	description: "Fixes violations of rule #15 ('Double negation')."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_COMPARISON_OF_OBJECT_REFS_FIX

inherit
	CA_FIX
		redefine
			process_bin_eq_as
		end

create
	make_with_bin_eq

feature {NONE} -- Initialization
	make_with_bin_eq (a_class: attached CLASS_C; a_bin_eq_as: attached BIN_EQ_AS)
			-- Initializes `Current' with class `a_class'. `a_bin_eq_as' is the '='
			-- operation comparing object references.
		do
			make (ca_names.comparison_of_object_refs_fix, a_class)
			bin_eq_to_change := a_bin_eq_as
		end

feature {NONE} -- Implementation

	bin_eq_to_change: BIN_EQ_AS
		-- The '=' operation comparing object references.

feature {NONE} -- Visitor

	process_bin_eq_as (a_bin_eq_as: BIN_EQ_AS)
		local
			l_new_text: STRING_32
		do
			if a_bin_eq_as.is_equivalent (bin_eq_to_change) then
				create l_new_text.make_empty

				l_new_text.append (a_bin_eq_as.left.text_32 (matchlist))
				l_new_text.append (" ~ ")
				l_new_text.append (a_bin_eq_as.right.text_32 (matchlist))

				a_bin_eq_as.replace_text (l_new_text, matchlist)
			end
		end

end
