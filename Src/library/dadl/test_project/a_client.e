indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	A_CLIENT



feature -- Access

	my_bool: BOOLEAN
			-- my boolean value

	my_string: STRING
			-- my string value

	my_string2: STRING
			-- my string value

	my_int: INTEGER
			-- integer value

	my_rek_client:MY_CLASS1
			-- rekursive check

	my_client:A_PARENT

feature -- Element change

	set_my_bool (a_my_bool: like my_bool) is
			-- Set `my_bool' to `a_my_bool'.
		do
			my_bool := a_my_bool
		ensure
			my_bool_assigned: my_bool = a_my_bool
		end

	set_my_string (a_my_string: like my_string) is
			-- Set `my_string' to `a_my_string'.
		do
			my_string := a_my_string
		ensure
			my_string_assigned: my_string = a_my_string
		end

	set_my_string2 (a_my_string: like my_string) is
			-- Set `my_string' to `a_my_string'.
		do
			my_string2 := a_my_string
		ensure
			my_string_assigned: my_string2 = a_my_string
		end

	set_my_int (a_my_int: like my_int) is
			-- Set `my_int' to `a_my_int'.
		do
			my_int := a_my_int
		ensure
			my_int_assigned: my_int = a_my_int
		end

	set_parent is
			--
		do
			create my_client.make ("test",void)
		end


	set_rek_client(client:MY_CLASS1) is
			--
		do
			my_rek_client := client
		end


end
