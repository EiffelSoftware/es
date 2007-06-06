indexing
	description: "Partial CALLER implementation for the base library."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASE_CALLER

inherit
	CALLER

	STRING_HANDLER --necessary to call {STRING}.set_count

feature -- Access

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
	call_string_8(string: STRING_8; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of STRING_8
		local
			make_arg1: INTEGER
			set_count_arg1: INTEGER
			resize_arg1: INTEGER
			ignore_result: ANY
		do
			if feature_name.is_equal("make") then
				program_flow_sink.leave
				make_arg1 ?= arguments @ 1
				string.make (make_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("set_count") then
				program_flow_sink.leave
				set_count_arg1 ?= arguments @ 1
				string.set_count(set_count_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("out") then
				program_flow_sink.leave
				ignore_result := string.out
				program_flow_sink.enter
			elseif feature_name.is_equal("capacity") then
				program_flow_sink.leave
				ignore_result := string.capacity
				program_flow_sink.enter
			elseif feature_name.is_equal("resize") then
				program_flow_sink.leave
				resize_arg1 ?= arguments @ 1
				string.resize (resize_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("to_c") then
				program_flow_sink.leave
				ignore_result := string.to_c
				program_flow_sink.enter
			else
				report_and_set_feature_error(string, feature_name)
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
