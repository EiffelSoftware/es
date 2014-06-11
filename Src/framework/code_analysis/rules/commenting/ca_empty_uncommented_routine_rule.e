note
	description: "[
		RULE #51: Empty and uncommented feature
		
		A routine which does not contain any instructions and has no comment too indicates that the implementation might be missing.
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_UNCOMMENTED_ROUTINE_RULE

inherit

	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			make_with_defaults
			create {CA_HINT} severity
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		local
			l_foo: detachable STRING
		do
			io.put_integer (l_foo.count)
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_do_pre_action (agent process_do)
			a_checker.add_once_pre_action (agent process_once)
		end

feature {NONE} -- Rule checking

	current_feature: detachable FEATURE_AS

	process_do_once (a_as: attached INTERNAL_AS)
		local
			l_leaf_list: LEAF_AS_LIST
			l_comments: EIFFEL_COMMENTS
			l_comments_empty: BOOLEAN
			l_viol: CA_RULE_VIOLATION
		do
			check false and attached current_feature then
				if not attached a_as.compound or else a_as.compound.is_empty then
					l_leaf_list := current_context.matchlist
					if current_feature.body.is_routine then
							-- TODO: Unneeded helper variable detected here (which is fine).
							-- The problem is that the location of the suggestion is wrong,
							-- the text suggests it should point to the usage, not the assignment.
--						l_comments := current_feature.comment (l_leaf_list)
--						l_comments_empty := comments_are_empty (l_comments)
						l_comments := current_feature.comment (l_leaf_list)
						if comments_are_empty (l_comments) then
							create l_viol.make_with_rule (Current)
							l_viol.set_location (current_feature.start_location)
							l_viol.long_description_info.extend (current_feature.feature_name.name_32)
							violations.extend (l_viol)
						end
					end
				end
			end
		end

	process_do (a_do_as: attached DO_AS)
		do
			process_do_once (a_do_as)
		end

	process_once (a_once_as: attached ONCE_AS)
		do
			process_do_once (a_once_as)
		end

	process_feature (a_feature_as: attached FEATURE_AS)
		do
			current_feature := a_feature_as
		end

	comments_are_empty (a_comments: detachable EIFFEL_COMMENTS): BOOLEAN
		do
			Result := true
			if attached a_comments then
				from
					a_comments.start
				until
					a_comments.after or not Result
				loop
					if not a_comments.item.content_32.is_whitespace then
						Result := false
					end
					a_comments.forth
				end
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.empty_uncommented_routine_title
		end

	id: STRING_32 = "CA051"

	description: STRING_32
		do
			Result := ca_names.empty_uncommented_routine_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.empty_uncommented_routine_violation_1)
			check attached {STRING_32} a_violation.long_description_info.first as feature_name then
				a_formatter.add_feature_name (feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.empty_uncommented_routine_violation_2)
		end

end
