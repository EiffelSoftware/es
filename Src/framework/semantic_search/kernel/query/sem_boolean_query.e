note
	description: "A query which contains a set of term queries"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BOOLEAN_QUERY

inherit
	SEM_QUERY

create
	make

feature{NONE} -- Initialization

	make (a_config: SEM_QUERY_CONFIG)
			-- Initialize `config' with `a_config'.
		do
			config := a_config
		end

feature -- Access

	config: SEM_QUERY_CONFIG
			-- Config from which current query is generated

feature -- Process

	process (a_visitor: SEM_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_boolean_query (Current)
		end

end
