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
		end

end
