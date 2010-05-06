note
	description: "Printer to output a set of transitions into Weka ARFF format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_TO_WEKA_PRINTER

inherit
	EPA_SHARED_EQUALITY_TESTERS

	UC_SHARED_STRING_EQUALITY_TESTER

create
	make,
	make_with_selection_function

feature{NONE} -- Initialization

	make (a_context: like context)
			-- Initialize current with `a_context'.
		do
			context := a_context
		ensure
			context_set: context = a_context
		end

	make_with_selection_function (a_context: like context; a_function: like equation_selection_function)
			-- Initialize Current.
		do
			make (a_context)
			set_equation_selection_function (a_function)
		end

feature -- Access

	context: EPA_CONTEXT
			-- Context in which transitions are type checked

	transitions: LINKED_LIST [SEM_TRANSITION]
			-- Transitions to be translated as instances into Weka

	is_union_mode: BOOLEAN
			-- If `transitions' have different pre-/postcondition expressions,
			-- should the Weka relation contain the union of all the different expressions?
			-- Attributes that do not appear in certain transitions are treated as missing values.

	is_intersection_mode: BOOLEAN
			-- If `transitions' have different pre-/postcondition expression,
			-- should the Weka relation only contain the intersection of all the expression?
		do
			Result := not is_union_mode
		ensure
			good_result: Result = not is_union_mode
		end

	equation_selection_function: detachable PREDICATE [ANY, TUPLE [EPA_EQUATION]]
			-- Action to only select some expressions from a transition
			-- If this function returns True, the equation is selected, otherwise, not selected.
			-- If Void, all expressions from any transition is selected.

	as_weka_relation: WEKA_ARFF_RELATION
			-- Weka ARFF relation from Current
		local
			l_weka_attrs: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_pres: like precondition_attributes
			l_posts: like postcondition_attributes
			l_pre_count: INTEGER
			l_attrs: LINKED_LIST [STRING]
			l_attr: WEKA_ARFF_ATTRIBUTE
			i: INTEGER
			l_type: TYPE_A
			l_attr_name: STRING
			l_expr: STRING
			l_cursor: CURSOR
			l_instance: ARRAYED_LIST [STRING]
			l_transition: SEM_TRANSITION
			l_equation: detachable EPA_EQUATION
		do
			l_pres := precondition_attributes
			l_pre_count := l_pres.count
			l_posts := postcondition_attributes

			l_pres.keys.do_all (agent l_attrs.extend)
			l_posts.keys.do_all (agent l_attrs.extend)

			from
				i := 1
				l_attrs.start
			until
				l_attrs.after
			loop
					-- Calculate the final Weka attribute name and type.
				l_expr := l_attrs.item_for_iteration
				if i <= l_pre_count then
					l_type := l_pres.item (l_attrs.item_for_iteration)
					l_attr_name := weka_attribute_name (l_expr, True)
				else
					l_type := l_posts.item (l_attrs.item_for_iteration)
					l_attr_name := weka_attribute_name (l_expr, False)
				end

					-- Create Weka attribute.
				if l_type.is_boolean then
					create {WEKA_ARFF_BOOLEAN_ATTRIBUTE} l_attr.make (l_attr_name)
				elseif l_type.is_integer then
					create {WEKA_ARFF_NUMERIC_ATTRIBUTE} l_attr.make (l_attr_name)
				else
					check not_supported: False end
				end
				l_weka_attrs.extend (l_attr)

				i := i + 1
				l_attrs.forth
			end

				-- Create Weka relation.
			create Result.make (l_weka_attrs)
			Result.set_name (weka_relation_name)
			Result.set_comment (weka_comment)

				-- Iterate through `transitions' to add instances in the result Weka relation.
			l_cursor := transitions.cursor
			from
				transitions.start
			until
				transitions.after
			loop
					-- Collect fields of an instance by iterate through
					-- all pre-/postcondition assertions in a transition.
				l_transition := transitions.item_for_iteration
				create l_instance.make (l_weka_attrs.count)
				from
					i := 1
					l_weka_attrs.start
					l_attrs.start
				until
					l_attrs.after
				loop
					if i <= l_pre_count then
						l_equation := l_transition.precondition_by_anonymous_expression_text (l_attrs.item_for_iteration)
					else
						l_equation := l_transition.postcondition_by_anonymous_expression_text (l_attrs.item_for_iteration)
					end
					if l_equation /= Void then
						l_instance.extend (l_weka_attrs.item_for_iteration.value (l_equation.value.out))
					else
						l_instance.extend (Void)
					end
					i := i + 1
					l_attrs.forth
					l_weka_attrs.forth
				end
				Result.extend_instance (l_instance)
				transitions.forth
			end
		end

