note
	description: "[
		{PS_RDB_MANAGER} objects handle a relational database connection and operations.
		This class will be needed if the serialization mechanism has to be unified with the relational access
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RDB_MANAGER

inherit {NONE}

	REFACTORING_HELPER

	PS_LIB_UTILS

create
	connect_with_odbc

feature {NONE} -- Initialization

	connect_with_odbc (dsn, user, pw: STRING)
			-- Connect to the desired database_using a dataset name `dsn', `user' and a password `pw'.
		require
			dsn_exists: not dsn.is_empty
		do
			create retrieved_items.make (Default_dimension)
				--		create {PS_ONE_TO_ONE_MAPPER} mapper.make (a_class_name, a_table_name: STRING_8)
			create db_manager
			db_manager.set_data_source (dsn)
			db_manager.login (user, pw)
			if db_manager.is_logged_to_base then
				db_manager.set_base
				create db_session_control.make
				db_session_control.connect
				if db_session_control.is_connected then
					print ("%NReady to start a db session.")
				else
					print ("%NSomething went wrong while establishing a connection with the database.")
					print ("%NThis may happen if the data source name, userid or password are wrong, or the database is offline")
				end
			else
				print ("%NDidn't manage to login to the database.")
			end
		end

feature -- Status setting.
			--	set_mapper (a_mapper: PS_MAPPER)
			-- Set `a_mapper'.
			--		do
			--			mapper := a_mapper
			--		ensure
			--			mapper_set: mapper = a_mapper
			--		end

feature -- Access
			--	format: PS_FORMAT
			-- The format used for serialization.
			--	medium: IO_MEDIUM
			-- The medium used for serialization.
			--	mapper: PS_MAPPER
			-- The mapper to and from a relational db.

	retrieved_items: ARRAYED_LIST [detachable ANY]
			-- Object(s) retrieved.

	objects_stored_count: INTEGER
			-- Number of objects stored in the same file.

	last_store_successful: BOOLEAN
			-- Was last store operation successful?
			--	last_retrieval_information: STRING
			-- Information on last retrieval.

feature -- Basic operations

	store (an_object: detachable ANY)
			--	Store an_object. Replace it if invoked twice on the same medium.
		require
			object_exists: an_object /= Void
		do
			to_implement ("Complete integration")
		ensure
			object_stored_correctly: last_store_successful
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.
		require
			object_exists: an_object /= Void
		do
			to_implement ("Complete integration")
		ensure
			object_stored_correctly: last_store_successful
		end

	retrieve
			-- Retrieve an object. Update `retrieved_items'.
		do
			to_implement ("Complete integration")
		ensure
			retrieved_items_exists: retrieved_items /= Void
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		do
			to_implement ("Complete integration")
		ensure
			retrieved_items_exists: retrieved_items /= Void
		end

	disconnect
			-- Close connection to the database.
		do
			db_session_control.disconnect
		end

feature {NONE} -- Implementation

	db_session_control: detachable DB_CONTROL
			-- Database session controller.	

	db_manager: DATABASE_APPL [ODBC]
			-- Manager of all db operations.

feature -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
