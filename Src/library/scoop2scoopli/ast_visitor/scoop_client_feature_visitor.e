note
	description: "[
					Roundtrip visitor to generate client features out of original features. It uses specific visitors to handle the creation of locking requestors, enclosing routines, wait condition wrappers, and postcondition wrappers for features with separate arguments.
					
					Additionally the visitor handles the following aspects:
					
					- It handles the modification of call chains that involve calls to redeclared features.
					- It handles object tests and assignment attempts.
					- It handles agents.
					- It adds individual separate postcondition wrappers. These wrappers are always effective, so that they can be inherited by effective classes without redefinition.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_feature_as,
			process_keyword_as,
			process_object_test_as,
			process_reverse_as,
			process_routine_as,
			process_body_as,
			process_create_creation_as,
			process_create_creation_expr_as,
			process_access_feat_as,
			process_access_assert_as,
			process_access_inv_as,
			process_access_id_as,
			process_static_access_as,
			process_precursor_as,
			process_result_as,
			process_current_as,
			process_parameter_list_as,
			process_inline_agent_creation_as,
			process_agent_routine_creation_as,
			process_assign_as,
			process_instr_call_as
		end

create
	make

feature -- Access

	add_client_features (l_as: FEATURE_AS)
			-- Add the client features for the original feature 'l_as'.
		do
			safe_process (l_as)
		end

