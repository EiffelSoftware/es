indexing
	description: "Objects that are observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	OBSERVED_CLASS

inherit
	OBSERVABLE

create
	make

feature -- Initialization

	make is
			-- create an observed object.
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
			create unobserved_object.make
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end


feature -- Basic operations
	is_literal_string_correct: BOOLEAN is
			-- test a literal string received from an unobserved object.
		local
			string: STRING
		do
			-- <methodbody_start name="is_literal_string_correct" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("is_literal_string_correct", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			string := unobserved_object.read_literal_string
			Result := string.is_equal ("literal string")
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	is_string_from_file_correct: BOOLEAN is
			-- test reading of a string from a file through an unobserved object.
		local
			string: STRING
		do
			-- <methodbody_start name="is_string_from_file_correct" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("is_string_from_file_correct", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			string := unobserved_object.read_from_file
			Result := string.is_equal ("this is a line from the input file.")
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	unobserved_object: UNOBSERVED_CLASS

invariant
	invariant_clause: True -- Your invariant here

end
