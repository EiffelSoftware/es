indexing
	description: "Eiffel Vision sensitive. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "sensitive"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SENSITIVE_IMP

inherit
	EV_SENSITIVE_I
		redefine
			interface
		end

	EV_ANY_IMP
		undefine
			destroy,
			needs_event_box
		redefine
			interface
		end

feature -- Status report

	is_sensitive: BOOLEAN
			-- Is the object sensitive to user input.

feature -- Status setting

	enable_sensitive is
			-- Allow the object to be sensitive to user input.
		do
			is_sensitive := True
		end

	disable_sensitive is
			-- Set the object to ignore all user input.
		do
			is_sensitive := False
		end

feature {EV_ANY_I} -- Implementation

	has_parent: BOOLEAN is
			-- Is `Current' parented?
		do
		end

	parent: EV_ANY is
		deferred
		end

	parent_is_sensitive: BOOLEAN is
			-- (export status {NONE})
		do
		end

	interface: EV_SENSITIVE;
			-- Interface object for implementation

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




end -- EV_SENSITIVE_IMP

