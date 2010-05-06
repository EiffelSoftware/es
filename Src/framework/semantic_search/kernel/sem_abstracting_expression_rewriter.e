note
	description: "Class to replace variables in an expression with special format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_ABSTRACTING_EXPRESSION_REWRITER

inherit
	SEM_TRANSITION_EXPRESSION_REWRITER
		redefine
			process_nested_as
		end
	EPA_TYPE_UTILITY

create
	make

feature -- Basic operations

	abstracted_expression_texts (a_expr, a_principal_variable: EPA_EXPRESSION; a_abstract_types: LIST[CL_TYPE_A]; a_replacements: like replacements): LIST[STRING]
		do
			from
				principal_variable_text := a_principal_variable.text
				create {LINKED_LIST[STRING]}Result.make
				replacements := a_replacements
				a_abstract_types.start
			until
				a_abstract_types.after
			loop
				output.reset
				last_was_unqualified := true
				can_abstract := true
				replacements.force (once "{" + cleaned_type_name (a_abstract_types.item.name) + once "}", principal_variable_text)
				current_abstract_class := a_abstract_types.item.associated_class

				a_expr.process (Current)
				if can_abstract then
					Result.extend(output.string_representation)
				end

				a_abstract_types.forth
			end
		end

feature {NONE} -- Implementation

	can_abstract: BOOLEAN

	current_abstract_class: CLASS_C

	principal_variable_text: STRING

feature {AST_EIFFEL} -- Processing

	process_nested_as (l_as: NESTED_AS)
		do
			if not last_was_unqualified then
				process_child (l_as.target, l_as, 1)
				output.append_string (ti_dot)
				process_child (l_as.message, l_as, 2)
			else
				if l_as.target.access_name.is_equal (principal_variable_text) and then attached {ACCESS_AS}l_as.message as l_acc and then current_abstract_class.feature_named (l_acc.access_name)=void then
					-- Abstract class doesn't contain the feature
					-- No nesting supported
					-- No renaming supported
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
