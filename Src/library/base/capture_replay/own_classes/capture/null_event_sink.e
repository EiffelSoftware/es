indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_EVENT_SINK

inherit
	CONTROLLER

create
	make

feature -- Initialization

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

	methodbody_end (res: ANY): ANY is
			-- Hook for capture/replay. Is to be placed at the end of a MethodBody
			-- 'res' is the Result of the Method that should be instrumented.
			-- Return the replacement for the Methodbody's return value.
		do

		end

	methodbody_start (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE)
			-- Hook for capture/replay. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
		do
			
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
