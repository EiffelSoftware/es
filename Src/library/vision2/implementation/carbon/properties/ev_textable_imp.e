indexing
	description:
		"Eiffel Vision textable. Carbon implementation."
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
		do
		end

feature -- Access

	text: STRING_32 is
		do
			if cg_string /= void then
				Result := cg_string.string
			else
				create Result.make_empty
			end
		end

	text_alignment: INTEGER is
			-- Alignment of the text in the label.
		do
			--default is center
			Result := {EV_TEXT_ALIGNMENT_CONSTANTS}.Ev_text_alignment_center
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
			res: INTEGER
		do
			create cg_string.make_unshared_with_eiffel_string ( a_text )
			res := set_control_title_with_cfstring_external (c_object, cg_string.item)
		end


feature {EV_ANY_IMP} -- Implementation

	cg_string: EV_CARBON_CF_STRING

	accelerators_enabled: BOOLEAN is
			-- Does `Current' have keyboard accelerators enabled?
		do
		end

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

	interface: EV_TEXTABLE;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_TEXTABLE_IMP
