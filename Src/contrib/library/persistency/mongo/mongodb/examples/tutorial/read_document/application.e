note
	description: "Example: show how to read a document"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			read_document
		end

	read_document
    	local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
			driver: MONGODB_DRIVER
		do
			create driver
            driver.use
			
			create l_client.make ("mongodb://localhost:27017/?appname=find-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_query.make
			l_query.bson_append_utf8 ("hello", "new eiffel")
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