feature {NONE} -- General implementation

	process_feature_as (l_as: FEATURE_AS)
		local
			i, nb: INTEGER
			l_infix_prefix: INFIX_PREFIX_AS
			l_does_feature_lock_arguments: BOOLEAN
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_feature_assertion_visitor: SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR
			l_feature_lr_visitor: SCOOP_CLIENT_FEATURE_LR_VISITOR
			l_feature_er_visitor: SCOOP_CLIENT_FEATURE_ER_VISITOR
			l_feature_wc_visitor: SCOOP_CLIENT_FEATURE_WC_VISITOR
			l_feature_nsp_visitor: SCOOP_CLIENT_FEATURE_NSP_VISITOR
			l_feature_sp_visitor: SCOOP_CLIENT_FEATURE_SP_VISITOR
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT
		do
			-- Update the workbench with the feature and a fresh feature object.
			set_current_feature_as (l_as)
			set_feature_object (create {SCOOP_CLIENT_FEATURE_OBJECT}.make)
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				derived_class_information.set_wrapper_insertion_index (ctxt.cursor_to_current_position)
			end

			-- Check whether the feature is an attribute or a constant.
			if l_as.is_attribute or l_as.is_constant then
				-- The feature is an attribute or a constant.
				last_index := l_as.first_token (match_list).index - 1
				context.add_string ("%N%N%T")
				safe_process (l_as.feature_names)
				safe_process (l_as.body)
			else
				-- The feature is a routine.

				-- get feature name visitor
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
				-- create assertion visitor
				l_feature_assertion_visitor := scoop_visitor_factory.new_client_feature_assertion_visitor (context)
				-- create locking request body (feature, procedure, deferred routines)
				l_feature_lr_visitor := scoop_visitor_factory.new_client_feature_lr_visitor (context)
				-- create enclosing routine body (feature, procedure, deferred routines)
				l_feature_er_visitor := scoop_visitor_factory.new_client_feature_er_visitor (context)
				-- create wait condition wrapper (feature, procedure, deferred routines)
				l_feature_wc_visitor := scoop_visitor_factory.new_client_feature_wc_visitor (context)
				-- create non separate postcondition clauses wrapper
				l_feature_nsp_visitor := scoop_visitor_factory.new_client_feature_nsp_visitor (context)
				-- create separate postcondition clauses wrapper
				l_feature_sp_visitor := scoop_visitor_factory.new_client_feature_sp_visitor (context)

				-- create for each feature name a new body
				-- (and also for the other SCOOP routines)
				from
					i := 1
					nb := l_as.feature_names.count
					l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor
				until
					i > nb
				loop
					l_does_feature_lock_arguments := False
					-- check if there are separate arguments
					if l_as.body /= Void and then l_as.body.arguments /= void then
						from
							l_as.body.arguments.start
							create l_arguments.make
						until
							l_as.body.arguments.after
						loop
							l_type_expr_visitor.resolve_type_in_workbench (l_as.body.arguments.item.type)
							if
								l_type_expr_visitor.resolved_type.is_separate and
								attached {ATTACHABLE_TYPE_A} l_type_expr_visitor.resolved_type as attachable_resolved_type and then
								(attachable_resolved_type.has_attached_mark or not attachable_resolved_type.has_detachable_mark)
							then
								l_does_feature_lock_arguments := True
								l_arguments.separate_arguments.extend (l_as.body.arguments.item)
							else
								l_arguments.non_separate_arguments.extend (l_as.body.arguments.item)
							end
							l_as.body.arguments.forth
						end
						feature_object.set_arguments (l_arguments)
					end

					-- identify frozen key word
					last_index := l_as.feature_names.i_th (i).first_token (match_list).index
					if l_as.feature_names.i_th (i).is_frozen and then
					   l_as.feature_names.i_th (i).frozen_keyword.index /= 0 then
						feature_object.is_feature_frozen.set_item (True)
					end

					-- process name
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), False)
					feature_object.set_feature_name (l_feature_name_visitor.feature_name)
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), True)
					feature_object.set_feature_alias_name (l_feature_name_visitor.feature_name)
					-- declaration name writes the infix and non-infix notation if the feature name
					-- contains an infix name. Change this to an alias notation in EiffelStudio 6.4
					l_feature_name_visitor.process_feature_declaration_name (l_as.feature_names.i_th (i))
					feature_object.set_feature_declaration_name (l_feature_name_visitor.feature_name)


					if l_does_feature_lock_arguments then

						-- assertion visitor
						is_processing_assertions := True
						l_feature_assertion_visitor.analyze_precondition_and_postcondition (l_as.body)
						is_processing_assertions := False

						-- get result objects
						feature_object.set_preconditions (l_feature_assertion_visitor.preconditions)
						feature_object.set_postconditions (l_feature_assertion_visitor.postconditions)

						-- locking request body (feature, procedure, deferred routines)
						l_feature_lr_visitor.add_locking_requestor (l_as.body)

						-- enclosing routine body (feature, procedure, deferred routines)
						l_feature_er_visitor.add_enclosing_routine (l_as.body)

						-- wait condition wrapper (feature, procedure, deferred routines)
						l_feature_wc_visitor.add_wait_condition_wrapper (l_as.body)

						-- postcondition processing
						if
							not feature_object.postconditions.separate_postconditions.is_empty or
							not feature_object.postconditions.non_separate_postconditions.is_empty
						then
							-- unseparated postcondition attribute
							add_unseparated_postcondition_attribute
						end

						if not feature_object.postconditions.non_separate_postconditions.is_empty then
							-- non separate postcondition clauses wrapper
							l_feature_nsp_visitor.add_non_separate_postcondition_wrapper (l_as.body)
						end

						if not feature_object.postconditions.separate_postconditions.is_empty then
							-- separate postcondition clauses wrapper
							l_feature_sp_visitor.add_separate_postcondition_wrapper (l_as.body)
						end

						-- postcondition processing
						add_individual_separate_postcondition_wrappers
					else
							-- print original feature
						context.add_string ("%N%N%T")
						if feature_object.is_feature_frozen then
							context.add_string ("frozen ")
						end
						context.add_string (feature_object.feature_alias_name + " ")
						last_index := l_as.body.first_token (match_list).index - 1

						safe_process (l_as.body)

						-- add a wrapper feature from the old infix notation to
						-- the non-infix notation version
						-- Remove this call with EiffelStudio 6.4
						l_infix_prefix ?= l_as.feature_names.i_th (i)
						if l_infix_prefix /= Void then
							l_feature_name_visitor.process_declaration_infix_prefix (l_infix_prefix)

							create_infix_feature_wrapper(l_as, l_feature_name_visitor.feature_name, feature_object.feature_name)
						end
					end

					i := i + 1
				end

			end

			-- invalidate workbench access
			set_current_feature_as_void
			set_feature_object (Void)
		end

	process_keyword_as (l_as: KEYWORD_AS)
			-- Process `l_as'.
		do
			if l_as.is_frozen_keyword then
				Precursor (l_as)
				-- add a space after the frozen keyword before printing the feature name
				context.add_string (" ")
			else
				Precursor (l_as)
			end
		end

	create_infix_feature_wrapper (l_as: FEATURE_AS; an_original_feature_name, a_feature_name: STRING)
			-- Remove this feature with EiffelStudio 6.4
			-- It creates a wrapper feature so that a call on a infix feature
			-- is wrapped to the non-infix version
		local
			i, nb: INTEGER
			l_last_index: INTEGER
			l_type_dec: TYPE_DEC_AS
			l_argument_list: FORMAL_ARGU_DEC_LIST_AS
		do
			-- save index
			l_last_index := last_index

			context.add_string ("%N%N%T" + an_original_feature_name + " ")

			last_index := l_as.body.first_token (match_list).index - 1

			safe_process (l_as.body.internal_arguments)
			safe_process (l_as.body.colon_symbol (match_list))
			safe_process (l_as.body.type)
			-- skip assigner
			--safe_process (l_as.assign_keyword (match_list))
			--safe_process (l_as.assigner)
			last_index := l_as.body.is_keyword_index - 1
			context.add_string (" ")
			safe_process (l_as.body.is_keyword (match_list))

			-- add comment
			context.add_string ("%N%T%T%T-- Feature wrapper for infix / prefix feature.")
			context.add_string ("%N%T%T%T-- Hack for EiffelStudio 6.3")

			if l_as.is_deferred then
				-- add deferred keyword
				context.add_string ("%N%T%Tdeferred")
			else
				-- add do keyword
				context.add_string ("%N%T%Tdo")

				-- add call to non_infix feature
				context.add_string ("%N%T%T%TResult := " + a_feature_name + " ")

				-- add internal argument as actual arguments
				if l_as.body.internal_arguments /= Void then
					l_argument_list := l_as.body.internal_arguments

					-- add bracket
					context.add_string ("(")

					from
						i := 1
						nb := l_argument_list.arguments.count
					until
						i > nb
					loop
						l_type_dec := l_argument_list.arguments.i_th (i)

						last_index := l_type_dec.first_token (match_list).index - 1
						process_identifier_list (l_type_dec.id_list)

						if i < nb then
							context.add_string (", ")
						end

						i := i + 1
					end

					-- add bracket
					context.add_string (")")
				end
			end

			-- add end keyword
			context.add_string ("%N%T%Tend")

			-- restore current index
			last_index := l_last_index
		end

	add_unseparated_postcondition_attribute
			-- Generate list of unseparated postconditions.
			-- Unseparated postconditions are separate postcondition that involve a non-separate object at run time. They are treated as non-separate postconditions.
		require
			feature_object_is_valid: feature_object /= Void
		do
			context.add_string (
				"%N%N%T" +
				feature_object.feature_name +
				{SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive +
				class_c.name.as_lower +
				{SCOOP_SYSTEM_CONSTANTS}.unseparated_postcondition_attribute_name_additive +
				": " +
				{SCOOP_SYSTEM_CONSTANTS}.unseparated_postcondition_attribute_type
			)
			context.add_string ("%N%T%T-- Precondition clauses of `" + feature_object.feature_name + "' that seem to be separate but are not.")
			context.add_string ("%N%T%T-- They have to be processed as correctness conditions.")
		end

	add_individual_separate_postcondition_wrappers
			-- Generate wrappers for individual separate postcondition clauses.
		local
			i: INTEGER
			current_separate_postcondition: SCOOP_CLIENT_ASSERTION_OBJECT
			l_feature_isp_visitor: SCOOP_CLIENT_FEATURE_ISP_VISITOR
		do
			-- create visitor for individual separate postcondition clauses.
			l_feature_isp_visitor := scoop_visitor_factory.new_client_feature_isp_visitor (context)

			-- iterate over all separate postconditions
			from
				i := 1
			until
				i > feature_object.postconditions.separate_postconditions.count
			loop
				-- get assertion
				current_separate_postcondition := feature_object.postconditions.separate_postconditions.i_th (i)

				-- process feature
				l_feature_isp_visitor.add_individual_separate_postcondition_wrapper (i, current_separate_postcondition)

				i := i + 1
			end
		end

