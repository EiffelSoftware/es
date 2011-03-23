-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:ValidityState"
class
	JS_VALIDITY_STATE

feature -- Basic Operation

	value_missing: BOOLEAN
			-- The control is suffering from being missing.
		external "C" alias "valueMissing" end

	type_mismatch: BOOLEAN
			-- The control is suffering from a type mismatch.
		external "C" alias "typeMismatch" end

	pattern_mismatch: BOOLEAN
			-- The control is suffering from a pattern mismatch.
		external "C" alias "patternMismatch" end

	too_long: BOOLEAN
			-- The control is suffering from being too long.
		external "C" alias "tooLong" end

	range_underflow: BOOLEAN
			-- The control is suffering from an underflow.
		external "C" alias "rangeUnderflow" end

	range_overflow: BOOLEAN
			-- The control is suffering from an overflow.
		external "C" alias "rangeOverflow" end

	step_mismatch: BOOLEAN
			-- The control is suffering from a step mismatch.
		external "C" alias "stepMismatch" end

	custom_error: BOOLEAN
			-- The control is suffering from a custom error.
		external "C" alias "customError" end

	valid: BOOLEAN
			-- None of the other conditions are true.
		external "C" alias "valid" end
end
