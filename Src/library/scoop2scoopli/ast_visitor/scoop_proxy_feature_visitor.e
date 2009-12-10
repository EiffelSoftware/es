indexing
	description: "Summary description for {SCOOP_PROXY_FEATURE_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_FEATURE_VISITOR

inherit
	SCOOP_SEPARATE_PROXY_PRINTER
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_feature_as
		end

create
	make_with_context

feature {NONE} -- Initialisation

	make_with_context(a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context
		end

feature -- Access

	process_feature(l_as: FEATURE_AS) is
			-- Process `l_as'.
		do
			-- init
			l_type_attribute_wrapper := scoop_visitor_factory.new_proxy_type_attriute_wrapper_printer (context)
			l_type_locals := scoop_visitor_factory.new_proxy_type_local_printer (context)
			l_type_signature := scoop_visitor_factory.new_proxy_type_signature_printer (context)

			-- process node
			safe_process (l_as)
		end

feature {NONE} -- Visitor implementation

	process_feature_as (l_as: FEATURE_AS) is
		local
			i, nb: INTEGER
			l_feature_name: FEATURE_NAME
			l_feature_name_str, l_feature_declaration_name: STRING
			l_original_feature_name, l_original_feature_alias_name, l_assigner_name: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			l_string_context: ROUNDTRIP_STRING_LIST_CONTEXT
		do
			set_current_feature_as (l_as)

			if l_as.is_attribute then
				process_attribute (l_as)
			elseif l_as.is_constant then
				process_constant (l_as)
			else -- routine
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

				-- create for each feature name a new body.
				from
					i := 1
					nb := l_as.feature_names.count
				until
					i > nb
				loop
					l_feature_name := l_as.feature_names.i_th (i)

					context.add_string ("%N%N%T")
					-- process frozen key word
					last_index := l_feature_name.first_token (match_list).index
					safe_process (l_feature_name.frozen_keyword)

					-- get feature name
					l_feature_name_visitor.process_feature_name (l_feature_name, false)
					l_feature_name_str := l_feature_name_visitor.get_feature_name
					l_feature_name_visitor.process_feature_name (l_feature_name, true)
					l_feature_declaration_name := l_feature_name_visitor.get_feature_name

					-- get original feature name
					l_feature_name_visitor.process_original_feature_name (l_feature_name, true)
					l_original_feature_alias_name := l_feature_name_visitor.get_feature_name
					l_feature_name_visitor.process_original_feature_name (l_feature_name, false)
					l_original_feature_name := l_feature_name_visitor.get_feature_name

					scoop_workbench_objects.set_current_proxy_feature_name (l_original_feature_name)

					-- add feature name
					context.add_string (l_feature_declaration_name + " ")

					-- reset assign name flag
					is_having_assign_id_name := false

					-- body (function and procedure)
					process_body (l_as.body, l_as, l_feature_name_str, l_feature_declaration_name)

					-- create mediator feature for assign id name
					create l_assign_finder
					if is_having_assign_id_name then
						l_assigner_name := l_as.body.assigner.name

						-- create wrapper feature for assigner call
						create_assign_wrapper_feature (l_feature_name_str, l_assigner_name, l_as)

						-- get string context
						l_string_context ?= context

						-- if there is already a feature f with assigner in an ancestor class
						-- then insert a redefine statement for the wrapper feature	
						-- simplification: just test the redefine statements of redefined
						-- reatures which occurres in the parents with assigner
						scoop_workbench_objects.insert_redefine_statement (l_original_feature_name, l_original_feature_alias_name, l_feature_name_str, l_string_context)

					-- if current feature has an assigner in an ancestor class
					-- then also add a wrapper feature if the current feature is
					-- effective, has no assigner and the next inherited version
					-- is deferred
					elseif not l_as.is_deferred and then l_assign_finder.has_parents_feature_with_assigner (l_original_feature_name, l_original_feature_alias_name, class_c)
						and then l_assign_finder.is_first_parent_feature_deferred (l_original_feature_name, l_original_feature_alias_name, class_c) then

						-- get the assigner name of a parent feature version
						l_assigner_name := l_assign_finder.get_inherited_assigner_name (l_original_feature_name, l_original_feature_alias_name, class_c)

						-- create wrapper feature for assigner call
						create_assign_wrapper_feature (l_feature_name_str, l_assigner_name, l_as)
					end

					i := i + 1
				end
				scoop_workbench_objects.set_current_proxy_feature_name (Void)
			end
			set_current_feature_as_void
		end

feature {NONE} -- Content implementation

	process_body (l_as: BODY_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING) is
		local
			r_as: ROUTINE_AS
			ex_as: EXTERNAL_AS
			once_as: ONCE_AS
		do
			last_index := l_as.first_token (match_list).index - 1

			-- create internal arguments
			if l_as.internal_arguments /= Void then
				process_formal_argument_list_with_a_caller (l_as.internal_arguments)
			else
				context.add_string ("(a_caller_: SCOOP_SEPARATE_TYPE)")
			end
			safe_process (l_as.colon_symbol (match_list))

			-- process type of feature
			l_type_signature.process_type (l_as.type)
			if l_as.type /= Void then
				last_index := l_as.type.last_token (match_list).index
				context.add_string (" ")
			end

			safe_process (l_as.assign_keyword (match_list))

			if l_as.assigner /= Void then
				process_leading_leaves (l_as.assigner.index)

				-- remember processing assigner
				is_having_assign_id_name := true

				-- create a call to a wrapper feature
				context.add_string (a_feature_name)
				context.add_string ("_scoop_separate_assigner_")

				-- set index
				last_index := l_as.assigner.index
			end

			safe_process (l_as.is_keyword (match_list))
			safe_process (l_as.indexing_clause)

			r_as ?= l_as.content
			if r_as /= Void then
				-- process function and procedure
				if l_as.type /= Void then
					if a_feature.is_deferred then
						context.add_string ("%N%T%Tdeferred%N%T%Tend")
					else
						process_function_content(r_as, a_feature, a_feature_name, a_feature_declaration_name)
					end
				else
					if a_feature.is_deferred then
						context.add_string ("%N%T%Tdeferred%N%T%Tend")
					else
						process_procedure_content(r_as, a_feature, a_feature_name, a_feature_declaration_name)
					end
				end
			end
			ex_as ?= l_as.content
			if ex_as /= Void then
				-- external_as or built_in_as
				if l_as.type /= Void then
					process_external_function_content(ex_as, a_feature, a_feature_name)
				else
					process_external_procedure_content(ex_as, a_feature, a_feature_name)
				end
			end
			once_as ?= l_as.content
			if once_as /= Void then
				if l_as.type /= Void then
					process_once_function_content(once_as, a_feature, a_feature_name)
				else
					process_once_procedure_content(once_as, a_feature, a_feature_name)
				end
			end
		end

	process_attribute (l_as: FEATURE_AS) is
			-- Process `l_as'.
		local
			i, nb: INTEGER
			a_class_type: CLASS_TYPE_AS
			a_class_c: CLASS_C
			l_feature_name: FEATURE_NAME
			l_feature_name_str: STRING
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			a_class_type ?= l_as.body.type
			if not (a_class_type /= Void and then a_class_type.class_name.name.as_upper.is_equal ("PROCESSOR")) then

				--context.add_string ("%N%Nfeature -- non-constant attribute wrapper")

					-- add feature wrapper for every feature_name
				from
					i := 1
					nb := l_as.feature_names.count
				until
					i > nb
				loop
					l_feature_name := l_as.feature_names.i_th (i)

					-- get feature name
					l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
					l_feature_name_visitor.process_feature_name (l_feature_name, false)
					l_feature_name_str := l_feature_name_visitor.get_feature_name
					scoop_workbench_objects.set_current_proxy_feature_name (l_feature_name_str)

					-- create agent feature
					last_index := l_feature_name.first_token (match_list).index - 1
					context.add_string ("%N%N%T")

					-- set feature name
					context.add_string (l_feature_name_str)

					-- set formal argument
					context.add_string (" (a_caller_: SCOOP_SEPARATE_TYPE): ")

					-- set type
					l_type_attribute_wrapper.process_type (l_as.body.type)

					-- keyword is and local declaration
					context.add_string (" is%N%T%Tlocal%N%T%T%Ta_function_to_evaluate: FUNCTION [ANY, TUPLE, ")
				--	 l_type_signature.process_type (l_as.body.type)
					l_type_locals.process_type (l_as.body.type)
					context.add_string ("]")

					-- body and agent declarateion
					context.add_string ("%N%T%Tdo%N%T%T%Ta_function_to_evaluate := agent ")
					context.add_string (l_feature_name_str)
					context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)

					-- execution
					context.add_string ("%N%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")

					-- feature result
					context.add_string ("%N%T%T%TResult ")
					create l_type_visitor
					a_class_c := l_type_visitor.evaluate_class_from_type (l_as.body.type, class_c)
