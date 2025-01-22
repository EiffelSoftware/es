note
	description: "Object to manage database operations"
	date: "$Date$"
	revision: "$Revision$"

class
	BOOKS_MANAGER

create
	make
feature {NONE} -- Implementation

	make (a_database: MONGODB_CLIENT)
		do
			mongodb_client := a_database
		end

feature -- Access

	mongodb_client: MONGODB_CLIENT

	mongodb_database: MONGODB_DATABASE
			-- Get a handle on the database.
		do
			 Result := mongodb_client.database (database_name)
		end

	mongodb_collection: MONGODB_COLLECTION
			-- Get a handle on the collection
		do
			Result := mongodb_client.collection (database_name, collection_name)
		end

	app_name: STRING = "books_restapi"

	database_name: STRING = "store"

	collection_name: STRING = "books"

feature -- Status Error

	has_error: BOOLEAN
			-- Indicates that there was an error during the last operation
		do
			Result := error /= Void
		end

	error_message: READABLE_STRING_32
		require
			has_error: has_error
		do
			if attached error as l_error then
				Result := l_error.message
			else
				Result := "Unknown error"
			end
		end

	error: detachable BSON_ERROR
			-- last error.

feature -- Access

	find_documents: JSON_ARRAY
			-- return a json array with all the files in the collection `books`.
		local
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_query.make
			l_cursor := mongodb_collection.find_with_opts (l_query, Void, Void)

			from
				create Result.make_empty
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					Result.extend (l_bson.bson_as_canonical_extended_json_value)
				else
					l_after := True
				end
			end
		end

	insert_document (a_book: BOOK)
			-- add the item `a_book' to the collection `books`.
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
		do
			reset
			create l_doc.make_from_json (a_book.to_json_string)
			mongodb_collection.insert_one (l_doc, Void, Void)
			if attached mongodb_collection.error as l_error then
				post_execution (l_error)
			end
		end

	find_document_by_id (a_id: STRING): detachable JSON_VALUE
			-- Return a json document by id `a_id', if any. from the collection `books'
		local
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_query.make
			l_query.bson_append_utf8 ("_id", a_id)
			l_cursor := mongodb_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					Result := l_bson.bson_as_canonical_extended_json_value
				else
					l_after := True
				end
			end
		end

	delete_by_id (a_id: STRING)
			--Delete an item by id `a_id', if any. from the collection `books'
		local
			l_doc: BSON
		do
			reset
			create l_doc.make
			l_doc.bson_append_utf8 ("_id", a_id)
			mongodb_collection.delete_one (l_doc, Void, Void)
			if attached mongodb_collection.error as l_error then
				post_execution (l_error)
			end
		end

	update_document (a_book: BOOK)
			-- Update document `a_book' in the collection `books'
		local
			l_query: BSON
			l_update: BSON
			l_subdoc: BSON
		do
			create l_query.make
			l_query.bson_append_utf8 ("_id", a_book.id.oid_to_string)
			create l_subdoc.make_from_json (a_book.to_json_string)
			create l_update.make
			l_update.bson_append_document ("$set", l_subdoc)

			mongodb_collection.update_one (l_query, l_update, Void, Void)
			if attached mongodb_collection.error as l_error then
				post_execution (l_error)
			end

		end


feature {NONE} -- Implementation

	reset
		do
			error := void
		end

	post_execution (a_error: BSON_ERROR)
			-- check if there was an error during the last execution
			-- and set the error `a_error' to error.
		do
			if mongodb_collection.has_error then
				create error.make_by_pointer (a_error.item)
			end
		end

	to_json_value (s: STRING): JSON_VALUE
		local
			p: JSON_PARSER
		do
			create p.make
			p.parse_string (s)
			if p.is_valid then
				Result := p.parsed_json_value
			end
			if Result = Void then
				create {JSON_NULL} Result
			end
		end
end
