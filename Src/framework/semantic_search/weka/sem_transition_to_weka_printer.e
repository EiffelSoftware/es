note
	description: "Printer to output a set of transitions into Weka ARFF format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_TO_WEKA_PRINTER

inherit
	SEM_TRANSITION_PRINTER

	SEM_FIELD_NAMES

	EPA_STRING_UTILITY

create
	make,
	make_with_selection_function

feature -- Access

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
			l_transition_changes: like transition_changes
			l_sorted_attrs: SORTED_TWO_WAY_LIST [STRING]
			l_value_table_rows: HASH_TABLE [STRING, STRING]
			l_last_value: detachable STRING
			l_is_value_table_generated: BOOLEAN
			l_row: STRING
			l_id_attr: WEKA_ARFF_NUMERIC_ATTRIBUTE
		do
			l_transition_changes := transition_changes

				-- Calculate all the attributes.
			l_pres := precondition_attributes
			l_pre_count := l_pres.count
			l_posts := postcondition_attributes

			create l_attrs.make
			l_pres.keys.do_all (agent l_attrs.extend)
			l_posts.keys.do_all (agent l_attrs.extend)

			if is_absolute_change_included or is_relative_change_included then
				calculate_changes
				attributes_for_changes.keys.do_all (agent l_attrs.extend)
				attributes_for_changes.do_all_with_key (agent l_posts.force_last)
			end

			create l_weka_attrs.make (100)
			create l_id_attr.make (id_field)
			l_weka_attrs.extend (l_id_attr)
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
					create {WEKA_ARFF_NOMINAL_ATTRIBUTE} l_attr.make (l_attr_name, weka_boolean_values)
				elseif l_type.is_integer then
					create {WEKA_ARFF_NUMERIC_ATTRIBUTE} l_attr.make (l_attr_name)
				else
					io.put_string ("Bad")
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

				-- Construct a format of instance data which is easier to read.
			l_is_value_table_generated := is_value_table_generated
			if l_is_value_table_generated then
				create l_sorted_attrs.make
				across l_weka_attrs as l_wattr_cursor loop
					if l_wattr_cursor.item /= l_id_attr then
						l_sorted_attrs.extend (l_wattr_cursor.item.name)
					end
				end
				l_sorted_attrs.sort
				l_sorted_attrs.start
				l_sorted_attrs.put_front (l_id_attr.name)
				create l_value_table_rows.make (l_attrs.count)
				l_value_table_rows.compare_objects
				across l_weka_attrs as l_wekac loop
					l_value_table_rows.put (create {STRING}.make (512), l_wekac.item.name)
					l_weka_attrs.forth
				end
			end

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
				l_instance.extend (transitions.index.out)
				l_row := l_value_table_rows.item (l_id_attr.name)
				l_row.append (transitions.index.out)
				l_row.append_character ('%T')
				from
					i := 1
					l_weka_attrs.go_i_th (2)
					l_attrs.start
				until
					l_attrs.after
				loop
					if l_attrs.item.starts_with (by_field_prefix) or l_attrs.item.starts_with (to_field_prefix) then
							-- Found a change definition, either "by::" or "to::".						
						if attached {like changes_by_transition} changes_by_transition (l_transition) as l_changes then
							l_changes.search (l_attrs.item_for_iteration)
							if l_changes.found then
								if attached {EPA_EXPRESSION} l_changes.found_item as l_found_value then
									l_last_value := l_weka_attrs.item_for_iteration.value (l_found_value.text)
								else
									l_last_value := not_applicable_value
								end
							else
								l_last_value := {WEKA_ARFF_ATTRIBUTE}.missing_value
							end
							l_instance.extend (l_last_value)
						else
							check False end
						end
					else
							-- Found a normal pre-/postcondition assertion.
						if i <= l_pre_count then
							l_equation := l_transition.precondition_by_anonymous_expression_text (l_attrs.item_for_iteration)
						else
							l_equation := l_transition.postcondition_by_anonymous_expression_text (l_attrs.item_for_iteration)
						end
						if l_equation /= Void then
							l_last_value := l_weka_attrs.item_for_iteration.value (l_equation.value.out)
						else
							l_last_value := Void
						end
						l_instance.extend (l_last_value)
					end
					if l_is_value_table_generated then
						l_row := l_value_table_rows.item (l_weka_attrs.item_for_iteration.name)
						if l_last_value /= Void then
							l_row.append (l_last_value)
						else
							l_row.append ({WEKA_ARFF_ATTRIBUTE}.missing_value)
						end
						l_row.append_character ('%T')
					end
					i := i + 1
					l_attrs.forth
					l_weka_attrs.forth
				end
				Result.extend_instance (l_instance)
				transitions.forth
			end

				-- Generate trailing comments containing an easier format of the instance data.
			if is_value_table_generated then
				Result.set_trailing_comment (comment_for_value_table (l_value_table_rows, l_sorted_attrs))
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

	is_value_table_generated: BOOLEAN
			-- Should an easy to read value table be generated (as comment)?
			-- Default: False

