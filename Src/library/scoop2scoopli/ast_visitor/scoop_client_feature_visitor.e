note
	description: "[
					Roundtrip visitor to process feature node (`FEATURE_AS' node) in
					SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
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
		--	process_inline_agent_creation_as,
		--	process_agent_routine_creation_as,
		--	process_instr_call_as,
		--	process_assign_as,
			process_routine_as,
			process_body_as,
			process_access_id_as,
			process_access_feat_as,
			process_result_as,
			process_parameter_list_as

		end

	SCOOP_BASIC_TYPE

create
	make

feature -- Access

	process_feature(l_as: FEATURE_AS) is
			-- Process `l_as'.
		do
			safe_process (l_as)
		end

feature {NONE} -- Visitor implementation

	process_feature_as (l_as: FEATURE_AS) is
		local
			i, nb: INTEGER
			l_infix_prefix: INFIX_PREFIX_AS
			is_separate: BOOLEAN
			l_feature_object: SCOOP_CLIENT_FEATURE_OBJECT
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_argument_visitor: SCOOP_CLIENT_ARGUMENT_VISITOR
			l_feature_assertion_visitor: SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR
			l_feature_lr_visitor: SCOOP_CLIENT_FEATURE_LR_VISITOR
			l_feature_er_visitor: SCOOP_CLIENT_FEATURE_ER_VISITOR
			l_feature_wc_visitor: SCOOP_CLIENT_FEATURE_WC_VISITOR
			l_feature_nsp_visitor: SCOOP_CLIENT_FEATURE_NSP_VISITOR
			l_feature_sp_visitor: SCOOP_CLIENT_FEATURE_SP_VISITOR
		do
			set_current_feature_as (l_as)
			-- create feature object
			create l_feature_object.make
			set_feature_object (l_feature_object)

			if l_as.is_attribute or l_as.is_constant then
				last_index := l_as.first_token (match_list).index - 1
				context.add_string ("%N%N%T")
				safe_process (l_as.feature_names)
				safe_process (l_as.body)
			else -- routine

				-- get feature name visitor
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

				-- create an argument visitor
				l_argument_visitor := scoop_visitor_factory.new_client_argument_visitor_for_class (parsed_class, match_list)
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
				until
					i > nb
				loop
					is_separate := False
					-- check if there are separate arguments
					if l_as.body /= Void and then l_as.body.internal_arguments /= void then
						l_feature_object.set_arguments (l_argument_visitor.process_arguments (l_as.body.internal_arguments))

						if l_feature_object.arguments.has_separate_arguments then
							is_separate := True
						end
					end

					-- identify frozen key word
					last_index := l_as.feature_names.i_th (i).first_token (match_list).index
					if l_as.feature_names.i_th (i).is_frozen and then
					   l_as.feature_names.i_th (i).frozen_keyword.index /= 0 then
						l_feature_object.is_feature_frozen.set_item (True)
					end

					-- process name
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), False)
					l_feature_object.set_feature_name (l_feature_name_visitor.feature_name)
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), True)
					l_feature_object.set_feature_alias_name (l_feature_name_visitor.feature_name)
					-- declaration name writes the infix and non-infix notation if the feature name
					-- contains an infix name. Change this to an alias notation in EiffelStudio 6.4
					l_feature_name_visitor.process_feature_declaration_name (l_as.feature_names.i_th (i))
					l_feature_object.set_feature_declaration_name (l_feature_name_visitor.feature_name)


					if is_separate then

						-- assertion visitor
						l_feature_assertion_visitor.process_feature_body (l_as.body, l_feature_object)

						-- get result objects
						l_feature_object.set_preconditions (l_feature_assertion_visitor.get_preconditions)
						l_feature_object.set_postconditions (l_feature_assertion_visitor.get_postconditions)

						-- locking request body (feature, procedure, deferred routines)
						l_feature_lr_visitor.process_feature_body (l_as.body, l_feature_object)

						-- enclosing routine body (feature, procedure, deferred routines)
						l_feature_er_visitor.process_feature_body (l_as.body, l_feature_object)

						-- wait condition wrapper (feature, procedure, deferred routines)
						l_feature_wc_visitor.process_feature_body (l_as.body, l_feature_object)

						-- postcondition processing
						if not l_feature_object.postconditions.separate_postconditions.is_empty then

							-- unseparated postcondition attribute
							create_unseparated_postcondition_attribute (l_feature_object)
						end

						if not l_feature_object.postconditions.non_separate_postconditions.is_empty then
							-- non separate postcondition clauses wrapper
							l_feature_nsp_visitor.process_feature_body (l_as.body, l_feature_object)
						end

						if not l_feature_object.postconditions.separate_postconditions.is_empty then
							-- separate postcondition clauses wrapper
							l_feature_sp_visitor.process_feature_body (l_as.body, l_feature_object)
						end

						-- postcondition processing
						if not l_feature_object.postconditions.separate_postconditions.is_empty then

							-- wrappers for individual separate postcondition clauses
							create_separate_postcondition_wrapper (l_feature_object)
						end

					else
							-- print original feature
						context.add_string ("%N%N%T")
						if l_feature_object.is_feature_frozen then
							context.add_string ("frozen ")
						end
						context.add_string (l_feature_object.feature_alias_name + " ")
						last_index := l_as.body.first_token (match_list).index - 1

						safe_process (l_as.body)

						-- add a wrapper feature from the old infix notation to
						-- the non-infix notation version
						-- Remove this call with EiffelStudio 6.4
						l_infix_prefix ?= l_as.feature_names.i_th (i)
						if l_infix_prefix /= Void then
							l_feature_name_visitor.process_declaration_infix_prefix (l_infix_prefix)

							create_infix_feature_wrapper(l_as, l_feature_name_visitor.feature_name, l_feature_object.feature_name)
						end
					end

					i := i + 1
				end

			end

			-- invalidate workbench access
			set_current_feature_as_void
		end

	process_keyword_as (l_as: KEYWORD_AS) is
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

