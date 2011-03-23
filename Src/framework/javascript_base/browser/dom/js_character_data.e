-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:CharacterData"
class
	JS_CHARACTER_DATA

inherit
	JS_NODE

feature -- Basic Operation

	data: STRING assign set_data
			-- The character data of the node that implements this interface. The DOM
			-- implementation may not put arbitrary limits on the amount of data that may
			-- be stored in a CharacterData node. However, implementation limits may mean
			-- that the entirety of a node's data may not fit into a single DOMString. In
			-- such cases, the user may call substringData to retrieve the data in
			-- appropriately sized pieces.
		external "C" alias "data" end

	set_data (a_data: STRING)
			-- See data
		external "C" alias "data=$a_data" end

	length: INTEGER
			-- The number of 16-bit units that are available through data and the
			-- substringData method below. This may have the value zero, i.e.,
			-- CharacterData nodes may be empty.
		external "C" alias "length" end

	substring_data (a_offset: INTEGER; a_count: INTEGER): STRING
			-- Extracts a range of data from the node.
		external "C" alias "substringData($a_offset, $a_count)" end

	append_data (a_arg: STRING)
			-- Append the string to the end of the character data of the node. Upon
			-- success, data provides access to the concatenation of data and the DOMString
			-- specified.
		external "C" alias "appendData($a_arg)" end

	insert_data (a_offset: INTEGER; a_arg: STRING)
			-- Insert a string at the specified 16-bit unit offset.
		external "C" alias "insertData($a_offset, $a_arg)" end

	delete_data (a_offset: INTEGER; a_count: INTEGER)
			-- Remove a range of 16-bit units from the node. Upon success, data and length
			-- reflect the change.
		external "C" alias "deleteData($a_offset, $a_count)" end

	replace_data (a_offset: INTEGER; a_count: INTEGER; a_arg: STRING)
			-- Replace the characters starting at the specified 16-bit unit offset with the
			-- specified string.
		external "C" alias "replaceData($a_offset, $a_count, $a_arg)" end
end
