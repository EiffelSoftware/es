note
	description: "Library constants."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_LIBRARY_CONSTANTS

feature -- Access

	Enable_profiler: BOOLEAN = True
			-- Whether to enable the profiler

	Enable_log: BOOLEAN = False
			-- Whether to enable log files

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

-- SCOOP REPLAY

	REPLAY_directory_name: STRING = "scoop_replay"
			-- Replay directory.

	REPLAY_file_extension: STRING = "sls"
			-- Extension for replay file.

	REPLAY_diagram_file_extension: STRING = "dot"
			-- Extension for diagram file.

	REPLAY_file_header: STRING = "scoop_replay_file"
			-- Header that every replay file has to contain at the beginning.

	REPLAY_command_line_argument_beginning: STRING = "-REC_REP"
			-- Left bound of replay command line arguments.

	REPLAY_command_line_argument_end: STRING = "+REC_REP"
			-- Right bound of replay command line arguments.

	REPLAY_command_line_argument_record: STRING = "RECORD"
			-- Replay command line argument that activates record mode.

	REPLAY_command_line_argument_replay: STRING = "REPLAY"
			-- Replay command line argument that activates replay mode.

	REPLAY_command_line_argument_diagram: STRING = "DIAGRAM"
			-- Replay command line argument that activates diagram generation mode.

	REPLAY_command_line_argument_verbose_info: STRING = "VERBOSE_INFO"
			-- Replay command line argument that activates verbose replay information output.

-- SCOOP REPLAY	end

	default_feature_name: STRING = "Feature"

	default_class_name: STRING = "Class"


feature -- Matching

	Separate_features_infix: STRING = "_scoop_separate_"
			-- Infix of separate features

	Effective_features_prefix: STRING = "effective_"
			-- Prefix for effective features

end
