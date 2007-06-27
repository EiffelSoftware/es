indexing
	description: "Objects that are not observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	UNOBSERVED_CLASS
inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- Initialization
	make is
			-- Create an object of UNOBSERVED_CLASS
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="make" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			create file.make("input.txt")
			file.open_read
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Access
	is_observed: BOOLEAN is False

	read_literal_string: STRING is
			--
		do
			-- <methodbody_start name="read_literal_string" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("read_literal_string", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			Result := "literal string"
			Result.get_area.note_direct_manipulation (Result.get_area)
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	read_from_file: STRING is
		do
			-- <methodbody_start name="read_from_file" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("read_from_file", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			file.read_line
			Result := file.last_string
			-- This would belong to the FILE class:
			Result.get_area.note_direct_manipulation(Result.get_area)
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	file: KL_TEXT_INPUT_FILE

invariant
	invariant_clause: True -- Your invariant here

end
