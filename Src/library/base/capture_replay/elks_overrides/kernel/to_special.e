indexing
	description: "References to special objects, for direct access to arrays and strings"
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TO_SPECIAL [T]

create
	make_area

feature -- Access

	area: SPECIAL [T]
			-- Special data zone

feature {NONE} -- Initialization

	make_area (n: INTEGER) is
			-- Creates a special object for `n' entries.
		require
			non_negative_argument: n >= 0
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="make_area" args="[n]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make_area", Current, [n])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			create area.make (n)
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		ensure
			area_allocated: area /= Void and then area.count = n
		end

feature -- Access

	item alias "[]", infix "@" (i: INTEGER): T assign put is
			-- Entry at index `i', if in index interval
		require
			valid_index: valid_index (i)
		do
			-- <methodbody_start name="item" args="[i]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("item", Current, [i])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			Result := area.item (i)
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' within the bounds of Current?
		do
			-- <methodbody_start name="valid_index" args="[i]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("valid_index", Current, [i])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			Result := (0 <= i) and then (i < area.count)
			-- <methodbody_end return_value="True">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				Result ?= program_flow_sink.put_feature_exit(Result)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature -- Element change

	put (v: T; i: INTEGER) is
			-- Replace `i'-th entry, if in index interval, by `v'.
		require
			valid_index: valid_index (i)
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="put" args="[v,i]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("put", Current, [v,i])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			area.put (v, i)
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		ensure
			inserted: item (i) = v
		end

feature -- Capture/Replay

	memory_copy(other: SPECIAL[T]) is
			--
		local
			ignore_result: ANY
		do
			--call instrumentation..
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				manifest_wrapper.set_item(other)
				program_flow_sink.put_feature_invocation("memory_copy", Current, [manifest_wrapper])
				program_flow_sink.leave
			end

			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result := program_flow_sink.put_feature_exit (Void)
				program_flow_sink.leave
			end
			--call instrumentation end
		end

feature {NONE} -- Element change

	manifest_wrapper: MANIFEST_SPECIAL is
			-- the standard instance of the special to basic wrapper
		once
			create Result
		end

	set_area (other: like area) is
			-- Make `other' the new `area'
		local
			ignore_result: ANY
		do
			-- <methodbody_start name="set_area" args="[other]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("set_area", Current, [other])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
			area := other
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

end
