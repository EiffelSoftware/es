note
	description: "Class to extract annotations based the usage of interface variables."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_MENTION_ANNOTATION_EXTRACTOR

inherit
	EXT_ANNOTATION_EXTRACTOR [ANN_MENTION_ANNOTATION]
		redefine
			extract_from_ast
		end

	REFACTORING_HELPER

	ANN_SHARED_EQUALITY_TESTERS

create
	make_from_variable_context

feature {NONE} -- Initialization

	make_from_variable_context (a_variable_context: EXT_VARIABLE_CONTEXT)
			-- Initialize with `a_variable_context'.		
		do
			variable_context := a_variable_context
		end

feature -- Access

	is_conditional: BOOLEAN
		assign set_conditional
			-- States if `last_annotations' occure conditionally or mandatory.	

	set_conditional (a_conditional: BOOLEAN)
			-- Sets `is_conditional'.
		do
			is_conditional := a_conditional
		end

feature -- Basic operations

	extract_from_ast (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		local
			l_annotation: ANN_MENTION_ANNOTATION
		do
			create last_annotations.make_equal (10)
			last_annotations.set_equality_tester (mention_annotation_equality_tester)

			if attached collect_mention_expressions (a_ast) as l_mention_set then
				across
					l_mention_set as l_cursor
				loop
					create l_annotation.make_with_arguments (l_cursor.item, is_conditional)
					last_annotations.force (l_annotation)
				end
			end
		end

	extract_from_snippet (a_snippet: EXT_SNIPPET)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		do
			extract_from_ast (a_snippet.ast)
		end

feature {NONE} -- Implementation

	variable_context: EXT_VARIABLE_CONTEXT
			-- Contextual information about relevant variables.

	collect_mention_expressions (a_ast: AST_EIFFEL): LINKED_SET [STRING]
			-- Collect 'identifier' and 'identifier.feature_call' string representation of variables of interest used in `a_ast'.
		local
			l_identifier_usage_finder: EPA_IDENTIFIER_USAGE_CALLBACK_ITERATOR
		do
			create Result.make
			Result.compare_objects

			create l_identifier_usage_finder
			l_identifier_usage_finder.set_is_mode_disjoint (True)
			l_identifier_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_variable_context: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if a_variable_context.is_variable_of_interest (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, variable_context, Result)
				)
			l_identifier_usage_finder.set_on_access_identifier_with_feature_call (
				agent (l_as: NESTED_AS; a_variable_context: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if a_variable_context.is_variable_of_interest (l_as.target.access_name_8) then
							if attached get_call_name (l_as.message) as l_call_name then
								a_variable_usage.force (l_as.target.access_name_8 + once "." + l_call_name)
							else
								a_variable_usage.force (l_as.target.access_name_8)
							end
						end
					end (?, variable_context, Result)
				)

			a_ast.process (l_identifier_usage_finder)
		end

	get_call_name (a_as: CALL_AS): STRING
			-- Returns the feature name of a call.
		do
			fixme ("Re-check if all relevant cases are correctly handled. CALL_AS { ACCESS_AS, CREATION_EXPR_AS, NESTED_AS, NESTED_EXPR_AS }.")

			if attached {ACCESS_AS} a_as as l_as then
				Result := l_as.access_name_8
			elseif attached {NESTED_AS} a_as as l_as then
				Result := l_as.target.access_name_8
			end
		end

end
