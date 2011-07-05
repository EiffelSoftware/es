note
	description: "Class to rewrite a statement (either an instruction or an expression) in callee site into an expression in caller site"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CALLEE_STATEMENT_REWRITER

inherit
	ETR_CONTRACT_TOOLS

feature -- Access

	rewritten_ast (a_ast: AST_EIFFEL; a_written_class: CLASS_C; a_caller_context: EPA_CALLER_CONTEXT): AST_EIFFEL
			-- Rewritten AST from `a_ast' to `a_caller_context'
			-- `a_ast' is from `a_written_class'.
		do
			-- To implement.
		end

	rewritten_preconditions (a_caller_context: EPA_CALLER_CONTEXT): LINKED_LIST [AST_EIFFEL]
			-- Preconditions of the feature specified in `a_caller_context'
			-- rewritten in the context of `a_caller_context'
		require
			a_caller_context_has_feature: a_caller_context.has_callee
		do
			create Result.make
			across all_preconditions (a_caller_context.callee) as l_preconditions loop
				across l_preconditions.item.assertions as l_asserts loop
					Result.extend (rewritten_ast (l_asserts.item.expr, l_preconditions.item.source_class, a_caller_context))
				end
			end
		end

	rewritten_postconditions (a_caller_context: EPA_CALLER_CONTEXT): LINKED_LIST [AST_EIFFEL]
			-- Postconditions of the feature specified in `a_caller_context'
			-- rewritten in the context of `a_caller_context'
		require
			a_caller_context_has_feature: a_caller_context.has_callee
		do
			create Result.make
			across all_postconditions (a_caller_context.callee) as l_postconditions loop
				across l_postconditions.item.assertions as l_asserts loop
					Result.extend (rewritten_ast (l_asserts.item.expr, l_postconditions.item.source_class, a_caller_context))
				end
			end
		end

	rewritten_invariants (a_caller_context: EPA_CALLER_CONTEXT): LINKED_LIST [AST_EIFFEL]
			-- Invariants of the target in `a_caller_context'.
			-- rewritten in the context of `a_caller_context'
		do
			create Result.make
			across all_invariants (a_caller_context.target_type.associated_class) as l_invariants loop
				across l_invariants.item.assertions as l_asserts loop
					Result.extend (rewritten_ast (l_asserts.item.expr, l_invariants.item.source_class, a_caller_context))
				end
			end
		end

end
