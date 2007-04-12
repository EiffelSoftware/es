indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OBSERVABLE
	inherit
		IDENTIFIED

feature -- Access
	is_observed: BOOLEAN is
			-- Does this object belong to the observed set?
		deferred
		end

	the_recorder: RECORDER is
			--XXX Returns the global recorder that is used for all objects
			-- in a multi threading environment this would need to be replaced
			-- by a recorder per thread.
		once
			create Result.make
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
