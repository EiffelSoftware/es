note
	description: "Summary description for {SVN_CLIENT_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SVN_CLIENT_ITEM
q
feature {NONE} -- Initialization

	make_with_name (a_name: STRING_32)
		require
			valid_a_name: a_name /= Void and then not a_name.is_empty
		do
			name := a_name.twin
		ensure
			name_set: name.is_equal (a_name)
		end

feature -- Access

	is_folder: BOOLEAN
			-- Is `Current' item a folder?
		do
			Result := False
		end

	name: STRING_32
			-- Name of the current item

end
