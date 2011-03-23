-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:TimeRanges"
class
	JS_TIME_RANGES

feature -- Basic Operation

	length: INTEGER
			-- Returns the number of ranges in the object.
		external "C" alias "length" end

	start (a_index: INTEGER): REAL
			-- Returns the time for the start of the range with the given index. Throws an
			-- INDEX_SIZE_ERR if the index is out of range.
		external "C" alias "start($a_index)" end

	js_end (a_index: INTEGER): REAL
			-- Returns the time for the end of the range with the given index. Throws an
			-- INDEX_SIZE_ERR if the index is out of range.
		external "C" alias "end($a_index)" end
end
