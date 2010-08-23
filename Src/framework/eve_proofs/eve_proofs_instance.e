note
	description: "Summary description for {EVE_PROOFS_INSTANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EVE_PROOFS_INSTANCE

inherit

	EBB_TOOL_INSTANCE

create
	make

feature -- Status report

	is_running: BOOLEAN
			-- <Precursor>

feature {EBB_TOOL_EXECUTION} -- Basic operations

	start
			-- <Precursor>
		do
			if attached {EVE_PROOFS} tool as l_eve_proofs then
				l_eve_proofs.reset
				l_eve_proofs.add_class_to_verify (input.classes.first)
				l_eve_proofs.execute_verification
			end
			execution.set_finished
		end

	cancel
			-- <Precursor>
		do

		end

end
