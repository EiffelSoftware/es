indexing
	description: "Object that represents the user interface of an atm"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ATM_UI

inherit
	ANY
	redefine
		is_observed
	end

feature -- Initialization

	make (an_atm: ATM)
			-- Create a new ATM_UI for 'an_atm'.
		require
			an_atm_not_void: an_atm /= Void
		do
				atm := an_atm
		ensure
			atm_set: atm = an_atm
		end

feature -- Access

	is_observed: BOOLEAN is False

feature --Basic Operations
	run is
			-- Run the UI.
		deferred
		end


feature {NONE} -- Implementation
	-- These features won't be captured, as they can't be
	-- executed from other classes.

	atm: ATM  -- ATM the UI is connected to

invariant
	atm_not_void: atm /= Void
end
