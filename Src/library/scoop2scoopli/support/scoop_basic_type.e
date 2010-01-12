indexing
	description: "Summary description for {SCOOP_BASIC_CLASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_BASIC_TYPE

feature -- Basic type declaration

	is_special_class (a_name: STRING): BOOLEAN is
			-- Is `a_class_type' a special type (such as ARRAY, STRING, HASHABLE, that are treated as special by EiffelStudio)?
			-- Such classes should not inherit from SCOOP_SEPARATE_CLIENT, otherwise EiffelStudio reports a library error.
		require
			a_name /= Void
		do
			if a_name.is_equal ("ANY")
			   or else a_name.is_equal ("CONSOLE")

			   or else a_name.is_equal ("TUPLE")

			   or else a_name.is_equal ("BOOLEAN_REF")

			   or else a_name.is_equal ("INTEGER_64_REF")
			   or else a_name.is_equal ("INTEGER_32_REF")
			   or else a_name.is_equal ("INTEGER_16_REF")
			   or else a_name.is_equal ("INTEGER_8_REF")

   			   or else a_name.is_equal ("NATURAL_64_REF")
			   or else a_name.is_equal ("NATURAL_32_REF")
			   or else a_name.is_equal ("NATURAL_16_REF")
			   or else a_name.is_equal ("NATURAL_8_REF")

			   or else a_name.is_equal ("CHARACTER_32_REF")
			   or else a_name.is_equal ("CHARACTER_8_REF")

			   or else a_name.is_equal ("REAL_32_REF")
			   or else a_name.is_equal ("REAL_64_REF")

			   or else a_name.is_equal ("COMPARABLE")
			   or else a_name.is_equal ("PART_COMPARABLE")
			   or else a_name.is_equal ("DEBUG_OUTPUT")

			   or else a_name.is_equal ("ROUTINE")
			   or else a_name.is_equal ("FUNCTION")
			   or else a_name.is_equal ("PROCEDURE")

			   or else a_name.is_equal ("ARGUMENTS")

   			   or else a_name.is_equal ("RT_DBG_INTERNAL")
   			   or else a_name.is_equal ("RT_EXTENSION_COMMON")
   			   or else a_name.is_equal ("RT_DBG_EXECUTION_PARAMETERS")

   			   or else a_name.is_equal ("PLATFORM")
   			   or else a_name.is_equal ("OPERATING_ENVIRONMENT")
   			   or else a_name.is_equal ("BIT_REF")

   			   -- or else a_name.is_equal ("CELL")
   			   -- or else a_name.is_equal ("CURSOR")

   			   or else a_name.is_equal ("DISPOSABLE")
   			   or else a_name.is_equal ("TYPE")
   			   or else a_name.is_equal ("SYSTEM_STRING_FACTORY")
   			   or else a_name.is_equal ("STD_FILES")
   			   or else a_name.is_equal ("EXCEPTION_MANAGER")
   			   or else a_name.is_equal ("EXCEPTION_MANAGER_FACTORY")
   			   or else a_name.is_equal ("FILE_COMPARER")
   			   or else a_name.is_equal ("INTERNAL_HELPER")
   			   or else a_name.is_equal ("ISE_RUNTIME")

   			   --or else a_name.is_equal ("MATH_CONST")
   			   --or else a_name.is_equal ("DOUBLE_MATH")
   			   or else a_name.is_equal ("NATIVE_ARRAY")
   			   or else a_name.is_equal ("NUMERIC_INFORMATION")
   			   or else a_name.is_equal ("OBJECT_GRAPH_TRAVERSABLE")

   			   or else a_name.is_equal ("NUMERIC")


				or else a_name.is_equal ("MISMATCH_CORRECTOR")
			    or else a_name.is_equal ("MISMATCH_INFORMATION")

				or else a_name.is_equal ("ARRAY")
				or else a_name.is_equal ("INDEXABLE")
				or else a_name.is_equal ("RESIZABLE")
				or else a_name.is_equal ("BOUNDED")
				or else a_name.is_equal ("BOX")
				or else a_name.is_equal ("CONTAINER")
				or else a_name.is_equal ("COLLECTION")
				or else a_name.is_equal ("BAG")
				or else a_name.is_equal ("CHAIN")
				or else a_name.is_equal ("DYNAMIC_CHAIN")
				or else a_name.is_equal ("LIST")
				or else a_name.is_equal ("DYNAMIC_LIST")
				or else a_name.is_equal ("TABLE")
				or else a_name.is_equal ("DISPENSER")
				or else a_name.is_equal ("TRAVERSABLE")
				or else a_name.is_equal ("BILINEAR")
				or else a_name.is_equal ("COUNTABLE")
				or else a_name.is_equal ("QUEUE")

				or else a_name.is_equal ("LINKED_QUEUE")

				or else a_name.is_equal ("COUNTABLE_SEQUENCE")
				or else a_name.is_equal ("SEQUENCE")
				or else a_name.is_equal ("RANDOM")


				or else a_name.is_equal ("LINKED_LIST")
				or else a_name.is_equal ("ARRAYED_LIST")

				or else a_name.is_equal ("FINITE")
				or else a_name.is_equal ("INFINITE")

				or else a_name.is_equal ("CURSOR_STRUCTURE")

				or else a_name.is_equal ("UNBOUNDED")
				or else a_name.is_equal ("SET")
				or else a_name.is_equal ("ACTIVE")

				or else a_name.is_equal ("LINEAR")

				or else a_name.is_equal ("INTEGER_INTERVAL")

				or else a_name.is_equal ("STRING_8")
				or else a_name.is_equal ("STRING_32")
				or else a_name.is_equal ("READABLE_STRING_8")
				or else a_name.is_equal ("READABLE_STRING_32")
				or else a_name.is_equal ("READABLE_STRING_GENERAL")
				or else a_name.is_equal ("STRING_GENERAL")
				or else a_name.is_equal ("STRING_SEARCHER")
				or else a_name.is_equal ("STRING")
				or else a_name.is_equal ("STRING_HANDLER")
				or else a_name.is_equal ("SYSTEM_STRING")

				or else a_name.is_equal ("SPECIAL")
				or else a_name.is_equal ("TO_SPECIAL")

				or else a_name.is_equal ("HASHABLE")


				or else a_name.is_equal ("REFACTORING_HELPER")


				or else a_name.is_equal ("INTERNAL")
				or else a_name.is_equal ("EXCEP_CONST")

				or else a_name.is_equal ("POINTER")
				or else a_name.is_equal ("POINTER_REF")

				-- added by paedde
				or else a_name.is_equal ("NONE")

				-- basic class: otherwise we get a cycle in the inheritance structure via `SCOOP_SEPARATE_CLIENT'
				-- which inherits from `EXCEPTION'.
--				or else a_name.is_equal ("EXCEPTION_MANAGER_FACTORY")
--				or else a_name.is_equal ("EXCEP_CONST")

				-- basic classes: we have here the problem that e.g. INTEGER_32_REF has some infix / prefix features
				-- INTEGER_32 from elk inherits from INTEGER_32_REF and uses the original feature declaration.
				or else a_name.is_equal ("HASHABLE")
--				or else a_name.is_equal ("PART_COMPARABLE")
				or else a_name.is_equal ("INTERNAL")
				or else a_name.is_equal ("INTEGER_32")
			then
				Result := True
			else
				Result := False
			end
		end

end
