note
	description: "Deferred implementation for classes that work with {EXT_HOLE_FACTORY}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_HOLE_FACTORY_AWARE

feature -- Configuration

	hole_factory: EXT_HOLE_FACTORY
		assign set_hole_factory
			-- Hole factory to create new instances with distinct identifiers.

	set_hole_factory (a_factory: EXT_HOLE_FACTORY)
			-- Sets `hole_factory'.
		require
			attached a_factory
		do
			hole_factory := a_factory
		end

end