feature -- Basic operations

	set_is_value_table_generated (b: BOOLEAN)
			-- Set `is_value_table_generated' with `b'.
		do
			is_value_table_generated := b
		ensure
			is_value_table_generated_set: is_value_table_generated = b
		end

feature{NONE} -- Implementation

	weka_attribute_name (a_name: STRING; a_precondition: BOOLEAN): STRING
			-- Final attribute name from `a_name' for Weka
			-- `a_precondition' indicates if `a_name' is used in precondition, otherwise postcondition.
		do
			create Result.make (a_name.count + 10)
			Result.append_character ('%"')
			if not (a_name.starts_with (by_field_prefix) or a_name.starts_with (to_field_prefix)) then
				if a_precondition then
					Result.append (precondition_field_prefix)
				else
					Result.append (postcondition_field_prefix)
				end
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
						Result.append_character (':')
						Result.append_character (' ')
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
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.interface_precondition end)
		end

	postcondition_attributes: DS_HASH_TABLE [TYPE_A, STRING]
			-- Attributes that are used as postconditions
			-- Elements in Result is anonymous expression names for those attributes.
		do
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.interface_postcondition end)
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
			l_type: TYPE_A
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
						l_type := l_expression.type
						fixme ("We only handle boolean and integer expressions for the moment. 9.6.2010 Jasonw")
						if l_type.is_boolean or l_type.is_integer then
							l_anonymous_expr := l_transition.anonymous_expression_text (l_expression)
							l_frequence_tbl.force_last (l_frequence_tbl.item (l_anonymous_expr) + 1, l_anonymous_expr)
							l_type_tbl.force_last (l_expression.resolved_type (l_transition.context_type), l_anonymous_expr)
						end
					end
					l_state_cursor.forth
				end
				transitions.forth
			end
			transitions.go_to (l_cursor)

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.set_key_equality_tester (string_equality_tester)
			l_union_mode := is_union_mode

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

	attribute_name_for_change (a_change: EPA_EXPRESSION_CHANGE; a_transition: SEM_TRANSITION): STRING
			-- Name of the Weka attribute representing `a_change' in `a_transition'
		do
			create Result.make (64)
			if a_change.is_absolute then
				Result.append (to_field_prefix)
			else
				Result.append (by_field_prefix)
			end
			Result.append (a_transition.anonymous_expression_text (a_change.expression))
		end

	calculate_changes
			-- Calculate changes in `transitions' and store result in `changes'.
			-- Also calculate `attributes_for_changes'.
		local
			l_transition: SEM_TRANSITION
			l_union_mode: BOOLEAN
			l_count: INTEGER
			l_frequence_tbl: HASH_TABLE [INTEGER, STRING]
			l_type_tbl: HASH_TABLE [TYPE_A, STRING]
			l_change_set: like transition_change_set
			l_tran_changes: like transition_changes
			l_change_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION_CHANGE]
			l_attr_name: STRING
			l_changes: HASH_TABLE [detachable EPA_EXPRESSION, STRING]
			l_change: EPA_EXPRESSION_CHANGE
			l_attributes_for_changes: like attributes_for_changes
			l_zero_expression: EPA_AST_EXPRESSION
		do
			create l_tran_changes.make
			create l_frequence_tbl.make (100)
			l_frequence_tbl.compare_objects
			create l_type_tbl.make (50)
			l_type_tbl.compare_objects

			create l_tran_changes.make

				-- Iterate through all transitions and calculate changes for each transition.
				-- Calculate `transition_changes'.
			across transitions as l_cursor loop
				l_transition := l_cursor.item
				create l_zero_expression.make_with_text (l_transition.context.class_, l_transition.context.feature_, "0", l_transition.context.class_)
				l_change_set := transition_change_set (l_transition)
				create l_changes.make (20)
				l_changes.compare_objects
				l_tran_changes.extend ([l_transition, l_changes])
				from
					l_change_cursor := l_change_set.new_cursor
					l_change_cursor.start
				until
					l_change_cursor.after
				loop
					l_change := l_change_cursor.item
					l_attr_name := attribute_name_for_change (l_change, l_transition)
					l_frequence_tbl.force (l_frequence_tbl.item (l_attr_name) + 1, l_attr_name)
					if l_change.is_no_change then
						if l_change.expression.type.is_integer then
							l_changes.put (l_zero_expression, l_attr_name)
						else
							l_changes.put (Void, l_attr_name)
						end
					else
						l_changes.put (l_change.values.first, l_attr_name)
					end
					if not l_type_tbl.has (l_attr_name) then
						l_type_tbl.put (l_change.expression.resolved_type (l_transition.context_type), l_attr_name)
					end
					l_change_cursor.forth
				end
				l_tran_changes.extend ([l_transition, l_changes])
			end
			transition_changes := l_tran_changes

				-- Calculate `attributes_for_changes'
			l_union_mode := is_union_mode
			l_count := transitions.count
			create l_attributes_for_changes.make (50)
			l_attributes_for_changes.set_key_equality_tester (string_equality_tester)
			across l_frequence_tbl as l_freq_tbl_cursor loop
				l_attributes_for_changes.force_last (l_type_tbl.item (l_freq_tbl_cursor.key), l_freq_tbl_cursor.key)
			end
			attributes_for_changes := l_attributes_for_changes
		end

	transition_changes: LINKED_LIST [TUPLE [transition: SEM_TRANSITION; changes: HASH_TABLE [EPA_EXPRESSION, STRING]]]
			-- Changes in `transitions'
			-- `transition' is the transition to which `changes' are associated.
			-- `changes' is a hash-table from expression names to change values.

	attributes_for_changes: DS_HASH_TABLE [TYPE_A, STRING]
			-- Set of attributes that are to be translated into Weka attributes.

	transition_change_set (a_transition: SEM_TRANSITION): DS_HASH_SET [EPA_EXPRESSION_CHANGE]
			-- Change set from `a_transition'
		local
			l_change_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_set: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_changes: LIST [EPA_EXPRESSION_CHANGE]
			l_change: EPA_EXPRESSION_CHANGE
			l_cursor: DS_HASH_TABLE_CURSOR [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_is_absoluted_change_included: BOOLEAN
			l_is_relative_change_included: BOOLEAN
			l_pre_state: EPA_STATE
			l_post_state: EPA_STATE
			l_result_name: STRING
			l_expr_name: STRING
			l_type: TYPE_A
		do
			l_is_absoluted_change_included := is_absolute_change_included
			l_is_relative_change_included := is_relative_change_included

				-- Calculate changes from `a_transition'.
			create Result.make (50)
			Result.set_equality_tester (partial_expression_change_equality_tester)
			create l_change_calculator

			from
				l_pre_state := a_transition.interface_precondition.subtraction (a_transition.written_preconditions)
				l_post_state := a_transition.interface_postcondition.subtraction (a_transition.written_postconditions)
					-- If `a_transition' is a query feature call transition, we remove the postconditions which mention "Result"
					-- from being used for change calculation.
				if attached {SEM_FEATURE_CALL_TRANSITION} a_transition as l_feat_transition and then l_feat_transition.feature_.has_return_value then
					l_result_name := curly_brace_surrounded_integer (l_feat_transition.feature_.argument_count + 1)
					from
						l_post_state.start
					until
						l_post_state.after
					loop
						l_type := l_post_state.item_for_iteration.expression.type
						l_expr_name := a_transition.anonymous_expression_text (l_post_state.item_for_iteration.expression)
						if l_expr_name.has_substring (l_result_name) then
							l_post_state.remove (l_post_state.item_for_iteration)
						else
							l_post_state.forth
						end
					end
				end
				l_change_calculator.set_is_no_change_included (True)
				l_cursor := l_change_calculator.change_set (l_pre_state, l_post_state).new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				across l_cursor.item as l_change_cursor loop
					l_change := l_change_cursor.item
					l_type := l_change.expression.type
					fixme ("We only handle boolean and integer types for the moment. 9.6.2010 Jasonw")
					if l_type.is_boolean or l_type.is_integer then
						if l_change.is_no_change then
							Result.force_last (l_change)
						else
							if
								((l_is_absoluted_change_included and l_change.is_absolute) or (l_is_relative_change_included and l_change.is_relative)) and then
								l_change.values.count = 1
							then
								Result.force_last (l_change)
							end
						end
					end
				end
				l_cursor.forth
			end
		end

	changes_by_transition (a_transition: SEM_TRANSITION): detachable HASH_TABLE [EPA_EXPRESSION, STRING]
			-- Changes from `transition_changes' by `a_transition'
		local
			l_cursor: CURSOR
			l_tran_changes: like transition_changes
		do
			l_tran_changes := transition_changes
			l_cursor := l_tran_changes.cursor
			from
				l_tran_changes.start
			until
				l_tran_changes.after or Result /= Void
			loop
				if l_tran_changes.item.transition = a_transition then
					Result := l_tran_changes.item.changes
				end
				l_tran_changes.forth
			end
			l_tran_changes.go_to (l_cursor)
		end

	weka_boolean_values: LINKED_SET [STRING]
			-- Boolean values
		do
			if weka_boolean_values_cache = Void then
				create weka_boolean_values_cache.make
				weka_boolean_values_cache.compare_objects
				weka_boolean_values_cache.extend ("True")
				weka_boolean_values_cache.extend ("False")
				weka_boolean_values_cache.extend (not_applicable_value)
			end
			Result := weka_boolean_values_cache
		end

	not_applicable_value: STRING = "NA"
			-- Not applicable value

	weka_boolean_values_cache: detachable like weka_boolean_values
			-- Cache for `weka_boolean_values'

	comment_for_value_table (a_rows: HASH_TABLE [STRING, STRING]; a_attributes: SORTED_TWO_WAY_LIST [STRING]): STRING
			-- Comment for value table
			-- `a_rows' is the data, key is attribute name, value is a TAB separated string containing all the values
			-- of that attribute in all instances.
			-- `a_attributes' is a list of sorted attribute names.
		local
			l_row: STRING
		do
			create Result.make (1024 * 16)
			Result.append ("%%This is an easier to read format consisting the same data as the above section.%N")
			across a_attributes as l_cursor loop
				create l_row.make (1024)
				l_row.append_character ('%%')
				l_row.append (l_cursor.item)
				l_row.append_character ('%T')
				l_row.append (a_rows.item (l_cursor.item))
				l_row.right_adjust
				l_row.append_character ('%N')
				Result.append (l_row)
			end
		end

end
