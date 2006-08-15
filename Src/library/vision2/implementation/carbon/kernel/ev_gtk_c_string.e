indexing
	description: "A low-level string class to solve some garbage collector problems (mainly objects moving around) when interfacing with C APIs"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_GTK_C_STRING

inherit
	DISPOSABLE
	CFSTRING_FUNCTIONS_EXTERNAL

create
	set_with_eiffel_string, share_from_pointer, make_from_pointer

convert
	set_with_eiffel_string ({STRING_GENERAL, STRING, STRING_32})

feature {NONE} -- Initialization

	make_from_pointer (a_utf8_ptr: POINTER) is
			-- Set `item' to `a_utf8_ptr' and gain ownership of memory.
		require
			a_utf8_ptr_not_null: a_utf8_ptr /= default_pointer
		do
			item := a_utf8_ptr
		end

feature -- Access

	is_shared: BOOLEAN
		-- Is `item' shared with gtk?

	item: POINTER
			-- Pointer to the UTF8 string.

	string: STRING_32 is
			-- Locale string representation of the UTF8 string
		do
			Result := c_str.string.as_string_32
		ensure
			not_void: Result /= void
		end

	string_length: INTEGER
			-- Length of string data held in `managed_data'

	set_with_eiffel_string (a_string: STRING_GENERAL) is
			-- Create `item' and retain ownership.
		require
			a_string_not_void: a_string /= Void
		local
			res: INTEGER
		do
			create c_str.make (a_string)
			item := c_string_to_cfstring_ptr (c_str)
		ensure
			string_set: string.is_equal (a_string)
		end

	share_with_eiffel_string (a_string: STRING_GENERAL) is
			-- Create `item' but do not take ownership.
		require
			a_string_not_void: a_string /= Void
		do
		ensure
			string_set: string.is_equal (a_string)
		end

	share_from_pointer (a_utf8_ptr: POINTER) is
			-- Set `Current' to use `a_utf8_ptr'.
			-- `a_utf8_ptr' is not owned by `Current' as it isn't copied so do not free from outside.
		require
			a_utf8_ptr_not_null: a_utf8_ptr /= default_pointer
		do
		end

feature {NONE} -- Implementation

	c_str: C_STRING

	c_string_to_cfstring_ptr(a_str: C_STRING):POINTER is
			local
				null_ptr:POINTER
			do
				Result:= cfstring_create_with_cstring_external(null_ptr, a_str.item,  kCFStringEncodingASCII)
			end

	frozen kCFStringEncodingASCII: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCFStringEncodingASCII"
	end

	shared_pointer_helper: MANAGED_POINTER is
			-- Reusable Managed Pointer for UTF8 pointer manipulations.
		once
		end

	internal_set_with_eiffel_string (a_string: STRING_GENERAL; a_shared: BOOLEAN) is
			-- Create a UTF8 string from Eiffel String `a_string'
		require
			a_string_not_void: a_string /= Void
		do
		end

	set_from_pointer (a_ptr: POINTER; a_size: INTEGER; a_shared: BOOLEAN) is
			--  Set `item' to use `a_ptr'.
		require
			a_ptr_not_null: a_ptr /= default_pointer
			size_valid: a_size > 0
		do
			item := a_ptr
			string_length := a_size
			is_shared := a_shared
		end

	dispose is
			-- Dispose `Current'.
		do
		end

feature {NONE} -- Externals

	c_strlen (ptr: POINTER): INTEGER is
		do
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_GTK_C_STRING

