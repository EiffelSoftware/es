note
	description: "Class that represents an extracted snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_SHARED_EQUALITY_TESTERS

	HASHABLE

	DEBUG_OUTPUT

	SHARED_EIFFEL_PARSER

	STORABLE

create
	make

feature{NONE} -- Initialization

	make (a_content: like content; a_variable_context: like variable_context; a_holes: like holes; a_source: like source)
			-- Initialize Current.
		require
			not_a_content_is_empty: not a_content.is_empty
		local
			l_retried: BOOLEAN
			l_bp_initializer: ETR_BP_SLOT_INITIALIZER
		do
			variable_context := a_variable_context.deep_twin
			holes := a_holes.deep_twin

			content := a_content.twin
			source := a_source.twin

			build_debug_output
			hash_code := debug_output.hash_code

			create annotations.make

			if not l_retried then
				fixme ("Seems not to work with 'across' loops. msteindorfer:2011-07-14")

					-- Initialize break point slots.
				create l_bp_initializer
				l_bp_initializer.set_current_breakpoint_slot (1)
				l_bp_initializer.init_from (ast)
			end
		rescue
			l_retried := True
			retry
		end

feature -- Configuration

	set_content_original (a_content: STRING)
			-- Sets `content_original' to `a_content'
		require
			attached a_content
		do
			content_original := a_content
		end

feature -- Access

	operands: HASH_TABLE [STRING, STRING]
			-- Operands appearing in current snippet
			-- Keys are variable names (in lower case), values are types of those
			-- variables.
		do
			create Result.make (
				variable_context.target_variables.count +
				variable_context.interface_variables.count)
			Result.compare_objects

			Result.merge (variable_context.target_variables)
			Result.merge (variable_context.interface_variables)
		end

	operand_names: ARRAYED_SET [STRING]
			-- Set of operand names from `operands'
			-- Note: create a new set every time.
		do
			create Result.make (operands.count)
			Result.compare_objects
			across operands as l_opds loop
				Result.extend (l_opds.key)
			end
		end

	holes: HASH_TABLE [EXT_HOLE, STRING]
			-- Set of holes in current snippet
			-- Keys are names of holes, values are the holes.

	variable_context: EXT_VARIABLE_CONTEXT
			-- Contextual information about relevant variables used
			-- during the extraction process.	

	content: STRING
			-- Textual representation of current snippet.
			-- The content should be a parse-able string.

	content_original: detachable STRING
		assign set_content_original
			-- Textual representation of originating AST.
			-- The content should be a parse-able string.

	source: EXT_SNIPPET_ORIGIN
			-- The source where current snippet come from

	ast: detachable EIFFEL_LIST [INSTRUCTION_AS]
			-- AST representation of `content'
		do
			if ast_internal = Void then
				parser.parse_from_ascii_string (dummy_feature_for_content, Void)
				if attached {FEATURE_AS} parser.feature_node as l_feat then
					if attached {BODY_AS} l_feat.body as l_body then
						if attached {ROUTINE_AS} l_body.content as l_routine then
							if attached {DO_AS} l_routine.routine_body as l_do then
								ast_internal := l_do.compound
							end
						end
					end
				end
			end
			Result := ast_internal
		end

	hash_code: INTEGER
			-- Hash code value

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.

	annotations: LINKED_LIST [ANN_ANNOTATION]
		-- List of annotations associated with current snippet	

	as_string: STRING
			-- String representation of current snippet containing operand definition and snippet content.
		local
			l_cursor: like operands.new_cursor
			l_output: STRING
		do
			create Result.make (128)
			l_output := Result

				-- Build operands and their types.
			from
				l_cursor := operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_output.append (l_cursor.key)
				l_output.append_character (':')
				l_output.append_character (' ')
				l_output.append (output_type_name (l_cursor.item))
				l_output.append_character ('%N')
				l_cursor.forth
			end
			l_output.append_character ('%N')

				-- Build `content'.
			l_output.append (content)
			l_output.append_character ('%N')
		end

feature{NONE} -- Implementation

	ast_internal: detachable like ast
			-- Cache for `ast'

	parser: EIFFEL_PARSER
			-- Parser used for parsing expressions
		do
			Result := expression_parser
			Result.set_syntax_version (Result.provisional_syntax)
		end

	dummy_feature_for_content: STRING
			-- Dummy feature for `content'
		do
			create Result.make (content.count + 20)
			Result.append (once "feature dummy_feature do%N")
			Result.append (content)
			Result.append_character ('%N')
			Result.append (once "end")
		end

	build_debug_output
			-- Build `debug_output'.
		local
			l_cursor: like operands.new_cursor
			l_output: STRING
		do
			create debug_output.make (128)
			l_output := debug_output
			l_output.append (as_string)

				-- Build `source'.
			l_output.append_character ('%N')
			l_output.append (source.out)
		end

end