--					if l_scoop_type_visitor.is_formal then
--						context.add_string (":= ")
--					elseif a_class_c /= Void then
--						if a_class_c.is_deferred and then not l_scoop_type_visitor.is_formal  then
--							context.add_string ("?= ")
--						else
--							context.add_string (":= ")
--						end
--					else
						context.add_string ("?= ")
--					end
					context.add_string ("a_function_to_evaluate.last_result")

					-- create result conversion code
					process_result_conversion_code (l_as.body.type)

					-- end keyword
					context.add_string ("%N%T%Tend%N%N%T")

					-- Create wrapper for attribute. Necessary for agent creation.
					context.add_string (l_feature_name_str)
					context.add_string  ("_scoop_separate_" + class_as.class_name.name.as_lower + ": ")

					-- result type (original / client type)
					l_type_locals.process_type (l_as.body.type)
--					process_result_type (l_as.body.type, true, l_type_signature)

					-- body
					context.add_string ("%N%T%T%T-- Wrapper for attribute `" + l_feature_name_str + "'.")
					context.add_string ("%N%T%Tis do%N%T%T%TResult := implementation_." + l_feature_name_str)
					context.add_string ("%N%T%Tend")

					-- no is_keyword, no body, skip indexing clause
					i := i + 1
				end
				last_index := l_as.last_token (match_list).index
				scoop_workbench_objects.set_current_proxy_feature_name (Void)
			end
		end

	process_constant (l_as: FEATURE_AS) is
		local
			i, nb: INTEGER
			a_class_c: CLASS_C
			l_feature_name: FEATURE_NAME
			l_feature_name_str: STRING
			l_scoop_type_visitor: SCOOP_TYPE_VISITOR
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			--context.add_string ("%N%Nfeature -- constant attribute wrapper")

				-- add feature wrapper for every feature_name
			from
				i := 1
				nb := l_as.feature_names.count
			until
				i > nb
			loop
				l_feature_name := l_as.feature_names.i_th (i)

				-- get feature name
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
				l_feature_name_visitor.process_feature_name (l_feature_name, false)
				l_feature_name_str := l_feature_name_visitor.get_feature_name
				scoop_workbench_objects.set_current_proxy_feature_name (l_feature_name_str)

				context.add_string ("%N%N%T")

				-- set feature name
				context.add_string (l_feature_name_str)

				-- set formal argument
				context.add_string (" (a_caller_: SCOOP_SEPARATE_TYPE): ")

				-- set type
				l_type_attribute_wrapper.process_type (l_as.body.type)

				-- keyword is and local declaration
				context.add_string (" is%N%T%Tlocal%N%T%T%Ta_function_to_evaluate: FUNCTION [ANY, TUPLE, ")
				l_type_locals.process_type (l_as.body.type)
			--	l_type_signature.process_type (l_as.body.type)
				context.add_string ("]")

				-- body and agent declarateion
				context.add_string ("%N%T%Tdo%N%T%T%Ta_function_to_evaluate := agent " + l_feature_name_str)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)

				-- execution
				context.add_string ("%N%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")

				-- feature result
				context.add_string ("%N%T%T%TResult ")
				create l_scoop_type_visitor
				a_class_c := l_scoop_type_visitor.evaluate_class_from_type (l_as.body.type, class_c)
