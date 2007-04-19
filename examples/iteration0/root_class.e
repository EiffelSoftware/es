indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			bank: BANK
			atm: ATM
			ui: ATM_UI
		do
			recorder.capture_methodbody_start ("make", Current, [])
			-- Initialize everything and start the UI...
			create bank.make
			atm := bank.atm
			ui := atm.ui

			ui.run
			recorder.capture_methodbody_end (Void)
		end

feature --Access
end -- class ROOT_CLASS
