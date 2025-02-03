note
	description: "Example: show how to count documents "
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
			count_documents
		end

	count_documents
		local
			l_client: MONGODB_CLIENT
			l_filter: BSON
			l_collection: MONGODB_COLLECTION
			l_count: INTEGER_64
			l_reply: BSON
			driver: MONGODB_DRIVER
		do
			-- Initialize driver
			create driver
			driver.use
			create l_client.make ("mongodb://localhost:27017/?appname=count-example")
			l_collection := l_client.collection ("mydb", "mycoll")

				-- Create filter document
			create l_filter.make
			l_filter.bson_append_utf8 ("hello", "new eiffel")

				-- Use count_documents instead of deprecated count
			create l_reply.make
			l_count := l_collection.count_documents (l_filter, Void, Void, l_reply)
			if l_count < 0 then
				print ({STRING_32}"Error: " + if attached {MONGODB_ERROR} l_collection.last_error as le then le.message else {STRING_32}"Unknown" end + "%N")
			else
				print ("Number of documents:" + l_count.out)
			end
		end

end

