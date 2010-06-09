note
	description: "Class to replace variables in an expression with special format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_ABSTRACTING_EXPRESSION_REWRITER

inherit
	EPA_TRANSITION_EXPRESSION_REWRITER
		redefine
			process_nested_as,
			process_access_feat_as
		end
	EPA_TYPE_UTILITY
	ETR_SHARED_TOOLS
create
	make

feature -- Basic operations

	abstracted_expression_texts (a_expr: EPA_EXPRESSION; a_principal_variable: detachable EPA_EXPRESSION; a_abstract_types: detachable LIST[CL_TYPE_A]; a_replacements: detachable like replacements): LIST[STRING]
		local
			l_trans: ETR_TRANSFORMABLE
			l_trans_in_context: ETR_TRANSFORMABLE
		do
			create {LINKED_LIST[STRING]}Result.make
			if not a_expr.type.is_none then
				from
					create l_trans.make (a_expr.ast, create {ETR_CLASS_CONTEXT}.make (a_expr.type.associated_class), true)
					principal_variable_text := a_principal_variable.text
					replacements := a_replacements
					a_abstract_types.start
				until
					a_abstract_types.after
				loop
					create abstract_context.make (a_abstract_types.item.associated_class)
					l_trans_in_context := l_trans.as_in_other_context (abstract_context)

					output.reset
					last_was_unqualified := true
					can_abstract := true
					replacements.force (once "{" + cleaned_type_name (a_abstract_types.item.name) + once "}", principal_variable_text)
					current_abstract_class := a_abstract_types.item.associated_class

					l_trans_in_context.target_node.process (Current)
					if can_abstract then
						Result.extend(output.string_representation)
					end

					a_abstract_types.forth
				end
			end
		end

feature {NONE} -- Implementation

	can_abstract: BOOLEAN

	abstract_context: ETR_CLASS_CONTEXT

	current_abstract_class: CLASS_C

	principal_variable_text: STRING

	current_feature: FEATURE_I

	print_static_argument_types (a_feature: FEATURE_I)
			-- Print the static arguments types of `a_feature'
		local
			l_expl_type: TYPE_A
		do
			from
				a_feature.arguments.start
			until
				a_feature.arguments.after
			loop
				l_expl_type := type_checker.explicit_type (a_feature.arguments.item, current_abstract_class, a_feature)
				output.append_string (once "{" + cleaned_type_name (l_expl_type.name) + once "}")

				a_feature.arguments.forth
				if not a_feature.arguments.after then
					output.append_string (", ")
				end
			end
		end

feature {AST_EIFFEL} -- Processing

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: FEATURE_I
		do
			if last_was_unqualified then
				process_access_name (l_as.access_name)
			else
				output.append_string (l_as.access_name)
				l_feature := current_abstract_class.feature_named (l_as.access_name)
			end

			last_was_unqualified := true
			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space+ti_l_parenthesis)
				if l_feature /= void then
					process_child_list (l_as.parameters, ti_comma+ti_Space, l_as, 1)
				else
					print_static_argument_types (l_feature)
				end
				output.append_string (ti_r_parenthesis)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			if not last_was_unqualified then
				process_child (l_as.target, l_as, 1)
				output.append_string (ti_dot)
				process_child (l_as.message, l_as, 2)
			else
				if l_as.target.access_name.is_equal (principal_variable_text) and then attached {ACCESS_AS}l_as.message as l_acc and then current_abstract_class.feature_named (l_acc.access_name)=void then
					-- Abstract class doesn't contain the feature
					-- Should never happen at this point.
					can_abstract := false
				else
					process_child (l_as.target, l_as, 1)
					last_was_unqualified := false
					output.append_string (ti_dot)
					process_child (l_as.message, l_as, 2)
					last_was_unqualified := true
				end
			end
		end
end
