note
	description: "Factory to create concrete transitions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_FACTORY

inherit
	SHARED_WORKBENCH

	SHARED_NAMES_HEAP

	SHARED_EIFFEL_PARSER

	EPA_UTILITY

feature -- Access

--	new_feature_call_transition (a_context_class: CLASS_C; a_feature: FEATURE_I; a_variables: HASH_TABLE [TYPE_A, STRING]; a_operands: HASH_TABLE [INTEGER, STRING]; a_creation: BOOLEAN): SEM_FEATURE_CALL_TRANSITION
--			-- New feature call transition for `a_feature' viewed from `a_context_class'
--			-- `a_variables' are the set of variables in the transition, key is variable name,
--			-- value is type name of that variable.
--			-- `a_operands' is a table for operands of `a_feature', including possible result, if any.
--			-- Key is 0-based operand index (0 means target, 1 means the first argument, and so on),
--			-- value is the operand name at that index.
--			-- `a_creation' indicates if `a_feature' is used as a creation procedure.
--		require
--			has_root_class: has_root_class
--		do
--			create Result.make (a_context_class, a_feature, environment_class, environment_feature (a_variables), a_variables, a_operands, a_creation)
--		end

--	new_simple_feature_call_transition (a_context_class: CLASS_C; a_feature: FEATURE_I; a_creation: BOOLEAN): SEM_FEATURE_CALL_TRANSITION
--			-- New feature call transition for `a_feature' viewed from `a_context_class'
--			-- Use "v_0" for target variable, "v_1" for the first argument, and so on.			
--		local
--			l_variables: HASH_TABLE [TYPE_A, STRING]
--			l_operands: HASH_TABLE [INTEGER, STRING]
--			l_operand_count: INTEGER
--			i: INTEGER
--		do
--			l_operand_count := operand_count_of_feature (a_feature)
--			create l_operands.make (l_operand_count)
--			l_operands.compare_objects
--			create l_variables.make (0)

--			from
--				i := 0
--			until
--				i < l_operand_count
--			loop
--				l_operands.put (i, once "v_" + i.out)
--				i := i + 1
--			end
--			Result := new_feature_call_transition (a_context_class, a_feature, l_variables, l_operands, a_creation)
--		end

feature -- Status report

	has_root_class: BOOLEAN
			-- Does Current system have root class?
		do
			Result := attached workbench.system.root_type as l_root_type and then l_root_type.associated_class /= Void
		end

feature{NONE} -- Implementation

	environment_class: CLASS_C
			-- Environment class in which transitions are type checked
		do
			Result := workbench.system.root_type.associated_class
		end

	environment_feature (a_variable: HASH_TABLE [TYPE_A, STRING]): FEATURE_I
			-- Environment feature in which type checking is done for transition of `a_feature' viewed from `a_context_class'
			-- `a_variables' are the set of variables in the transition, key is variable name,
			-- value is type name of that variable.
		local
			l_class: CLASS_C
			l_vars: HASH_TABLE [TYPE_A, INTEGER]
			l_feat_as: FEATURE_AS
			l_name_id: INTEGER
			l_body: STRING
			l_cursor: CURSOR
		do
				-- Synthesize the fake feature body for type checking purpose.
			create l_body.make (256)
			l_body.append (once "feature ")
			l_body.append (transition_feature_name)
			l_body.append (once " local %N")
			l_cursor := a_variable.cursor
			from
				a_variable.start
			until
				a_variable.after
			loop
				l_body.append (a_variable.key_for_iteration)
				l_body.append (once ": ")
				l_body.append (a_variable.item_for_iteration.name)
				l_body.append_character ('%N')
				a_variable.forth
			end
			a_variable.go_to (l_cursor)
			l_body.append (once "do end%N")

				-- Parse this fake feature.
			entity_feature_parser.parse_from_string (l_body, Void)
			l_feat_as := entity_feature_parser.feature_node

				-- Generate FEATURE_I for this fake feature.
			l_class := workbench.system.root_type.associated_class
			names_heap.put (transition_feature_name)
			l_name_id := names_heap.id_of (transition_feature_name)

			Result := feature_i_generator.new_feature (l_feat_as, 0, l_class)
			Result.set_written_in (l_class.class_id)
			Result.set_feature_name_id (l_name_id, l_name_id)
		end

	feature_i_generator_internal: like feature_i_generator
			-- Cache for `feature_i_generator'

	transition_feature_name: STRING = "feature__transition"
			-- Name of the fake feature used to type check feature transitions

end
