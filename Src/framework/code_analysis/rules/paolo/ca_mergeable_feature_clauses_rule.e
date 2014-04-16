note
	description: "[
					RULE #88: Mergeable feature clauses
		
					Feature clauses with the same export status and comment could possibly
					be merged into one, or their comments could be made more specific.
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_MERGEABLE_FEATURE_CLAUSES_RULE

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
		do
			a_checker.add_class_pre_action (agent class_pre)
			a_checker.add_class_post_action (agent class_pre)
			a_checker.add_feature_clause_pre_action (agent process_feature_clause)
		end

feature {NONE} -- Rule checking

	class_pre (a_class_as: CLASS_AS)
		do
			create seen_feature_table.make (32)
		end

	class_post (a_class_as: CLASS_AS)
		do
			seen_feature_table := Void
		end

	process_feature_clause (a_feature_clause_as: attached FEATURE_CLAUSE_AS)
		local
			l_viol: CA_RULE_VIOLATION
			l_key: STRING
			l_comment_text: STRING
		do
			l_comment_text := trim_string (stringify_comments (a_feature_clause_as.comment (current_context.matchlist)))
			l_key := l_comment_text.as_lower + stringify_clients (a_feature_clause_as.clients) -- Case insensitive on comments
			if not seen_feature_table.has (l_key) then
				seen_feature_table.put (a_feature_clause_as, l_key)
			else
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_feature_clause_as.start_location)
				l_viol.long_description_info.extend (l_comment_text)
				violations.extend (l_viol)
			end
		end

	seen_feature_table: detachable HASH_TABLE [FEATURE_CLAUSE_AS, STRING]
			-- Contains the features that have been met so far. The key is a combination
			-- of the feature comment and the exports.

	stringify_comments (a_comments: EIFFEL_COMMENTS): STRING
		do
			create Result.make (512) -- Should be more space than enough
			across
				a_comments as ic
			loop
				Result.append_string (ic.item.content_32)
			end
		end

	stringify_clients (a_clients: CLIENT_AS): STRING
		local
			l_inner_clients: CLASS_LIST_AS
			l_client_list: SORTABLE_ARRAY [STRING]
			l_current_client: STRING
			i: INTEGER
		do
			if a_clients = Void or else a_clients.clients = Void then
				create Result.make_empty
			else
				l_inner_clients := a_clients.clients
				create l_client_list.make_filled (Void, 1, l_inner_clients.count)
				from
					i := 1
				until
					i > l_inner_clients.count
				loop
					l_current_client := l_inner_clients [i].name_32
					check
						attached l_current_client
					end
					l_client_list [i] := l_current_client
					i := i + 1
				end
				l_client_list.sort
				create Result.make (256) -- Should be more space than enough
				across
					l_client_list as ic
				loop
					Result.append (ic.item + " ")
				end
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.mergeable_feature_clauses_title
		end

	id: STRING_32 = "CA088"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.mergeable_feature_clauses_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.mergeable_feature_clauses_violation_1)
			check attached {STRING} a_violation.long_description_info.first as comment_text then
				a_formatter.add_quoted_text (comment_text)
			end
			a_formatter.add (ca_messages.mergeable_feature_clauses_violation_2)
		end

end
