note
	description: "AutoTest tool for the blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_AUTOTEST_TOOL

inherit

	EBB_TOOL

feature -- Access

	name: attached STRING = "AutoTest"
			-- <Precursor>

	description: attached STRING = ""
			-- <Precursor>

	configurations: LINKED_LIST [attached EBB_TOOL_CONFIGURATION]
			-- <Precursor>
		once
			create Result.make
			Result.extend (create {EBB_TOOL_CONFIGURATION}.make (Current, "Default"))
		end

feature -- Basic operations

	create_new_instance (a_execution: EBB_TOOL_EXECUTION)
			-- <Precursor>
		do
			create last_instance.make (a_execution)
		end

	last_instance: EBB_AUTOTEST_INSTANCE
			-- <Precursor>

end
