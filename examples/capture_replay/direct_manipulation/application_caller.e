indexing
	description: "CALLER implementation for the 'direct manipulation' example"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_CALLER

inherit
	BASE_CALLER

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

	call (target: ANY; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features on BANK or BANK_ACCOUNT
		local
			observed: OBSERVED_CLASS
			string: STRING_8
			special: SPECIAL [ANY]
			string_routines: KL_STRING_ROUTINES
		do
			-- Discriminate by target type first, to speed things up.
			if target.generating_type.is_equal("OBSERVED_CLASS") then
				observed ?= target
				call_observed(observed, feature_name, arguments)
			elseif target.generating_type.is_equal("STRING_8") then
				string ?= target
				call_string_8 (string, feature_name, arguments)
			elseif target.generating_type.substring_index ("SPECIAL", 1)=1 then
				special ?= target
				call_special (special, feature_name, arguments)
			elseif target.generating_type.is_equal ("KL_STRING_ROUTINES") then
				string_routines ?= target
				call_string_routines (string_routines, feature_name, arguments)
			else
				report_and_set_type_error(target)
			end
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

		call_observed(observed: OBSERVED_CLASS; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of UNOBSERVED_CLASS
		do
			if feature_name.is_equal("make") then
				program_flow_sink.leave
				observed.make
				program_flow_sink.enter
			elseif feature_name.is_equal ("check_literal_string_from_unobserved") then
				program_flow_sink.leave
				observed.check_literal_string_from_unobserved
				program_flow_sink.enter
			elseif feature_name.is_equal ("check_string_from_file") then
				program_flow_sink.leave
				observed.check_string_from_file
				program_flow_sink.enter
			else
				report_and_set_feature_error (observed, feature_name)
			end
		end

		call_string_routines (string_routines: KL_STRING_ROUTINES; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call features of UNOBSERVED_CLASS
		local
			string_argument: STRING
			ignored_result: ANY
		do
			if feature_name.is_equal("as_string") then
				string_argument ?= arguments @ 1
				program_flow_sink.leave
				ignored_result := string_routines.as_string (string_argument)
				program_flow_sink.enter
			else
				report_and_set_feature_error (string_routines, feature_name)
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
