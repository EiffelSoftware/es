indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

inherit
	OBSERVABLE

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			bank: BANK
			atm: ATM
			ui: ATM_UI
			serializer: LINE_BASED_SERIALIZER
		do
			-- XXX hm... where is a good place to configure the recorder?
			create serializer.make_on_textfile("run.log")
			recorder.set_serializer (serializer)

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
