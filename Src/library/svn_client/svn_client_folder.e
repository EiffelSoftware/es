note
	description: "Summary description for {SVN_CLIENT_FOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_FOLDER

inherit
	SVN_CLIENT_ITEM
		redefine
			make_with_name,
			is_folder
		end

	LINKED_LIST[SVN_CLIENT_ITEM]
		undefine
			is_equal,
			copy
		end

create
	make_with_name

feature {NONE} -- Initialization

	make_with_name (a_name: STRING_32)
		do
			make
			Precursor (a_name)
		end

feature -- Access

	is_folder: BOOLEAN
		do
			Result := True
		end

end
