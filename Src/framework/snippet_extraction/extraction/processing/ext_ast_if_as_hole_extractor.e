note
	description: "Iterator to extract holes from 'if' statements within an AST."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_IF_AS_HOLE_EXTRACTOR

inherit
	AST_ITERATOR
		redefine
			process_if_as
		end

	EXT_HOLE_EXTRACTOR

	EXT_HOLE_FACTORY_AWARE

	EXT_VARIABLE_CONTEXT_AWARE

	EXT_AST_UTILITY

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

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
		do
				-- Scan expression.
			variable_of_interest_usage_checker.check_ast (l_as.condition)
			l_use_cond := variable_of_interest_usage_checker.passed_check

				-- Scan true branch
			if attached l_as.compound then
				variable_of_interest_usage_checker.check_ast (l_as.compound)
				l_use_branch_true := variable_of_interest_usage_checker.passed_check
			end

				-- Scan elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list
				across l_as.elsif_list as l_elsif_list loop
					variable_of_interest_usage_checker.check_ast (l_elsif_list.item)
					if variable_of_interest_usage_checker.passed_check then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
					end
				end
			end

				-- Scan false branch
			if attached l_as.else_part then
				variable_of_interest_usage_checker.check_ast (l_as.else_part)
				l_use_branch_false := variable_of_interest_usage_checker.passed_check
			end

				-- Decide on processing.
			if not l_use_elsif_list and not l_use_branch_true and not l_use_branch_false and l_use_cond then
				add_hole (create_hole (l_as), l_as.path)
			else
				Precursor (l_as)
			end
		end

feature {NONE} -- Annotation Handling

	create_hole (a_ast: AST_EIFFEL): EXT_HOLE
			-- Create a new `{EXT_ANN_HOLE}' with metadata.
		local
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
		do
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.extract_from_ast (a_ast)

			Result := hole_factory.new_hole (l_annotation_extractor.last_annotations)
		end

end
