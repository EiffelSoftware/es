note
	description: "[
		Class representing results from a query to the search engine
		This class supports results from either SOLR or Lucene.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERY_RESULT

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

	documents: LINKED_LIST [SEM_DOCUMENT]
			-- List of returned document, every document is a set of fields (name,value) pairs.
			-- The order of the documents is preserved from the raw query result
end
