note
	description: "Expression builder to build expressions which are evaluated during analysis."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_EXPRESSION_BUILDER

inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_access_id_as,
			process_create_creation_as,
			process_nested_as,
			process_assign_as,
			process_assigner_call_as,
			process_access_feat_as,
			process_if_as,
			process_loop_as
		end

	EPA_SHARED_EQUALITY_TESTERS
		rename
			pointer_type as shared_pointer_type
		export
			{NONE} all
		end

	EPA_UTILITY
		rename
			pointer_type as shared_pointer_type
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_)
			-- Initialize expression builder.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			class_ := a_class
			feature_ := a_feature
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
		end

feature -- Access

	class_: CLASS_C
			-- Context class of `feature_'.

	feature_: FEATURE_I
			-- Feature under analysis.

	last_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Last built expressions.

	last_expression_mapping: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Last mapping between variables and expressions.
			-- Keys are variables.
			-- Values are expressions built from variables.

feature -- Basic operations

	build_from_ast (a_ast: AST_EIFFEL; a_program_locations: like program_locations)
			-- Build expressions from `a_ast' and consider only program locations specified in
			-- `a_program_locations'. Make built expressions available in `last_expressions' and
			-- `last_expression_mapping'.
		require
			a_ast_not_void: a_ast /= Void
			a_program_locations_not_void: a_program_locations /= Void
		local
			l_breakpoint_initializer: ETR_BP_SLOT_INITIALIZER
		do
			create variables_from_feature_calls.make_default
			variables_from_feature_calls.set_equality_tester (string_equality_tester)

			create variables_from_assignments.make_default
			variables_from_assignments.set_equality_tester (string_equality_tester)

			program_locations := a_program_locations

			-- Initialize breakpoints of `a_ast'.			
			create l_breakpoint_initializer
			l_breakpoint_initializer.init_from (a_ast)

			-- Find variables in `a_ast'.
			a_ast.process (Current)

			-- Build expressions from found variables.
			build_from_variables (variables_from_feature_calls)
			build_from_variables_from_assignments (variables_from_assignments)
		ensure
			last_expressions_not_void: last_expressions /= Void
			last_expression_mapping_not_void: last_expression_mapping /= Void
		end

	build_from_variables (a_variables: DS_HASH_SET [STRING])
			-- Build expressions from `a_variables' and make built expressions available in
			-- `last_expressions' and `last_expression_mapping'.
		require
			a_variables_not_void: a_variables /= Void
		local
			l_feature_selector: EPA_FEATURE_SELECTOR
			l_variable: STRING
			l_expression: EPA_AST_EXPRESSION
			l_expression_type: TYPE_A
			l_queries: LINKED_LIST [FEATURE_I]
			l_expressions: DS_HASH_SET [EPA_EXPRESSION]
		do
			create last_expressions.make_default
			last_expressions.set_equality_tester (expression_equality_tester)

			create last_expression_mapping.make_default
			last_expression_mapping.set_key_equality_tester (string_equality_tester)

			-- Initialize feature selector which will select attributes and
			-- queries not inherited from ANY. These attributes and queries are used together with
			-- variables to build expressions.
			create l_feature_selector.default_create
			l_feature_selector.add_query_selector
			l_feature_selector.add_argumented_feature_selector (0, 0)
			l_feature_selector.add_selector (l_feature_selector.not_from_any_feature_selector)

			-- Build expressions from `a_variables'.
			from
				a_variables.start
			until
				a_variables.after
			loop
				l_variable := a_variables.item_for_iteration

				-- Build an expression with the text `l_variable'.
				create l_expression.make_with_text (class_, feature_, l_variable, class_)

				l_expression_type := l_expression.type

				-- Discard variable whose type conforms to one of the types specified
				-- in `Pointer_type' and `File_type'.
				if
					not is_file_type (l_expression_type) and
					not is_pointer_type (l_expression_type)
				then
					create l_expressions.make_default
					l_expressions.set_equality_tester (expression_equality_tester)
					l_expressions.force_last (l_expression)

					last_expressions.force_last (l_expression)

					-- Distinguish between reference and expanded types.
					if
						not is_basic_type (l_expression_type) and
						not is_string_type (l_expression_type)
					then
						-- Select attributes and queries without arguments which are not
						-- inherited from ANY from the class associated with `l_expression_type'.
						l_feature_selector.select_from_class (l_expression_type.associated_class)

						-- Build expressions whose target is `l_variable' and whose messages are
						-- all attributes and queries found by the feature selector.
						l_queries := l_feature_selector.last_features

						from
							l_queries.start
						until
							l_queries.after
						loop
							create l_expression.make_with_text (
								class_,
								feature_,
								l_variable + "." + l_queries.item_for_iteration.feature_name,
								class_
							)

							last_expressions.force_last (l_expression)
							l_expressions.force_last (l_expression)

							l_queries.forth
						end

						-- Extend the mapping between variables and expressions with the newly
						-- created expressions.
						if
							last_expression_mapping.has (l_variable)
						then
							l_expressions.do_all (
								agent (last_expression_mapping.item (l_variable)).force_last
							)
						else
							last_expression_mapping.force_last (l_expressions, l_variable)
						end
					else
						-- Extend the mapping between variables and expressions with the newly
						-- created expression.
						if
							last_expression_mapping.has (l_variable)
						then
							last_expression_mapping.item (l_variable).force_last (l_expression)
						else
							last_expression_mapping.force_last (l_expressions, l_variable)
						end
					end
				end

				a_variables.forth
			end
		ensure
			last_expressions_not_void: last_expressions /= Void
			last_expression_mapping_not_void: last_expression_mapping /= Void
		end

	build_from_expressions (a_expressions: DS_HASH_SET [STRING])
			-- Build expressions from `a_expressions' and make
			-- built expressions available in `last_expressions'.
		require
			a_expressions_not_void: a_expressions /= Void
		local
			l_expression: EPA_AST_EXPRESSION
			l_expression_text: STRING
			l_expression_text_for_type_check: STRING
			l_expression_type: TYPE_A
		do
			create last_expressions.make_default
			last_expressions.set_equality_tester (expression_equality_tester)

			create last_expression_mapping.make (0)
			last_expression_mapping.set_key_equality_tester (string_equality_tester)

			-- Iterate over `a_expressions' to build expressions.
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				l_expression_text := a_expressions.item_for_iteration

				-- Distinguish if expression has a target and a message.
				if
					l_expression_text.has ('.')
				then
					l_expression_text_for_type_check := l_expression_text.split ('.').i_th (1)
				else
					l_expression_text_for_type_check := l_expression_text
				end

				-- Discard expression whose type conforms to one of the types specified
				-- in `Pointer_type' and `File_type'.
				create l_expression.make_with_text (
					class_,
					feature_,
					l_expression_text_for_type_check,
					class_
				)

				l_expression_type := l_expression.type

				if
					not is_file_type (l_expression_type) and
					not is_pointer_type (l_expression_type)
				then
					create l_expression.make_with_text (class_, feature_, l_expression_text, class_)
					last_expressions.force_last (l_expression)
				end

				a_expressions.forth
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Process `l_as'.
		do
			-- Discard AST node if the breakpoint of `l_as' belongs to an AST node which should not
			-- be considered.
			if
				program_locations.has (l_as.breakpoint_slot)
			then
				-- Distinguish if `l_as' is a qualified or unqualified feature call.
				if
					is_nested_node
				then
					-- Add the target of the qualified feature call to the set of variables if and
					-- only if the target of the qualified feature call is not `io'.
					if
						not l_as.access_name_8.is_equal (Io_string)
					then
						variables_from_feature_calls.force_last (l_as.access_name_8)
					end
				else
					-- Add the target of the unqualified feature call which is "Current" to the set
					-- of interesting variables.
					variables_from_feature_calls.force_last (ti_current)
				end
			end

			process_access_feat_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
			-- Add the target of the creation procedure to the set of variables.
			if
				program_locations.has (l_as.breakpoint_slot)
			then
				variables_from_feature_calls.force_last (l_as.target.access_name)
			end
		end

	process_nested_as (l_as: NESTED_AS)
			-- Process `l_as'.
		do
			-- Set `is_nested_node' to "True" to indicate the presence of a qualified feature call.
			is_nested_node := True

			-- Add variable contained in `l_as' to set of interesting expressions if `l_as' is the
			-- target of an assigner call node.
			if
				is_assigner_call_node
			then
				variables_from_assignments.force_last (text_from_ast (l_as))
			end

			-- Process the target of the `l_as' node.
			l_as.target.process (Current)

			-- Set `is_nested_node' to "False" because the processing of `l_as' is finished.
			is_nested_node := False
		end

	process_assign_as (l_as: ASSIGN_AS)
			-- Process `l_as'.
		do
			-- Add the target of the assignment to the set of variables from assignments.
			variables_from_assignments.force_last (l_as.target.access_name)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
			-- Process `l_as'.
		do
			-- Set `is_assigner_call_node' to "True" to indicate the presence of an assigner call.
			is_assigner_call_node := True

			-- Process the target of the `l_as' node.
			l_as.target.process (Current)

			-- Set `is_assigner_call_node' to "False" because the processing of `l_as' is finished.
			is_assigner_call_node := False
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- Process `l_as'.
		do
			-- Nothing to be done
		end

	process_if_as (l_as: IF_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_loop_as (l_as: LOOP_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.compound)
		end

feature {NONE} -- Implementation

	Io_string: STRING = "io"
			-- String representation of "io".

feature {NONE} -- Implementation

	is_nested_node: BOOLEAN
			-- Is the currently processed node part of a NESTED_AS node?

	is_assigner_call_node: BOOLEAN
			-- Is the currently processed node part of a ASSIGNER_CALL_AS node?

feature {NONe} -- Implementation

	program_locations: DS_HASH_SET [INTEGER]
			-- Program locations at which variables in an AST should be found.

	variables_from_feature_calls: DS_HASH_SET [STRING]
			-- Variables from feature call which should be used to build expressions.

	variables_from_assignments: DS_HASH_SET [STRING]
			-- Variables from assignments which should be used to build expressions.

feature {NONE} -- Implementation

	basic_types: LINKED_LIST [STRING]
			-- Basic types of the EiffelBase cluster.
		once
			create Result.make
			Result.extend ("BOOLEAN")
			Result.extend ("NATURAL_8")
			Result.extend ("NATURAL_16")
			Result.extend ("NATURAL_32")
			Result.extend ("NATURAL_64")
			Result.extend ("INTEGER_8")
			Result.extend ("INTEGER_16")
			Result.extend ("INTEGER_32")
			Result.extend ("INTEGER_64")
			Result.extend ("REAL_32")
			Result.extend ("REAL_64")
			Result.extend ("CHARACTER_8")
			Result.extend ("CHARACTER_32")
		end

	string_types: LINKED_LIST [STRING]
			-- String types of the EiffelBase cluster.
		once
			create Result.make
			Result.extend("STRING_8")
			Result.extend("STRING_32")
		end

	Pointer_type: STRING = "POINTER"
			-- Pointer type of the EiffelBase cluster.

	File_type: STRING = "FILE"
			-- File type of EiffelBase cluster.

	Eiffelbase_cluster_name: STRING = "elks"
			-- Name of the EiffelBase cluster.

feature {NONE} -- Implementation

	is_basic_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to one of the types specified in `basic_types'?
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_is_sought_class_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			from
				basic_types.start
			until
				basic_types.after
			loop
				l_classes := universe.classes_with_name (basic_types.item_for_iteration)

				l_type := Void

				-- Iterate over fetched classes to find the class belonging to the EiffelBase
				-- cluster.
				from
					l_classes.start
					l_is_sought_class_found := False
				until
					l_is_sought_class_found or else l_classes.after
				loop
					l_class := l_classes.item

					if
						attached {EIFFEL_CLASS_I} l_class as l_eiffel_class and then
						l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name)
					then
						l_type := l_eiffel_class.compiled_representation.actual_type
						l_is_sought_class_found := True
					end

					l_classes.forth
				end

				-- Update the result.
				if
					l_type /= Void
				then
					Result :=
						Result or else is_type_conformant_in_application_context (a_type, l_type)
				end

				basic_types.forth
			end
		end

	is_string_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to one of the types specified in `string_types'?
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_is_sought_class_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			from
				string_types.start
			until
				string_types.after
			loop
				l_classes := universe.classes_with_name (string_types.item_for_iteration)

				l_type := Void

				-- Iterate over fetched classes to find the class belonging to the EiffelBase
				-- cluster.
				from
					l_classes.start
					l_is_sought_class_found := False
				until
					l_is_sought_class_found or else l_classes.after
				loop
					l_class := l_classes.item

					if
						attached {EIFFEL_CLASS_I} l_class as l_eiffel_class and then
						l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name)
					then
						l_type := l_eiffel_class.compiled_representation.actual_type
						l_is_sought_class_found := True
					end

					l_classes.forth
				end

				-- Update the result.
				if
					l_type /= Void
				then
					Result :=
						Result or else is_type_conformant_in_application_context (a_type, l_type)
				end

				string_types.forth
			end
		end

	is_pointer_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to the type specified by `Pointer_type'?
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_is_sought_class_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			l_classes := universe.classes_with_name (Pointer_type)

			-- Iterate over fetched classes to find the class belonging to the EiffelBase cluster.
			from
				l_classes.start
				l_is_sought_class_found := False
			until
				l_is_sought_class_found or else l_classes.after
			loop
				l_class := l_classes.item

				if
					attached {EIFFEL_CLASS_I} l_class as l_eiffel_class and then
					l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name)
				then
					l_type := l_eiffel_class.compiled_representation.actual_type
					l_is_sought_class_found := True
				end

				l_classes.forth
			end

			-- Update the result.
			Result := is_type_conformant_in_application_context (a_type, l_type)
		end

	is_file_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to the type specified by `File_type'?
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_is_sought_class_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			l_classes := universe.classes_with_name (File_type)

			-- Iterate over fetched classes to find the class belonging to the EiffelBase cluster.
			from
				l_classes.start
				l_is_sought_class_found := False
			until
				l_is_sought_class_found or else l_classes.after
			loop
				l_class := l_classes.item

				if
					attached {EIFFEL_CLASS_I} l_class as l_eiffel_class and then
					l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name)
				then
					l_type := l_eiffel_class.compiled_representation.actual_type
					l_is_sought_class_found := True
				end

				l_classes.forth
			end

			-- Update the result.
			Result := is_type_conformant_in_application_context (a_type, l_type)
		end

feature {NONE} -- Implementation

	build_from_variables_from_assignments (a_variables: DS_HASH_SET [STRING])
			-- Build expressions from `a_variables' and make built expressions available in
			-- `last_expressions' and `last_expression_mapping'.
		require
			a_variables_not_void: a_variables /= Void
		local
			l_variable: STRING
			l_expression: EPA_AST_EXPRESSION
			l_expression_type: TYPE_A
			l_expressions: DS_HASH_SET [EPA_EXPRESSION]
		do
			from
				a_variables.start
			until
				a_variables.after
			loop
				l_variable := a_variables.item_for_iteration

				-- Build an expression with text `l_variable'.
				create l_expression.make_with_text (class_, feature_, l_variable, class_)

				l_expression_type := l_expression.type

				-- Check that `l_expression_type' does not conform to one of the types specified
				-- in `File_type' and `Pointer_type'.
				if
					not is_file_type (l_expression_type) and
					not is_pointer_type (l_expression_type)
				then
					create l_expressions.make_default
					l_expressions.set_equality_tester (expression_equality_tester)
					l_expressions.force_last (l_expression)

					last_expressions.force_last (l_expression)

					-- Extend the mapping between variables and expressions with the newly
					-- created expression.
					if
						last_expression_mapping.has (l_variable)
					then
						l_expressions.do_all (
							agent (last_expression_mapping.item (l_variable)).force_last
						)
					else
						last_expression_mapping.force_last (l_expressions, l_variable)
					end
				end

				a_variables.forth
			end
		end

end
