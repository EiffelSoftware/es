indexing
	description: "Summary description for {SCOOP_BASIC_CLASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_BASIC_TYPE

feature -- Basic type declaration

	is_basic_type (a_name: STRING): BOOLEAN is
			-- Is `a_class_type' a special type (such as ARRAY, STRING, HASHABLE, that are treated as special by EiffelStudio)?
			-- Such classes should not inherit from SCOOP_SEPARATE_CLIENT, otherwise EiffelStudio reports a library error.
		require
			a_name /= Void
		do
			if a_name.is_equal ("ANY")
			   or else a_name.is_equal ("CONSOLE")
--			   or else a_name.is_equal ("MISMATCH_INFORMATION")
--			   or else a_name.is_equal ("TUPLE")
--			   or else a_name.is_equal ("COMPARABLE")
--			   or else a_name.is_equal ("ROUTINE")
--			   or else a_name.is_equal ("FUNCTION")
--			   or else a_name.is_equal ("PROCEDURE")
--			   or else a_name.is_equal ("SYSTEM_STRING")
--			   or else a_name.is_equal ("SPECIAL")
--			   or else a_name.is_equal ("ARGUMENTS")
--			   or else a_name.is_equal ("STRING")
--			   or else a_name.is_equal ("STRING_8")
--			   or else a_name.is_equal ("READABLE_STRING_8")
--			   or else a_name.is_equal ("READABLE_STRING_GENERAL")
--			   or else a_name.is_equal ("STRING_GENERAL")
-- Just some guesses to get things to compile, please remove later
--			   or else a_name.is_equal ("ARGUMENTS")

--				or else a_name.is_equal ("ARRAY")
--				or else a_name.is_equal ("STRING")
--				or else a_name.is_equal ("STRING_HANDLER")
--				or else a_name.is_equal ("TO_SPECIAL")
--				or else a_name.is_equal ("HASHABLE")
--				or else a_name.is_equal ("MISMATCH_CORRECTOR")
--				or else a_name.is_equal ("PART_COMPARABLE")
--				or else a_name.is_equal ("REFACTORING_HELPER")
--				or else a_name.is_equal ("DEBUG_OUTPUT")
--				or else a_name.is_equal ("CONTAINER")
--				or else a_name.is_equal ("INTERNAL")
--				or else a_name.is_equal ("EXCEP_CONST")

				-- added by paedde
				or else a_name.is_equal ("NONE")

				-- basic class: otherwise we get a cycle in the inheritance structure via `SCOOP_SEPARATE_CLIENT'
				-- which inherits from `EXCEPTION'.
--				or else a_name.is_equal ("EXCEPTION_MANAGER_FACTORY")
--				or else a_name.is_equal ("EXCEP_CONST")

				-- basic classes: we have here the problem that e.g. INTEGER_32_REF has some infix / prefix features
				-- INTEGER_32 from elk inherits from INTEGER_32_REF and uses the original feature declaration.
--				or else a_name.is_equal ("HASHABLE")
--				or else a_name.is_equal ("PART_COMPARABLE")
--				or else a_name.is_equal ("INTERNAL")

			then
				Result := True
			else
				Result := False
			end
		end

end
