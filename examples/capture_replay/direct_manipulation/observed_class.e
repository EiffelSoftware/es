indexing
	description: "Objects that are observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	OBSERVED_CLASS

inherit

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
	check_literal_string_from_unobserved is
			-- Test a literal string received from an unobserved object.
		local
			string: STRING
			ignored_result: ANY
		do
			-- <methodbody_start name="check_literal_string_from_unobserved" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("check_literal_string_from_unobserved", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			string := unobserved_object.read_literal_string
			if not string.is_equal ("literal string") then
				exceptions.raise ("literal string from UNOBSERVED_CLASS incorrect")
			end
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignored_result := program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

	check_string_from_file is
			-- test reading of a string from a file through an unobserved object.
		local
			string: STRING
			ignored_result: ANY
		do
			-- <methodbody_start name="check_string_from_file" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("check_string_from_file", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			string := unobserved_object.read_from_file
			if not string.is_equal ("this is a line from the input file.") then
				exceptions.raise("string from file (via UNOBSERVED_CLASS) incorrect.")
			end
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignored_result := program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	unobserved_object: UNOBSERVED_CLASS

	exceptions: EXCEPTIONS is
	 once
	 	create Result
	 end

invariant
	invariant_clause: True -- Your invariant here

end
