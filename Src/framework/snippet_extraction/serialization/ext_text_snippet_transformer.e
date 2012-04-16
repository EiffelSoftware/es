note
	description: "Class which transforms a snippet into a textual representation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_TEXT_SNIPPET_TRANSFORMER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_id_as,
			processing_access_feat_as
		end

create
	make_with_output

feature -- Basic operations

	transform (a_snippet: EXT_SNIPPET)
			-- Transform `a_snippet' into textual representation.
		do
			snippet := a_snippet
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} a_snippet.ast as l_as then
				l_as.process (Current)
			end
		end

	transformed_ast (a_ast: AST_EIFFEL; a_snippet: EXT_SNIPPET): STRING
			-- Transform `ast' in context of `a_snippet'.
		local
			l_output: like output
			l_new_output: ETR_AST_STRING_OUTPUT
		do
			l_output := output
			create l_new_output.make
			output := l_new_output
			snippet := a_snippet
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} a_snippet.ast as l_as then
				a_ast.process (Current)
			end
			Result := l_new_output.string_representation
			output := l_output
		end
feature{NONE} -- Implementation

	snippet: EXT_SNIPPET
			-- Snippet that is processed currently

feature -- Process

	process_id_as (l_as: ID_AS)
		do
			Precursor (l_as)
			safe_process_hole (l_as.name)
		end

	processing_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			output.append_string (l_as.access_name)
			safe_process_hole (l_as.access_name)
			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space+ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
		end

	safe_process_hole (l_name: STRING)
			-- Process hole named `l_name' if such hole exists.
		local
			l_hole: EXT_HOLE
		do
			snippet.holes.search (l_name)
			if snippet.holes.found then
				l_hole := snippet.holes.found_item
				output.append_string (once " (")
				if attached l_hole.hole_type as l_type then
					output.append_string (l_type)
					output.append_string (once "; ")
				end
				if attached l_hole.annotations as l_annotations then
					l_annotations.do_all_with_index (agent process_mention_annotation)
				end
				output.append_string (once " )")
			end
		end

	process_mention_annotation (a_annotation: ANN_MENTION_ANNOTATION; a_index: INTEGER)
			-- Process `a_annotation'.
		do
			if attached a_annotation.expression as l_exp then
				if a_index > 1 then
					output.append_string (once ", ")
				end
				if a_annotation.is_conditional then
					output.append_string (once "|")
				end
				output.append_string (l_exp)
			end
		end
end
