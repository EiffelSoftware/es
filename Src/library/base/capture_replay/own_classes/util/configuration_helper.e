indexing
	description: "Objects that help to configure the capture/replay environment"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURATION_HELPER

inherit
	PROGRAM_FLOW_SINK_VISITOR

create
	make

feature --initialization
	make(a_caller: CALLER) is
			--  create a configuration helper.
		do
			capture_file_name := "run.log"
			replay_log_file_name := "replay_run.log"
			caller := a_caller
		end


feature -- Access

	capture_file_name: STRING

	replay_log_file_name: STRING

	caller: CALLER

feature -- Status setting

	set_capture_file_name(file_name: STRING) is
			-- changes the capture_file_name to use for setting up
			-- the PROGRAM_FLOW_SINK.
		require
			file_name_not_void: file_name /= Void
		do
			capture_file_name := file_name
		end

	set_replay_log_file_name(file_name: STRING) is
			-- changes the replay log filename for the setup
			-- of the PROGRAM_FLOW_SINK
		require
			file_name_not_void: file_name /= Void
		do
			replay_log_file_name := file_name
		end

	set_caller(a_caller: CALLER) is
			-- set the caller for the setup of the PLAYER.
		require
			a_caller_not_void: a_caller /= Void
		do
			caller := a_caller
		end

feature -- Measurement

feature -- Basic operations

	configure_program_flow_sink(sink: PROGRAM_FLOW_SINK) is
			-- Start configuration of `sink' with the current
			-- values.
			-- Note: currently, configuration is only working for
			-- configuring each sink once.
		do
			sink.accept(Current)
		end


	visit_null_sink(null_sink: NULL_PROGRAM_FLOW_SINK) is
			--
		do
			--nothing to configure
		end

	visit_recorder(recorder: RECORDER) is
			--
		do
			recorder.setup_on_text_serializer (capture_file_name)
		end

	visit_player(player: PLAYER) is
			--
		do
			player.setup_on_text_file (capture_file_name, caller)
		end

	visit_logging_player(logging_player: LOGGING_PLAYER) is
			--
		do
			logging_player.setup_on_text_files (capture_file_name, replay_log_file_name, caller)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	caller_not_void: caller /= Void
	capture_filename_not_void: 	capture_file_name /= Void
	replay_log_file_name_not_void: replay_log_file_name /= Void

end
