indexing
	description:
		"Eiffel Vision frame. Carbon implementation"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FRAME_IMP

inherit
	EV_FRAME_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CELL_IMP
		undefine
			make
		redefine
			interface,
			initialize
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			initialize
		end

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is True

	make (an_interface: like interface) is
			-- Create frame.
		do
			base_make (an_interface)
			set_c_object ($current)
		end

	initialize is
			-- Initialize `Current'.
		do
		--	set_style (Ev_frame_etched_in)
			align_text_left
			Precursor {EV_CELL_IMP}
		end

feature -- Access

	style: INTEGER is
			-- Visual appearance. See: EV_FRAME_CONSTANTS.
		do
			Result := {EV_FRAME_CONSTANTS}.Ev_frame_etched_in
		end

feature -- Element change

	set_style (a_style: INTEGER) is
			-- Assign `a_style' to `style'.
		do
		end

feature -- Status setting

	align_text_left is
			-- Display `text' left aligned.
		do
		end

	align_text_right is
			-- Display `text' right aligned.
		do
		end

	align_text_center is
			-- Display `text' centered.
		do
		end

feature -- Access

	text_alignment: INTEGER is
			-- Alignment of the text in the label.
		do

		end

	text: STRING_32 is
			-- Text of the frame
		do
			if internal_text = Void then
				internal_text := ""
			end
			Result := internal_text.twin
		end

feature -- Element change

	set_text (a_text: STRING_GENERAL) is
			-- set the `text' of the frame
		local
			a_cs: EV_CARBON_CF_STRING
		do
			internal_text := a_text.twin
			create a_cs.make_unshared_with_eiffel_string (a_text)
		--	{EV_GTK_EXTERNALS}.gtk_frame_set_label (container_widget, a_cs.item)
		end

feature {NONE} -- Implementation

	internal_text: STRING_32
		-- Text used to represent frame's label text

	internal_alignment_code: INTEGER
		-- Code used to represent label alignment

feature {EV_ANY_I} -- Implementation

	interface: EV_FRAME;
			-- Provides a common user interface to possibly platform
			-- dependent functionality implemented by `Current'

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




end -- class EV_FRAME_IMP

