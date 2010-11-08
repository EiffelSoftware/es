note
	description: "Query which can retrieve a whole document based on its document uuid"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_WHOLE_DOCUMENT_QUERY [G -> SEM_QUERYABLE]

inherit
	SEMQ_QUERY [G]

create
	make

feature{NONE} -- Initialization

	make (a_uuid: STRING)
			-- Initialize `uuid' with `a_uuid'.
		do
			uuid := a_uuid.twin
		end

feature -- Access

	uuid: STRING
			-- UUID of the document to retrieve

feature -- Process

	process (a_visitor: SEMQ_QUERY_VISITOR [G])
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_whole_document_query (Current)
		end

end
