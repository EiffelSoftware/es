indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_CLASS1
inherit
	A_PARENT

feature -- Access

	my_bool: BOOLEAN
			-- my boolean value

	my_string: STRING
			-- my string value

	my_string2: STRING
			-- my string value

	my_int: INTEGER
			-- integer value

	my_client:A_CLIENT
			-- client class

	my_array:ARRAY[A_CLIENT]
			-- array

	my_array3:ARRAYED_LIST[INTEGER]
			-- arrayed list

	my_table:HASH_TABLE[INTEGER,INTEGER]
			-- hash table

	my_table2:HASH_TABLE[A_CLIENT,INTEGER]
			-- hast table user type

	my_tuple:TUPLE[A_CLIENT,INTEGER]
			-- tuple

	my_list:LINKED_LIST[TUPLE[A_CLIENT]]
			-- linked list tuple

	my_pointer:POINTER_REF

	my_empty:EMPTY

	myself:MY_CLASS1

	my_real:REAL

	my_nat:NATURAL

	my_char:CHARACTER

	my_array2:ARRAY[LINKED_LIST[TUPLE[A_CLIENT]]]


feature -- Element change

	set_client(a_client:A_CLIENT) is
			--
		do
			my_client := a_client
		end

	set_self_reference is
			--
		do
			myself := current
		end


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

	set_my_real(a_real:REAL) is
			--
		do
			my_real := a_real
		end

	set_my_char(a_char:CHARACTER) is
			--
		do
			my_char := a_char
		end

	set_my_natural(a_nat:NATURAL) is
			--
		do
			my_nat := a_nat
		end



	init_array is
			--
		do
			create my_array.make (1, 5)
			my_array.put (my_client, 1)
			my_array.put (my_client, 2)
			my_array.put (my_client, 3)
		end

	init_array2 is
			--
		local
			list:LINKED_LIST[TUPLE[A_CLIENT]]
			client:A_CLIENT
		do
			create list.make
			create client
			client.set_my_bool (false)
--			client.set_my_string2 ("client_string_test")
			list.extend([client])
			create my_array2.make (1, 5)
			my_array2.put (list, 1)
		end

	init_tuple is
			--
		do
			create my_tuple
			my_tuple.put (my_client,1)
			my_tuple.put_integer (100, 2)
		end

	init_list is
			--
		do
			create my_list.make
			my_list.extend ([my_client])
		end

	init_pointer is
			--
		local
			int:INTEGER
		do
			create my_pointer
			my_pointer.set_item (my_client.default_pointer)
		end

	init_empty is
			--
		do
			create my_empty
		end

	init_array3 is
			--
		do
			create my_array3.make(5)
			my_array3.extend(1)
			my_array3.extend(2)
		end

	init_table is
			--
		do
			create my_table.make(5)
			my_table.put(2,5)
			my_table.put(3,4)
		end

	init_table2 is
			--
		do
			create my_table2.make(5)
			my_table2.put(my_client,66)
			my_table2.put(my_client,666)
		end





end
