indexing
	description:
		"EiffelVision2 Toolbar button,%
		%a specific button that goes in a tool-bar."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_BUTTON_IMP

inherit
	EV_TOOL_BAR_BUTTON_I
		export
			{EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} select_actions_internal
		redefine
			interface
		end

	EV_ITEM_IMP
		redefine
			interface,
			initialize,
			event_widget,
			set_pixmap,
			needs_event_box
		end

	EV_DOCKABLE_SOURCE_IMP
		redefine
			interface
		end

	EV_SENSITIVE_IMP
		redefine
			interface,
			enable_sensitive
		end

	EV_TOOLTIPABLE_IMP
		undefine
			visual_widget
		redefine
			interface,
			set_tooltip,
			tooltip
		end

create
	make

feature {NONE} -- Initialization

	cg_string: EV_GTK_C_STRING

	needs_event_box: BOOLEAN is do Result := False end

	make (an_interface: like interface) is
			-- Create the tool bar button.
		do
			base_make (an_interface)
		end

	initialize is
			-- Initialization of button box and events.
		do
			Precursor {EV_ITEM_IMP}
			pixmapable_imp_initialize
			set_is_initialized (True)
		end

	event_widget: POINTER is
			-- Pointer to the Gtk widget that handles the events
		do
		end

feature -- Access

	text: STRING_32 is
			-- Text of the label.
		do
			if cg_string /= void then
					Result := cg_string.string
				else
					create Result.make_empty
				end
		end

	gray_pixmap: EV_PIXMAP
			-- Image displayed on `Current'.

	tooltip: STRING_32 is
			-- Tooltip use for describing `Current'.
		do
			create Result.make_empty
		end

	internal_tooltip: STRING_32
		-- Tooltip for `Current'.

feature -- Element change

	set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
			local
			res: INTEGER
		do
			cg_string.set_with_eiffel_string (a_text)
		--	res:=set_control_title_with_cfstring_external (c_object, cg_string.item)
		end
	set_pixmap (a_pixmap: EV_PIXMAP) is
			-- Assign `a_pixmap' to `pixmap'.
		do
		end

	set_tooltip (a_text: STRING_GENERAL) is
			-- Set `tooltip' to `a_text'.
		do
		end

	set_gray_pixmap (a_gray_pixmap: EV_PIXMAP) is
			-- Assign `a_gray_pixmap' to `gray_pixmap'.
		do
		end

	remove_gray_pixmap is
			-- Make `pixmap' `Void'.
		do
		end

	enable_sensitive is
			--
		do
		end

feature {EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Implementation

	call_select_actions is
			-- Call the select_actions for `Current'
		do
		end

	in_select_actions_call: BOOLEAN
		-- Is `Current' in the process of having its select actions called

feature {EV_ANY_I, EV_GTK_CALLBACK_MARSHAL} -- Implementation

	create_select_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Create a select action sequence.
			-- Attach to GTK "clicked" signal.
		do
		end

	create_drop_down_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- 	Create a drop down action sequence.
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_TOOL_BAR_BUTTON;

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




end -- class EV_TOOL_BAR_BUTTON_IMP

