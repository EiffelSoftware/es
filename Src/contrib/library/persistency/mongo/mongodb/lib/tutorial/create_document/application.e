note
	description: "Example: show how to create/insert a document."
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
			create_document
		end

	create_document
		note
			EIS: "name=Insert a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#basic-crud-operations", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
			l_error: BSON_ERROR
		do
			create l_client.make ("mongodb://localhost:27017/?appname=insert-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_doc.make
			create l_oid.make (Void)
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "new eiffel")

			create l_error.make
			l_collection.insert_one (l_doc, Void, Void)
		end

end
