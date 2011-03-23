-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:DOMTokenList"
class
	JS_DOM_TOKEN_LIST

feature -- Basic Operation

	length: INTEGER
			-- Returns the number of tokens in the string.
		external "C" alias "length" end

	item alias "[]" (a_index: INTEGER): STRING
			-- Returns the token with index index. The tokens are returned in the order
			-- they are found in the underlying string. Returns null if index is out of
			-- range.
		external "C" alias "item($a_index)" end

	contains (a_token: STRING): BOOLEAN
			-- Returns true if the token is present; false otherwise.
		external "C" alias "contains($a_token)" end

	add (a_token: STRING)
			-- Adds token, unless it is already present.
		external "C" alias "add($a_token)" end

	remove (a_token: STRING)
			-- Removes token if it is present.
		external "C" alias "remove($a_token)" end

	toggle (a_token: STRING): BOOLEAN
			-- Adds token if it is not present, or removes it if it is. Returns true if
			-- token is now present (it was added); returns false if it is not (it was
			-- removed).
		external "C" alias "toggle($a_token)" end

feature -- stringifier DOMString ();
end
