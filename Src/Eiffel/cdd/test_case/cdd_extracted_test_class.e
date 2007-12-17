indexing
	description: "Objects that represent an extracted test class containing program state for some feature"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_EXTRACTED_TEST_CLASS

inherit

	CDD_TEST_CLASS
		  redefine
				make_with_class
		  end

create
	make_with_class

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
				-- Initialize test class.
		  local
				l_feat: E_CONSTANT
		  do
				Precursor (a_class)
				l_feat ?= test_class.feature_with_name ("class_under_test")
				if l_feat /= Void then
					 class_name := l_feat.value
				else
					 create class_name.make_empty
				end
				l_feat ?= test_class.feature_with_name ("feature_under_test")
				if l_feat /= Void then
					 feature_name := l_feat.value
				else
					 create class_name.make_empty
				end
		  end

feature -- Access

	class_name: STRING
				-- Name of class beeing tested

	feature_name: STRING
				-- Name of feature beeing tested

	class_under_test: EIFFEL_CLASS_C is
				-- Compiled class for `class_name'
		  local
				l_uni: UNIVERSE_I
				l_list: LIST [CLASS_I]
		  do
				if internal_class_under_test = Void and not class_name.is_empty then
					 l_uni := eiffel_universe
					 l_list := eiffel_universe.classes_with_name (class_name)
					 from
						  l_list.start
					 until
						  l_list.after or internal_class_under_test /= Void
					 loop
						  internal_class_under_test ?= l_list.item.compiled_class
						  l_list.forth
					 end
				end
				Result := internal_class_under_test
		  ensure
				internal_set: Result = internal_class_under_test
		  end

	feature_under_test: E_FEATURE is
				-- Compiled feature for `feature_name' in `class_under_test'
		  local
				l_class: like class_under_test
		  do
				if internal_feature_under_test = Void and not feature_name.is_empty then
					 l_class := class_under_test
					 if l_class /= Void then
						  internal_feature_under_test := l_class.feature_with_name (feature_name)
					 end
				end
				Result := feature_under_test
		  ensure
				internal_set: Result = internal_feature_under_test
				not_void_implies_class_not_void: Result /= Void implies class_under_test /= Void
		  end

	cluster: CLUSTER_I is
				-- Cluster of `class_under_test' if not void
		  local
				l_class: EIFFEL_CLASS_C
		  do
				l_class := class_under_test
				if l_class /= Void then
					 Result := l_class.cluster
				end
		  ensure
				not_void_equals_class_not_void: Result /= Void = class_under_test /= Void
		  end

feature -- Not implemented

	contains_prestate: BOOLEAN
				-- Is context of `current' actual pre-state?

	call_stack_uuid: UUID
				-- uuid of the call stack

	position_in_call_stack: NATURAL
				-- position within the call stack

feature {NONE} -- Implementation

	internal_class_under_test: like class_under_test
				-- Precomputed `class_under_test'

	internal_feature_under_test: like feature_under_test
				-- Precomputed `feature_under_test'

invariant
	class_name_valid: class_name /= Void and then not class_name.is_empty
	feature_name_valid: feature_name /= Void and then not feature_name.is_empty

end
