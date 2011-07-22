note
	description: "[
		Class used to normalize variable names in snippets
		Note: This class is experimental, do not write your class relying on this class.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_VARIABLE_NAME_NORMALIZER

inherit
	EPA_UTILITY

	ANN_SHARED_EQUALITY_TESTERS

feature -- Basic operations

	normalized_snippet (a_snippet: EXT_SNIPPET): EXT_SNIPPET
			-- Normalize variable names in `a_snippet'.
		require
			no_annotations_yet: a_snippet.annotations.is_empty
		local
			l_replacements: HASH_TABLE [STRING, STRING]
			l_context: EXT_VARIABLE_CONTEXT
			l_content: STRING
			l_source: STRING
			l_holes: HASH_TABLE [EXT_HOLE, STRING]
			l_new_hole: EXT_HOLE
			l_cursor: DS_HASH_SET_CURSOR [ANN_MENTION_ANNOTATION]
			l_ann: DS_HASH_SET [ANN_MENTION_ANNOTATION]
			l_men: ANN_MENTION_ANNOTATION
			l_header: STRING
			l_new_hole_content: STRING
			l_new_header: STRING
		do
			create variable_index.make (5)
			variable_index.compare_objects
			variable_index.force (0, 'v')
			variable_index.force (0, 'b')
			variable_index.force (0, 'i')
			variable_index.force (0, 'o')

			create l_replacements.make (5)
			l_replacements.compare_objects

			across a_snippet.variable_context.target_variables as l_targets loop
				l_replacements.force (variable_name (type_a_from_string_in_application_context (l_targets.item), True), l_targets.key)
				if l_header = Void then
					l_header := l_targets.key + "."
					l_new_header := l_replacements.item (l_targets.key) + "."
				end
			end

			across a_snippet.variable_context.interface_variables as l_interfaces loop
				l_replacements.force (variable_name (type_a_from_string_in_application_context (l_interfaces.item), False), l_interfaces.key)
			end

			l_context := variable_context_with_variable_renaming (a_snippet.variable_context, l_replacements)
			l_content := expression_rewriter.ast_text (a_snippet.ast, l_replacements)

			create l_holes.make (a_snippet.holes.count)
			l_holes.compare_objects
			across a_snippet.holes as l_hs loop
				create l_new_hole
				l_new_hole.set_hole_id (l_hs.item.hole_id)
				create l_ann.make (5)
				l_ann.set_equality_tester (mention_annotation_equality_tester)
				from
					l_cursor := l_hs.item.annotations.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_new_hole_content := l_cursor.item.expression.twin
					l_new_hole_content.replace_substring_all (l_header, l_new_header)
					create l_men.make_with_arguments (l_new_hole_content, l_cursor.item.is_conditional)
					l_ann.force_last (l_men)
					l_cursor.forth
				end
				l_new_hole.set_annotations (l_ann)
				l_holes.force (l_new_hole, l_hs.item.hole_name)
			end

			create Result.make (l_content, l_context, l_holes, a_snippet.source)
		end

	variable_context_with_variable_renaming (a_context: EXT_VARIABLE_CONTEXT; a_renaming: HASH_TABLE [STRING, STRING]): EXT_VARIABLE_CONTEXT
			-- New snippet varaible context from `a_context' with variables renamed.
			-- `a_renaming' defines how the variables in `a_contex' should be renamed
			-- in the result context. Keys of `a_renaming' are old variable names,
			-- values are new names for those variables.
		local
			l_targets: HASH_TABLE [STRING, STRING]
			l_interfaces: HASH_TABLE [STRING, STRING]
			l_candidates: HASH_TABLE [STRING, STRING]
		do
			create l_targets.make (a_context.target_variables.count)
			l_targets.compare_objects
			across a_context.target_variables as l_vars loop
				if a_renaming.has (l_vars.key) then
					l_targets.force (l_vars.item, a_renaming.item (l_vars.key))
				else
					l_targets.force (l_vars.item, l_vars.key)
				end
			end

			create l_interfaces.make (a_context.interface_variables.count)
			l_interfaces.compare_objects
			across a_context.interface_variables as l_vars loop
				if a_renaming.has (l_vars.key) then
					l_interfaces.force (l_vars.item, a_renaming.item (l_vars.key))
				else
					l_interfaces.force (l_vars.item, l_vars.key)
				end
			end

			create l_candidates.make (a_context.candidate_interface_variables.count)
			l_candidates.compare_objects
			across a_context.candidate_interface_variables as l_vars loop
				if a_renaming.has (l_vars.key) then
					l_candidates.force (l_vars.item, a_renaming.item (l_vars.key))
				else
					l_candidates.force (l_vars.item, l_vars.key)
				end
			end

			create Result.make
			Result.set_target_variables (l_targets)
			Result.set_interface_variables (l_interfaces)
			Result.set_candidate_interface_variables (l_candidates)
		end

feature{NONE} -- Implementation

	variable_name (a_type: TYPE_A; a_target: BOOLEAN): STRING
			-- Name of variable of type `a_type'
			-- `a_target' indicates if the variable name is for a target variable
			-- inside a snippet.
		local
			l_header: CHARACTER
			l_index: INTEGER
		do
			create Result.make (2)
			if a_target then
				l_header := 'v'
			elseif a_type = Void then
				l_header := 'o'
			else
				if a_type.is_integer then
					l_header := 'i'
				elseif a_type.is_boolean then
					l_header := 'b'
				else
					l_header := 'o'
				end
			end
			Result.append_character (l_header)
			l_index := variable_index.item (l_header)
			if l_index > 0 then
				Result.append_integer (l_index)
			end
			variable_index.force (l_index + 1, l_header)
		end

	variable_index: HASH_TABLE [INTEGER, CHARACTER]
			-- Table to count how many variables
			-- we already have for each type
			-- Keys are variable type short hands
			-- (v for target, b for boolean, i for integer, o for everything else).
			-- Values are number of variables.

end
