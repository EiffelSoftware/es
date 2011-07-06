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
	make_with_factory

feature {NONE} -- Creation

	make_with_factory (a_factory: EXT_HOLE_FACTORY)
			-- Make with `a_factory'.
		require
			attached a_factory
		do
			hole_factory := a_factory
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

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
		do
				-- Scan expression.
			l_use_cond := is_ast_eiffel_using_variable_of_interest (l_as.condition, variable_context)

				-- Scan true branch
			if attached l_as.compound then
				l_use_branch_true := is_ast_eiffel_using_variable_of_interest (l_as.compound, variable_context)
			end

				-- Scan elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list
				across l_as.elsif_list as l_elsif_list loop
					if is_ast_eiffel_using_variable_of_interest (l_elsif_list.item, variable_context) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
					end
				end
			end

				-- Scan false branch
			if attached l_as.else_part then
				l_use_branch_false := is_ast_eiffel_using_variable_of_interest (l_as.else_part, variable_context)
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
			l_annotation_set: LINKED_SET [EXT_MENTION_ANNOTATION]
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
		do
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.extract_from_ast (a_ast)

			create l_annotation_set.make
			l_annotation_extractor.last_annotations.do_all (agent l_annotation_set.force)

			Result := hole_factory.new_hole (l_annotation_set)
		end

end
