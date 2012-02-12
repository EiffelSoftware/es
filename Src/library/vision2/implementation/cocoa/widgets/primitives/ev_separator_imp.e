note
	description: "Eiffel Vision separator. Cocoa implementation"
	author:	"Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SEPARATOR_IMP

inherit
	EV_SEPARATOR_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			make,
			interface
		end

feature {NONE} -- Initialization

	make
			-- Create the separator control.
		local
			box: NS_BOX
		do
			create box.make_with_frame_ (create {NS_RECT}.make_with_coordinates (0, 0, 4, 4))
			box.set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := box
			Precursor {EV_PRIMITIVE_IMP}
			disable_tabable_from
			-- NSBoxSeparator = 2
			box.set_box_type_ (2)
			set_is_initialized (True)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_SEPARATOR note option: stable attribute end;

end -- class EV_SEPARATOR_IMP
