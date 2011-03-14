note
	description: "Class to check which breakpoints are not visited in the semantic database"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CHECK_UNVISITED_BREAKPOINTS_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	SEMQ_UTILITY

	EPA_STRING_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature -- Basic operations

	execute
			-- Execute current command
		local
			l_connection: MYSQL_CLIENT
			l_feats: LINKED_LIST [FEATURE_I]
			l_class: CLASS_C
			l_feat: FEATURE_I
			l_log_manager: ELOG_LOG_MANAGER
			i: INTEGER
			l_calculator: SEM_DB_BOOST_UPDATE_MANAGER
			l_bps: LINKED_LIST [INTEGER]
			l_classes: LINKED_LIST [STRING]
			l_bp_str: STRING
		do
			create l_log_manager.make_with_logger_array (<<create {ELOG_CONSOLE_LOGGER}>>)
			create l_connection.make_with_database (config.mysql_host, config.mysql_user, config.mysql_password, config.mysql_schema, config.mysql_port)
			l_connection.connect

			if config.class_name /= Void then
				create l_classes.make
				l_classes.extend (config.class_name)
			else
				l_classes := classes_from_database (False, l_connection)
			end
			across l_classes as l_class_names loop
				io.put_string ("--------------------------------------------%N")
				l_class := first_class_starts_with_name (l_class_names.item)
				create l_feats.make
				if config.feature_name /= Void then
					l_feat := l_class.feature_named (config.feature_name)
						-- We only calculate rankings for commands.
					if l_feat /= Void and then not l_feat.has_return_value then
						l_feats.extend (l_feat)
					end
				else
					across features_from_database (l_class, False, l_connection) as l_feat_names loop
						l_feat := l_class.feature_named (l_feat_names.item)
							-- We only calculate rankings for commands.
						if l_feat /= Void and then not l_feat.has_return_value then
							l_feats.extend (l_feat)
						end
					end
				end

					-- Update rankings for all the collected features.		
				if not l_feats.is_empty then
					across l_feats as l_features loop
						l_feat := l_features.item
						if is_test_case_for_feature_available (l_class, l_feat, l_connection) then
							create l_bp_str.make (64)
							l_bps := unvisited_breakpoints (l_class, l_feat, l_connection)
							across l_bps as l_breakpoints loop
								if not l_bp_str.is_empty then
									l_bp_str.append (", ")
								end
								l_bp_str.append (l_breakpoints.item.out)
							end
							if not l_bp_str.is_empty then
								io.put_string (class_name_dot_feature_name (l_class, l_feat) + ": ")
								io.put_string (l_bp_str)
								io.put_string ("%N")
							end
						end
					end
				end
			end
			l_connection.dispose
		end

feature{NONE} -- Implementation

	is_test_case_for_feature_available (a_class: CLASS_C; a_feature: FEATURE_I; a_connection: MYSQL_CLIENT): BOOLEAN
			-- Is there any test case for `a_feature' from `a_class' available in the semantic
			-- search database through `a_connection'?
		require
			a_connection_is_connected: a_connection.is_connected
		local
			l_select: STRING
			l_result: MYSQL_RESULT
		do
			l_select := "SELECT COUNT(qry_id) FROM Queryables WHERE class = '" + a_class.name_in_upper + "' AND feature = '" + a_feature.feature_name.as_lower + "'"
			a_connection.execute_query (l_select)
			if a_connection.last_error_number = 0 and then a_connection.has_result then
				l_result := a_connection.last_result
				l_result.start
				if not l_result.after then
					Result := l_result.at (1).to_integer > 0
				end
				l_result.dispose
			end
		end

	unvisited_breakpoints (a_class: CLASS_C; a_feature: FEATURE_I; a_connection: MYSQL_CLIENT): LINKED_LIST [INTEGER]
			-- List of unvisited breakpoints in all test cases for `a_feature' in `a_class'
			-- through the semantic database givne by `a_connection'
		local
			l_select: STRING
			l_result: MYSQL_RESULT
			l_all_bps: DS_HASH_SET [INTEGER]
			l_count: INTEGER
			l_bp: INTEGER
			l_sorted: SORTED_TWO_WAY_LIST [INTEGER]
		do
				-- Collect all possible breakpoints.
			l_count := a_feature.e_feature.number_of_breakpoint_slots
			create l_all_bps.make (l_count)
			across 1 |..| l_count as l_bps loop
				l_all_bps.force_last (l_bps.item)
			end

				-- Check which breakpoints are visited, and which are not visited.
			create Result.make
			l_select := "SELECT DISTINCT h.bp_slot FROM Queryables q, HitBreakpoints h WHERE q.class = '" + a_class.name_in_upper + "' and q.feature = '" + a_feature.feature_name.as_lower + "' AND q.qry_kind = 2 AND h.qry_id = q.qry_id ORDER BY h.bp_slot"
			a_connection.execute_query (l_select)
			if a_connection.last_error_number = 0 and then a_connection.has_result then
				l_result := a_connection.last_result
				from
					l_result.start
				until
					l_result.after
				loop
					l_bp := l_result.at (1).to_integer
					if l_all_bps.has (l_bp) then
						l_all_bps.remove (l_bp)
					end
					l_result.forth
				end
				l_result.dispose

					-- Sort left breakpoints.
				create l_sorted.make
				from
					l_all_bps.start
				until
					l_all_bps.after
				loop
					l_sorted.extend (l_all_bps.item_for_iteration)
					l_all_bps.forth
				end
				across l_sorted as l_sorted_bps loop Result.extend (l_sorted_bps.item) end
			end
		end
end
