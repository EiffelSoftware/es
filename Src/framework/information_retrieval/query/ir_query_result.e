note
	description: "Class that represents results from a query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_QUERY_RESULT

inherit
	DEBUG_OUTPUT

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

	text: STRING
			-- Text representation of Current		
		do
			create Result.make (2048)

				-- Append meta data.
			Result.append (once "Meta:%N")
			across meta as l_meta loop
				Result.append_character ('%T')
				Result.append (l_meta.key)
				Result.append (once " == ")
				Result.append (l_meta.item)
				Result.append_character ('%N')
			end

				-- Append document data.
			Result.append (once "Documents:%N")
			across documents as l_documents loop
				Result.append (once "---------------------------%N")
				Result.append (l_documents.item.text)
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Basic opertions

	extend_document (a_document: IR_DOCUMENT)
			-- Extend `a_document' at the end of `documents'.
		do
			documents.extend (a_document)
		end

end