feature {NONE} -- Implementation

	create_infix_feature_wrapper (l_as: FEATURE_AS; an_original_feature_name, a_feature_name: STRING) is
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

	create_unseparated_postcondition_attribute (a_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Generate list of unseparated postconditions.
			-- Unseparated postconditions are separate postcondition that
			-- involve a non-separate object at run time. They are treated as
			-- non-separate postconditions.
		require
			a_fo_not_void: a_fo /= Void
		do
			context.add_string ("%N%N%T" + a_fo.feature_name + "_scoop_separate_" + class_c.name.as_lower +
								"_unseparated_postconditions: LINKED_LIST [ROUTINE [ANY, TUPLE]]")
			context.add_string ("%N%T%T-- Precondition clauses of `" + a_fo.feature_name + "' that seem to be separate but are not.")
			context.add_string ("%N%T%T-- They have to be processed as correctness conditions.")
		end

	create_separate_postcondition_wrapper  (a_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Generate wrappers for individual separate postcondition clauses.
		require
			a_fo_not_void: a_fo /= Void
		local
			i: INTEGER
			an_assertion: SCOOP_CLIENT_ASSERTION_OBJECT
			l_feature_isp_visitor: SCOOP_CLIENT_FEATURE_ISP_VISITOR
		do
			-- create visitor for individual separate postcondition clauses.
			l_feature_isp_visitor := scoop_visitor_factory.new_client_feature_isp_visitor (context)

			-- iterate over all separate postconditions
			from
				i := 1
			until
				i > a_fo.postconditions.separate_postconditions.count
			loop
				-- get assertion
				an_assertion := a_fo.postconditions.separate_postconditions.i_th (i)

				-- process feature
				l_feature_isp_visitor.process_individual_separate_postcondition (i, an_assertion, a_fo)

				i := i + 1
			end
		end

feature -- feature body

	process_body_as (l_as: BODY_AS)
		local
			feature_name: FEATURE_NAME
			c_as: CONSTANT_AS
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			l_generics_visitor: SCOOP_GENERICS_VISITOR
			generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
		do

			-- Reset
			result_substitution := False

			safe_process (l_as.internal_arguments)

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
						if l_assign_finder.have_to_replace_return_type(feature_name, class_c, false) then
							context.add_string ({SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_class_prefix+typ.class_name.name)
							result_substitution := true
	--						seperate_result_signature := typ
						else
							-- No substitution needed, print normaly
							context.add_string (typ.class_name.name)
						end
					else
						-- Separate: No substitution needed, print normaly
						context.add_string ({SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_class_prefix+typ.class_name.name)
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
						l_generics_visitor.process_internal_generics (gen_typ.generics, True, True)


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


feature {NONE} -- Adding .implementation_ for precondition processing.
	processing_assertions : BOOLEAN



feature -- Result Substitution


	process_result_as (l_as: RESULT_AS) is
			-- Process `l_as', print it to context.
		do
			process_leading_leaves (l_as.index)
			last_index := l_as.index
			if result_substitution then
				context.add_string ({SCOOP_SYSTEM_CONSTANTS}.nonseparate_result)
			else
				put_string (l_as)
			end
			update_current_level_with_call (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local

			l_is_in_nested: BOOLEAN
			a_type_a: TYPE_A
			current_levels: LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]
			index_current_level: INTEGER
			l_class_c: CLASS_C
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- Process actual arguments and add current if target is of separate type.
			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				accessed_feature := l_as.feature_name
			end
			process_internal_parameters(l_as.internal_parameters)

			current_levels := levels_layers.item
			index_current_level := levels_layers.item.index_of(current_level ,1)

			a_type_a := current_level.type


			if not attached {VOID_A} a_type_a and a_type_a /= void then
				-- If `a_type_a' is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					-- If this is separate, no fix needed anyway.
					--l_class_c := system.class_of_id (class_as_by_name(a_type_a.name).class_id)
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, a_type_a.associated_class)
					else
						a_type_a := previous_level.type
						add_result_type_substitution(l_as.feature_name, a_type_a.associated_class)
					end
				end
			end

		end

	process_access_id_as (l_as: ACCESS_ID_AS)

		local
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			feature_i: FEATURE_I
			l_is_in_nested: BOOLEAN
			a_type_a: TYPE_A
			current_levels: LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]
			index_current_level: INTEGER
		do
			safe_process (l_as.feature_name)
			update_current_level_with_call (l_as)

			if l_as.internal_parameters /= void and then l_as.internal_parameters.parameters /= void then
				-- Save accessed feature
				accessed_feature := l_as.feature_name
			end
			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			current_levels := levels_layers.item
			index_current_level := levels_layers.item.index_of(current_level ,1)

			a_type_a := current_level.type
			if not attached {VOID_A} a_type_a and a_type_a /= void then
				-- If `a_type_a' is `VOID_A' then its a command -> ignore
				if not current_level.type.is_separate then
					if not previous_level_exists then
						-- No call chain, get class of current item
						add_result_type_substitution(l_as.feature_name, a_type_a.associated_class)
					else
						a_type_a := previous_level.type
						add_result_type_substitution(l_as.feature_name, a_type_a.associated_class)
					end
				end
			end

		end

feature {NONE} -- Internal Arguments Substitution

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'. Add 'Current' as first argument in paramenter list.
			-- For each parameter temporarily add a new levels layer.
		local
			i,pos: INTEGER
			l_count: INTEGER
			a_class_c: CLASS_C
		do

			safe_process (l_as.lparan_symbol (match_list))

			-- add additional argument 'Current'
			if (previous_level_exists and then previous_level.is_separate) or add_prefix_current_cc then
				add_prefix_current_cc := False
				context.add_string ("Current, ")
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

					-- Check if current Parameter is separate, if it is -> check if fix is needed
					if current_level.type.is_separate then
						if accessed_feature /= void then
							if need_internal_argument_substitution (accessed_feature, a_class_c, pos) then
								context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation)
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

	need_internal_argument_substitution(a_feature_name: ID_AS; a_class_c: CLASS_C; argument_position: INTEGER): BOOLEAN is
			-- Do we need to substitute the internal argument?
			-- Needed when current argument is separate and a parent version of the feature has a non separate argument.

			require
				has_name: a_feature_name /= void
				has_class: a_class_c /= void
				has_argu: argument_position /= void
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
							if l_feature_name /= void and then l_assign_finder.have_to_replace_internal_arguments (l_feature_name, a_class_c, argument_position, has_context) then
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

feature {NONE} -- Redeclaration Substitution Impl


	accessed_feature: ID_AS
			-- Accessed feature of the actual arguments we are processing.
			-- i.e a.b.f(c,d) -> f

--	seperate_result_signature: CLASS_TYPE_AS
--			-- Signature substituted of the return type.
--			-- Return type of the feature is substituted when it is non separate and there exists a parent redeclaration with separate return type.

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

	add_result_type_substitution(a_feature_name: ID_AS; a_class_c: CLASS_C) is
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
								if l_feature_name /= void and then l_assign_finder.have_to_replace_return_type (l_feature_name, a_class_c, has_context) then
									context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation)
								end
							end
							feature_i.body.feature_names.forth
						end
					end
				end
			end

