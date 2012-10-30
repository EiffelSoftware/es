note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CHECK_VIOLATION

inherit

	E2B_VIOLATION

create
	make

--feature -- Access

--	help_text: attached LIST [STRING]
--			-- <Precursor>
--		do
--			create {LINKED_LIST [STRING]} Result.make
--			Result.extend ("Verification of {" + class_c.name_in_upper + "}." + e_feature.name_8.as_lower + " successful.")
--		end

--	single_line_help_text: STRING
--			-- <Precursor>
--		do
--			Result := "Check violation"
--		end

end
