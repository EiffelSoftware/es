indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	A_PARENT

create
	make


feature -- creation

	make(a_str,a_str2:STRING) is
			--
		do
			parent_string := a_str
			parent_string2 := a_str2
		end


feature -- access

	parent_string:STRING

	parent_string2:STRING

	parent_client:A_CLIENT

	set_client2(client:A_CLIENT) is
			--
		do
			--parent_client := client
		end


end
