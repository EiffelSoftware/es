note
	description: "Summary description for {SCOOP_LIBRARY_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_LIBRARY_CONSTANTS

feature -- Access

	Profile_collector_buffer: INTEGER = 25
			-- Number of events to buffer before writing to disk
			-- (per processor)

	Profile_file_extension: STRING = "pfi"
			-- Extension for profile file

	Profile_log_extension: STRING = "log"
			-- Extension for log file

	Information_file_name: STRING = "scoop_profile_information"
			-- Information file name

	Information_file_extension: STRING = ""
			-- Extension for information file

	Profile_directory: STRING = "scoop_profile"
			-- Profile directory

	Eifgens_directory: STRING = "EIFGENs"
			-- EIFGENs directory

feature -- Matching

	Separate_features_infix: STRING = "_scoop_separate_"
			-- Infix of separate features

	Effective_features_prefix: STRING = "effective_"
			-- Prefix for effective features

end
