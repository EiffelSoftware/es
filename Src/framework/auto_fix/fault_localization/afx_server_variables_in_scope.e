note
	description: "Summary description for {AFX_SHARED_SERVER_VARIABLES_IN_SCOPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SERVER_VARIABLES_IN_SCOPE

inherit

	KL_SHARED_STRING_EQUALITY_TESTER

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

	SHARED_NAMES_HEAP

	ETR_TYPE_CHECKER

create
	default_create

feature -- Access

	integer_or_boolean_locals_and_attributes_for_feature (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [STRING]
			-- Set of locals and attributes of type INTEGER/BOOLEAN, from {a_class}.{a_feature}.
		local
			l_query_key: STRING
			l_table: like integer_or_boolean_locals_and_attributes_table
			l_set: DS_HASH_SET [STRING]
		do
			l_query_key := "" + a_class.name + "." + a_feature.feature_name_32
			l_table := integer_or_boolean_locals_and_attributes_table
			if not l_table.has (l_query_key) then
				create l_set.make (20)
				l_set.set_equality_tester (case_insensitive_string_equality_tester)
				l_set.append (integer_or_boolean_locals_of_feature (a_class, a_feature))
				l_set.append (integer_or_boolean_attributes_of_class (a_class))

				l_table.force (l_set, l_query_key)
			end
			check l_table.has (l_query_key) end

			Result := l_table.item (l_query_key)
		end

	integer_or_boolean_locals_of_feature (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [STRING]
			-- Set of local variable names of the feature `a_class'.`a_feature'.
		require
			class_attached: a_class /= Void
			feature_attached: a_feature /= Void
		local
			l_local_info: HASH_TABLE [LOCAL_INFO, INTEGER]
			l_local_type: TYPE_A
		do
			create Result.make (20)
			Result.set_equality_tester (case_insensitive_string_equality_tester)

			l_local_info := local_info (a_class, a_feature)
			from l_local_info.start
			until l_local_info.after
			loop
				l_local_type := explicit_type (l_local_info.item_for_iteration.type, a_class, a_feature)
				if l_local_type.is_boolean or else l_local_type.is_integer then
					Result.force (names_heap.item (l_local_info.key_for_iteration).as_lower)
				end

				l_local_info.forth
			end
		end

	integer_or_boolean_attributes_of_class (a_class: CLASS_C): DS_HASH_SET [STRING]
			-- Set of attribute names of a class `a_class'.
		require
			class_attached: a_class /= Void
		local
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING_32
		do
			l_feature_table := a_class.feature_table
			create Result.make (l_feature_table.count + 1)
			Result.set_equality_tester (case_insensitive_string_equality_tester)

			-- Attributes of reference types can always be used as target objects.
			-- Attibutes of INTEGER or BOOLEAN types will be added to the result set.
			from
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration

				if l_next_feature.is_attribute then
					l_feature_type := l_next_feature.type.instantiation_in (a_class.actual_type, a_class.class_id).actual_type
					l_feature_type := actual_type_from_formal_type (l_feature_type, a_class)
					if l_feature_type.is_integer or else l_feature_type.is_boolean then
						Result.force (l_next_feature.feature_name_32)
					end
				end

				l_feature_table.forth
			end
		end

	feature_names_from_class (a_class: CLASS_C): EPA_HASH_SET [STRING]
			-- Feature names from the `a_class'.
		require
			class_attached: a_class /= Void
		local
			l_class_id: INTEGER
			l_feature_table: FEATURE_TABLE
			l_names: EPA_HASH_SET [STRING]
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING_32
		do
			l_class_id := a_class.class_id
			if not feature_names_table.has (l_class_id) then
				l_feature_table := a_class.feature_table
				create l_names.make (l_feature_table.count + 1)
				l_names.set_equality_tester (case_insensitive_string_equality_tester)

				from
					l_feature_table.start
				until
					l_feature_table.after
				loop
					l_next_feature := l_feature_table.item_for_iteration

					l_names.force (l_next_feature.feature_name_32)

					l_feature_table.forth
				end
				feature_names_table.force (l_names, l_class_id)
			end

			check names_ready: feature_names_table.has (l_class_id) end
			Result := feature_names_table.item (l_class_id)
		end

feature{NONE} -- Implementation

	integer_or_boolean_locals_and_attributes_table: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Table mapping a feature to the set of its local variables and attributes, of type integer/boolean.
			-- Key: class_name.feature_name
			-- Val: set of names of locals and attributes.
		once
			create Result.make (5)
			Result.set_key_equality_tester (case_insensitive_string_equality_tester)
		end

	feature_names_table: DS_HASH_TABLE [EPA_HASH_SET[STRING], INTEGER]
			-- Table of feature names for classes.
			-- Key: class_id
			-- Val: set of feature names
		once
			create Result.make (5)
		end



end
