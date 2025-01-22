note
	description: "Example: show all documents in a collection"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			find_all_documents
		end

	find_all_documents
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_client.make ("mongodb://localhost:27017/?appname=find-all-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_query.make
			l_cursor := l_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					print (l_bson.bson_as_canonical_extended_json)
					print ("%N")
				else
					l_after := True
				end
			end
		end
end
