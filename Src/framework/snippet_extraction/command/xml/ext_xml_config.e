note
	description: "Options for XML transformation engine."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_CONFIG

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

create
	make

feature {NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		require
			a_system_not_void: attached a_system
		do
			eiffel_system := a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system.

	class_name: STRING
		assign set_class_name
			-- Class to be transformed to XML.	

	group_name: detachable STRING
		assign set_group_name
			-- Name of library or cluster that restricts search space for classes.

	output_path: detachable STRING
		assign set_output_path
			-- Output directory for some operations.

feature -- Setting

	set_class_name (a_class_name: like class_name)
			-- Set `class_name' with `a_class_name'.
		do
			if a_class_name = Void then
				class_name := Void
			else
				class_name := a_class_name.twin
				class_name.to_upper
			end
		end

	set_group_name (a_group_name: like group_name)
			-- Set `group_name' with `a_group_name'.
		do
			if a_group_name = Void then
				group_name := Void
			else
				group_name := a_group_name.twin
			end
		end

	set_output_path (a_output_path: like output_path)
			-- Set `output_path' with `a_output_path'.
		do
			output_path := a_output_path
		end

end
