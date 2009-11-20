note
	description: "Summary description for {AFX_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UTILITY

inherit
	SHARED_WORKBENCH

feature -- Access

	first_class_starts_with_name (a_class_name: STRING): detachable CLASS_C
			-- First class found in current system with name `a_class_name'
			-- Void if no such class was found.
		local
			l_classes: LIST [CLASS_I]
			l_class_c: CLASS_C
		do
			l_classes := universe.classes_with_name (a_class_name)
			if not l_classes.is_empty then
				Result := l_classes.first.compiled_representation
			end
		end

	feature_from_class (a_class_name: STRING; a_feature_name: STRING): detachable FEATURE_I
			-- Feature named `a_feature_name' from class named `a_class_name'
			-- Void if no such feature exists.
		local
			l_class: detachable CLASS_C
		do
			l_class := first_class_starts_with_name (a_class_name)
			if l_class /= Void then
				Result := l_class.feature_named (a_feature_name)
			end
		end

	test_case_info_from_string (a_string: STRING): AFX_TEST_CASE_INFO
			-- Test case information analyzed from `a_string'
		do
			create Result.make_with_string (a_string)
		end

feature -- Equality tester

	class_with_prefix_equality_tester: AGENT_BASED_EQUALITY_TESTER [AFX_CLASS_WITH_PREFIX] is
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: AFX_CLASS_WITH_PREFIX): BOOLEAN do Result := a.is_equal (b) end)
		end

end
