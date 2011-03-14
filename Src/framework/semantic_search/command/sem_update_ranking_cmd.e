note
	description: "Command to update property rankings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UPDATE_RANKING_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	SEMQ_UTILITY

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
		do
			create l_log_manager.make_with_logger_array (<<create {ELOG_CONSOLE_LOGGER}>>)
			create l_connection.make_with_database (config.mysql_host, config.mysql_user, config.mysql_password, config.mysql_schema, config.mysql_port)
			l_connection.connect
				-- We assume that the class name is always provided.
				-- If feature_name is also provided, only update ranking for that feature
				-- from the class, otherwise, update the rankings for all features in the
				-- given class (this will take a long time).
			l_class := first_class_starts_with_name (config.class_name)
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
				i := 1
				across l_feats as l_features loop
					l_feat := l_features.item
					l_log_manager.put_line_with_time ("Updating ranking for " + l_class.name_in_upper + "." + l_feat.feature_name + " (" + i.out + "/" + l_feats.count.out + ")")
--					l_boost_calculator.update_table_boost_values (
--						l_class.name_in_upper,
--						l_feat.feature_name.as_lower,
--						l_feat.argument_count)
				end
			end
			l_connection.dispose
		end

end
