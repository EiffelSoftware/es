note
	description: "Summary description for {CA_TODO_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_TODO_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization
	make
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

	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			if attached {STRING_32} a_violation.long_description_info.first as l_comment then
				a_formatter.add (l_comment)
			end
		end

feature {NONE} -- AST Visit

	process_class (a_class: CLASS_AS)
		local
			l_comments: EIFFEL_COMMENTS
		do

		end

	search_todo (a_comment: EIFFEL_COMMENT_LINE)
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

				create l_viol.make_with_rule (Current)
				l_viol.set_location (create {LOCATION_AS}.make (a_comment.line, a_comment.column, 0, 0, 0, 0, 0))
				l_viol.long_description_info.extend (l_todo)
				violations.extend (l_viol)
			end
		end

end
