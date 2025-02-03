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
			insert_array
		end

	insert_array
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
			l_array: LIST [BSON]
			driver: MONGODB_DRIVER
		do
			create driver
			driver.use
			create l_client.make ("mongodb://localhost:27017/?appname=insert-array")
			l_collection := l_client.collection ("employess", "array")

			create {ARRAYED_LIST [BSON]} l_array.make (2)

			create l_doc.make_from_json (json_array)
			create l_oid.make (Void)
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "array2")
			l_array.force (l_doc)

			create l_doc.make_from_json (json_array2)
			create l_oid.make (Void)
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello2", "array2")
			l_array.force (l_doc)

			l_collection.insert_many (l_array, Void, Void)
		end




	json_array: STRING = "[
	[

		{
			"Employeeid" : 1,
			"EmployeeName" : "Smith"
		},
		{
			"Employeeid"   : 2,
			"EmployeeName" : "Mohan"
		},
		{
			"Employeeid"   : 3,
			"EmployeeName" : "Joe"
		}

	]
	]"

	json_array2: STRING = "[
	[

		{
			"Employeeid" : 4,
			"EmployeeName" : "Smith"
		},
		{
			"Employeeid"   : 5,
			"EmployeeName" : "Mohan"
		},
		{
			"Employeeid"   : 6,
			"EmployeeName" : "Joe"
		}

	]
	]"


end

