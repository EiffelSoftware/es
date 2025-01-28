note
	description: "Example: copy a collection from one database to another"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
    make

feature -- Initialization

    make
            -- Initialize and run the database copy example
        local
            l_context: MONGODB_CONTEXT
            l_client: MONGODB_CLIENT
            l_source_db, l_target_db: MONGODB_DATABASE
            l_source_collection, l_target_collection: MONGODB_COLLECTION
            l_cursor: MONGODB_CURSOR
            l_bulk: MONGODB_BULK_OPERATION
            l_opts: BSON
            l_reply : BSON
            l_after: BOOLEAN
        do
            	-- Initialize MongoDB context
            create l_context
            l_context.start

            	-- Create MongoDB client
            create l_client.make ("mongodb://localhost:27017")

            	-- Get source and target databases
            l_source_db := l_client.database ("source_db")
            l_target_db := l_client.database ("target_db")

            	-- Get collections
            l_source_collection := l_source_db.collection ("test_collection")
            l_target_collection := l_target_db.collection ("test_collection")

            	-- Insert some test data into source collection
            insert_test_data (l_source_collection)

            	-- Create bulk operation for target collection with default options
            create l_opts.make
            l_bulk := l_target_collection.create_bulk_operation_with_opts (l_opts)

            	-- Read all documents from source collection
            create l_opts.make
            l_cursor := l_source_collection.find_with_opts (create {BSON}.make, l_opts, Void)

            	-- Copy documents to target collection
            from
                l_after := False
            until
                l_after
            loop
                if attached l_cursor.next as l_doc then
                    l_bulk.insert_with_opts (l_doc, Void)
                else
                    l_after := True
                end
            end

            	-- Execute bulk operation
            create l_reply.make
            l_bulk.execute (l_reply)

            l_context.finish
        end

feature {NONE} -- Implementation

    insert_test_data (a_collection: MONGODB_COLLECTION)
            -- Insert some test documents into the collection
        local
            l_document: BSON
            l_bulk: MONGODB_BULK_OPERATION
            l_opts: BSON
            l_reply: BSON
        do
            	-- Create bulk operation
            create l_opts.make
            l_bulk := a_collection.create_bulk_operation_with_opts (l_opts)

            	-- Create and insert first document
            create l_document.make
            l_document.bson_append_utf8 ("name", "John Doe")
            l_document.bson_append_integer_32 ("age", 30)
            l_bulk.insert_with_opts (l_document, Void)

            	-- Create and insert second document
            create l_document.make
            l_document.bson_append_utf8 ("name", "Jane Smith")
            l_document.bson_append_integer_32 ("age", 25)
            l_bulk.insert_with_opts (l_document, Void)

            	-- Create and insert third document
            create l_document.make
            l_document.bson_append_utf8 ("name", "Bob Johnson")
            l_document.bson_append_integer_32 ("age", 35)
            l_bulk.insert_with_opts (l_document, Void)

            	-- Execute bulk operation
            create l_reply.make
            l_bulk.execute (l_reply)
        end

end
