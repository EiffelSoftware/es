note
	description: "[
		This class should give a list of expressions to be satisfied in order to reach all possible
		points in a given feature.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BRANCHING_EXPRESSION_FINDER

inherit
	EPA_EXPRESSION_FINDER

	REFACTORING_HELPER

	EPA_UTILITY

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	AST_ITERATOR
	redefine
		process_if_as, process_loop_as, process_elseif_as
	end

create
	make

feature {NONE}
	make(a_feature: like the_feature)
		-- Would it be better to just take a feature as an argument and return all the branchings for that feature
		-- than to return the branchings for all features of the class?
		-- Initialization
		do
			the_feature := a_feature
			create big_stack.make
			create found_branching_expressions.make(10)
		end

feature -- Access
	the_feature: FEATURE_I
	found_branching_expressions: ARRAYED_LIST[ARRAYED_LIST[EPA_AST_EXPRESSION]]
	big_stack: LINKED_STACK[LINKED_STACK[STRING]]

	feature{EPA_BRANCHING_EXPRESSION_FINDER}
		add_to_main_stack(text:STRING)
				-- adds a new entry into the big stack
			local
				l_stack: LINKED_STACK[STRING]
			do
				create l_stack.make
				l_stack.put (text)
				big_stack.put (l_stack)
			end

		add_to_sub_stack(text:STRING)
				-- pushes 'text' to the stack which is on top of the big stack
			require
				big_stack_not_empty: not big_stack.is_empty
			do
				big_stack.item.put (text)
			end

		dump_stack(a_stack:LINKED_STACK[STRING]): ARRAYED_LIST[EPA_AST_EXPRESSION]
				-- returns a text representation of all the expressions in 'a_stack'
			local
				l_expr: EPA_AST_EXPRESSION
				l_list : ARRAYED_LIST[STRING]
			do
				create Result.make (10)
				create l_expr.make_with_text (the_feature.written_class, the_feature, a_stack.item, the_feature.written_class)
				Result.force (l_expr)
				l_list := a_stack.linear_representation
				-- remove the element that we just put into the result
				l_list.start
				l_list.remove

				from l_list.start until l_list.after loop
					create l_expr.make_with_text (the_feature.written_class, the_feature,"not " +  l_list.item_for_iteration, the_feature.written_class)
					Result.force (l_expr)
					l_list.forth
				end
			end

		save_stack_snapshot
				-- saves everything that exist in 'big_stack' into a list of expressions and puts it into 'found_branching_expressions'
			local
				l_list: ARRAYED_LIST[LINKED_STACK[STRING]]
				l_expr_list : ARRAYED_LIST[EPA_AST_EXPRESSION]
			do
				l_list := big_stack.linear_representation
				create l_expr_list.make (0)
				from l_list.finish
				until l_list.before
				loop
					l_expr_list.append (dump_stack (l_list.item_for_iteration))
					l_list.back
				end
				found_branching_expressions.force (l_expr_list)
			end

		handle_if_end
			local
				l_stack : LINKED_STACK[STRING]
			do
				l_stack := big_stack.item
				from
				until l_stack.count = 1
				loop
					l_stack.remove
				end
				save_stack_snapshot
				big_stack.remove
			end

feature
	process_if_as (l_as: IF_AS)
		local
			l_stack : LINKED_STACK[STRING]
		do
			add_to_main_stack (text_from_ast (l_as.condition))
			precursor(l_as)
			handle_if_end
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			add_to_sub_stack (text_from_ast (l_as.expr))
			precursor(l_as)
			save_stack_snapshot
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_stack : LINKED_STACK[STRING]
		do
			add_to_main_stack (text_from_ast (l_as.stop))
			precursor(l_as)
			save_stack_snapshot
			big_stack.remove

		end

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
		local
			l_features: LIST [FEATURE_I]
		do
			the_feature.e_feature.ast.process(Current)
		end


invariant
	invariant_clause: True -- Your invariant here

end
