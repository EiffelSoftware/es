note
	description: "Tracks queryables"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_DATABASE_QUERYABLES

inherit
	SEMQ_DATABASE

create
	make

feature -- Initialization

	load_empty
			-- Don't load any queryables
		do
			create queryables.make (1) -- there should only be one at a time
			open_mysql
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`HitBreakpoints` VALUES (?, ?)")
			stmt_insert_hitbreakpoints := mysql.last_statement
			mysql.prepare_statement (once "SELECT `qry_id` FROM `semantic_search`.`Queryables` WHERE `uuid` = ?")
			stmt_find_uuid := mysql.last_statement
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`Queryables` VALUES (NULL, 0, NULL, NULL, NULL, NULL, NULL, ?, ?, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL)")
			stmt_insert_queryable := mysql.last_statement
			stmt_insert_queryable.set_string (0, config.timestamp)
		end

feature -- Basic operations

	new_queryable (a_uuid: STRING): INTEGER
			-- Returns a value > 0 if this UUID is not yet in the database
		require
			queryables /= Void
		do
			stmt_find_uuid.set_string (0, a_uuid)
			stmt_find_uuid.execute
			if stmt_find_uuid.num_rows > 0 then
				Result := 0
			else
				stmt_insert_queryable.set_string (1, a_uuid)
				stmt_insert_queryable.execute
				Result := stmt_insert_queryable.last_insert_id
				-- Prepare for attributes
				queryables.put (create {HASH_TABLE [STRING, STRING]}.make (5), Result)
			end
		end

	save_queryable (a_qry_id: INTEGER)
			-- Write attributes of queryable with a_qry_id to database
		require
			queryables.has (a_qry_id)
		local
			stmt: STRING
			attributes: HASH_TABLE [STRING, STRING]
			hit_breakpoints: LIST [STRING]
		do
			-- Setup
			attributes := queryables.at (a_qry_id)
			make_sem_field_names

			create stmt.make (65536) -- Serialization can be very large
			stmt.append (once "UPDATE `semantic_search`.`Queryables` SET `uuid` = `uuid`")
			-- `qry_kind` tinyint(3) unsigned NOT NULL
			if attributes.has (once "document_type") then
				stmt.append (once ", `qry_kind` = "+sem_field_names.queryable_types.at (attributes.at (once "document_type")).out)
			end
			-- `class` varchar(128) DEFAULT NULL
			if attributes.has (once "class") then
				stmt.append (once ", `class` = '"+attributes.at (once "class")+once "'")
			end
			-- `feature` varchar(128) DEFAULT NULL
			if attributes.has (once "feature") then
				stmt.append (once ", `feature` = '"+attributes.at (once "feature")+once "'")
			end
			-- `library` varchar(128) DEFAULT NULL
			if attributes.has (once "library") then
				stmt.append (once ", `library` = '"+attributes.at (once "library")+once "'")
			end
			-- `transition_status` tinyint(3) unsigned DEFAULT NULL
			if attributes.has (once "transition_status") then
				stmt.append (once ", `transition_status` = "+sem_field_names.queryable_transition_status.at (attributes.at (once "transition_status")).out)
			end
			-- `hit_breakpoints` varchar(2048)
			if attributes.has (once "hit_breakpoints") then
				stmt.append (once ", `hit_breakpoints` = '"+attributes.at (once "hit_breakpoints")+once "'")
			end
			-- `is_creation` tinyint(3) unsigned DEFAULT NULL
			if attributes.has (once "is_creation") then
				stmt.append (once ", `is_creation` = "+sem_field_names.queryable_true_false.at (attributes.at (once "is_creation")).out)
			end
			-- `is_query` tinyint(3) unsigned DEFAULT NULL
			if attributes.has (once "is_query") then
				stmt.append (once ", `is_query` = "+sem_field_names.queryable_true_false.at (attributes.at (once "is_query")).out)
			end
			-- `argument_count` tinyint(3) unsigned DEFAULT NULL
			if attributes.has (once "argument_count") then
				stmt.append (once ", `argument_count` = "+attributes.at (once "argument_count"))
			end
			-- `pre_serialization` longtext
			if attributes.has (once "pre_serialization") then
				stmt.append (once ", `pre_serialization` = '"+attributes.at (once "pre_serialization")+once "'")
			end
			-- `pre_serialization_info` text
			if attributes.has (once "pre_object_info") then
				stmt.append (once ", `pre_serialization_info` = '"+attributes.at (once "pre_object_info")+once "'")
			end
			-- `post_serialization` longtext
			if attributes.has (once "serialization") then
				stmt.append (once ", `post_serialization` = '"+attributes.at (once "serialization")+once "'")
			end
			-- `post_serialization_info` text
			if attributes.has (once "object_info") then
				stmt.append (once ", `post_serialization_info` = '"+attributes.at (once "object_info")+once "'")
			end
			-- `exception_recipient` varchar(128) DEFAULT NULL
			if attributes.has (once "recipient") then
				stmt.append (once ", `exception_recipient` = '"+attributes.at (once "recipient")+once "'")
			end
			-- `exception_class` varchar(128) DEFAULT NULL
			if attributes.has (once "recipient_class") then
				stmt.append (once ", `exception_class` = '"+attributes.at (once "recipient_class")+once "'")
			end
			-- `exception_breakpoint` int(11) DEFAULT NULL
			if attributes.has (once "exception_break_point_slot") then
				stmt.append (once ", `exception_breakpoint` = "+attributes.at (once "exception_break_point_slot"))
			end
			-- `exception_code` int(11) DEFAULT NULL
			if attributes.has (once "exception_code") then
				stmt.append (once ", `exception_code` = "+attributes.at (once "exception_code"))
			end
			-- `exception_meaning` varchar(256) DEFAULT NULL
			if attributes.has (once "exception_meaning") then
				stmt.append (once ", `exception_meaning` = '"+attributes.at (once "exception_meaning")+once "'")
			end
			-- `exception_tag` varchar(256) DEFAULT NULL
			if attributes.has (once "exception_assertion_tag") then
				stmt.append (once ", `exception_tag` = '"+attributes.at (once "exception_assertion_tag")+once "'")
			end
			-- `exception_trace` text
			if attributes.has (once "exception_trace") then
				attributes.at (once "exception_trace").replace_substring_all (once "'", once "\'")
				stmt.append (once ", `exception_trace` = '"+attributes.at (once "exception_trace")+once "'")
			end
			-- `fault_signature` varchar(256) DEFAULT NULL
			if attributes.has (once "fault_id") then
				stmt.append (once ", `fault_signature` = '"+attributes.at (once "fault_id")+once "'")
			end
			-- `feature_kind` tinyint(3) unsigned DEFAULT NULL
			if attributes.has (once "feature_type") then
				stmt.append (once ", `feature_kind` = "+sem_field_names.queryable_feature_types.at (attributes.at (once "feature_type")).out)
			end
			-- `operand_count` int(10) unsigned DEFAULT NULL
			if attributes.has (once "operand_count") then
				stmt.append (once ", `operand_count` = "+attributes.at (once "operand_count"))
			end
			-- `content` varchar(2048) DEFAULT NULL
			if attributes.has (once "content") then
				stmt.append (once ", `content` = '"+attributes.at (once "content")+once "'")
			end
			-- `test_case_name` varchar(300)
			if attributes.has (once "test_case_name") then
				stmt.append (once ", `test_case_name` = '"+attributes.at (once "test_case_name")+once "'")
			end
			-- `breakpoint_number` int(10) unsigned NOT NULL
			if attributes.has (once "breakpoint_number") then
				stmt.append (once ", `breakpoint_number` = "+attributes.at (once "breakpoint_number"))
			end
			-- `first_body_breakpoint` int(10) unsigned NOT NULL
			if attributes.has (once "first_body_breakpoint") then
				stmt.append (once ", `first_body_breakpoint` = "+attributes.at (once "first_body_breakpoint"))
			end
			-- `pre_bounded_functions` varchar (300)
			if attributes.has (once "prestate_bounded_functions") then
				stmt.append (once ", `pre_bounded_functions` = '"+attributes.at (once "prestate_bounded_functions")+once "'")
			end
			-- `post_bounded_functions` varchar (300)
			if attributes.has (once "poststate_bounded_functions") then
				stmt.append (once ", `post_bounded_functions` = '"+attributes.at (once "poststate_bounded_functions")+once "'")
			end

			-- Update database
			stmt.append (once " WHERE `qry_id` = ")
			stmt.append_integer (a_qry_id)
			mysql.execute_query (stmt)

			-- HitBreakpoints
			if attributes.has (once "hit_breakpoints") then
				hit_breakpoints := attributes.at (once "hit_breakpoints").split (';')
				from
					hit_breakpoints.start
				until
					hit_breakpoints.off
				loop
					if hit_breakpoints.item.at (1) /= '_' then
						stmt_insert_hitbreakpoints.set_int (0, a_qry_id)
						stmt_insert_hitbreakpoints.set_int (1, hit_breakpoints.item.to_integer)
						stmt_insert_hitbreakpoints.execute
					end
					hit_breakpoints.forth
				end
			end

			-- Cleanup
			queryables.remove (a_qry_id)
		end

	set_attribute (a_qry_id: INTEGER; an_attribute, a_value: STRING)
			-- Set attribute of a queryable (call save to write it to the database)
		require
			queryables.has (a_qry_id)
		do
			queryables.at (a_qry_id).put (a_value, an_attribute)
		end

feature -- Access

	queryables: HASH_TABLE [HASH_TABLE [STRING, STRING], INTEGER]
			-- Holds queryable attributs until saved

feature{SEMQ_DATABASE} -- MySQL Client

	cleanup_mysql
			-- Close statements
		do
			stmt_insert_hitbreakpoints.close
			stmt_find_uuid.close
			stmt_insert_queryable.close
		end

feature{NONE} -- Prepared Statements

	stmt_insert_hitbreakpoints: MYSQL_STMT
	stmt_find_uuid: MYSQL_STMT
	stmt_insert_queryable: MYSQL_STMT

end
