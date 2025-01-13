note
	description: "Example: show how to delete a document."
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
			delete_document
		end

	delete_document
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
			l_error: BSON_ERROR
		do
			create l_client.make ("mongodb://localhost:27017/?appname=delete-example")
			l_collection := l_client.collection ("test", "test")
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "world")

                -- insert a document
			l_collection.insert_one (l_doc, Void, Void)

                -- delete the document.
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_collection.delete_one (l_doc, Void, Void)
		end
end
