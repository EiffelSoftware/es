note
	description: "[
			RULE #73: Comment not well phrased
			
			The comment does not end with a period or question
			mark. This indicates that the comment is not well
			phrased. A comment should always consist of whole
			sentences.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_COMMENT_NOT_WELL_PHRASED_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_defaults
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent check_comments)
		end

feature {NONE} -- Rule checking

	check_comments (a_class: attached CLASS_AS)
		-- Checks for not well phrased comments in `a_class'.
		local
			l_violation: CA_RULE_VIOLATION
			l_comment_string: STRING_32
		do

			if current_context.matchlist /= Void then
				across
					current_context.matchlist.extract_comment (create {ERT_TOKEN_REGION}.make(a_class.first_token (current_context.matchlist).index, a_class.last_token (current_context.matchlist).index)) as l_comment
				loop
					l_comment_string := l_comment.item.content_32

					if not l_comment_string.is_empty and then not (l_comment_string.at (l_comment_string.count).is_equal ('?') or l_comment_string.at (l_comment_string.count).is_equal ('.')) then
						create l_violation.make_with_rule (Current)
						l_violation.set_location (create {LOCATION_AS}.make (l_comment.item.line, l_comment.item.column, 0, 0, 0, 0, 0))
						l_violation.long_description_info.extend (l_comment.item.content_32)
						violations.extend (l_violation)
					end
				end
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.comment_not_well_phrased_title
		end

	id: STRING_32 = "CA073"

	description: STRING_32
		do
			Result := ca_names.comment_not_well_phrased_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			if attached {STRING_32} a_violation.long_description_info.first as l_comment_text then
				a_formatter.add_quoted_text (l_comment_text)
			end
		end
end
