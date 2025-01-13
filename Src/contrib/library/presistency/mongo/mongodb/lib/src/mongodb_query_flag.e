note
	description: "Object representing Flags for query operations"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=", "src=http://mongoc.org/libmongoc/current/mongoc_query_flags_t.html", "protocol=uri"


class
	MONGODB_QUERY_FLAG

feature -- Access

	MONGOC_QUERY_NONE: INTEGER
			-- Specify no query flags.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_none
		end

	MONGOC_QUERY_TAILABLE_CURSOR: INTEGER
			-- Cursor will not be closed when the last data is retrieved. You can resume this cursor later.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_tailable_cursor
		end

	MONGOC_QUERY_SLAVE_OK: INTEGER
			-- Allow query of replica set secondaries.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_slave_ok
		end

	MONGOC_QUERY_OPLOG_REPLAY: INTEGER
			-- Used internally by MongoDB.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_oplog_replay
		end

	MONGOC_QUERY_NO_CURSOR_TIMEOUT: INTEGER
			-- The server normally times out an idle cursor after an inactivity period (10 minutes). This prevents that.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_no_cursor_timeout
		end

	MONGOC_QUERY_AWAIT_DATA: INTEGER
			-- Use with MONGOC_QUERY_TAILABLE_CURSOR. Block rather than returning no data. After a period, time out.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_await_data
		end

	MONGOC_QUERY_EXHAUST: INTEGER
			-- Stream the data down full blast in multiple “reply” packets. Faster when you are pulling down a lot of data and you know you want to retrieve it all.
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_exhaust
		end

	MONGOC_QUERY_PARTIAL: INTEGER
			-- Get partial results from mongos if some shards are down (instead of throwing an error).
		do
			Result := {MONGODB_EXTERNALS}.mongoc_query_partial
		end

feature --Query

	is_valid_flag (a_value: INTEGER): BOOLEAN
			-- is value `a_value' a valid flag?
		do
			if a_value = mongoc_query_none then
				Result := True
			elseif a_value = mongoc_query_tailable_cursor then
				Result := True
			elseif a_value = mongoc_query_slave_ok then
				Result := True
			elseif a_value = mongoc_query_oplog_replay then
				Result := True
			elseif a_value = mongoc_query_no_cursor_timeout then
				Result := True
			elseif a_value = mongoc_query_await_data then
				Result := True
			elseif a_value = mongoc_query_exhaust then
				Result := True
			elseif a_value = mongoc_query_partial then
				Result := True
			else
				Result := False
			end
		end

end
