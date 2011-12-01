note
	description: "Iterator to extract holes from 'if' statements within an AST."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_INSPECT_AS_HOLE_EXTRACTOR

inherit
	AST_ITERATOR
		redefine
			process_inspect_as
		end

	EXT_HOLE_EXTRACTOR

	EXT_HOLE_FACTORY_AWARE

	EXT_VARIABLE_CONTEXT_AWARE

	EXT_AST_UTILITY

	EXT_HOLE_UTILITY

	EPA_UTILITY

create
	make_with_arguments

feature {NONE} -- Creation

	make_with_arguments (a_variable_context: like variable_context; a_factory: like hole_factory)
			-- Make with `a_factory'.
		require
			attached a_variable_context
			attached a_factory
		local
			l_variable_set: DS_HASH_SET [STRING]
		do
			variable_context := a_variable_context
			hole_factory := a_factory

			create l_variable_set.make_equal (10)
			variable_context.variables_of_interest.current_keys.do_all (agent l_variable_set.put)

			create variable_of_interest_usage_checker.make_from_variables (l_variable_set)
		end

feature -- Basic operations

	extract (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_ast' and
			-- make results available in `last_holes' and
			-- make transformed AST available in `last_ast'.
		do
				-- Freshly initialize variables holding the output of the run.
			initialize_hole_context

				-- Process and rewrite AST to output while collecting holes.
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	variable_of_interest_usage_checker: EXT_AST_VARIABLE_USAGE_CHECKER
			-- Checks if an AST is accessing any variable of interest.

	process_inspect_as (a_as: INSPECT_AS)
		local
			l_use_switch, l_use_case_list, l_use_else_part: BOOLEAN
		do
			variable_of_interest_usage_checker.check_ast (a_as.switch)
			l_use_switch := variable_of_interest_usage_checker.passed_check

			if attached a_as.case_list as l_as then
				variable_of_interest_usage_checker.check_ast (l_as)
				l_use_case_list := variable_of_interest_usage_checker.passed_check
			end

			if attached a_as.else_part as l_as then
				variable_of_interest_usage_checker.check_ast (l_as)
				l_use_else_part := variable_of_interest_usage_checker.passed_check
			end

				-- Decide on processing.
			if l_use_switch and not l_use_case_list and not l_use_else_part then
				add_hole (create_hole (a_as), a_as.path)
			else
				Precursor (a_as)
			end
		end

feature {NONE} -- Annotation Handling

	create_hole (a_ast: AST_EIFFEL): EXT_HOLE
			-- Create a new `{EXT_HOLE}' with metadata.
		local
			l_hole_type_string: STRING
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
		do
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.extract_from_ast (a_ast)

			if evaluate_hole_types then
				-- Try to determinable hole type.
				l_hole_type_string := get_hole_type (a_ast, variable_context.context_class, variable_context.context_feature)
			end
			
			Result := hole_factory.new_hole (l_annotation_extractor.last_annotations, l_hole_type_string)
		end

end
