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

feature -- Basic operations
	call_string_8(string: STRING_8; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of STRING_8
		local
			make_arg1: INTEGER
			set_count_arg1: INTEGER
			resize_arg1: INTEGER
			a_character: CHARACTER
			ignore_result: ANY
		do
			if feature_name.is_equal("make") then
				make_arg1 ?= arguments @ 1
				program_flow_sink.leave
				string.make (make_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("set_count") then
				set_count_arg1 ?= arguments @ 1
				program_flow_sink.leave
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
				resize_arg1 ?= arguments @ 1
				program_flow_sink.leave
				string.resize (resize_arg1)
				program_flow_sink.enter
			elseif feature_name.is_equal("to_c") then
				program_flow_sink.leave
				ignore_result := string.to_c
				program_flow_sink.enter
			elseif feature_name.is_equal("get_area") then
				program_flow_sink.leave
				ignore_result := string.get_area
				program_flow_sink.enter
			elseif feature_name.is_equal("append_character") then
				a_character ?= arguments @ 1
				program_flow_sink.leave
				string.append_character (a_character)
				program_flow_sink.enter
			else
				report_and_set_feature_error(string, feature_name)
			end
		end

	call_special (special: SPECIAL [ANY]; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of SPECIAL-type
			-- note: XXX call to 'note_direct_manipulation' only works for specials that contain elements of character type.
		local
			special_char: SPECIAL [CHARACTER]
			message: STRING
		do

			if feature_name.is_equal("note_direct_manipulation") then
				special_char ?= arguments @ 1
				if special_char /= Void then
					program_flow_sink.leave
					special.note_direct_manipulation(special_char)
					program_flow_sink.enter
				else
					message := "feature {SPECIAL}.note_direct_manipulation only supported for calls that "
					message.append ("have a SPECIAL [CHAR] as argument.")
					report_and_set_error (message)
				end
			else
				report_and_set_feature_error(special, feature_name)
			end
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
