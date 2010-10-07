note
	description: "Class that represents results from a query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_QUERY_RESULT

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create meta.make (20)
			meta.compare_objects

			create documents.make
		end

feature -- Access

	meta: HASH_TABLE [STRING, STRING]
			-- Table of meta data, such as query time, query status code
			-- Key is data name, value is data value

	documents: LINKED_LIST [IR_DOCUMENT]
			-- List of returned document, every document is a set of fields (name,value) pairs.
			-- The order of the documents is preserved from the raw query result
end