feature {NONE} -- Feature redeclaration handling

	process_routine_as(l_as: ROUTINE_AS)
		local
			l_generics_visitor : SCOOP_GENERICS_VISITOR
		do
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)

			is_processing_assertions := True
			safe_process (l_as.precondition)
			is_processing_assertions := False

			safe_process (l_as.internal_locals)

			--	if not is_in_agent then
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				if not is_in_agent then
					feature_locals_agent_counter :=0
				end
				feature_object.set_locals_index(ctxt.cursor_to_current_position)
			end
		--	end

			if result_substitution then
				if attached {CLASS_TYPE_AS} feature_as.body.type as typ then
					if l_as.internal_locals = void then
						feature_object.set_need_local_section ( True )
					end
					context.add_string ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+": "+typ.class_name.name)
					if attached {GENERIC_CLASS_TYPE_AS} feature_as.body.type then
						l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
						l_generics_visitor.process_internal_generics (typ.generics, false, True)
					end
				end
			end

			safe_process (l_as.routine_body)

			if result_substitution then
				if attached {CLASS_TYPE_AS} feature_as.body.type as typ then
					context.add_string ("%N%T%T%Tif "+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+" /= Void then")
					context.add_string ("%N%T%T%T%TResult := "+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+"."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					context.add_string ("%N%T%T%Telse")
					context.add_string ("%N%T%T%T%TResult := create {"+{SCOOP_SYSTEM_CONSTANTS}.proxy_class_prefix+typ.class_name.name.as_upper)
					if typ.generics /= Void then
						l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
						l_generics_visitor.process_internal_generics (typ.generics, false, True)
					--	last_index := l_generics_visitor.get_last_index
					end
	           		context.add_string ("}.set_processor_ (Current.processor_)%N%T%T%T%TResult.set_implementation_(Void)%N")
	           		context.add_string ("%N%T%T%Tend")
	           	end
			end
			is_processing_assertions := True
			safe_process (l_as.postcondition)
			is_processing_assertions := True

			safe_process (l_as.rescue_keyword (match_list))
			safe_process (l_as.rescue_clause)
			safe_process (l_as.end_keyword)

			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				if feature_object.need_local_section then
					ctxt.insert_after_cursor ("%N%T%Tlocal", feature_object.locals_index)
					feature_object.set_need_local_section( False )
				end
			end

			-- Disable `Result' replacement, unless we are in an agent
			if (not is_in_agent) and (not is_in_inline_agent) then
				result_substitution := false
			end

		end

	process_body_as (l_as: BODY_AS)
		local
			feature_name: FEATURE_NAME
			c_as: CONSTANT_AS
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			l_generics_visitor: SCOOP_GENERICS_VISITOR
			generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
		do
			-- Reset result substitution
			result_substitution := False

			is_internal_arguments := True
			safe_process (l_as.internal_arguments)
			is_internal_arguments := False

			safe_process (l_as.colon_symbol (match_list))

			if l_as.type /= void then

				-- Fix for redeclarations if feature is query type:
				-- If `l_as.type' is non separate but was separate in an ancestor version we need to make it separate
				-- Only a potential problem when return type is `non-separate' and a `CLASS_TYPE_AS'
				-- If `feature_name' is void we are in an attribute or constant

				if attached {CLASS_TYPE_AS} l_as.type as typ then
					create l_assign_finder
					from
						feature_as.feature_names.start
					until
						feature_as.feature_names.after
					loop
						feature_name := feature_as.feature_names.item
						feature_as.feature_names.forth
					end
					if not typ.is_separate then
						-- non Separate: Check if substitution is needed.
						if l_assign_finder.have_to_replace_return_type(feature_name, class_c) then
							context.add_string ({SCOOP_SYSTEM_CONSTANTS}.proxy_class_prefix+typ.class_name.name)
							result_substitution := True
	--						seperate_result_signature := typ
						else
							-- No substitution needed, print normaly
							context.add_string (typ.class_name.name)
						end
					else
						-- Separate: No substitution needed, print normaly
						context.add_string ({SCOOP_SYSTEM_CONSTANTS}.proxy_class_prefix+typ.class_name.name)
					end
				else
					safe_process (l_as.type)
				end
				-- Print generics and check if they need a substitution
				if attached {GENERIC_CLASS_TYPE_AS} l_as.type as gen_typ then
						l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
						generics_to_substitute := l_assign_finder.generic_parameters_to_replace (feature_name, class_c, False, Void, True)
						if not generics_to_substitute.is_empty then
							l_generics_visitor.set_generics_to_substitute (generics_to_substitute)
						end
						l_generics_visitor.process_internal_generics (gen_typ.generics, false, True)


					--	last_index := l_generics_visitor.get_last_index
				end
			last_index := l_as.type.last_token (match_list).index
			end
--			if not result_substitution then
--				-- Nothing was done -> process normally
--				safe_process (l_as.type)
--			else
		--		last_index := l_as.type.last_token (match_list).index
--			end
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			c_as ?= l_as.content
			if c_as /= Void then
				l_as.content.process (Current)
				safe_process (l_as.indexing_clause)
			else
				safe_process (l_as.indexing_clause)
				safe_process (l_as.content)
			end

			-- Wipe out `internal_arguments_to_substitute'
			feature_object.internal_arguments_to_substitute.wipe_out

		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			if l_as.call /= void and then l_as.call.internal_parameters /= void and then l_as.call.internal_parameters.parameters /= void then
				accessed_feature := l_as.call.feature_name
			end

			Precursor (l_as)
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			if l_as.call /= void and then l_as.call.internal_parameters /= void and then l_as.call.internal_parameters.parameters /= void then
				accessed_feature := l_as.call.feature_name
			end

			Precursor (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				accessed_feature := l_as.feature_name
			end

			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If the current level type is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					-- If this is separate, no fix needed anyway.
					--l_class_c := system.class_of_id (class_as_by_name(a_type_a.name).class_id)
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(l_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				accessed_feature := l_as.feature_name
			end

			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If the current level type is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					-- If this is separate, no fix needed anyway.
					--l_class_c := system.class_of_id (class_as_by_name(a_type_a.name).class_id)
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(l_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				accessed_feature := l_as.feature_name
			end

			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If the current level type is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					-- If this is separate, no fix needed anyway.
					--l_class_c := system.class_of_id (class_as_by_name(a_type_a.name).class_id)
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(l_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				-- Save accessed feature
				accessed_feature := l_as.feature_name
			end

			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If `a_type_a' is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(l_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				-- Save accessed feature
				accessed_feature := l_as.feature_name
			end

			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If `a_type_a' is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(l_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				-- Save accessed feature
				accessed_feature := feature_as.feature_name
			end


			Precursor (l_as)

			if current_level.type /= void and then not attached {VOID_A} current_level.type then
				-- If `a_type_a' is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(feature_as.feature_name, current_level.type.associated_class)
					else
						add_result_type_substitution(feature_as.feature_name, previous_level.type.associated_class)
					end
				end
			end
		end

	process_result_as (l_as: RESULT_AS)
			-- Process `l_as', print it to context.
		do
			if result_substitution then
				process_leading_leaves (l_as.index)
				last_index := l_as.index
				context.add_string ({SCOOP_SYSTEM_CONSTANTS}.nonseparate_result)
				update_current_level_with_call (l_as)
			else
				Precursor (l_as)
			end
		end

	process_current_as (l_as: CURRENT_AS)
		do
			Precursor (l_as)
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'. Add 'Current' as first argument in paramenter list.
			-- For each parameter temporarily add a new levels layer.
		local
			i,pos: INTEGER
			l_count: INTEGER
			a_class_c: CLASS_C
			l_current_accessed_feature: ID_AS
		do
			-- Remember the current accessed feature to restore after a actual argument has been processed. Note that the processing of an actual argument could change the accessed feature, if the actual argument contains a call.
			l_current_accessed_feature := accessed_feature

			safe_process (l_as.lparan_symbol (match_list))

			-- add additional argument 'Current'
			if (previous_level_exists and then previous_level.is_separate) or add_prefix_current_cc then
				add_prefix_current_cc := False
				context.add_string ("Current")
				if l_as.parameters /= void and then not l_as.parameters.is_empty then
					context.add_string (", ")
				end
			end

			-- Get the class where the called feature is in
			if not previous_level_exists then
				-- No call chain, get class of current item
				a_class_c := class_c
			else
				a_class_c := previous_level.type.associated_class
			end


			if l_as.parameters /= Void and then l_as.parameters.count > 0 then
				from
					l_as.parameters.start
					i := 1
					pos := 1
					if l_as.parameters.separator_list /= Void then
						l_count := l_as.parameters.separator_list.count
					end
				until
					l_as.parameters.after
				loop
					-- process the node
					add_levels_layer
					safe_process (l_as.parameters.item)

					-- Restore the accessed feature to the previous value for the next actual argument.
					accessed_feature := l_current_accessed_feature

					-- Check if current Parameter is separate, if it is -> check if fix is needed
					if current_level.type.is_separate then
						if accessed_feature /= void then
							if need_internal_argument_substitution (accessed_feature, a_class_c, pos) then
								context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							end
						end
					end

					remove_current_levels_layer

					if i <= l_count then
						safe_process (l_as.parameters.separator_list_i_th (i, match_list))
						i := i + 1
					end
					pos := pos +1
					l_as.parameters.forth
				end
			end

			safe_process (l_as.rparan_symbol (match_list))
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			process_leading_leaves (l_as.call.first_token (match_list).index)
			if not is_in_agent then
				inlining := compute_inlining(l_as.call.first_token (match_list).index-1)
			end
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				feature_object.set_last_instr_call_index(ctxt.cursor_to_current_position)
			end
			precursor(l_as)
		end

	process_assign_as (l_as: ASSIGN_AS)
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			feature_i: FEATURE_I
		do

			process_leading_leaves (l_as.target.first_token (match_list).index)
			if not is_in_agent then
				inlining := compute_inlining(l_as.target.first_token (match_list).index-1)
			end
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				-- needed to insert agent objects
				feature_object.set_last_instr_call_index(ctxt.cursor_to_current_position)
			end
			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
			feature_i := class_c.feature_named (feature_as.feature_name.name)
			l_type_expression_visitor.evaluate_call_type_in_class_and_feature (l_as.target, class_c, feature_i,flattened_object_tests_layers,flattened_inline_agents_layers )
			if l_type_expression_visitor.is_expression_separate	then
				-- Right side of assign is separate -> Skip result type substitution
				skip_result_type_substitution := True
			end

			Precursor(l_as)

			-- Reset Variable
			skip_result_type_substitution := False
		end

	need_internal_argument_substitution (a_feature_name: ID_AS; a_class_c: CLASS_C; argument_position: INTEGER): BOOLEAN
			-- Do we need to substitute the internal argument?
			-- Needed when current argument is separate and a parent version of the feature has a non separate argument.
		require
			has_name: a_feature_name /= void
			has_class: a_class_c /= void
			valid: not argument_position.is_equal (0)
		local
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			feature_i: FEATURE_I
			l_feature_name: FEATURE_NAME
			has_context: BOOLEAN
		do
			if a_class_c = class_c then
				has_context := true
			end
			create l_assign_finder
			feature_i := a_class_c.feature_named (a_feature_name.name)
			if feature_i /= Void then
				-- Does not have to be the current feature beeing processed, get the name of the feature.
				from
					feature_i.body.feature_names.start
				until
					feature_i.body.feature_names.after
				loop
					if feature_i.body.feature_names.item.visual_name.is_equal (a_feature_name.name) then
						l_feature_name := feature_i.body.feature_names.item
						if l_feature_name /= void and a_class_c.feature_table.item (l_feature_name.internal_name.name).arguments /= Void and then
						   l_assign_finder.have_to_replace_internal_arguments (l_feature_name, a_class_c, argument_position) then
							Result := True
						end
					end
					feature_i.body.feature_names.forth
				end
			end
		end

	is_internal_arguments: BOOLEAN
			-- Are we currently processing internal arguments?
			-- If so we have to check if there is no parent redeclaration of the feature with different argument types (separate / non separate).

	accessed_feature: ID_AS
			-- Accessed feature of the actual arguments we are processing.
			-- i.e a.b.f(c,d) -> f

	result_substitution: BOOLEAN
			-- Is the result type of the feature beeing changed from non separate to separate?
			-- Is the case when a feature with non separate return type has a parent feature redeclaration with separate return type.
			-- If so we replace `Result' in queries with an own object.

	substitute_internal_argument: BOOLEAN
			-- Does the current type of the internal argument have to be substituted?
			-- Is the case if the it is separate and the current feature has a parent redeclaration with non separate argument.

	skip_result_type_substitution: BOOLEAN
			-- Skip result type substition?
			-- Used for preformance improvement like when the right hand side of an assignment is separate we skip the substitution

	add_result_type_substitution (a_feature_name: ID_AS; a_class_c: CLASS_C) is
			-- Check if the result type was substituted in the case where the current result type is non separate and was non separate in a parent redeclaration.
			-- If so add `implementation_' to reconvert.
		require
			has_name: a_feature_name /= void
			has_class: a_class_c /= void
		local
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			feature_i: FEATURE_I
			l_feature_name: FEATURE_NAME
			has_context: BOOLEAN

		do
			-- If we went throuth a `NESTED_AS' this has to be handled there
			-- If target of assignment is separate this is skipped

			if not skip_result_type_substitution then
				if a_class_c = class_c then
					has_context := true
				end
				create l_assign_finder
				feature_i := a_class_c.feature_named (a_feature_name.name)
				if feature_i /= Void then
					-- Might not be the current processing feature, so get the name of the feature
					from
						feature_i.body.feature_names.start
					until
						feature_i.body.feature_names.after
					loop
						if feature_i.body.feature_names.item.visual_name.is_equal (a_feature_name.name) then
							l_feature_name := feature_i.body.feature_names.item
							if l_feature_name /= void and then l_assign_finder.have_to_replace_return_type (l_feature_name, a_class_c) then
								context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							end
						end
						feature_i.body.feature_names.forth
					end
				end
			end
		end

feature -- Agent handling

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		local
			i: INTEGER
--			l_agent: STRING
--			l_agent_sig, l_agent_ass: STRING
--			l_context: ROUNDTRIP_STRING_LIST_CONTEXT
--			l_feature_last_instr_call_index,l_feature_locals_index: LINKED_LIST_CURSOR[STRING]
--			top_level: BOOLEAN
		do
			Precursor (l_as)
			-- The following to be re-enabled after agents within the context of
			-- the base libraries are sorted out.

--			create l_context.make
--			create l_agent_sig.make_empty
--			create l_agent_ass.make_empty
--			l_agent := "l_agent"+feature_locals_agent_counter.out
--			feature_locals_agent_counter := feature_locals_agent_counter+1


--			if not is_in_agent then
--				top_level := TRUE
--				is_in_agent := TRUE
--				create agent_ass_to_update.make_empty
--				create agent_sig_to_update.make_empty
--			else
--				top_level := FALSE
--			end
--			is_in_inline_agent := TRUE

--			-- Do we need to add a local section at the end?
--			if attached {ROUTINE_AS} feature_as.body.content as rout then
--				if rout.internal_locals = void then
--					feature_object.set_need_local_section(True)
--				end
--			end



--			if l_as.body.type /= void then
--				-- has return type
--				l_agent_sig.append ("%N"+inlining+l_agent+": attached FUNCTION[ANY")
----					ctxt.insert_after_cursor ("%N%T%T%T"+l_agent+": FUNCTION[ANY", feature_locals_index)
--			else
--				l_agent_sig.append ("%N"+inlining+l_agent+": attached PROCEDURE[ANY")
----					ctxt.insert_after_cursor ("%N%T%T%T"+l_agent+": PROCEDURE[ANY", feature_locals_index)
--			end


			if l_as.body.arguments /= Void then
--				-- has arguments
--				l_agent_sig.append (", TUPLE[")

				from
					l_as.body.arguments.start
				until
					l_as.body.arguments.after
				loop
--					l_agent_sig.append(l_as.body.arguments.item.type.text (match_list))
					add_to_current_inline_agents_layer (l_as.body.arguments.item)
					l_as.body.arguments.forth
--					if not l_as.body.arguments.after then
--						l_agent_sig.append(", ")
--					end

				end
--				l_agent_sig.append("]")
--			else
--				-- no arguments, signatur -> FUNCTION[BASE_TYPE, TUPLE, RESULT_TYPE]
--				l_agent_sig.append (", TUPLE")
			end

--			if l_as.body.type /= void then
--				-- has return type
--				 l_agent_sig.append(", "+l_as.body.type.text (match_list))
--			end


			if attached {ROUTINE_AS} l_as.body.content as l_routine and then l_routine.locals /= Void then
				-- has locals
				from
					i := 1
				until
					i > l_routine.locals.count
				loop
					add_to_current_inline_agents_layer (l_routine.locals.i_th (i))
					i := i + 1
				end
			end

			add_inline_agents_layer

--			if {ctxt: ROUNDTRIP_STRING_LIST_CONTEXT} context then

--				l_agent_sig.append ("]")

--				-- assign agent object to agent
--				l_agent_ass.append("%N"+inlining+l_agent+" := ")

--				-- adjust inlining
--				inlining.prepend ("%T")

--				-- store indexes
--				l_feature_last_instr_call_index := feature_object.last_instr_call_index
--				l_feature_locals_index := feature_object.locals_index

--				-- call processing of the inline agent in another context
--				l_context ?= safe_process_debug (l_as.agent_keyword (match_list))
--				l_agent_ass.append(l_context.string_representation)
--			--	l_agent_ass.append (" ")

--				l_context ?= safe_process_debug (l_as.body)
--				l_agent_ass.append(l_context.string_representation)
--				if l_as.internal_operands /= void then
--					l_context ?= safe_process_debug (l_as.internal_operands)
--					l_agent_ass.append(l_context.string_representation)
--				end

--				-- restore indexes
--				feature_object.set_last_instr_call_index(l_feature_last_instr_call_index)
--				feature_object.set_locals_index(l_feature_locals_index)

--				--adjust inlining
--				inlining := inlining.substring (2,inlining.count)

--				-- assign correct processor to agent object
--				l_agent_ass.append("%N"+inlining+l_agent+".set_processor_ (Current.processor_)%N"+inlining)

--				-- prepend the output from possible nested agents

--				if ctxt.valid_cursor(feature_object.last_instr_call_index) and ctxt.valid_cursor(feature_object.locals_index) then
--					l_agent_ass.prepend (agent_ass_to_update)
--					l_agent_sig.prepend (agent_sig_to_update)
--					ctxt.insert_after_cursor (l_agent_ass, feature_object.last_instr_call_index)
--					ctxt.insert_after_cursor (l_agent_sig, feature_object.locals_index)
--					agent_ass_to_update.make_empty
--					agent_sig_to_update.make_empty
--				else
--					agent_ass_to_update.prepend (l_agent_ass)
--					agent_sig_to_update.prepend (l_agent_sig)
--				end


--				context.add_string (l_agent)
--			else
--				-- should not happen
--				Precursor(l_as)
--			end


--			if l_as.internal_operands /= void then
--				last_index := l_as.internal_operands.last_token (match_list).index
--			else
--				last_index := l_as.body.last_token (match_list).index
--			end

			update_current_level_with_expression (l_as)

--			if top_level then
--				is_in_agent := FALSE
--			end
--			is_in_inline_agent := FALSE
			remove_current_inline_agents_layer
			reset_current_inline_agents_layer


		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
			-- Process `l_as'.
		local
--			feature_i: FEATURE_I
--			l_agent: STRING
--			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
--			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
--			l_target_type: TYPE_A
--			is_target_separate: BOOLEAN
--			l_agent_sig, l_agent_ass: STRING
--			agent_feature: FEATURE_AS
--			l_context: ROUNDTRIP_STRING_LIST_CONTEXT
--			l_feature_last_instr_call_index,l_feature_locals_index: LINKED_LIST_CURSOR[STRING]
--			top_level: BOOLEAN
		do
			Precursor (l_as)

			-- The following to be re-enabled after agents within the context of
			-- the base libraries are sorted out.


--			create l_agent_sig.make_empty
--			create l_agent_ass.make_empty
--			l_agent := "l_agent"+feature_locals_agent_counter.out
--			feature_locals_agent_counter := feature_locals_agent_counter+1

--			-- get feature which is passed
--			agent_feature := class_as.feature_of_name (l_as.feature_name.name, false)

--			l_agent_ass.append ("%N"+inlining+l_agent+" := ")

--			if not is_in_agent then
--				top_level := TRUE
--				is_in_agent := TRUE
--				create agent_ass_to_update.make_empty
--				create agent_sig_to_update.make_empty
--			else
--				top_level := FALSE
--			end

--			-- Store indexes
--			l_feature_last_instr_call_index := feature_object.last_instr_call_index
--			l_feature_locals_index := feature_object.locals_index

--			-- call process of the inline agent in another context
--			l_context ?= safe_process_debug (l_as.agent_keyword (match_list))
--			l_agent_ass.append(l_context.string_representation)
--			l_agent_ass.append (" ")
--			if l_as.target /= Void then
--				l_context ?= safe_process_debug (l_as.lparan_symbol (match_list))
--				l_agent_ass.append(l_context.string_representation)
--				l_context ?= safe_process_debug (l_as.target)
--				l_agent_ass.append(l_context.string_representation)
--				l_context ?= safe_process_debug (l_as.rparan_symbol (match_list))
--				l_agent_ass.append(l_context.string_representation)
--				l_context ?= safe_process_debug (l_as.dot_symbol (match_list))
--				l_agent_ass.append(l_context.string_representation)
--			end
--			l_context ?= safe_process_debug (l_as.feature_name)
--			l_agent_ass.append(l_context.string_representation)
--			if l_as.internal_operands /= void then
--				l_context ?= safe_process_debug (l_as.internal_operands)
--				l_agent_ass.append(l_context.string_representation)
--			end

--			-- reStore indexes
--			feature_object.set_last_instr_call_index(l_feature_last_instr_call_index)
--			feature_object.set_locals_index(l_feature_locals_index)

--			if l_as.target /= void then
--				feature_i := class_c.feature_named (feature_as.feature_name.name)
--				l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
--				l_type_expression_visitor.evaluate_expression_type_in_class_and_feature(l_as.target, class_c, feature_i, flattened_object_tests_layers, flattened_inline_agents_layers)
--				l_target_type := l_type_expression_visitor.expression_type
--				is_target_separate := l_type_expression_visitor.is_expression_separate

--				if is_target_separate then
--					l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)

--					-- has target and it is separate	
--					l_agent_ass.append ("%N"+inlining+"if {tar: SCOOP_SEPARATE_PROXY} "+l_agent+"."+{SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation+".target then ")
--					l_agent_ass.append (l_agent+".set_processor_ (tar."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+") end %N"+inlining)


--					-- Do we need to add a local section at the end?
--					if attached {ROUTINE_AS} feature_as.body.content as rout then
--						if rout.internal_locals = void then
--							feature_object.set_need_local_section(True)
--						end
--					end

--					if is_in_inline_agent then
--						l_agent_sig.append ("%N"+inlining)
--					else
--						l_agent_sig.append ("%N%T%T%T")
--					end

--					if agent_feature.body.type /= void then
--						l_agent_sig.append (l_agent+": attached SCOOP_SEPARATE__FUNCTION[ANY")
--					else
--						l_agent_sig.append (l_agent+": attached SCOOP_SEPARATE__PROCEDURE[ANY")
--					end

--				else
--					-- has target but is non separate.
--					l_agent_ass.append ("%N"+inlining+l_agent+".set_processor_ (Current."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name + ")%N"+inlining)

--					-- Do we need to add a local section at the end?
--					if attached {ROUTINE_AS} feature_as.body.content as rout then
--						if rout.internal_locals = void then
--							feature_object.set_need_local_section(True)
--						end
--					end

--					if is_in_inline_agent then
--						l_agent_sig.append ("%N"+inlining)
--					else
--						l_agent_sig.append ("%N%T%T%T")
--					end
--					if agent_feature.body.type /= void then
--						l_agent_sig.append (l_agent+": attached FUNCTION[ANY")
--					else
--						l_agent_sig.append (l_agent+": attached PROCEDURE[ANY")
--					end
--				end

--			else
--				-- target void, agent is attached and non separate
--				l_agent_ass.append ("%N"+inlining+l_agent+".set_processor_ (Current."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name + ")%N"+inlining)


--				-- Do we need to add a local section at the end?
--				if attached {ROUTINE_AS} feature_as.body.content as rout then
--					if rout.internal_locals = void then
--						feature_object.set_need_local_section(True)
--					end
--				end


--				if is_in_inline_agent then
--					l_agent_sig.append ("%N"+inlining)
--				else
--					l_agent_sig.append ("%N%T%T%T")
--				end
--				if agent_feature.body.type /= void then
--					l_agent_sig.append (l_agent+": attached FUNCTION[ANY")
--				else

--					l_agent_sig.append (l_agent+": attached PROCEDURE[ANY")
--				end

--			end
--			if agent_feature.body.arguments /= Void then
--				-- has arguments
--				l_agent_sig.append (", TUPLE[")
--				from
--					agent_feature.body.arguments.start
--				until
--					agent_feature.body.arguments.after
--				loop
--					l_agent_sig.append(agent_feature.body.arguments.item.type.text (match_list))
--					agent_feature.body.arguments.forth
--					if not agent_feature.body.arguments.after then
--						l_agent_sig.append(", ")
--					end
--				end
--				l_agent_sig.append("]")
--			else
--				-- no arguments, signatur -> FUNCTION[BASE_TYPE, TUPLE, RESULT_TYPE]
--				l_agent_sig.append (", TUPLE")
--			end

--			if agent_feature.body.type /= void then
--				-- has return type
--				 l_agent_sig.append(", "+agent_feature.body.type.text (match_list))
--			end

--			if l_as.internal_operands /= void then
--				last_index := l_as.internal_operands.last_token (match_list).index
--			else
--				last_index := l_as.feature_name.last_token (match_list).index
--			end


--			if {ctxt: ROUNDTRIP_STRING_LIST_CONTEXT} context then

--				l_agent_sig.append ("]")

--				-- prepend output from possible nested agents
--				if top_level or is_in_inline_agent then
--					l_agent_ass.prepend (agent_ass_to_update)
--					l_agent_sig.prepend (agent_sig_to_update)
--					ctxt.insert_after_cursor (l_agent_sig, feature_object.locals_index)
--					ctxt.insert_after_cursor (l_agent_ass, feature_object.last_instr_call_index)
--				else
--					agent_ass_to_update.prepend (l_agent_ass)
--					agent_sig_to_update.prepend (l_agent_sig)
--				end

--				context.add_string (l_agent)


--			else
--				-- should not happen
--				precursor(l_as)
--			end

--			if top_level then
--				is_in_agent := FALSE
--			end
		end

feature {NONE} -- Agent handling

	inlining: STRING
		-- Inlining used to print code for agent object creation

	feature_locals_agent_counter:INTEGER
		-- Counter to create local agent objects

	is_in_agent, is_in_inline_agent: BOOLEAN
		-- Keeps track if we are currently 'inside' of an inline agent / normal agent	

	agent_sig_to_update, agent_ass_to_update: STRING
		-- if there is the need to propagate stuff to the upper agent level

feature -- Object test and assignment attempt handling

	process_object_test_as (l_as: OBJECT_TEST_AS)
			-- handles object tests {l: l_as.type} l_as.expression
			-- Added by `damienm' 5.Nov 2009
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_is_expression_separate,l_is_type_separate: BOOLEAN
			type_type: TYPE_A
			feature_i: FEATURE_I
		do
			if not l_as.is_attached_keyword then

				l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor

				if feature_as /= void then
					feature_i := class_c.feature_named (feature_as.feature_name.name)

					l_type_expression_visitor.evaluate_expression_type_in_class_and_feature(l_as.expression, class_c, feature_i, flattened_object_tests_layers, flattened_inline_agents_layers)
					l_is_expression_separate := l_type_expression_visitor.is_expression_separate

					l_type_expression_visitor.resolve_type_in_class_and_feature(l_as.type, class_c, feature_i)
					type_type := l_type_expression_visitor.resolved_type
					l_is_type_separate := type_type.is_separate

				else
					l_type_expression_visitor.evaluate_expression_type_in_class(l_as.expression, class_c, flattened_object_tests_layers, flattened_inline_agents_layers)
					l_is_expression_separate := l_type_expression_visitor.is_expression_separate

					l_type_expression_visitor.resolve_type_in_class(l_as.type, class_c)
					type_type := l_type_expression_visitor.resolved_type
					l_is_type_separate := type_type.is_separate

				end

					-- `l_is_type_separate' is non separate:
					--      `l_is_expression_separate' is not separate:
					--            {l: T} exp
					--      `l_is_expression_separate' is separate:
					--            exp /= Void and then exp.processor_ = processor_ and then attached {l: T} exp.implementation_

				if not l_is_type_separate then
					if not l_is_expression_separate then
						-- {non sep} non sep
						Precursor(l_as)
					else
						-- {non sep} sep
						print_leading_separators (l_as.lcurly_symbol_index-1)
						last_index := l_as.expression.first_token (match_list).index

						safe_process (l_as.expression)
						context.add_string (" /= Void and then ")
						safe_process (l_as.expression)
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = "+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" and then ")
						Precursor(l_as)
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					end
						-- `l_is_type_separate' is separate with no specifications
						--      `l_is_expression_separate' is not separate:
						--            exp /= Void and then {l: T} exp.proxy_
						--      `l_is_expression_separate' is not separate:
						--             {l:T} exp

				elseif type_type.processor_tag.top then

					if not l_is_expression_separate then
						-- {sep (T)} non sep
						print_leading_separators (l_as.lcurly_symbol_index-1)
						last_index := l_as.expression.first_token (match_list).index

						safe_process (l_as.expression)
						context.add_string (" /= Void and then ")
						Precursor(l_as)
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					else
						-- {sep (T)} sep
						Precursor(l_as)
					end

					--	`l_is_type_separate' is separate with a handler
					--      `l_is_expression_separate' is not separate:
					--            exp /= Void and then exp.processor_ = e.processor_ and then {l:T} exp.proxy_
					--      `l_is_expression_separate' is separate:
					--            exp /= Void and then exp.processor_ = e.processor_ and then {l:T} exp

				elseif type_type.processor_tag.has_handler	then
					print_leading_separators (l_as.lcurly_symbol_index-1)
					last_index := l_as.expression.first_token (match_list).index

					safe_process (l_as.expression)
					context.add_string (" /= Void and then ")
					safe_process (l_as.expression)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = ")
					context.add_string (type_type.processor_tag.parsed_processor_name)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" and then ")
					Precursor(l_as)

					if not l_is_expression_separate then
						-- {sep (<e.handler>)} non sep
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					end

					--	`l_is_type_separate' is separate with a processor tag
					--      `l_is_expression_separate' is not separate:
					--            exp /= Void and then exp.processor_ = p and then {l: T} exp.proxy_
					--     `l_is_expression_separate' is separate:
					--            exp /= Void and then exp.processor_ = p and then  {l: T} exp

				elseif not type_type.processor_tag.has_handler and not type_type.processor_tag.tag_name.is_empty then

					print_leading_separators (l_as.lcurly_symbol_index-1)
					last_index := l_as.expression.first_token (match_list).index

					safe_process (l_as.expression)
					context.add_string (" /= Void and then ")
					safe_process (l_as.expression)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = ")
					context.add_string (type_type.processor_tag.parsed_processor_name)
					context.add_string (" and then ")
					Precursor(l_as)

					if not l_is_expression_separate then
						-- {sep (<p>)} non sep
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					end
				end
		 	else

		 		Precursor (l_as)
		 	end
			last_index := l_as.last_token (match_list).index
		end

	process_reverse_as (l_as: REVERSE_AS)
				--process ass. attemps 'target' '?=' 'source'
				-- Added by `damienm' 5.Nov 2009
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_is_source_separate,l_is_target_separate: BOOLEAN
			target_type: TYPE_A
			feature_i: FEATURE_I
		do
			feature_i := class_c.feature_named (feature_as.feature_name.name)
			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor

			l_type_expression_visitor.evaluate_expression_type_in_class_and_feature (l_as.source, class_c, feature_i, flattened_object_tests_layers, flattened_inline_agents_layers)
			l_is_source_separate := l_type_expression_visitor.is_expression_separate

			l_type_expression_visitor.evaluate_call_type_in_class_and_feature(l_as.target, class_c, feature_i, flattened_object_tests_layers, flattened_inline_agents_layers)
			l_is_target_separate := l_type_expression_visitor.is_expression_separate
			target_type := l_type_expression_visitor.expression_type


			if not l_is_target_separate then

				--	`l_is_target_separate' is not separate:
				--     `l_is_source_separate' is not separate:
				--            l ?= exp
				--     `l_is_source_separate' is separate:
				--            if exp /= Void and then exp.processor_ = processor_ then
				--                  l ?= exp.implementation_
				--            else
				--                  l := Void
				--            end
				if not l_is_source_separate then
					-- non sep ?= non sep
					Precursor(l_as)


				else
					-- non sep ?= sep
					print_leading_separators (l_as.target.first_token (match_list).index-1)
					last_index := l_as.source.first_token (match_list).index
					context.add_string ("if ")
					safe_process (l_as.source)
					context.add_string (" /= Void and then ")
					safe_process (l_as.source)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = "+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" then ")
					Precursor(l_as)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name+" else ")
					safe_process (l_as.target)
					context.add_string (" := Void end")

				end

			elseif target_type.processor_tag.top then

				--	`l_is_target_separate' is not separate with no specifications:
				--      `l_is_source_separate' is not separate:
				--            if exp /= Void then
				--                  l ?= exp.proxy_
				--            else
				--                  l := Void
				--            end
				--      `l_is_source_separate' is separate:
				--            l ?= exp

				if not l_is_source_separate then
					-- sep (T) ?= non sep
					print_leading_separators (l_as.target.first_token (match_list).index-1)
					last_index := l_as.source.first_token (match_list).index
					context.add_string ("if ")
					safe_process (l_as.source)
					context.add_string (" /= Void then ")
					Precursor(l_as)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name+ " else ")
					safe_process (l_as.target)
					context.add_string (" := Void end")
				else
					-- sep (T) ?=  sep
					Precursor(l_as)
				end


			elseif target_type.processor_tag.has_handler then
				--				
				--	`l_is_target_separate' is not separate with a handler:
				--      `l_is_source_separate' is not separate:
				--            if exp /= Void and then exp.processor_ = e.processor_ then
				--                  l ?= exp.proxy_
				--            else
				--                  l := Void
				--            end
				--      `l_is_source_separate' is separate:
				--            if exp /= Void and then exp.processor_ = e.processor_ then
				--                  l ?= exp
				--            else
				--                  l := Void
				--            end
				print_leading_separators (l_as.target.first_token (match_list).index-1)
				last_index := l_as.source.first_token (match_list).index
				context.add_string ("if ")
				safe_process (l_as.source)
				context.add_string (" /= Void and then ")
				safe_process (l_as.source)
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = ")
				context.add_string (target_type.processor_tag.parsed_processor_name)
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name)
				context.add_string (" then ")
				Precursor(l_as)
				if not l_is_source_separate then
					-- sep (<e.handler>) ?= non sep
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name+ " else ")
				else
					-- sep (<e.handler>) ?= sep
					context.add_string (" else ")
				end

				safe_process (l_as.target)
				context.add_string (" := Void end")

			elseif not target_type.processor_tag.has_handler and not target_type.processor_tag.tag_name.is_empty then

				--	`l_is_target_separate' is not separate with a processor tag:
				--      `l_is_source_separate' is not separate:
				--            if exp /= Void and then exp.processor_ = p then
				--                  l ?= exp.proxy_
				--            else
				--                  l := Void
				--            end
				--      `l_is_source_separate' is separate:
				--            if exp /= Void and then exp.processor_ = p then
				--                  l ?= exp
				--            else
				--                  l := Void
				--            en
				print_leading_separators (l_as.target.first_token (match_list).index-1)
				last_index := l_as.source.first_token (match_list).index
				context.add_string ("if ")
				safe_process (l_as.source)
				context.add_string (" /= Void and then ")
				safe_process (l_as.source)
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name+" = ")
				context.add_string (target_type.processor_tag.parsed_processor_name)
				context.add_string (" then ")
				Precursor(l_as)

				if not l_is_source_separate then
					-- sep (<p>) ?= non sep
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name+ " else ")
				else
					-- sep (<p>) ?= sep
					context.add_string (" else ")
				end

				safe_process (l_as.target)
				context.add_string (" := Void end")

			end
	 		last_index := l_as.last_token (match_list).index
		end

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end

