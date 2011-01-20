note
	description: "Command to add queryables to MySQL database and performance maintenance tasks"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_ADD_DOCUMENT_TO_MYSQL_CMD

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
		local
			importer: SEMQ_DATABASE_IMPORTER
			maintenance: SEMQ_DATABASE_MAINTENANCE
			example: MYSQL_EXAMPLE
		do
			-- Empty tables
			if false then
				create maintenance.make(config)
				maintenance.empty_tables
			end

			-- Import SSQL files
			if config.input /= Void then
				create importer.make(config)
				importer.execute
			end

			-- Rebuild conformances
			if false then
				create maintenance.make(config)
				maintenance.rebuilds_conformances
			end
		end

end
