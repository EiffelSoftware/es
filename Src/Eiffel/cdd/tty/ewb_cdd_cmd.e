indexing
	description: "Objects that provide a tty command for cdd functions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWB_CDD_CMD

inherit
	EWB_CMD

	SHARED_DEBUGGER_MANAGER
		export
			{NONE} all
		end

	CDD_CONSTANTS

feature -- Access

	cdd_manager: CDD_MANAGER is
			-- Current instance of CDD_MANAGER
		do
			Result := debugger_manager.cdd_manager
		ensure
			not_void: Result /= Void
		end


feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
