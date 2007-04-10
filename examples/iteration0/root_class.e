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
			foo: ANY
		do
			--just for testing:
			foo:=arguments_test("Hi!",1.3)

			--initialize everything and start the UI...
			create bank.make
			atm := bank.atm
			ui := atm.ui

			ui.run
		end

	arguments_test(arg1:STRING; arg2: REAL): ANY
			--
		external
			"C signature (EIF_REFERENCE,float):EIF_REFERENCE use recorder.h"
		alias
			"c_arguments_test"
		end


	expanded_test():ANY
			--test to see how eiffel converts an expanded type to any.
		local
			da_real: REAL
		do
			da_real:=5
			Result:=da_real
		end
end -- class ROOT_CLASS