--				if l_scoop_type_visitor.is_formal then
--					context.add_string (":= ")
--				elseif a_class_c /= Void then
--					if a_class_c.name_in_upper.is_equal ("LINKABLE")
--						or a_class_c.is_deferred and then not l_scoop_type_visitor.is_formal  then
--						context.add_string ("?= ")
--					else
--						context.add_string (":= ")
--					end
--				else
					context.add_string ("?= ")
--				end

				context.add_string ("a_function_to_evaluate.last_result")

				-- create result conversion code
				process_result_conversion_code (l_as.body.type)

				-- end keyword
				context.add_string ("%N%T%Tend%N%N%T")

				-- Create wrapper for attribute. Necessary for agent creation.
				last_index := l_feature_name.first_token (match_list).index - 1
				safe_process (l_feature_name)
				context.add_string  ("_scoop_separate_" + class_as.class_name.name.as_lower + ": ")

				-- result type
				l_type_locals.process_type (l_as.body.type)
--				safe_process (l_as.body.type)
--				process_result_type (l_as.body.type, true, l_type_signature)

				-- body
				context.add_string ("%N%T%T%T-- Wrapper for constant `")
--				last_index := l_feature_name.first_token (match_list).index - 1
				context.add_string (l_feature_name_str)
--				safe_process (l_feature_name)
				context.add_string ( "'.")
				context.add_string ("%N%T%Tis do%N%T%T%TResult := implementation_.")
