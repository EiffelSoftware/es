note
	description: "Quantified expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_QUANTIFIED_EXPRESSION

inherit
	EPA_SHARED_EQUALITY_TESTERS
		undefine
			out
		end

	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

	EPA_STRING_UTILITY
		undefine
			out
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		undefine
			out
		end

	EPA_UTILITY
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_index: INTEGER; a_predicate: like predicate; a_scope: like scope; a_for_all: BOOLEAN; a_operand_map: like operand_map)
			-- Initialize Current.
		do
			quantified_variable_argument_index := a_index
			predicate := a_predicate
			scope := a_scope
			is_for_all := a_for_all
			operand_map := a_operand_map.twin
		end

feature -- Access

	quantified_variable_argument_index: INTEGER
			-- Index of the quanfied variable as argument in `predicate'

	quantified_variabale_type: TYPE_A
			-- Type of current quantified variable
		do
			Result := predicate.argument_type (quantified_variable_argument_index)
		end

	scope: CI_QUANTIFIED_SCOPE
			-- Scope of the quantified variable

	predicate: EPA_FUNCTION
			-- Predicate of current quantified expression

	quantified_variable_name (a_feature: FEATURE_I; a_class: CLASS_C): STRING
			-- A possible name for the quantified variable in the context of `a_feature' viewed in `a_class'
		local
			l_ctxt: ETR_FEATURE_CONTEXT
			l_names: LINKED_LIST [STRING]
			l_type: TYPE_A
			l_cursor: CURSOR
			l_done: BOOLEAN
			l_hashable_class: CLASS_C
			l_hashable_type: TYPE_A
			l_class_ctxt: ETR_CLASS_CONTEXT
		do
			l_hashable_class := first_class_starts_with_name (once "HASHABLE")
			l_hashable_type := l_hashable_class.actual_type
			l_type := quantified_variabale_type.actual_type
			l_type := actual_type_from_formal_type (l_type, a_class)
			l_type := l_type.instantiation_in (a_class.actual_type, a_class.class_id)
			if l_type.is_integer then
				l_names := preferred_integer_names
			elseif l_type.has_associated_class then
				l_type := actual_type_from_formal_type (l_type, a_class)
				if l_type.has_associated_class and then l_type.conform_to (a_class, l_hashable_type) then
					l_names := preferred_key_names
				else
					l_names := preferred_object_names
				end
			end
			create l_class_ctxt.make (a_class)
			create l_ctxt.make (a_feature, l_class_ctxt)
			l_cursor := l_names.cursor
			from
				l_names.start
			until
				l_names.after or else l_done
			loop
				if not l_ctxt.has_argument (l_names.item) and then not l_ctxt.has_local (l_names.item) then
					l_done := True
					Result := l_names.item.twin
				end
				l_names.forth
			end
			l_names.go_to (l_cursor)
			if not l_done then
				Result := "zz"
			end
		end

	operand_map: HASH_TABLE [INTEGER, INTEGER]
			-- Map from 1-based argument index in `predicate' to 0-based operand index in the feature under test
			-- Key is 1-based operand index of `predicate', value is 0-based operand index in the feature under test

	quantifier_free_functions (a_context: CI_TEST_CASE_TRANSITION_INFO): DS_HASH_SET [EPA_FUNCTION]
			-- Set of quantifier free expressions
			-- with the quantifier replaced with a value in `scope' in `a_context'
		local
			l_values: DS_HASH_SET [EPA_FUNCTION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_predicate: like predicate
			l_quantified_variable_operand_index: INTEGER
		do
			l_quantified_variable_operand_index := quantified_variable_argument_index
			create Result.make (5)
			Result.set_equality_tester (function_equality_tester)

			l_predicate := predicate
			l_values := scope.scope (a_context)
			from
				l_cursor := l_values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_predicate.partially_evalauted (l_cursor.item, l_quantified_variable_operand_index))
				l_cursor.forth
			end
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := predicate.hash_code
		end

	quantifier_name: STRING
			-- Name of the quantifier
		do
			if is_for_all then
				Result := once "forall"
			else
				Result := once "exists"
			end
		end

feature -- Status report

	is_for_all: BOOLEAN
			-- Is `predicate' quantified by a for_all quantifier?

	is_there_exists: BOOLEAN
			-- Is `predicate' quantified by a there_exists quantifier?
		do
			Result := not is_for_all
		end

feature -- Debug

	out: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (quantifier_name)
			Result.append (curly_brace_surrounded_integer (quantified_variable_argument_index))
			Result.append (once " :: ")
			Result.append (predicate.debug_output)
		end

	debug_output: STRING
			-- Debug output
		do
			Result := out
		end

	text: STRING
			-- Text
		do
			Result := out
		end

feature{NONE} -- Implemenation

	preferred_integer_names: LINKED_LIST [STRING]
			-- Preferred names as quantified variable of type integer
		once
			create Result.make
			Result.extend ("i")
			Result.extend ("j")
			Result.extend ("k")
		end

	preferred_object_names: LINKED_LIST [STRING]
			-- Preferred names as quantified variable of type ANY
		once
			create Result.make
			Result.extend ("o")
			Result.extend ("m")
			Result.extend ("n")
		end

	preferred_key_names: LINKED_LIST [STRING]
			-- Preferred names as quantified variable of type HASHABLE
		once
			create Result.make
			Result.extend ("k")
			Result.extend ("s")
			Result.extend ("t")
		end


end
