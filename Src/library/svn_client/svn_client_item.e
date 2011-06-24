note
	description: "Summary description for {SVN_CLIENT_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SVN_CLIENT_ITEM

feature {NONE} -- Initialization

	make_with_name (a_name: STRING_32)
		require
			valid_a_name: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			create properties.make (7)
		ensure
			name_set: name = a_name
		end

feature -- Access

	is_folder: BOOLEAN
			-- Is `Current' item a folder?
		do
			Result := False
		end

	name: STRING_32
			-- Name of the current item

	properties: STRING_8
			-- Status of the current item (modified, added, deleted, locked, ...). Each property is one character wide

feature -- Element change

	set_properties (a_properties: STRING_8)
		require
			valid_properties: a_properties /= Void and then a_properties.count = 7
		do
			properties := a_properties
		end
end
