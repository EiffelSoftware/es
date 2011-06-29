note
	description: "Summary description for {EXT_OBJECT_TEST_AS_ALIAS_FINDER}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_OBJECT_TEST_AS_ALIAS_FINDER

inherit
	AST_ITERATOR
		redefine
			process_object_test_as
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

	last_object_test_aliases: like {EXT_VARIABLE_CONTEXT}.target_variables
			-- The identifiers and evaluated types of last AST visit.
		local
			l_type_a: TYPE_A
		do
			create Result.make (5)
			Result.compare_objects

			across attached_object_test_as_tuples as l_iterator loop
				if object_test_as_alias_expr_decider (l_iterator.item.expression) then
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

--	on_object_test_as: ROUTINE [ANY, TUPLE [a_as: OBJECT_TEST_AS]]
--		assign set_on_object_test_as
--			-- Callback agent triggered when a `{OBJECT_TEST_AS}' node is encountered.

--	set_on_object_test_as (a_action: like on_object_test_as)
--			-- Assigner for `on_object_test_as'.
--		require
--			a_action_not_void: attached a_action
--		do
--			on_object_test_as := a_action
--		end

feature {NONE} -- Implementation

	target_variables: like {EXT_VARIABLE_CONTEXT}.target_variables
			-- Variables that are subject of the analysis.

	context_class: CLASS_C
			-- Class the visitor operates on.

	attached_object_test_as_tuples: LINKED_LIST [TUPLE [type: TYPE_AS; expression: EXPR_AS; name: ID_AS]]
			-- Collect object test instances during AST visit.

--	process_object_test_as (l_as: OBJECT_TEST_AS)
--		do
--				-- Invoke callback agent if configured.
--			if attached on_object_test_as as l_agent then
--				l_agent.call ([l_as])
--			end
--			Precursor (l_as)
--		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
			-- Collect all `{OBJECT_TEST_AS}' instances that use the attached keyword and set a read-only name.
		do
			if l_as.is_attached_keyword and attached l_as.name then
				attached_object_test_as_tuples.force([l_as.type, l_as.expression, l_as.name])
			end
			Precursor (l_as)
		end

	object_test_as_alias_expr_decider (a_as: EXPR_AS): BOOLEAN
			-- AST iterator processing `a_as' answering if a variable of interest is used in that AST.
			-- Currently it is checking if the one of the target variables occur in the the AST. If yes, the expression is taken into account.
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make

			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_target_variables: like {EXT_VARIABLE_CONTEXT}.target_variables; a_variable_usage: LINKED_SET [STRING])
					do
						if a_target_variables.has (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, target_variables, l_variable_usage)
			)

			a_as.process (l_variable_usage_finder)

			Result := not l_variable_usage.is_empty
		end

end
