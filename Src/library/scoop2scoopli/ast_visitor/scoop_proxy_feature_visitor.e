note
	description: "[
					A class visitor to generate proxy features out of original features.
					
					- For each original feature of the original class, a feature with the same name gets created in the proxy class. This feature is deferred if the original feature is deferred, and effective if the original feature is effective.
					- A proxy feature decides whether the call from the client is asynchronous or synchronous. Lock passing and wait by necessity cause a synchronous call.
					- Each such proxy feature has as a first argument the caller. The caller is necessary to decide whether lock passing will happen. The remaining argument are the same as in the original feature, except that non-ignored, non-expanded, non-formal types are transformed into the respective proxy types.
					- The visitor takes care of assigner mediator creation.
					- For each attribute, a attribute wrapper gets generated, because Eiffel doesn't support agents on attributes directly. This wrapper is always effective, so that it can be inherited by effective classes without the need to redefine them.
					- For each constant, a constant wrapper gets generated, because Eiffel doesn't support agents on constants directly. This wrapper is always effective, so that it can be inherited by effective classes without the need to redefine them.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_FEATURE_VISITOR

inherit
	SCOOP_SEPARATE_PROXY_PRINTER
		redefine
			process_feature_as
		end

create
	make_with_context

feature {NONE} -- Initialisation

	make_with_context (a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context
		end


feature -- Access

	add_proxy_features (l_as: FEATURE_AS)
			-- Add the proxy features for the original feature 'l_as'.
		do
			-- init
			l_type_attribute_wrapper := scoop_visitor_factory.new_proxy_type_attriute_wrapper_printer (context)
			l_type_locals := scoop_visitor_factory.new_proxy_type_local_printer (context)
			l_type_signature := scoop_visitor_factory.new_proxy_type_signature_printer (context)

			-- process node
			safe_process (l_as)
		end

feature {NONE} -- Implementation

	process_feature_as (l_as: FEATURE_AS)
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
				add_attribute_proxy_features (l_as)
			elseif l_as.is_constant then
				add_constant_proxy_features (l_as)
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

					if not is_first_feature then
						context.add_string ("%N%N%T")
					else
						set_is_first_feature (False)
					end
					-- process frozen key word
					last_index := l_feature_name.first_token (match_list).index
					safe_process (l_feature_name.frozen_keyword)

					-- get feature name
					l_feature_name_visitor.process_feature_name (l_feature_name, False)
					l_feature_name_str := l_feature_name_visitor.feature_name
					-- l_feature_name_visitor.process_feature_name (l_feature_name, True)
					l_feature_declaration_name := l_feature_name_visitor.feature_name

					-- get original feature name
					l_feature_name_visitor.process_original_feature_name (l_feature_name, True)
					l_original_feature_alias_name := l_feature_name_visitor.feature_name
					-- l_feature_name_visitor.process_original_feature_name (l_feature_name, False)
					l_original_feature_name := l_feature_name_visitor.feature_name


					scoop_workbench_objects.set_current_proxy_feature_name (l_original_feature_name)

					-- add feature name
					context.add_string (l_feature_declaration_name + " ")

					-- reset assign name flag
					is_having_assign_id_name := False

					-- body (function and procedure)
					add_routine_proxy_features (l_as.body, l_as, l_feature_name_str, l_feature_declaration_name)

					-- create mediator feature for assign id name
					create l_assign_finder
					if is_having_assign_id_name then
						l_assigner_name := l_as.body.assigner.name

						-- create wrapper feature for assigner call
						add_assigner_mediator (l_feature_name_str, l_assigner_name, l_as)

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
						l_assigner_name := l_assign_finder.inherited_assigner_name (l_original_feature_name, l_original_feature_alias_name, class_c)

						-- create wrapper feature for assigner call
						add_assigner_mediator (l_feature_name_str, l_assigner_name, l_as)
					end

					i := i + 1
				end
				scoop_workbench_objects.set_current_proxy_feature_name (Void)
			end
			set_current_feature_as_void
		end

	add_routine_proxy_features (l_as: BODY_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING)
		local
			r_as: ROUTINE_AS
			ex_as: EXTERNAL_AS
			once_as: ONCE_AS
			generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
			feature_name: FEATURE_NAME
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
		do

			last_index := l_as.first_token (match_list).index - 1

			-- create internal arguments
			if l_as.internal_arguments /= Void then
				last_index := l_as.internal_arguments.first_token (match_list).index - 1
				add_formal_argument_list (l_as.internal_arguments, true)
				last_index := l_as.internal_arguments.last_token (match_list).index
			else
				context.add_string ("(" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ": attached " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_separate_type_class_name + ")")
			end

			safe_process (l_as.colon_symbol (match_list))

			-- Do we need to substitute some generics
			from
				feature_as.feature_names.start
			until
				feature_as.feature_names.after
			loop
				if feature_as.feature_names.item.visual_name.is_equal (feature_as.feature_name.name) then
					feature_name := feature_as.feature_names.item
				end
				feature_as.feature_names.forth
			end
			if attached {GENERIC_CLASS_TYPE_AS}  l_as.type as gen_typ then
				create l_assign_finder
				generics_to_substitute := l_assign_finder.generic_parameters_to_replace (feature_name, class_c, False, Void, True)
				if not generics_to_substitute.is_empty then
					l_type_signature.set_generics_to_substitute (generics_to_substitute)
				end
			end

			-- process type of feature
			if attached feature_as as feat then
				l_type_signature.set_from_formal (parent_result_is_formal (feat.feature_name.name_id))
			end

			l_type_signature.process_type_replace_current (l_as.type)



			if l_as.type /= Void then
				last_index := l_as.type.last_token (match_list).index
				context.add_string (" ")
			end

			safe_process (l_as.assign_keyword (match_list))

			if l_as.assigner /= Void then
				process_leading_leaves (l_as.assigner.index)

				-- remember processing assigner
				is_having_assign_id_name := True

				-- create a call to a wrapper feature
				context.add_string (a_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + {SCOOP_SYSTEM_CONSTANTS}.assigner_mediator_name_additive)

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
						add_function_content(r_as, a_feature, a_feature_name, a_feature_declaration_name)
					end
				else
					if a_feature.is_deferred then
						context.add_string ("%N%T%Tdeferred%N%T%Tend")
					else
						add_procedure_content(r_as, a_feature, a_feature_name, a_feature_declaration_name)
					end
				end
			end
			ex_as ?= l_as.content
			if ex_as /= Void then
				-- external_as or built_in_as
				if l_as.type /= Void then
					add_external_function_content(ex_as, a_feature, a_feature_name)
				else
					add_external_procedure_content(ex_as, a_feature, a_feature_name)
				end
			end
			once_as ?= l_as.content
			if once_as /= Void then
				if l_as.type /= Void then
					add_once_function_content(once_as, a_feature, a_feature_name)
				else
					add_once_procedure_content(once_as, a_feature, a_feature_name)
				end
			end
			-- Wipe out `feature_object.internal_arguments_to_substitute'
			feature_object.internal_arguments_to_substitute.wipe_out
		end

	add_attribute_proxy_features (l_as: FEATURE_AS)
			-- Process `l_as'.
		local
			i, nb: INTEGER
			a_class_type: CLASS_TYPE_AS
			l_feature_name: FEATURE_NAME
			l_feature_name_str: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			a_class_type ?= l_as.body.type
			if not (a_class_type /= Void and then a_class_type.class_name.name.as_upper.is_equal ({SCOOP_SYSTEM_CONSTANTS}.original_code_processor_class_name)) then

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
					l_feature_name_visitor.process_feature_name (l_feature_name, False)
					l_feature_name_str := l_feature_name_visitor.feature_name
					scoop_workbench_objects.set_current_proxy_feature_name (l_feature_name_str)

					-- create agent feature
					last_index := l_feature_name.first_token (match_list).index - 1
					if not is_first_feature then
						context.add_string ("%N%N%T")
					else
						set_is_first_feature (False)
					end

					-- set feature name
					context.add_string (l_feature_name_str)

					-- set formal argument
					context.add_string (" (" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ": attached " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_separate_type_class_name + ")")
					context.add_string (": ")
					-- set type
					l_type_attribute_wrapper.process_type (l_as.body.type)

					-- keyword is and local declaration
					context.add_string ("%N%T%Tlocal")
					add_client_agent_local (l_as)

					-- body and agent declarateion
					context.add_string ("%N%T%Tdo%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := ")
					context.add_string ("agent " + l_feature_name_str + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)

					-- execution
					context.add_string (
						"%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_synchronous_execute_feature_name + " (" +
							{SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + "," +
							{SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name +
						")"
					)

					-- feature result
					context.add_string ("%N%T%T%TResult ")
					context.add_string (":=")
					context.add_string ({SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + "." + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_result_query_name)

					l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
					l_type_expression_visitor.resolve_type_in_workbench (l_as.body.type)
					if
						not (
							l_type_expression_visitor.resolved_type.is_expanded or
							l_type_Expression_visitor.is_resolved_type_based_on_formal_generic_parameter or
							(feature_as /= Void and then parent_result_is_formal (feature_as.feature_name.name_id))
						)
					then
						-- first has prefix
						if not l_type_expression_visitor.resolved_type.is_separate then
							-- second doesnt have prefix
							if not is_in_ignored_group (l_type_expression_visitor.resolved_type.associated_class) then
								if not add_result_substitution then
									-- If `add_result_substitution' was converted -> dont reconvert
									context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
								end
							end
						end
					end

					-- end keyword
					context.add_string ("%N%T%Tend%N%N%T")

					-- Create wrapper for attribute. Necessary for agent creation.
					context.add_string (l_feature_name_str + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)
					context.add_string (": ")

					-- result type (original / client type)
					if add_result_substitution then
						if attached {CLASS_TYPE_AS} l_as.body.type as type then
							-- Fix was added before: need to convert to separate return type
							context.add_string ({SCOOP_SYSTEM_CONSTANTS}.proxy_class_prefix+type.class_name.name)
						end
					else
						l_type_locals.process_type (l_as.body.type)
					end

--					process_result_type (l_as.body.type, True, l_type_signature)

					-- body
					context.add_string ("%N%T%T%T-- Wrapper for attribute `" + l_feature_name_str + "'.")
					context.add_string ("%N%T%Tdo%N%T%T%TResult := " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + "." + l_feature_name_str)
					context.add_string ("%N%T%Tend")

					-- no is_keyword, no body, skip indexing clause
					i := i + 1
				end
				last_index := l_as.last_token (match_list).index
				scoop_workbench_objects.set_current_proxy_feature_name (Void)
			end
		end

	add_constant_proxy_features (l_as: FEATURE_AS)
		local
			i, nb: INTEGER
			l_feature_name: FEATURE_NAME
			l_feature_name_str: STRING
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
				l_feature_name_visitor.process_feature_name (l_feature_name, False)
				l_feature_name_str := l_feature_name_visitor.feature_name
				scoop_workbench_objects.set_current_proxy_feature_name (l_feature_name_str)

				if not is_first_feature then
					context.add_string ("%N%N%T")
				else
					set_is_first_feature (False)
				end

				-- set feature name
				context.add_string (l_feature_name_str)

				-- set formal argument
				context.add_string (" (" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ": attached " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_separate_type_class_name + ")")
				context.add_string (": ")

				-- set type
				l_type_attribute_wrapper.process_type (l_as.body.type)

				-- keyword is and local declaration
				context.add_string ("%N%T%Tlocal")
				add_client_agent_local (l_as)

				-- body and agent declarateion
				context.add_string ("%N%T%Tdo%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := ")
				context.add_string ("agent " + l_feature_name_str + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)

				-- execution
				context.add_string (
					"%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_synchronous_execute_feature_name + "(" +
						{SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ", " +
						{SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name +
					")"
				)

				-- feature result
				context.add_string ("%N%T%T%TResult ")
				context.add_string ("?= ")
				context.add_string ({SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + "." + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_result_query_name)

				-- end keyword
				context.add_string ("%N%T%Tend%N%N%T")

				-- Create wrapper for attribute. Necessary for agent creation.
				last_index := l_feature_name.first_token (match_list).index - 1
				context.add_string  (l_feature_name_str + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower + ": ")

				-- result type
				l_type_locals.process_type (l_as.body.type)

				-- body
				context.add_string ("%N%T%T%T-- Wrapper for constant `")
				context.add_string (l_feature_name_str)
				context.add_string ( "'.")
				context.add_string ("%N%T%Tdo%N%T%T%TResult := " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
				context.add_string (l_feature_name_str)
				context.add_string ("%N%T%Tend")

				-- no is_keyword, no body, skip indexing clause
				i := i + 1
			end
			last_index := l_as.last_token (match_list).index
			scoop_workbench_objects.set_current_proxy_feature_name (Void)
		end

	add_async_call_content
		do
			context.add_string ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.async_call_name)
			context.add_string ("(" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name)
			context.add_string ("," + {SCOOP_SYSTEM_CONSTANTS}.lock_passing_detector_local_name)
			context.add_string ("," + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name)
			context.add_string (")")
		end

	add_wait_call_content
		do
			context.add_string ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.wait_call_name)
			context.add_string ("(" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name)
			context.add_string ("," + {SCOOP_SYSTEM_CONSTANTS}.lock_passing_detector_local_name)
			context.add_string ("," + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name)
			context.add_string (")")
		end

	add_function_content (l_as: ROUTINE_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING)
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			context.add_string ("%N%T%Tlocal")
			add_client_agent_local (a_feature)
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_wait_call_content

			context.add_string ("%N%T%T%TResult ")
			context.add_string (":= ")
			context.add_string ({SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + "." + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_result_query_name)

			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
			l_type_expression_visitor.resolve_type_in_workbench (a_feature.body.type)
			if
				not (
					l_type_expression_visitor.resolved_type.is_expanded or
					l_type_expression_visitor.is_resolved_type_based_on_formal_generic_parameter or
					(feature_as /= Void and then parent_result_is_formal (feature_as.feature_name.name_id))
				)
			then
				-- first has prefix
				if not l_type_expression_visitor.resolved_type.is_separate then

					-- second doesnt have prefix
					if not is_in_ignored_group (l_type_expression_visitor.resolved_type.associated_class) then
						if not add_result_substitution then
							-- If `add_result_substitution' means the result type was converted -> dont reconvert
							context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
						end
					end
				end
			end

			context.add_string ("%N%T%Tend%N")
		end

	add_procedure_content (l_as: ROUTINE_AS; a_feature: FEATURE_AS; a_feature_name, a_feature_declaration_name: STRING)
		do
			context.add_string ("%N%T%Tlocal")
			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + ": " + system.procedure_class.name + "[" + system.any_class.name + ", " + system.tuple_class.name + "]")
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_async_call_content

			context.add_string ("%N%T%Tend")
		end

	add_external_function_content (l_as: EXTERNAL_AS; a_feature: FEATURE_AS; a_feature_name: STRING)
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			context.add_string ("%N%T%Tlocal")
			add_client_agent_local (a_feature)
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_wait_call_content

			context.add_string ("%N%T%T%TResult ")
			context.add_string (":= ")
			context.add_string ({SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + "." + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_result_query_name)

			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
			l_type_expression_visitor.resolve_type_in_workbench (a_feature.body.type)
			if
				not (
					l_type_expression_visitor.resolved_type.is_expanded or
					l_type_expression_visitor.is_resolved_type_based_on_formal_generic_parameter or
					(feature_as /= Void and then parent_result_is_formal (feature_as.feature_name.name_id))
				)
			then
				-- first has prefix
				if not l_type_expression_visitor.resolved_type.is_separate then

					-- second doesnt have prefix
					if not is_in_ignored_group (l_type_expression_visitor.resolved_type.associated_class) then
						if not add_result_substitution then
							-- If `add_result_substitution' means the result type was converted -> dont reconvert
							context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
						end
					end
				end
			end

			context.add_string ("%N%T%Tend%N")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)
			context.add_string (" ")
			if a_feature.body.internal_arguments /= void then
				last_index := a_feature.body.internal_arguments.first_token (match_list).index - 1
				add_formal_argument_list (a_feature.body.internal_arguments, false)
				last_index := a_feature.body.internal_arguments.last_token (match_list).index
			end

			-- process type
			add_result_type (a_feature.body.type, True, l_type_signature)

			context.add_string ("%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%TResult := " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + "." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				add_actual_argument_list (a_feature.body.internal_arguments, false, true, true)
			end
			context.add_string ("%N%T%Tend")
		end

	add_external_procedure_content (l_as: EXTERNAL_AS; a_feature: FEATURE_AS; a_feature_name: STRING)
		do
			context.add_string ("%N%T%Tlocal")
			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + ": " + system.procedure_class.name + "[" + system.any_class.name + ", " + system.tuple_class.name + "]")
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_async_call_content

			context.add_string ("%N%T%Tend")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)
			context.add_string (" ")
			if a_feature.body.internal_arguments /= void then
				last_index := a_feature.body.internal_arguments.first_token (match_list).index - 1
				add_formal_argument_list (a_feature.body.internal_arguments, false)
				last_index := a_feature.body.internal_arguments.last_token (match_list).index
			end
			context.add_string ("%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + "." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				add_actual_argument_list (a_feature.body.internal_arguments, false, true, true)
			end
			context.add_string ("%N%T%Tend")
		end

	add_once_procedure_content (l_as: ONCE_AS; a_feature: FEATURE_AS; a_feature_name: STRING)
		do
			context.add_string ("%N%T%Tlocal")
			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + ": " + system.procedure_class.name + "[" + system.any_class.name + ", " + system.tuple_class.name + "]")
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_async_call_content

			context.add_string ("%N%T%Tend")

			-- Create wrapper for external feature. Necessary for agent creation.
			context.add_string (a_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower + " ")
			if a_feature.body.internal_arguments /= void then
				last_index := a_feature.body.internal_arguments.first_token (match_list).index - 1
				add_formal_argument_list (a_feature.body.internal_arguments, false)
				last_index := a_feature.body.internal_arguments.last_token (match_list).index
			end
			context.add_string ("%N%T%T%T")
			context.add_string ("-- Wrapper for external feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + "." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				add_actual_argument_list (a_feature.body.internal_arguments, false, true, true)
			end
			context.add_string ("%N%T%Tend")
		end

	add_once_function_content (l_as: ONCE_AS; a_feature: FEATURE_AS; a_feature_name: STRING)
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			context.add_string ("%N%T%Tlocal")
			add_client_agent_local (a_feature)
			add_lock_passing_detection_code (a_feature)

			context.add_string ("%N%T%T%T" + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + " := agent " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + ".")
			context.add_string (a_feature_name)
			if a_feature.body.internal_arguments /= Void then
				add_actual_argument_list (a_feature.body.internal_arguments, False, True, true)
			end

			add_wait_call_content

			context.add_string ("%N%T%T%TResult ")
			context.add_string (":= ")
			context.add_string ({SCOOP_SYSTEM_CONSTANTS}.client_agent_local_name + "." + {SCOOP_SYSTEM_CONSTANTS}.client_agent_local_result_query_name)

			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
			l_type_expression_visitor.resolve_type_in_workbench (a_feature.body.type)
			if
				not (
					l_type_expression_visitor.resolved_type.is_expanded or
					l_type_expression_visitor.is_resolved_type_based_on_formal_generic_parameter or
					(feature_as /= Void and then parent_result_is_formal (feature_as.feature_name.name_id))
				)
			then
				-- first has prefix
				if not l_type_expression_visitor.resolved_type.is_separate then

					-- second doesnt have prefix
					if not is_in_ignored_group (l_type_expression_visitor.resolved_type.associated_class) then
						if not add_result_substitution then
							-- If `add_result_substitution' means the result type was converted -> dont reconvert
							context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
						end
					end
				end
			end

			context.add_string ("%N%T%Tend%N")

			-- Create wrapper for once feature. Necessary for agent creation.
			context.add_string (a_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + class_as.class_name.name.as_lower)
			context.add_string (" ")
			if a_feature.body.internal_arguments /= void then
				last_index := a_feature.body.internal_arguments.first_token (match_list).index - 1
				add_formal_argument_list (a_feature.body.internal_arguments, false)
				last_index := a_feature.body.internal_arguments.last_token (match_list).index
			end
			add_result_type (a_feature.body.type, True, l_type_signature)
			context.add_string ("%N%T%T%T")
			context.add_string ("-- Wrapper for once feature `" + a_feature_name + "'.")
			context.add_string ("%N%T%Tdo%N%T%T%TResult := " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name + "." + a_feature_name)
			if a_feature.body.internal_arguments /= void then
				context.add_string (" ")
				add_actual_argument_list (a_feature.body.internal_arguments, false, true, true)
			end
			context.add_string ("%N%T%Tend")
		end

	add_result_type (a_type: TYPE_AS; is_declared_type: BOOLEAN; l_proxy_type_visitor: SCOOP_PROXY_TYPE_VISITOR)
			-- Process `a_type'. Precede with `:' if `is_declared_type' is True.
		local
			is_separate: BOOLEAN
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
						process_class_name_str (l_name, False, context, match_list)
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

	add_assigner_mediator (l_feature_name, an_assigner_name: STRING; l_as: FEATURE_AS)
			-- create a new feature for the assign id of the current processed feature
		require
			assigner_not_void: an_assigner_name /= Void
		local
			l_last_index: INTEGER
			l_args : FORMAL_ARGU_DEC_LIST_AS
		do
			l_last_index := last_index
			l_args := l_as.body.internal_arguments

			-- create a new feature clause with export status {NONE}
			context.add_string ("%N%Nfeature {NONE} -- Assign mediator feature of feature '" + l_feature_name + "'")

			-- create a call to a wrapper feature
			context.add_string ("%N%N%T")
			context.add_string (l_feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive + {SCOOP_SYSTEM_CONSTANTS}.assigner_mediator_name_additive)

			-- process type
			-- first argument is the processed type of the feature
			context.add_string ("(" + {SCOOP_SYSTEM_CONSTANTS}.assigner_mediator_source_formal_argument_name + ": ")
			l_type_signature.process_type (l_as.body.type)
			-- second argument is the caller.
			context.add_string ("; " + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ": attached " + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_separate_type_class_name + "; ")
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
				context.add_string (" (" + {SCOOP_SYSTEM_CONSTANTS}.caller_formal_argument_name + ", " + {SCOOP_SYSTEM_CONSTANTS}.assigner_mediator_source_formal_argument_name)
				if l_args /= Void then
					context.add_string (", ")
					add_actual_argument_list (l_args, False, False, false)
				end
				context.add_string (")")
			end

			-- end keyword
			context.add_string ("%N%T%Tend")

			-- reset the feature clause: print out the original to get also the
			-- original export state.
			context.add_string ("%N%N")
			last_index := feature_clause_as.first_token (match_list).index
			safe_process (feature_clause_as.feature_keyword)

			if feature_clause_as.features /= Void then
				process_leading_leaves (feature_clause_as.features.first_token (match_list).index)
			else
				process_leading_leaves (feature_clause_as.last_token (match_list).index + 1)
			end

			-- set index back
			set_is_first_feature (True)
			last_index := l_last_index
		end

	is_having_assign_id_name: BOOLEAN
			-- is the current processed body containing an assign id name.

	l_type_attribute_wrapper: SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER
			-- prints 'TYPE_AS' to the context

;note
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

end -- class SCOOP_PROXY_FEATURE_VISITOR
