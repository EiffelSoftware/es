note
	description: "Command to update property rankings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UPDATE_RANKING_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature -- Basic operations

	execute
			-- Execute current command
		do
			find_transitions
		end

feature{NONE} -- Implementation

	find_transitions
			-- Find transition ssql files.
		local
			l_finder: EPA_FILE_SEARCHER
		do
			create l_finder.make_with_pattern ("tran.+\.ssql")
			l_finder.file_found_actions.extend (agent on_file_found)
			l_finder.search (config.mysql_file_directory)
		end

	on_file_found (a_path: STRING; a_file_name: STRING)
			-- Action to be performed if `a_path' is found
		local
			l_loader: SEMQ_QUERYABLE_LOADER
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_expression: EPA_EXPRESSION
			l_anonymouse_form: STRING
			l_precondition: EPA_STATE
		do
			io.put_string ("Loading " + a_file_name + "%N")
			create l_loader
			l_loader.load (a_path)
			l_transition ?= l_loader.last_queryable
			l_precondition := l_transition.interface_preconditions
		end

end