--				last_index := l_feature_name.first_token (match_list).index - 1
				context.add_string (l_feature_name_str)
--				safe_process (l_feature_name)
				context.add_string ("%N%T%Tend")

				-- no is_keyword, no body, skip indexing clause
				i := i + 1
			end
			last_index := l_as.last_token (match_list).index
			scoop_workbench_objects.set_current_proxy_feature_name (Void)
		end

	process_function_content (l_as: ROUTINE_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_class_c: CLASS_C
		do
			create l_type_visitor

			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			context.add_string ("%N%T%T%Ta_function_to_evaluate := agent implementation_.")

			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				process_formal_argument_list_with_auxiliary_variables (a_feature.body.internal_arguments, false, true)
			end
			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				context.add_string ("%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
			end

			context.add_string ("%N%T%T%TResult ")

			l_class_c := l_type_visitor.evaluate_class_from_type (a_feature.body.type, class_c)

	--		if l_class_c /= Void and then
	--			(l_class_c.name_in_upper.is_equal ("LINKABLE") or else l_class_c.is_deferred) then

				context.add_string ("?= ")
	--		else
	--			context.add_string (":= ")
	--		end
			context.add_string ("a_function_to_evaluate.last_result")

			process_result_conversion_code (a_feature.body.type)
			context.add_string ("%N%T%Tend%N")
		end

	process_procedure_content (l_as: ROUTINE_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
		do
			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, agent implementation_.")
				context.add_string (a_feature_name)
				if a_feature.body.internal_arguments /= void then
					process_formal_argument_list_with_auxiliary_variables (a_feature.body.internal_arguments, false, true)
				end
				context.add_string (")")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_asynchronous_execute (a_caller_, agent implementation_." + a_feature_name)
				if a_feature.body.internal_arguments /= void then
					process_formal_argument_list_with_auxiliary_variables (a_feature.body.internal_arguments, false, true)
				end
				context.add_string (")%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_asynchronous_execute (a_caller_, agent implementation_." + a_feature_name)
				if a_feature.body.internal_arguments /= void then
					process_formal_argument_list_with_auxiliary_variables (a_feature.body.internal_arguments, false, true)
				end
				context.add_string (")")
			end
			context.add_string ("%N%T%Tend")
		end

	process_external_function_content (l_as: EXTERNAL_AS; a_feature: FEATURE_AS; a_feature_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_class_c: CLASS_C
		do
			create l_type_visitor

			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			context.add_string ("%N%T%T%Ta_function_to_evaluate := agent ")

			context.add_string (a_feature_name)
			context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)

			if a_feature.body.internal_arguments /= Void then
				context.add_string (" ")
				process_formal_argument_list_with_auxiliary_variables (a_feature.body.internal_arguments, false, true)
			end
			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				context.add_string ("%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
			end

			context.add_string ("%N%T%T%TResult ")

			l_class_c := l_type_visitor.evaluate_class_from_type (a_feature.body.type, class_c)

--			if l_class_c.name_in_upper.is_equal ("LINKABLE")
--				or else (l_class_c.is_deferred and then not l_scoop_type_visitor.is_formal) then

				context.add_string ("?= ")
--			else
--				context.add_string (":= ")
--			end
			context.add_string ("a_function_to_evaluate.last_result")

			process_result_conversion_code (a_feature.body.type)
			context.add_string ("%N%T%Tend%N")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name)
			context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower + " ")
			if a_feature.body.internal_arguments /= void then
				process_flattened_formal_argument_list (a_feature.body.internal_arguments, false)
			end

			-- process type
			process_result_type (a_feature.body.type, true, l_type_signature)

			context.add_string (" is%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%TResult := implementation_.")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string ("%N%T%Tend")
		end

	process_external_procedure_content (l_as: EXTERNAL_AS; a_feature: FEATURE_AS; a_feature_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
		do
			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_asynchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_asynchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")")
			end
			context.add_string ("%N%T%Tend%N")

			context.add_string ("%N%T%Tend")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name + "_scoop_separate_" + class_as.class_name.name.as_lower + " ")
			if a_feature.body.internal_arguments /= void then
				process_flattened_formal_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string (" is%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%Timplementation_." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string ("%N%T%Tend")
		end

	process_once_procedure_content (l_as: ONCE_AS; a_feature: FEATURE_AS; a_feature_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
		do
			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_asynchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_asynchronous_execute (a_caller_, agent " + a_feature_name)
				context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)
				if a_feature.body.internal_arguments /= void then
					context.add_string (" ")
					process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
				end
				context.add_string (")")
			end
			context.add_string ("%N%T%Tend%N")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name + "_scoop_separate_" + class_as.class_name.name.as_lower + " ")
			if a_feature.body.internal_arguments /= void then
				process_flattened_formal_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string (" is%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%Timplementation_." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string ("%N%T%Tend")
		end

	process_once_function_content (l_as: ONCE_AS; a_feature: FEATURE_AS; a_feature_name: STRING) is
		local
			lock_passing_possible: BOOLEAN
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_class_c: CLASS_C
		do
			create l_type_visitor

			lock_passing_possible := process_auxiliary_local_variables (a_feature, a_feature_name)

			context.add_string ("%N%T%T%Ta_function_to_evaluate := agent ")
			context.add_string (a_feature_name)
			context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower)

			if a_feature.body.internal_arguments /= Void then
				context.add_string (" ")
				process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
			end

			if lock_passing_possible then
				process_lock_passing_before
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				process_lock_passing_after
				context.add_string ("%N%T%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
				context.add_string ("%N%T%T%Tend")
			else
				context.add_string ("%N%T%T%Tscoop_synchronous_execute (a_caller_, a_function_to_evaluate)")
			end

			context.add_string ("%N%T%T%TResult ")

			l_class_c := l_type_visitor.evaluate_class_from_type (a_feature.body.type, class_c)

--			if (l_class_c.is_deferred and then not l_scoop_type_visitor.is_formal) then

				context.add_string ("?= ")
--			else
--				context.add_string (":= ")
--			end
			context.add_string ("a_function_to_evaluate.last_result")

			process_result_conversion_code (a_feature.body.type)
			context.add_string ("%N%T%Tend%N")

			-- Create wrapper for once feature. Necessary for agent creation.
			context.add_string (a_feature_name)
			context.add_string ("_scoop_separate_" + class_as.class_name.name.as_lower + " ")
			if a_feature.body.internal_arguments /= void then
				process_flattened_formal_argument_list (a_feature.body.internal_arguments, false)
			end
			process_result_type (a_feature.body.type, true, l_type_signature)
			context.add_string (" is%N%T%T%T")
			context.add_string ("-- Wrapper for once feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%TResult := implementation_.")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				process_formal_argument_list_as_actual_argument_list (a_feature.body.internal_arguments, false)
			end
			context.add_string ("%N%T%Tend")
		end

feature -- Test

	process_result_conversion_code (l_as: TYPE_AS) is
		-- Generate code that sets Result's processor_ to supplier's processor if necessary.
		local
			a_class_c: CLASS_C
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			create l_type_visitor
			a_class_c := l_type_visitor.evaluate_class_from_type (l_as, class_c)
			if a_class_c /= Void then
				if not a_class_c.is_expanded
					and not l_type_visitor.is_formal
					and not l_type_visitor.is_tuple_type
				then
					context.add_string ("%N%T%T%Tif Result /= void and then (Result.implementation_ /= void or else Result.processor_ /= void) then")
					context.add_string ("%N%T%T%T%Tif Result.processor_ = void then Result.set_processor_ (processor_) end")
					context.add_string ("%N%T%T%Telse%N%T%T%T%TResult := void%N%T%T%Tend%N%T%T")
				end
			end
		end

	process_result_type (a_type: TYPE_AS; is_declared_type: BOOLEAN; l_proxy_type_visitor: SCOOP_PROXY_TYPE_VISITOR) is
			-- Process `a_type'. Precede with `:' if `is_declared_type' is true.
		local
			a_class_c: CLASS_C
			is_separate: BOOLEAN
			l_type_visitor: SCOOP_TYPE_VISITOR
			a_like_type: LIKE_ID_AS
			l_type_a: TYPE_A
			l_formal_a: FORMAL_A
			l_feature_i: FEATURE_I
			l_name: STRING
		do
			-- process colon symbol
			if is_declared_type then
				context.add_string (": ")
			end

			-- get TYPE_C of given TYPE_AS
			create l_type_visitor
			a_class_c := l_type_visitor.evaluate_class_from_type (a_type, class_c)

			-- check if type is like type
			a_like_type ?= a_type
			if a_like_type /= Void and then a_like_type.anchor /= Void then
				if class_as.feature_table.has (a_like_type.anchor.name) then
					l_feature_i := class_as.feature_table.item (a_like_type.anchor.name)
					l_type_a := l_feature_i.type

					-- get class type for a like type and process it
					if l_type_a.is_attached then
						context.add_string (" !")
					else
						context.add_string (" ")
					end

					-- print class name
					if l_type_a.is_formal then
						l_formal_a ?= l_type_a
						create l_name.make_from_string (class_c.generics.i_th (l_formal_a.position).name.name.as_upper)
						process_class_name_str (l_name, false, context, match_list)
					else
						is_separate := l_type_a.is_separate

						-- get class name of actual type
						if l_type_a.associated_class /= Void then
							create l_name.make_from_string (l_type_a.associated_class.name_in_upper)
						else
							-- can be the case when a like type refers to a like type of generic type
							-- todo: check other implementation
							create l_name.make_from_string (l_type_a.actual_type.name.as_upper)
						end
						process_class_name_str (l_name, is_separate, context, match_list)

						-- process_class_name_str (l_type_a.associated_class.name_in_upper, is_separate, context, match_list)

						-- process generics
						if l_feature_i.access_class.is_generic then
							l_proxy_type_visitor.process_type_ast (l_feature_i.access_class.ast.internal_generics)
						end
					end
				end
			else
				-- process type
				l_proxy_type_visitor.process_type (a_type)
			end
		end

	create_assign_wrapper_feature (l_feature_name, an_assigner_name: STRING; l_as: FEATURE_AS) is
			-- create a new feature for the assign id of the current processed feature
		require
			assigner_not_void: an_assigner_name /= Void
		local
			l_last_index: INTEGER
			l_args : FORMAL_ARGU_DEC_LIST_AS
		do
			l_last_index := last_index
			l_args := l_as.body.internal_arguments

			-- create a call to a wrapper feature
			context.add_string ("%N%N%T")
			context.add_string (l_feature_name)
			context.add_string ("_scoop_separate_assigner_")

			-- process type
			-- first argument is the processed type of the feature
			context.add_string ("(" + an_assigner_name + "_arg_1_: ")
			l_type_signature.process_type (l_as.body.type)
			-- second argument `a_caller_: SCOOP_SEPARATE_TYPE'.
			context.add_string ("; a_caller_: SCOOP_SEPARATE_TYPE; ")
			-- now append the arguments of the current feature
			if l_args /= Void and then
				l_args.arguments /= Void then
				last_index := l_args.first_token (match_list).index -- - 1

				safe_process (l_args.arguments)
			end
			context.add_string (")")

			-- create is keyword and comment
			context.add_string ("%N%T%T%T-- Wrapper for assign call")

			if l_as.is_deferred then
				-- deferred keyword
				context.add_string ("%N%T%Tdeferred")
			else
				-- create do keyword
				context.add_string ("%N%T%Tdo")

				-- create call to the assigner feature
				context.add_string ("%N%T%T%T")
				context.add_string (an_assigner_name)

				-- print argument list
				context.add_string (" (a_caller_, " + an_assigner_name + "_arg_1_")
				if l_args /= Void then
					context.add_string (", ")
					process_formal_argument_list_with_auxiliary_variables (l_args, false, false)
				end
				context.add_string (")")
			end

			-- end keyword
			context.add_string ("%N%T%Tend")

			-- set index back
			last_index := l_last_index
		end

feature{NONE} -- Implementation

	is_having_assign_id_name: BOOLEAN
			-- is the current processed body containing an assign id name.

	l_type_attribute_wrapper: SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER
			-- prints 'TYPE_AS' to the context

end
