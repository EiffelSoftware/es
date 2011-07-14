note
	description: "Collects read-only alias names from type {ID_AS}, used in 'across' loops and 'object test local' statements."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_READ_ONLY_ALIAS_FINDER

inherit
	AST_ITERATOR
		redefine
			process_object_test_as,
			process_loop_as
		end

	EPA_UTILITY

	EXT_SHARED_LOGGER

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_target_variables: like target_variables; a_context_class: like context_class)
			-- Default initialiation.
		do
			target_variables := a_target_variables
			context_class := a_context_class

			reset
		end

feature -- Access

	reset
			-- Reset data from last visit.
		do
			create attached_object_test_as_tuples.make
		end

	last_aliases: like {EXT_VARIABLE_CONTEXT}.target_variables
			-- The identifiers and evaluated types of last AST visit.
		local
			l_type_a: TYPE_A
		do
			create Result.make (5)
			Result.compare_objects

			across attached_object_test_as_tuples as l_iterator loop
				if is_expression_dependant_on_targets (l_iterator.item.expression) then
						-- Default type if real type cannot be resolved.
					create {NONE_A} l_type_a

--						-- `type_a_from_string' does not succeed always in resolving the type. It is known to
--						-- not support the occurence of the `like' keyword in the generics part of a type declaration.
--						-- It resolves neither generics in general.
--					l_type_a := type_a_from_string (text_from_ast (l_type), context_class)

--						-- Attempt to resolve type once again if previous evaluation failed. The following call
--						-- succeeds for generic delarations.
--					if not attached l_type_a then
--						l_type_a := type_a_generator.evaluate_type_if_possible (l_type, context_class)
--					end

					Result.force (l_type_a.name, l_iterator.item.name.name_8)
				end
			end
		end

feature {NONE} -- Implementation

	target_variables: like {EXT_VARIABLE_CONTEXT}.target_variables
			-- Variables that are subject of the analysis.

	context_class: CLASS_C
			-- Class the visitor operates on.

	attached_object_test_as_tuples: LINKED_LIST [TUPLE [type: TYPE_AS; expression: EXPR_AS; name: ID_AS]]
			-- Collect object test instances during AST visit.

feature {NONE} -- AST Iteration

	process_object_test_as (l_as: OBJECT_TEST_AS)
			-- Collect all `{OBJECT_TEST_AS}' instances that use the attached keyword and set a read-only name.
		do
			if l_as.is_attached_keyword and attached l_as.name then
				attached_object_test_as_tuples.force([l_as.type, l_as.expression, l_as.name])
			end
			Precursor (l_as)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			if attached l_as.iteration as l_iteration then
				attached_object_test_as_tuples.force ([Void, l_iteration.expression, l_iteration.identifier])
			end
			Precursor (l_as)
		end

feature {NONE} -- Helper

	is_expression_dependant_on_targets (a_as: EXPR_AS): BOOLEAN
			-- AST iterator processing `a_as' answering if a variable of interest is used in that AST.
			-- Currently it is checking if the one of the target variables occur in the the AST. If yes, the expression is taken into account.
		local
			l_variable_set: DS_HASH_SET [STRING]
			l_variable_usage_checker: EXT_AST_VARIABLE_USAGE_CHECKER
		do
			create l_variable_set.make_equal (10)
			target_variables.current_keys.do_all (agent l_variable_set.put)

			create l_variable_usage_checker.make_from_variables (l_variable_set)
			l_variable_usage_checker.check_ast (a_as)

			Result := l_variable_usage_checker.passed_check
		end

end
