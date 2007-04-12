indexing
	description: "Eiffel Vision dialog. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_UNTITLED_DIALOG_IMP

inherit
	EV_DIALOG_IMP
		redefine
			interface,
			default_wm_decorations,
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize is
			-- Initialize `Current'
		do
			Precursor {EV_DIALOG_IMP}
		end

feature {NONE} -- Implementation

	default_wm_decorations: INTEGER is
			-- Default Window Manager decorations of `Current'.
		do
			Result := 0
		end

	interface: EV_UNTITLED_DIALOG;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

indexing
	copyright:	"Copyright (c) 2007, The Eiffel.Mac Team"
end -- class EV_DIALOG_IMP

