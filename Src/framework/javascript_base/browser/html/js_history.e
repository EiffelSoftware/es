-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:History"
class
	JS_HISTORY

feature -- Basic Operation

	length: INTEGER
			-- Returns the number of entries in the joint session history.
		external "C" alias "length" end

	go (a_delta: INTEGER)
			-- Goes back or forward the specified number of steps in the joint session
			-- history. A zero delta will reload the current page. If the delta is out of
			-- range, does nothing.
		external "C" alias "go($a_delta)" end

	back
			-- Goes back one step in the joint session history. If there is no previous
			-- page, does nothing.
		external "C" alias "back()" end

	forward
			-- Goes forward one step in the joint session history. If there is no next
			-- page, does nothing.
		external "C" alias "forward()" end

	push_state (a_data: ANY; a_title: STRING; a_url: STRING)
			-- Pushes the given data onto the session history, with the given title, and,
			-- if provided, the given URL.
		external "C" alias "pushState($a_data, $a_title, $a_url)" end

	replace_state (a_data: ANY; a_title: STRING; a_url: STRING)
			-- Updates the current entry in the session history to have the given data,
			-- title, and, if provided, URL.
		external "C" alias "replaceState($a_data, $a_title, $a_url)" end
end
