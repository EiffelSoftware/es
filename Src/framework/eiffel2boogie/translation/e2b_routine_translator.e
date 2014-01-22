note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ROUTINE_TRANSLATOR

inherit

	E2B_ROUTINE_TRANSLATOR_BASE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize routine translator.
		do
		end

feature -- Translation: Signature

	translate_routine_signature (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate signature of feature `a_feature' of type `a_type'.
		require
			not_attribute: not a_feature.is_attribute
		do
			translate_signature (a_feature, a_type, False)
		end

	translate_creator_signature (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate signature of feature `a_feature' of type `a_type'.
		do
			translate_signature (a_feature, a_type, True)
		end

	translate_default_create_signature (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate signature of feature `a_feature' of type `a_type'.
		do
			translate_signature (a_feature, a_type, True)
			-- TODO: create special signature
		end

	translate_logical_signature (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate signature of a logical feature `a_feature' of type `a_type'.
		require
			class_logical: helper.is_class_logical (a_type.base_class)
		do
			set_context (a_feature, a_type)

				-- Add referenced types
			translation_pool.add_type (current_type)
			across arguments_of_current_feature as i loop
				translation_pool.add_type (i.item.type.deep_actual_type.instantiated_in (current_type))
			end
			if current_feature.has_return_value then
				translation_pool.add_type (current_feature.type.deep_actual_type.instantiated_in (current_type))
			end

				-- Add precondition
			if a_feature.has_precondition then
				translation_pool.add_precondition_predicate (current_feature, current_type)
			end
		end

	translate_signature (a_feature: FEATURE_I; a_type: TYPE_A; a_for_creator: BOOLEAN)
			-- Translate signature of feature `a_feature' of type `a_type'.
		require
			routine: a_feature.is_routine
		local
			l_proc_name: STRING
			l_contracts: like contracts_of
			l_fields: LINKED_LIST [TUPLE [o: IV_EXPRESSION; f: IV_ENTITY]]
			l_modifies: IV_MODIFIES
			l_type: TYPE_A
		do
			set_context (a_feature, a_type)
			translation_pool.add_type (current_type)

				-- Check status compatibility
			if not helper.has_functional_representation (a_feature) and helper.is_functional (a_feature) then
				helper.add_semantic_warning (a_feature, messages.functional_feature_not_function, -1)
			end

				-- Set up name
			if a_for_creator then
				l_proc_name := name_translator.boogie_procedure_for_creator (current_feature, current_type)
			else
				l_proc_name := name_translator.boogie_procedure_for_feature (current_feature, current_type)
			end

				-- Initialize procedure
			set_up_boogie_procedure (l_proc_name)

				-- Arguments
			add_argument_with_property ("Current", current_type, types.ref)
			across arguments_of_current_feature as i loop
				add_argument_with_property (i.item.name, i.item.type, i.item.boogie_type)
			end

				-- Result type
			add_result_with_property

				-- Modifies
			if helper.is_lemma (a_feature) then
					-- Lemmas do not modify the heap
			else
				create l_modifies.make ("Heap")
				current_boogie_procedure.add_contract (l_modifies)
			end

				-- Pre- and postconditions
			l_contracts := contracts_of (current_feature, current_type)
			across l_contracts.pre as j loop
				process_precondition (j.item, l_contracts.pre_origin [j.target_index])
			end
			create l_fields.make
			across l_contracts.post as j loop
				process_postcondition (j.item, l_contracts.post_origin [j.target_index], l_fields)
			end

				-- Creator: add default field initialization
			if a_for_creator then
				add_field_initialization
			end

				-- Framing
			if options.is_ownership_enabled then
				add_ownership_contracts (a_for_creator, not helper.is_lemma (a_feature))
			else
				if helper.feature_note_values (current_feature, "framing").has ("False") then
						-- No frame condition
				elseif helper.feature_note_values (current_feature, "pure").has ("True") then
						-- Pure feature
					add_pure_frame_condition
				elseif helper.feature_note_values (current_feature, "pure_fresh").has ("True") then
					add_pure_fresh_frame_condition
				else
						-- Normal frame condition
					process_fields_list (l_fields)
				end
			end

			if options.is_precondition_predicate_enabled then
				add_precondition_predicate
			end
			if options.is_postcondition_predicate_enabled then
				add_postcondition_predicate
			end
		end

	add_field_initialization
			-- Add free preconditions to `current_boogie_procedure' that all attributes are initialized to default values
		local
			l_mapping: E2B_ENTITY_MAPPING
			l_pre: IV_PRECONDITION
			l_attr_name: STRING
			l_attribute: FEATURE_I
		do
			create l_mapping.make
			from
				current_type.base_class.feature_table.start
			until
				current_type.base_class.feature_table.after
			loop
				l_attribute := current_type.base_class.feature_table.item_for_iteration
				if l_attribute.is_attribute then
					translation_pool.add_referenced_feature (l_attribute, current_type)
					l_attr_name := name_translator.boogie_procedure_for_feature (l_attribute, current_type)
					create l_pre.make (factory.equal (
						factory.heap_current_access (l_mapping, l_attr_name, types.for_type_a (l_attribute.type)),
						types.for_type_a (l_attribute.type).default_value))
					l_pre.set_free
					current_boogie_procedure.add_contract (l_pre)
				end
				current_type.base_class.feature_table.forth
			end
				-- Add ownership-realted built-in attribute
			if options.is_ownership_enabled then
				-- closed
				create l_pre.make (factory.function_call ("is_open", << factory.global_heap, factory.std_current >>, types.bool))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

				-- owner
				create l_pre.make (factory.equal (factory.heap_current_access (l_mapping, "owner", types.ref), factory.void_))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

				-- owns
				create l_pre.make (factory.equal (
					factory.heap_current_access (l_mapping, "owns", types.set (types.ref)),
					factory.function_call ("Set#Empty", << >>, types.set (types.ref))))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

				-- subjects
				create l_pre.make (factory.equal (
					factory.heap_current_access (l_mapping, "subjects", types.set (types.ref)),
					factory.function_call ("Set#Empty", << >>, types.set (types.ref))))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

				-- observers
				create l_pre.make (factory.equal (
					factory.heap_current_access (l_mapping, "observers", types.set (types.ref)),
					factory.function_call ("Set#Empty", << >>, types.set (types.ref))))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)
			end
		end

	add_ownership_contracts (a_for_creator: BOOLEAN; a_modifies_heap: BOOLEAN)
			-- Add ownership contracts to current feature.
		local
			l_pre: IV_PRECONDITION
			l_post: IV_POSTCONDITION
		do
				-- Preserves global invariant
			create l_pre.make (factory.function_call ("global", << factory.global_heap >>, types.bool))
			l_pre.set_free
			current_boogie_procedure.add_contract (l_pre)

				-- Only add postconditions and frame properties if the procedure modifies heap
			if a_modifies_heap then
				create l_post.make (factory.function_call ("global", << factory.global_heap >>, types.bool))
				l_post.set_free
				current_boogie_procedure.add_contract (l_post)

					-- Add stronger global invariant
				if helper.is_public (current_feature) or a_for_creator then
					create l_post.make (factory.function_call ("global_public", << factory.global_heap >>, types.bool))
					l_post.set_free
					current_boogie_procedure.add_contract (l_post)
				end

				add_ownership_frame (a_for_creator)

					-- OWNERSHIP DEFAULTS
					-- ToDo: should default precondtions be enabled for lemmas?
				if not helper.is_explicit (current_feature, "contracts") then
					add_ownership_default (a_for_creator)
				end
			end
		end

	add_ownership_frame (a_for_creator: BOOLEAN)
			-- Add framing contracts to current feature.
		local
			l_pre: IV_PRECONDITION
			l_post: IV_POSTCONDITION
			l_fcall: IV_FUNCTION_CALL
		do
				-- Write frame:
				-- Precondition: Modify set is writable
			create l_fcall.make (name_translator.boogie_function_for_write_frame (current_feature, current_type), types.frame)
			l_fcall.add_argument (factory.global_heap)
			across current_boogie_procedure.arguments as i loop
				l_fcall.add_argument (i.item.entity)
			end
			create l_pre.make (factory.function_call ("Frame#Subset", << l_fcall, factory.global_writable>>, types.bool))
			l_pre.node_info.set_type ("pre")
			l_pre.node_info.set_tag ("frame_writable")
			current_boogie_procedure.add_contract (l_pre)

				-- Free precondition: Everything in the domains of writable objects is writable
			create l_pre.make (factory.function_call ("closed_under_domains", <<factory.global_writable, factory.global_heap>>, types.bool))
			l_pre.set_free
			current_boogie_procedure.add_contract (l_pre)

				-- Free postcondition: Only writes set has changed
			create l_post.make (factory.writes_routine_frame (current_feature, current_type, current_boogie_procedure))
			l_post.set_free
			current_boogie_procedure.add_contract (l_post)

			translation_pool.add_write_frame_function (current_feature, current_type)

				-- Free postcondition: HeapSucc
			create l_post.make (factory.function_call ("HeapSucc", <<factory.old_heap, factory.global_heap>>, types.bool))
			l_post.set_free
			current_boogie_procedure.add_contract (l_post)

				-- Read frame:
			if helper.has_functional_representation (current_feature) then
					-- Free precondition: Read set is readable
				create l_fcall.make (name_translator.boogie_function_for_read_frame (current_feature, current_type), types.frame)
				l_fcall.add_argument (factory.global_heap)
				across current_boogie_procedure.arguments as i loop
					l_fcall.add_argument (i.item.entity)
				end
				create l_pre.make (factory.function_call ("Frame#Subset", << l_fcall, factory.global_readable>>, types.bool))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

					-- Free precondition: Everything in the domains of writable objects is writable
				create l_pre.make (factory.function_call ("closed_under_domains", << factory.global_readable, factory.global_heap >>, types.bool))
				l_pre.set_free
				current_boogie_procedure.add_contract (l_pre)

				translation_pool.add_read_frame_function (current_feature, current_type)
			end
		end

	add_ownership_default (a_for_creator: BOOLEAN)
			-- Add default ownership contracts to current feature.
		local
			l_pre: IV_PRECONDITION
			l_post: IV_POSTCONDITION
		do
			if a_for_creator then
				create l_post.make (factory.function_call ("is_wrapped", << factory.global_heap, factory.std_current >>, types.bool))
				l_post.node_info.set_type ("post")
				l_post.node_info.set_tag ("default_is_wrapped")
				l_post.node_info.set_attribute ("default", "contracts")
				current_boogie_procedure.add_contract (l_post)
				create l_post.make (forall_mml_set_property ("Current", "observers", "is_wrapped"))
				l_post.node_info.set_type ("post")
				l_post.node_info.set_tag ("defaults_observers_are_wrapped")
				l_post.node_info.set_attribute ("default", "contracts")
				current_boogie_procedure.add_contract (l_post)
			elseif helper.is_public (current_feature) then
				if helper.has_functional_representation (current_feature) then
						-- Pure function
					create l_pre.make (factory.function_call ("!is_open", << factory.global_heap, factory.std_current >>, types.bool))
					l_pre.node_info.set_type ("pre")
					l_pre.node_info.set_tag ("default_is_closed")
					l_pre.node_info.set_attribute ("default", "contracts")
					current_boogie_procedure.add_contract (l_pre)
				else
					create l_pre.make (factory.function_call ("is_wrapped", << factory.global_heap, factory.std_current >>, types.bool))
					l_pre.node_info.set_type ("pre")
					l_pre.node_info.set_tag ("default_is_wrapped")
					l_pre.node_info.set_attribute ("default", "contracts")
					current_boogie_procedure.add_contract (l_pre)
					create l_pre.make (forall_mml_set_property ("Current", "observers", "is_wrapped"))
					l_pre.node_info.set_type ("pre")
					l_pre.node_info.set_tag ("default_observers_are_wrapped")
					l_pre.node_info.set_attribute ("default", "contracts")
					current_boogie_procedure.add_contract (l_pre)
					create l_post.make (factory.function_call ("is_wrapped", << factory.global_heap, factory.std_current >>, types.bool))
					l_post.node_info.set_type ("post")
					l_post.node_info.set_tag ("default_is_wrapped")
					l_post.node_info.set_attribute ("default", "contracts")
					current_boogie_procedure.add_contract (l_post)
					create l_post.make (forall_mml_set_property ("Current", "observers", "is_wrapped"))
					l_post.node_info.set_type ("post")
					l_post.node_info.set_tag ("default_observers_are_wrapped")
					l_post.node_info.set_attribute ("default", "contracts")
					current_boogie_procedure.add_contract (l_post)
				end
			elseif helper.is_private (current_feature) then
				create l_pre.make (factory.function_call ("is_open", << factory.global_heap, factory.std_current >>, types.bool))
				l_pre.node_info.set_type ("pre")
				l_pre.node_info.set_tag ("default_is_open")
				l_pre.node_info.set_attribute ("default", "contracts")
				current_boogie_procedure.add_contract (l_pre)
				create l_post.make (factory.function_call ("is_open", << factory.global_heap, factory.std_current >>, types.bool))
				l_post.node_info.set_type ("post")
				l_post.node_info.set_tag ("default_is_open")
				l_post.node_info.set_attribute ("default", "contracts")
				current_boogie_procedure.add_contract (l_post)
			end
			if a_for_creator or (helper.is_public (current_feature) and not helper.has_functional_representation (current_feature)) then
				across arguments_of_current_feature as i loop
					if i.item.boogie_type ~ types.ref then
						create l_pre.make (factory.function_call ("is_wrapped", << factory.global_heap, factory.entity (i.item.name, i.item.boogie_type) >>, types.bool))
						l_pre.node_info.set_type ("pre")
						l_pre.node_info.set_tag ("arg_" + i.item.name + "_is_wrapped")
						l_pre.node_info.set_attribute ("default", "contracts")
						current_boogie_procedure.add_contract (l_pre)
						create l_post.make (factory.function_call ("is_wrapped", << factory.global_heap, factory.entity (i.item.name, i.item.boogie_type) >>, types.bool))
						l_post.node_info.set_type ("post")
						l_post.node_info.set_tag ("arg_" + i.item.name + "_is_wrapped")
						l_post.node_info.set_attribute ("default", "contracts")
						current_boogie_procedure.add_contract (l_post)
					end
				end
			end
--				if a_for_creator or helper.is_public (current_feature) then
--					across arguments_of_current_feature as i loop
--						if i.item.boogie_type.is_reference then
--							create l_pre.make (forall_mml_set_property (i.item.name, "observers", "is_wrapped"))
--							-- ToDo: add?
--						end
--					end
--				end
		end

feature -- Translation: Implementation

	translate_routine_implementation (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate implementation of feature `a_feature' of type `a_type'.
		require
			routine: a_feature.is_routine
		do
			translate_implementation (a_feature, a_type, False)
		end

	translate_creator_implementation (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate implementation of feature `a_feature' of type `a_type'.
		do
			translate_implementation (a_feature, a_type, True)
		end

	translate_implementation (a_feature: FEATURE_I; a_type: TYPE_A; a_for_creator: BOOLEAN)
			-- Translate implementation of feature `a_feature' of type `a_type'.
		local
			l_procedure: IV_PROCEDURE
			l_implementation: IV_IMPLEMENTATION
			l_translator: E2B_INSTRUCTION_TRANSLATOR
			l_type: TYPE_A
			l_proc_name, l_local_name: STRING
			l_values: ARRAYED_LIST [STRING_32]
			l_assign: IV_ASSIGNMENT
			l_call: IV_PROCEDURE_CALL
			l_ownership_handler: E2B_CUSTOM_OWNERSHIP_HANDLER
			l_expr_translator: E2B_BODY_EXPRESSION_TRANSLATOR
		do
			set_context (a_feature, a_type)
			set_inlining_options_for_feature (a_feature)

			if a_for_creator then
				l_proc_name := name_translator.boogie_procedure_for_creator (current_feature, current_type)
			else
				l_proc_name := name_translator.boogie_procedure_for_feature (current_feature, current_type)
			end

			l_procedure := boogie_universe.procedure_named (l_proc_name)
			check l_procedure /= Void end
			current_boogie_procedure := l_procedure

			create l_implementation.make (l_procedure)
			boogie_universe.add_declaration (l_implementation)

			create l_translator.make
			l_translator.set_context (l_implementation, current_feature, current_type)
			if helper.has_functional_representation (a_feature) then
				l_translator.set_context_readable (factory.global_readable)
			end

				-- Add initial tracing information
			l_implementation.body.add_statement (factory.trace (l_proc_name))

				-- OWNERSHIP: start of routine body
			if options.is_ownership_enabled then
					-- Public procedures unwrap Current in the beginning, unless lemma or marked with explicit wrapping
				if not a_for_creator and helper.is_public (current_feature) and not a_feature.has_return_value and
					not helper.is_explicit (current_feature, "wrapping") and not helper.is_lemma (a_feature) then
					l_call := factory.procedure_call ("unwrap", << factory.std_current >>)
					l_call.node_info.set_attribute ("default", "wrapping")
					l_call.node_info.set_attribute ("cid", system.any_id.out)
					l_call.node_info.set_attribute ("rid", system.any_class.compiled_class.feature_named_32 ("unwrap").rout_id_set.first.out)
					l_call.node_info.set_line (a_feature.body.start_location.line)
					l_implementation.body.add_statement (l_call)
				end
			end

				-- Process statements (byte node tree)
			helper.set_up_byte_context (current_feature, current_type)
			if attached Context.byte_code as l_byte_code then
				if l_byte_code.compound /= Void and then not l_byte_code.compound.is_empty then
					if l_byte_code.locals /= Void then
						across l_byte_code.locals as i loop
							l_type := i.item.deep_actual_type.instantiated_in (current_type)
							translation_pool.add_type (l_type)
							l_local_name := name_translator.boogie_name_for_local (i.cursor_index)
							l_translator.entity_mapping.set_local (i.cursor_index, create {IV_ENTITY}.make (l_local_name, types.for_type_a (l_type)))
							l_implementation.add_local (l_local_name, types.for_type_a (l_type))
						end
					end
					l_translator.process_compound (l_byte_code.compound)
				end
			end

				-- OWNERSHIP: end of routine body
			if options.is_ownership_enabled and not helper.is_lemma (a_feature) then
				if not helper.is_explicit (current_feature, "wrapping") then
					if a_for_creator or helper.is_public (current_feature) and not a_feature.has_return_value then
							-- Set static ghost sets before wrapping
						create l_ownership_handler
						create l_expr_translator.make
						l_expr_translator.set_context (a_feature, a_type)
						l_expr_translator.set_context_line_number (a_feature.body.end_location.line)
						l_ownership_handler.set_static_ghost_sets (l_expr_translator, "wrap")
						l_implementation.body.statements.append (l_expr_translator.side_effect)

						l_call := factory.procedure_call ("wrap", << factory.std_current >>)
						l_call.node_info.set_attribute ("default", "wrapping")
						l_call.node_info.set_attribute ("cid", system.any_id.out)
						l_call.node_info.set_attribute ("rid", system.any_class.compiled_class.feature_named_32 ("wrap").rout_id_set.first.out)
						l_call.node_info.set_line (a_feature.body.end_location.line)
						l_implementation.body.add_statement (l_call)
					end
				end
			end
		end

feature -- Translation: Functions

	translate_functional_representation (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Generate a Boogie function that encodes the result of Eiffel function `a_feature' and its definitional axiom.
		local
			l_function: IV_FUNCTION
			l_proc: IV_PROCEDURE
			l_post: IV_POSTCONDITION
			l_fcall: IV_FUNCTION_CALL
			l_boogie_type: IV_TYPE
			l_type: TYPE_A
			i: INTEGER
		do
			set_context (a_feature, a_type)
			helper.set_up_byte_context (current_feature, current_type)

				-- Function
			create l_function.make (
				name_translator.boogie_function_for_feature (current_feature, current_type),
				types.for_type_a (a_feature.type.deep_actual_type.instantiated_in (current_type))
			)
			boogie_universe.add_declaration (l_function)
			create l_fcall.make (l_function.name, l_function.type)

				-- Arguments
			translation_pool.add_type (current_type)
			l_function.add_argument ("heap", types.heap)
			l_function.add_argument ("current", types.ref)
			l_fcall.add_argument (factory.old_ (factory.global_heap))
			l_fcall.add_argument (factory.std_current)
			from i := 1 until i > current_feature.argument_count loop
				l_type := current_feature.arguments.i_th (i).deep_actual_type.instantiated_in (current_type)
				translation_pool.add_type (l_type)
				l_boogie_type := types.for_type_a (l_type)
				l_function.add_argument (current_feature.arguments.item_name (i), l_boogie_type)
				l_fcall.add_argument (factory.entity (current_feature.arguments.item_name (i), l_boogie_type))
				i := i + 1
			end

				-- Axiom
			if helper.is_functional (a_feature) then
				generate_definition_from_body (l_function)
					-- Also add a precondition predicate, which can be checked when the feature is called as a function
				if a_feature.has_precondition then
					translation_pool.add_precondition_predicate (a_feature, a_type)
				end
			else
				generate_definition_from_post (l_function)
					-- Add a postcondition to the corresponding procedure connecting it to the function
					-- (so that properties claimed about the function can be traced back to the procedure result).
				l_proc := boogie_universe.procedure_named (name_translator.boogie_procedure_for_feature (current_feature, current_type))
				check attached l_proc and then not l_proc.results.is_empty end
				create l_post.make (factory.equal (l_proc.results.first.entity, l_fcall))
				l_post.set_free
				l_proc.add_contract (l_post)
			end
		end

	translate_frame_function (a_feature: FEATURE_I; a_type: TYPE_A; a_read: BOOLEAN)
			-- Translate the frame function of feature `a_feature' of type `a_type';
			-- (translate the read frame for the functional representation if `a_read' and the write frame otherwise)
		require
			read_for_pure_functions: a_read implies helper.has_functional_representation (a_feature)
		local
			l_exprs: like frame_expressions_of
			l_function: IV_FUNCTION
			l_forall: IV_FORALL
			l_fcall: IV_FUNCTION_CALL
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			set_context (a_feature, a_type)
			helper.set_up_byte_context (current_feature, current_type)

				-- Frame function
			if a_read then
				create l_function.make (name_translator.boogie_function_for_read_frame (current_feature, current_type), types.frame)
			else
				create l_function.make (name_translator.boogie_function_for_write_frame (current_feature, current_type), types.frame)
			end
			boogie_universe.add_declaration (l_function)

				-- Arguments
			translation_pool.add_type (current_type)
			l_function.add_argument ("heap", types.heap)
			l_function.add_argument ("current", types.ref)
			across arguments_of_current_feature as i loop
				l_function.add_argument (i.item.name, i.item.boogie_type)
			end

				-- Get the modified objects and apply defaults
			create l_translator.make
			l_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
			l_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
			l_translator.set_context (current_feature, current_type)
			if a_read then
				l_exprs := read_expressions_of (contracts_of (current_feature, current_type).reads, l_translator)

					-- Defaults and validity
				if l_exprs.full_objects.is_empty and l_exprs.partial_objects.is_empty then
					-- Missing modify clause: apply defaults
					l_exprs.full_objects.extend (create {IV_ENTITY}.make ("current", types.ref))
				end
			else
				l_exprs := modify_expressions_of (contracts_of (current_feature, current_type).modifies, l_translator)

					-- Defaults and validity
				if l_exprs.full_objects.is_empty and l_exprs.partial_objects.is_empty then
					-- Missing modify clause: apply defaults
					if not a_feature.has_return_value then
						l_exprs.full_objects.extend (create {IV_ENTITY}.make ("current", types.ref))
					end
				elseif a_feature.has_return_value and not helper.is_feature_status (a_feature, "impure") and not is_pure (l_exprs) then
					-- Only impure functions are allowed to have modify clauses
					helper.add_semantic_error (a_feature, messages.pure_function_has_mods, -1)
				end
			end

				-- Definitional axiom
				-- (forall args :: frame_defintition (f (args)))
			create l_fcall.make (l_function.name, types.frame)
			across l_function.arguments as a loop
				l_fcall.add_argument (a.item.entity)
			end
			create l_forall.make (frame_definition (l_exprs, l_fcall))
			across l_function.arguments as a
			loop
				l_forall.add_bound_variable (a.item.entity.name, a.item.entity.type)
			end
			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	translate_variant_functions (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate the decreases of feature `a_feature' of type `a_type'.
		local
			l_decreases_list: like decreases_expressions_of
			l_entity: IV_ENTITY
			l_function: IV_FUNCTION
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			set_context (a_feature, a_type)
			helper.set_up_byte_context (current_feature, current_type)

			create l_translator.make
			l_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
			l_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
			l_translator.set_context (current_feature, current_type)
			l_decreases_list := decreases_expressions_of (contracts_of (current_feature, current_type).decreases, l_translator)
			if l_decreases_list.is_empty then
				-- No decreases clause: apply default
				across arguments_of_current_feature as j loop
					if j.item.boogie_type.has_rank then
						create l_entity.make (j.item.name, j.item.boogie_type)
						l_decreases_list.extend (l_entity)
					end
				end
					-- If still empty, add a trivial variant
				if l_decreases_list.is_empty then
					l_decreases_list.extend (factory.int_value (0))
				end
			elseif l_decreases_list.first = Void then
				-- Decreases empty set (*): do not check termination
				l_decreases_list.wipe_out
			end

				-- Generate a function per variant
			across
				l_decreases_list as i
			loop
				if i.item.type.has_rank then
						-- Decreases function
					create l_function.make (name_translator.boogie_function_for_variant (i.target_index, current_feature, current_type), i.item.type)
					l_function.set_inline
					boogie_universe.add_declaration (l_function)

						-- Arguments
					translation_pool.add_type (current_type)
					l_function.add_argument ("heap", types.heap)
					l_function.add_argument ("current", types.ref)
					across arguments_of_current_feature as j loop
						l_function.add_argument (j.item.name, j.item.boogie_type)
					end
					l_function.set_body (i.item)
				else
					helper.add_semantic_error (a_feature, messages.variant_bad_type (i.target_index), -1)
				end
			end
		end

feature {NONE} -- Translation: Functions

	generate_definition_from_body (a_function: IV_FUNCTION)
			-- Generate a definitional axiom for `a_function' from the body of the current functional feature.
		require
			is_functional: helper.is_functional (current_feature)
		local
			l_expr_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			if attached Context.byte_code and then functional_body (Context.byte_code.compound) /= Void then
					-- Translate expression
				create l_expr_translator.make
				l_expr_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
				l_expr_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
				l_expr_translator.set_context (current_feature, current_type)
				functional_body (Context.byte_code.compound).process (l_expr_translator)
				a_function.set_body (l_expr_translator.last_expression)
			else
				helper.add_semantic_error (current_feature, messages.functional_feature_not_single_assignment, -1)
			end
		end

	functional_body (a_body: BYTE_LIST [BYTE_NODE]): detachable EXPR_B
			-- The expression of a functional feature with body `a_body',
			-- if it has the right shape, otherwise Void.
		do
			if attached a_body and then 													-- body exists
				not a_body.is_empty and then												-- body has instructions
				attached {ASSIGN_B} a_body.last as l_assign_b and then						-- last instruction is an assignment...
				attached {RESULT_B} l_assign_b.target and then								-- ... to Result
				across a_body as c all not c.is_last implies attached {CHECK_B} c.item end	-- All instructions but last are checks
			then
				Result := l_assign_b.source
			end
		end

	generate_definition_from_post (a_function: IV_FUNCTION)
			-- Generate a definitional axiom for `a_function' from the postcondition of the current feature.
		local
			l_contracts: like pre_post_expressions_of
			l_axiom: IV_AXIOM
			l_forall: IV_FORALL
			l_pre: IV_EXPRESSION
			l_entity_mapping: E2B_ENTITY_MAPPING
		do
			l_entity_mapping := translator_for_function (a_function).entity_mapping
			l_contracts := pre_post_expressions_of (current_feature, current_type, l_entity_mapping)
			if options.is_ownership_enabled and helper.is_public (current_feature) then
				-- Add ownership default precondition
				l_pre := factory.and_clean (l_contracts.pre, factory.heap_access (l_entity_mapping.heap.name, l_entity_mapping.current_expression, "closed", types.bool))
			else
				l_pre := l_contracts.pre
			end
			create l_forall.make (factory.implies_ (l_pre, l_contracts.post))
			l_forall.bound_variables.append (a_function.arguments)
			create l_axiom.make (l_forall)
			boogie_universe.add_declaration (l_axiom)
		end

	translator_for_function (a_function: IV_FUNCTION): E2B_CONTRACT_EXPRESSION_TRANSLATOR
			-- Translator that maps `Result' to the invocation of `a_function'.
		local
			i: INTEGER
			l_function_call: IV_FUNCTION_CALL
			l_boogie_type: IV_TYPE
			l_type: TYPE_A
		do
			create Result.make
			Result.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
			Result.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
			Result.set_context (current_feature, current_type)
			create l_function_call.make (a_function.name, a_function.type)
			l_function_call.add_argument (Result.entity_mapping.heap)
			l_function_call.add_argument (Result.entity_mapping.current_expression)
			from i := 1 until i > current_feature.argument_count loop
				l_type := current_feature.arguments.i_th (i).deep_actual_type.instantiated_in (current_type)
				l_boogie_type := types.for_type_a (l_type)
				l_function_call.add_argument (create {IV_ENTITY}.make(current_feature.arguments.item_name (i), l_boogie_type))
				i := i + 1
			end
			Result.entity_mapping.set_result (l_function_call)
		end

feature -- Translation: agents		

	translate_precondition_predicate (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate precondition predicate of feature `a_feature' of type `a_type'.
		local
			l_function: IV_FUNCTION
			l_mapping: E2B_ENTITY_MAPPING
			l_entity: IV_ENTITY
			i: INTEGER
		do
			set_context (a_feature, a_type)

				-- Function declaration
			create l_function.make (name_translator.precondition_predicate_name (current_feature, current_type), types.bool)
			create l_mapping.make

			if not helper.is_class_logical (a_type.base_class) then
					-- Only non-logical features depend on the heap
				l_entity := factory.heap_entity ("heap")
				l_function.add_argument (l_entity.name, l_entity.type)
				l_mapping.set_heap (l_entity)
			end

			if not helper.is_class_logical (a_type.base_class) or (create {E2B_CUSTOM_LOGICAL_HANDLER}).has_arg_current (a_feature) then
					-- Non-logical features and some logical once take "current" as the first argument
				create l_entity.make ("current", types.for_type_a (a_type))
				l_function.add_argument (l_entity.name, l_entity.type)
				l_mapping.set_current (l_entity)
			end

			from i := 1 until i > a_feature.argument_count loop
				create l_entity.make (a_feature.arguments.item_name (i), types.for_type_in_context (a_feature.arguments.i_th (i), current_type))
				l_function.add_argument (l_entity.name, l_entity.type)
				l_mapping.set_argument (i, l_entity)
				i := i + 1
			end
			l_function.set_body (pre_post_expressions_of (a_feature, a_type, l_mapping).pre)
			boogie_universe.add_declaration (l_function)
		end

	translate_postcondition_predicate (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate postconditino predicate of feature `a_feature' of type `a_type'.
		local
			l_procedure: IV_PROCEDURE
			l_function: IV_FUNCTION
			l_axiom: IV_AXIOM
		do
			set_context (a_feature, a_type)

			l_procedure := boogie_universe.procedure_named (name_translator.boogie_procedure_for_feature (current_feature, current_type))
			check l_procedure /= Void end
			current_boogie_procedure := l_procedure

				-- Function declaration
			create l_function.make (name_translator.postcondition_predicate_name (current_feature, current_type), types.bool)
			l_function.add_argument ("heap", types.heap)
			l_function.add_argument ("old_heap", types.heap)
			across current_boogie_procedure.arguments as i loop
				l_function.add_argument (i.item.name, i.item.type)
			end
			if a_feature.has_return_value then
				l_function.add_argument ("result", types.for_type_a (a_feature.type))
			end
			boogie_universe.add_declaration (l_function)

				-- Axioms per redefinition.
			generate_postcondition_axiom (current_feature, current_type, current_type)
				-- TODO: generate postcondition axiom for all known subtypes with redefined contracts
			if not current_feature.written_class.name_in_upper.is_equal ("ANY") then
				across current_feature.written_class.direct_descendants as d loop
					generate_postcondition_axiom (d.item.feature_named_32 (current_feature.feature_name_32), current_type, d.item.actual_type)
				end
			end
--			current_feature.written_class.direct_descendants.item.feature_of_rout_id_set (current_feature.rout_id_set)
		end

	generate_postcondition_axiom (a_feature: FEATURE_I; a_context_type: TYPE_A; a_postcondition_type: TYPE_A)
			-- Generate postcondition axiom for `current_feature' of type `a_context_type' for subtype `a_postcondition_type'.
		local
			l_contracts: TUPLE [pre: IV_EXPRESSION; post: IV_EXPRESSION]
			l_mapping: E2B_ENTITY_MAPPING
			l_heap, l_old_heap, l_current, l_result, l_arg: IV_ENTITY
			l_args: LINKED_LIST [IV_ENTITY]
			l_forall: IV_FORALL
			l_axiom: IV_AXIOM
			l_fcall, l_typeof: IV_FUNCTION_CALL
			l_type_value: IV_VALUE
			l_binop1, l_binop2, l_binop3: IV_BINARY_OPERATION
			i: INTEGER
		do
			create l_mapping.make
			create l_fcall.make (name_translator.postcondition_predicate_name (a_feature, a_context_type), types.bool)
			l_heap := factory.heap_entity ("heap")
			l_fcall.add_argument (l_heap)
			l_mapping.set_heap (l_heap)
			l_old_heap := factory.heap_entity ("old_heap")
			l_fcall.add_argument (l_old_heap)
			l_mapping.set_old_heap (l_old_heap)
			create l_current.make ("current", types.ref)
			l_fcall.add_argument (l_current)
			l_mapping.set_current (l_current)
			create l_args.make
			from i := 1 until i > a_feature.argument_count loop
				create l_arg.make (a_feature.arguments.item_name (i), types.for_type_a (a_feature.arguments.i_th (i)))
				l_fcall.add_argument (l_arg)
				l_mapping.set_argument (i, l_arg)
				l_args.extend (l_arg)
				i := i + 1
			end
			if a_feature.has_return_value then
				create l_result.make ("result", types.for_type_a (a_feature.type))
				l_fcall.add_argument (l_result)
				l_mapping.set_result (l_result)
			end

			l_contracts := pre_post_expressions_of (a_feature, a_postcondition_type, l_mapping)
			create l_typeof.make ("type_of", types.type)
			l_typeof.add_argument (l_current)
			create l_type_value.make (name_translator.boogie_name_for_type (a_postcondition_type), types.type)
			create l_binop1.make (l_typeof, "<:", l_type_value, types.bool)
			create l_binop2.make (l_fcall, "==>", l_contracts.post, types.bool)
			create l_binop3.make (l_binop1, "==>", l_binop2, types.bool)

			create l_forall.make (l_binop3)
			l_forall.add_bound_variable (l_heap.name, l_heap.type)
			l_forall.add_bound_variable (l_old_heap.name, l_old_heap.type)
			l_forall.add_bound_variable (l_current.name, l_current.type)
			across l_args as j loop
				l_forall.add_bound_variable (j.item.name, j.item.type)
			end
			if a_feature.has_return_value then
				l_forall.add_bound_variable (l_result.name, l_result.type)
			end
			create l_axiom.make (l_forall)
			boogie_universe.add_declaration (l_axiom)
		end

feature {NONE} -- Implementation

	set_inlining_options_for_feature (a_feature: FEATURE_I)
			-- Set inlining options for feature `a_feature'.
		do
			options.set_inlining_depth (0)
			if options.is_inlining_enabled then
				if helper.boolean_feature_note_value (a_feature, "inline") then
					options.set_inlining_depth (1)
				elseif helper.integer_feature_note_value (a_feature, "inline") > 0 then
					options.set_inlining_depth (helper.integer_feature_note_value (a_feature, "inline"))
				elseif options.routines_to_inline.has (a_feature.body_index) then
					options.set_inlining_depth (1)
				else
					options.set_inlining_depth (0)
				end
			end
		end

	process_precondition (a_assert: ASSERT_B; a_origin_class: CLASS_C)
			-- Process `a_assert' as precondition inherited from `a_origin_class'.
		local
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
			l_contract: IV_PRECONDITION
		do
			create l_translator.make
			l_translator.set_context (current_feature, current_type)
			l_translator.set_origin_class (a_origin_class)
			l_translator.set_context_line_number (a_assert.line_number)
			l_translator.set_context_tag (a_assert.tag)
			a_assert.process (l_translator)
			across l_translator.side_effect as i loop
				create l_contract.make (i.item.expression)
				l_contract.node_info.load (i.item.node_info)
				current_boogie_procedure.add_contract (l_contract)
			end
			create l_contract.make (l_translator.last_expression)
			l_contract.node_info.set_type ("pre")
			l_contract.node_info.set_tag (a_assert.tag)
			l_contract.node_info.set_line (a_assert.line_number)
			if options.is_precondition_predicate_enabled then
				l_contract.set_free
			end
			current_boogie_procedure.add_contract (l_contract)
		end

	process_postcondition (a_assert: ASSERT_B; a_origin_class: CLASS_C; a_fields: LIST [TUPLE [IV_EXPRESSION, IV_ENTITY]])
			-- Process `a_assert' as postcondition.
		local
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
			l_contract: IV_POSTCONDITION
		do
			create l_translator.make
			l_translator.set_context (current_feature, current_type)
			l_translator.set_origin_class (a_origin_class)
			l_translator.set_context_line_number (a_assert.line_number)
			l_translator.set_context_tag (a_assert.tag)
			a_assert.process (l_translator)
			a_fields.append (l_translator.field_accesses)
			across l_translator.side_effect as i loop
				create l_contract.make (i.item.expression)
				l_contract.node_info.load (i.item.node_info)
				current_boogie_procedure.add_contract (l_contract)
			end
			create l_contract.make (l_translator.last_expression)
			l_contract.node_info.set_type ("post")
			l_contract.node_info.set_tag (a_assert.tag)
			l_contract.node_info.set_line (a_assert.line_number)
			current_boogie_procedure.add_contract (l_contract)
		end

	process_fields_list (a_fields: LIST [TUPLE [o: IV_EXPRESSION; f: IV_ENTITY]])
			-- Process fields list.
		local
			l_type_var: IV_VAR_TYPE
			l_postcondition: IV_POSTCONDITION
			l_forall: IV_FORALL
			l_or: IV_BINARY_OPERATION
			l_expr: IV_EXPRESSION
			l_fcall: IV_FUNCTION_CALL
			o, f: IV_ENTITY
		do
			create l_type_var.make_fresh
			create o.make ("$o", types.ref)
			create f.make ("$f", types.field (l_type_var))
			across a_fields as i loop
				l_or := factory.or_ (factory.not_equal (o, i.item.o), factory.not_equal (f, i.item.f))
				if l_expr = Void then
					l_expr := l_or
				else
					l_expr := factory.and_ (l_expr, l_or)
				end
			end
			if l_expr = Void then
				l_expr := factory.true_
			end
			create l_forall.make (factory.implies_ (l_expr,
				factory.equal (factory.heap_access ("Heap", o, f.name, l_type_var), factory.heap_access ("old(Heap)", o, f.name, l_type_var))))
			l_forall.add_type_variable (l_type_var.name)
			l_forall.add_bound_variable (o.name, o.type)
			l_forall.add_bound_variable (f.name, f.type)
			create l_postcondition.make (l_forall)
			l_postcondition.node_info.set_type ("frame")
			if not options.is_checking_frame then
				l_postcondition.set_free
			end

			current_boogie_procedure.add_contract (l_postcondition)
		end

	add_precondition_predicate
			-- Add precondition predicate to current feature.
		local
			l_call: IV_FUNCTION_CALL
			l_pre: IV_PRECONDITION
		do
			translation_pool.add_precondition_predicate (current_feature, current_type)
			create l_call.make (name_translator.precondition_predicate_name (current_feature, current_type), types.bool)
			l_call.add_argument (factory.global_heap)
			across current_boogie_procedure.arguments as i loop
				l_call.add_argument (i.item.entity)
			end
			create l_pre.make (l_call)
			current_boogie_procedure.add_contract (create {IV_PRECONDITION}.make (l_call))
		end

	add_postcondition_predicate
			-- Add postcondition predicate to current feature.
		local
			l_call: IV_FUNCTION_CALL
			l_post: IV_POSTCONDITION
		do
			translation_pool.add_postcondition_predicate (current_feature, current_type)
			create l_call.make (name_translator.postcondition_predicate_name (current_feature, current_type), types.bool)
			l_call.add_argument (factory.global_heap)
			l_call.add_argument (factory.old_heap)
			across current_boogie_procedure.arguments as i loop
				l_call.add_argument (i.item.entity)
			end
			if current_feature.has_return_value then
				l_call.add_argument (create {IV_ENTITY}.make ("Result", types.for_type_a (current_feature.type)))
			end
			create l_post.make (l_call)
			l_post.set_free
			current_boogie_procedure.add_contract (l_post)
		end

	add_pure_frame_condition
			-- Add pure frame condition to current feature.
		local
			l_postcondition: IV_POSTCONDITION
			l_equal: IV_BINARY_OPERATION
		do
			create l_equal.make (factory.global_heap, "==", factory.old_heap, types.bool)
			create l_postcondition.make (l_equal)
			l_postcondition.node_info.set_type ("frame")
			current_boogie_procedure.add_contract (l_postcondition)
		end

	add_pure_fresh_frame_condition
			-- Add pure frame condition to current feature.
		local
			l_type_var: IV_VAR_TYPE
			l_postcondition: IV_POSTCONDITION
			l_forall: IV_FORALL
			l_or: IV_BINARY_OPERATION
			l_expr: IV_EXPRESSION
			l_fcall: IV_FUNCTION_CALL
			l_access, l_old_access, l_old_allocated: IV_MAP_ACCESS
			o: IV_ENTITY
		do
			create l_type_var.make_fresh
			create o.make ("$o", types.ref)
			l_access := factory.heap_access ("Heap", o, "$f", l_type_var)
			l_old_access := factory.heap_access ("old(Heap)", o, "$f", l_type_var)
			l_old_allocated := factory.heap_access ("old(Heap)", o, "allocated", types.bool)
			create l_forall.make (factory.implies_ (l_old_allocated, factory.equal (l_access, l_old_access)))
			l_forall.add_type_variable (l_type_var.name)
			l_forall.add_bound_variable ("$o", types.ref)
			l_forall.add_bound_variable ("$f", types.field (l_type_var))
			create l_postcondition.make (l_forall)
			l_postcondition.node_info.set_type ("frame")
			if not options.is_checking_frame then
				l_postcondition.set_free
			end
			current_boogie_procedure.add_contract (l_postcondition)
		end

	forall_mml_set_property (a_target_name: STRING; a_set_name: STRING; a_function_name: STRING): IV_EXPRESSION
			-- Expression "(forall i :: Heap[a_target_name, a_set_name][i] ==> a_function_name(Heap, i))"
		local
			l_forall: IV_FORALL
			l_i: IV_ENTITY
		do
			create l_i.make (helper.unique_identifier ("i"), types.ref)
			create l_forall.make (
				factory.implies_ (
					factory.map_access (factory.heap_access ("Heap", create {IV_ENTITY}.make (a_target_name, types.ref), a_set_name, types.set (types.ref)), << l_i >>),
					factory.function_call (a_function_name, << factory.global_heap, l_i >>, types.bool)))
			l_forall.add_bound_variable (l_i.name, l_i.type)
			Result := l_forall
		end

end