feature -- Status report

	is_transition_valid (a_transition: SEM_TRANSITION): BOOLEAN
			-- Is `a_transition' valid to be added into Current?
		local
			l_agent: FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]
		do
			l_agent :=
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result :=
							attached equation_selection_function as l_function implies l_function.item ([a_equation]) and
							((a_equation.value.is_boolean or
							a_equation.value.is_integer)) and
							a_equation.value.is_deterministic
					end

			Result :=
				a_transition.precondition.for_all (l_agent) and then
				a_transition.postcondition.for_all (l_agent)
		end

feature -- Basic operations

	set_is_union_mode (b: BOOLEAN)
			-- Set `is_union_mode' with `b'.
		do
			is_union_mode := b
		ensure
			is_union_mode_set: is_union_mode = b
		end

	set_equation_selection_function (a_function: like equation_selection_function)
			-- Set `equation_selection_function' with `a_function'.
		do
			equation_selection_function := a_function
		ensure
			equation_selection_function_set: equation_selection_function = a_function
		end

	extend_transition (a_transition: SEM_TRANSITION)
			-- Extend `a_transition' in Current as an instance in the target Weka relation.
		require
			a_transitio_valid: is_transition_valid (a_transition)
		do
			transitions.extend (a_transition)
		ensure
			a_transition_extended: transitions.has (a_transition)
		end

	extend_transitions (a_transitions: LINEAR [SEM_TRANSITION])
			-- Extend `a_transitions' in Current as instances in the target Weka relation.
		require
			a_transitions_valid: a_transitions.for_all (agent is_transition_valid)
		do
			a_transitions.do_all (agent extend_transition)
		ensure
			a_transitions_extended: a_transitions.for_all (agent transitions.has)
		end

feature{NONE} -- Implementation

	weka_attribute_name (a_name: STRING; a_precondition: BOOLEAN): STRING
			-- Final attribute name from `a_name' for Weka
			-- `a_precondition' indicates if `a_name' is used in precondition, otherwise postcondition.
		do
			create Result.make (a_name.count + 10)
			if a_precondition then
				Result.append (once "%"pre::")
			else
				Result.append (once "%"post::")
			end
			Result.append (a_name)
			Result.append_character ('%"')
		end

	weka_comment: STRING
			-- Comment for the Weka output
		local
			l_transition: SEM_TRANSITION
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_var: EPA_EXPRESSION
		do
			create Result.make (512)
			if not transitions.is_empty then
				l_transition := transitions.first
				Result.append_character ('%N')
				Result.append (l_transition.name)
				Result.append_character ('%N')

				from
					l_cursor := l_transition.variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_var := l_cursor.item
					if l_transition.is_operand_variable (l_var) then
						Result.append (l_transition.anonymous_expression_text (l_var))
						Result.append (once ": ")
						Result.append (l_transition.variable_name (l_var, {SEM_TRANSITION}.variable_type_name))
						Result.append_character ('%N')
					end
					l_cursor.forth
				end
				Result.append_character ('%N')
			end
		end

	weka_relation_name: STRING
			-- Name of the Weka relation
		do
			create Result.make (128)
			if not transitions.is_empty then
				Result.append (transitions.first.name)
			end
		end

	precondition_attributes: DS_HASH_TABLE [TYPE_A, STRING]
			-- Attributes that are used as preconditions
			-- Elements in Result is anonymous expression names for those attributes.
		do
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.precondition end)
		end

	postcondition_attributes: DS_HASH_TABLE [TYPE_A, STRING]
			-- Attributes that are used as postconditions
			-- Elements in Result is anonymous expression names for those attributes.
		do
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.postcondition end)
		end

	attributes (a_attributes_retriever: FUNCTION [ANY, TUPLE [SEM_TRANSITION], EPA_STATE]): DS_HASH_TABLE [TYPE_A, STRING]
			-- Set of expressions that are to be translated into Weka attributes
			-- Elements in Result is anonymous expression names for those attributes.
		local
			l_frequence_tbl: DS_HASH_TABLE [INTEGER, STRING]
			l_type_tbl: DS_HASH_TABLE [TYPE_A, STRING]
			l_cursor: CURSOR
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_selection_function: like equation_selection_function
			l_expression: EPA_EXPRESSION
			l_union_mode: BOOLEAN
			l_count: INTEGER
			l_anonymous_expr: STRING
			l_transition: SEM_TRANSITION
			l_state: EPA_STATE
		do
			l_selection_function := equation_selection_function
			create l_frequence_tbl.make (100)
			l_frequence_tbl.set_key_equality_tester (string_equality_tester)
			create l_type_tbl.make (100)
			l_type_tbl.set_key_equality_tester (string_equality_tester)

				-- Collect the number of times that each expression appears in all transitions.
			l_cursor := transitions.cursor
			from
				transitions.start
			until
				transitions.after
			loop
				from
					l_transition := transitions.item_for_iteration
					l_state := a_attributes_retriever.item ([l_transition])
					l_state_cursor := l_state.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					if l_selection_function = Void or else l_selection_function.item ([l_state_cursor.item]) then
						l_expression :=	l_state_cursor.item.expression
						l_anonymous_expr := l_transition.anonymous_expression_text (l_expression)
						l_frequence_tbl.force_last (l_frequence_tbl.item (l_anonymous_expr) + 1, l_anonymous_expr)
						l_type_tbl.force_last (l_expression.resolved_type, l_anonymous_expr)
					end
					l_state_cursor.forth
				end
				transitions.forth
			end
			transitions.go_to (l_cursor)

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.set_key_equality_tester (string_equality_tester)

			from
				l_count := transitions.count
				l_frequence_tbl.start
			until
				l_frequence_tbl.after
			loop
				if l_union_mode or else (l_frequence_tbl.item_for_iteration = l_count) then
					Result.force_last (l_type_tbl.item (l_frequence_tbl.key_for_iteration), l_frequence_tbl.key_for_iteration)
				end
				l_frequence_tbl.forth
			end
		end

end
