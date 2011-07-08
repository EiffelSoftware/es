note
	description: "Deferred implementation for classes that work with {EXT_HOLE_FACTORY}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_HOLE_FACTORY_AWARE

feature {NONE} -- Implementation

	hole_factory: EXT_HOLE_FACTORY
			-- Hole factory to create new instances with distinct identifiers.

end
