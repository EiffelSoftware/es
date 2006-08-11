indexing
	description:
		"Eiffel Vision textable. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_TEXTABLE_IMP

inherit
	EV_TEXTABLE_I
		redefine
			interface
		end

	EV_ANY_IMP
		undefine
			needs_event_box,
			destroy
		redefine
			interface
		end
	CFSTRING_FUNCTIONS_EXTERNAL
	CONTROLS_FUNCTIONS_EXTERNAL

feature {NONE} -- Initialization

	textable_imp_initialize is
			-- Create a GtkLabel to display the text.
		do
		end

feature -- Access

	text: STRING_32 is
			-- Text of the label.
		do
			--hiview_copy_text_external() ?
		end

	text_alignment: INTEGER is
			-- Alignment of the text in the label.
		do
		end

feature -- Status setting

	align_text_center is
			-- Display `text' centered.
		do
		end

	align_text_left is
			-- Display `text' left aligned.
		do
		end

	align_text_right is
			-- Display `text' right aligned.
		do
		end

feature -- Element change	

	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		local
			c_str: C_STRING
			ptr: POINTER
			res: INTEGER
		do

			create c_str.make (a_text)
			ptr:=c_string_to_cfstring_ptr(c_str)
			res:=set_control_title_with_cfstring_external (c_object, ptr)
		end

	c_string_to_cfstring_ptr(c_str: C_STRING):POINTER is
			local
				null_ptr:POINTER
			do
				Result:= cfstring_create_with_cstring_external(null_ptr, c_str.item,  kCFStringEncodingASCII)
			end

	frozen kCFStringEncodingASCII: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCFStringEncodingASCII"
	end



feature {EV_ANY_IMP} -- Implementation

	text_label: POINTER
			-- GtkLabel containing `text'.

	accelerators_enabled: BOOLEAN is
			-- Does `Current' have keyboard accelerators enabled?
		do
		end

	real_text: EV_GTK_C_STRING
			-- Internal `text'. (with ampersands)

	filter_ampersand (s: STRING_32; char: CHARACTER) is
			-- Replace occurrences of '&' from `s'  by `char' and
			-- replace occurrences of "&&" with '&'.
		require
			s_not_void: s /= Void
			s_has_at_least_one_ampersand: s.occurrences ('&') > 0
		do
		end

	u_lined_filter (s: STRING_GENERAL): STRING_32 is
			-- Copy of `s' with underscores instead of ampersands.
			-- (If `s' does not contain ampersands, return `s'.)
		require
			s_not_void: s /= Void
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_TEXTABLE

invariant
	text_label_not_void: is_usable implies text_label /= NULL

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




end -- class EV_TEXTABLE_IMP

