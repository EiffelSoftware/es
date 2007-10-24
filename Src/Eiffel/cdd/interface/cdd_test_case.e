indexing
	description: "Objects that represent CDD test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CASE

inherit

	CDD_CONSTANTS

	SHARED_EIFFEL_PROJECT

create
	make_with_class

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
			-- Set `test_class' to `a_class' and parse `test_class' to retrieve
			-- information for defining `test_under_test' and `class_under_test'.
		require
			a_class_not_void: a_class /= Void
		local
			l_feat: E_CONSTANT
			l_class_list: LIST [CLASS_I]
			l_class: EIFFEL_CLASS_C
		do
			test_class := a_class

				-- Retrieve class under test
			l_feat ?= test_class.feature_with_name ("class_under_test")
			if l_feat /= Void then
				class_name := l_feat.value
				if class_name /= Void and then not class_name.is_empty then
					l_class_list := eiffel_universe.classes_with_name (class_name)
					from
						l_class_list.start
					until
						l_class_list.after or l_class /= Void
					loop
						l_class ?= l_class_list.item.compiled_class
						l_class_list.forth
					end
					if l_class /= Void then
						cluster_name := l_class.cluster.cluster_name
					end
				end
			end
			l_feat ?= test_class.feature_with_name ("feature_under_test")
			if l_feat /= Void then
				feature_name := l_feat.value
				if feature_name /= Void and then not feature_name.is_empty then
						-- Fix for pre/suffix feature names
					feature_name.replace_substring_all ("%%", "")
				end
			end
			if cluster_name = Void or else cluster_name.is_empty then
				cluster_name := unknown_name
			end
			if feature_name = Void or else feature_name.is_empty then
				feature_name := unknown_name
			end
			if class_name = Void or else class_name.is_empty then
				class_name := unknown_name
			end
		end

feature -- Access

	test_class: CLASS_C
			-- Class containing context for `current'

	feature_name: STRING
			-- Name of feature beeing tested by `current'

	class_name: STRING
			-- Name of class containing `feature_under_test'

	cluster_name: STRING
			-- Name of cluster containing `class_under_test'

	status: INTEGER
			-- Current status of test case

	contains_prestate: BOOLEAN
			-- Is context of `current' actual pre-state?

	call_stack_uuid: UUID
			-- uuid of the call stack

	position_in_call_stack: NATURAL
			-- position within the call stack

feature -- Status report

	status_change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions called when `status' changes

feature -- Status setting

	set_status (a_status: like status) is
			-- Set `status' to `a_status' and notify agents.
		do
		end

invariant
	test_class_not_void: test_class /= Void
	class_name_not_empty: class_name /= Void and then not class_name.is_empty

end
