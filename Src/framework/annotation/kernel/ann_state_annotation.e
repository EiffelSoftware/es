note
	description: "[
		Annotation that represents state information
		Note: This class should be treated as immutable class.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_STATE_ANNOTATION

inherit
	ANN_ANNOTATION

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_breakpoints: like breakpoints; a_pre_state: like pre_state; a_post_state: like post_state)
			-- Initialize Current.
		do
			a_breakpoints.do_all (agent breakpoints.force_last)
			pre_state := a_pre_state
			post_state := a_post_state
			hash_code := debug_output.hash_code
		end

feature -- Access

	pre_state: DS_HASH_SET [STRING]
			-- Annotations in pre-state

	post_state: DS_HASH_SET [STRING]
			-- Annotations in post-state

	pre_state_as_ast: LINKED_LIST [EXPR_AS]
			-- AST representation of `pre_state' annotations
			-- Note: reclculate the result every time.
		do
			Result := state_as_ast (pre_state)
		end

	post_state_as_ast: LINKED_LIST [EXPR_AS]
			-- AST representation of `post_state' annotations
			-- Note: reclculate the result every time.
		do
			Result := state_as_ast (post_state)
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		local
			l_cursor: like pre_state.new_cursor
		do
			create Result.make (1024)
			Result.append (once "Breakpoints: ")
			Result.append (breakpoints_as_string)
			Result.append_character ('%N')
			Result.append (once "Pre-state:%N")
			from
				l_cursor := pre_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append_character ('%T')
				Result.append (l_cursor.item)
				Result.append_character ('%N')
				l_cursor.forth
			end
			Result.append (once "Post-state:%N")
			from
				l_cursor := post_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append_character ('%T')
				Result.append (l_cursor.item)
				Result.append_character ('%N')
				l_cursor.forth
			end
		end

feature{NONE} -- Implimentation

	state_as_ast (a_state: like pre_state): LINKED_LIST [EXPR_AS]
			-- AST representation for annotations in `a_state'
		local
			l_cursor: like pre_state.new_cursor
		do
			create Result.make
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.extend (ast_from_expression_text (l_cursor.item))
				l_cursor.forth
			end
		end

end