feature {NONE} -- index handling


	process_routine_as(l_as: ROUTINE_AS)
		local
			l_generics_visitor : SCOOP_GENERICS_VISITOR
		do
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)

			processing_assertions := True
			safe_process (l_as.precondition)
			processing_assertions := False

			-- local keyword needs to be added?

			if l_as.internal_locals = void or l_as.internal_locals.local_keyword (match_list) = void then
				if result_substitution then
					context.add_string ("%N%T%Tlocal%N")
				end
			end

			safe_process (l_as.internal_locals)
			if result_substitution then
				if attached {CLASS_TYPE_AS} feature_as.body.type as typ then
					context.add_string ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+": "+typ.class_name.name)
					if attached {GENERIC_CLASS_TYPE_AS} feature_as.body.type then
						l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
						l_generics_visitor.process_internal_generics (typ.generics, True, True)
					end
				end
			end

		--	if not is_in_agent then
			if {ctxt: ROUNDTRIP_STRING_LIST_CONTEXT} context then
				if not is_in_agent then
					feature_locals_agent_counter :=0
				end
				feature_locals_index := ctxt.cursor_to_current_position
			end
		--	end

			safe_process (l_as.routine_body)

			if result_substitution then
				if attached {CLASS_TYPE_AS} feature_as.body.type as typ then
					context.add_string ("%N%T%T%Tif "+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+" /= Void then")
					context.add_string ("%N%T%T%T%TResult := "+{SCOOP_SYSTEM_CONSTANTS}.nonseparate_result+"."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					context.add_string ("%N%T%T%Telse")
					context.add_string ("%N%T%T%T%TResult := create {"+{SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_prefix.as_upper+typ.class_name.name.as_upper)
					if typ.generics /= Void then
						l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
						l_generics_visitor.process_internal_generics (typ.generics, True, True)
					--	last_index := l_generics_visitor.get_last_index
					end
	           		context.add_string ("}.set_processor_ (Current.processor_)%N%T%T%T%TResult.set_implementation_(Void)%N")
	           		context.add_string ("%N%T%T%Tend")
	           	end
			end

			safe_process (l_as.postcondition)
			safe_process (l_as.rescue_keyword (match_list))
			safe_process (l_as.rescue_clause)
			safe_process (l_as.end_keyword)

			-- Disable `Result' replacement, unless we are in an agent
			if (not is_in_agent) and (not is_in_inline_agent) then
				result_substitution := false
			end
		end


	inlining: STRING
		-- Inlining used to print code for agent object creation
--	feature_last_instr_call_index: LINKED_LIST_CURSOR[STRING]
--		-- Position of the last instruction call of the current feature
	feature_locals_index: LINKED_LIST_CURSOR[STRING]
		-- Position of the `local' declaration of the current feature
	feature_locals_agent_counter:INTEGER
		-- Counter to create local agent objects
	is_in_agent, is_in_inline_agent: BOOLEAN
		-- Keeps track if we are currently 'inside' of an inline agent / normal agent
--	agent_sig_to_update, agent_ass_to_update: STRING
--		-- If there is the need to propagate stuff to the upper agent level

feature -- object test / ass attempt


	process_object_test_as (l_as: OBJECT_TEST_AS) is
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
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = "+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" and then ")
						Precursor(l_as)
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation)
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
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = ")
					context.add_string (type_type.processor_tag.parsed_processor_name)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" and then ")
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
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = ")
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

	process_reverse_as (l_as: REVERSE_AS) is
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
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = "+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" then ")
					Precursor(l_as)
					context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation+" else ")
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
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = ")
				context.add_string (target_type.processor_tag.parsed_processor_name)
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name)
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
				context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.scoop_processor_name+" = ")
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

