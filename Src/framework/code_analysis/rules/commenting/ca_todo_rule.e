note
	description: "See `description' below."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_TODO_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

	AST_ROUNDTRIP_ITERATOR
			-- In order to be able to access all the comments.
		redefine
			process_break_as
		end

create
	make

feature {NONE} -- Initialization
	make
			-- Initialization.
		do
				-- set the default parameters (subject to be changed by user)
			is_enabled_by_default := True
			create {CA_SUGGESTION} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent process_class)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.todo_title
		end

	id: STRING_32 = "CA080T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.todo_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			if attached {STRING_32} a_violation.long_description_info.first as l_comment then
				a_formatter.add (l_comment)
			end
		end

feature {NONE} -- AST Visit

	process_break_as (a_break: BREAK_AS)
			-- From {AST_ROUNDTRIP_ITERATOR}. Checks comment of `a_break' for
			-- a "TODO".
		do
			across
				a_break.extract_comment as l_comment_line
			loop
				if attached l_comment_line.item as l_comment and then attached l_comment.content_32 then
					search_todo (l_comment)
				end
			end
			Precursor (a_break)
		end

	process_class (a_class: CLASS_AS)
			-- Start roundtrip iteration on `a_class'.
		local
			l_comments: EIFFEL_COMMENTS
		do
			set_parsed_class (a_class)
			set_match_list (matchlist)
			set_will_process_leading_leaves (True)
			set_will_process_trailing_leaves (True)

			process_ast_node (a_class)
		end

	search_todo (a_comment: EIFFEL_COMMENT_LINE)
			-- Searches `a_comment' for a "TODO".
		local
			l_comment, l_todo: STRING_32
			l_toremove: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			create l_comment.make_from_string (a_comment.content_32)
			l_comment.left_adjust
			l_comment.to_lower
			if l_comment.starts_with ("todo") or l_comment.starts_with ("to do") then
					-- We will remove the leading "TODO" from the string that will be
					-- stored in the rule violation. Here, we save the correct number
					-- of characters to remove.
				l_toremove := 4
				if l_comment.starts_with ("to do") then
					l_toremove := 5
				end

					-- Initialize `l_todo' to the original TODO-comment (without the TODO).
				create l_todo.make_from_string (a_comment.content_32)
				l_todo.left_adjust
				l_todo.remove_head (l_toremove)
				l_todo.left_adjust -- Remove leading whitespace again.
				if l_todo [1].is_equal (':') then
						-- Remove the leading colon.
					l_todo.remove (1)
					l_todo.left_adjust
				end

				create l_viol.make_with_rule (Current)
				l_viol.set_location (create {LOCATION_AS}.make (a_comment.line, a_comment.column, 0, 0, 0, 0, 0))
				l_viol.long_description_info.extend (l_todo)
				violations.extend (l_viol)
			end
		end

end
