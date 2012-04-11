indexing
	description: "Summary description for {TC_LARGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_LARGE

create
	make

feature -- init

	make is
			-- Run application.
		local
			string:STRING
			obj:ANY
			l_array:ARRAYED_LIST[INTEGER]
			l_int:INTEGER
			l_char:CHARACTER
		do
			create l_array.make(5)

			create a_class1
			a_class1.set_my_int (12)
			a_class1.set_my_bool (false)
			a_class1.set_my_string ("test_string")
			a_class1.set_my_string2 ("test_string2")
			a_class1.set_my_natural (4)
			a_class1.set_my_real (0.5)
			a_class1.set_my_char ('t')
			create client
			a_class1.set_client2 (client)


			create a_client
			a_client.set_my_int (50)
			a_client.set_parent
			a_client.set_my_bool (true)
			a_client.set_my_string ("client_string1")
			a_client.set_my_string2 ("client_string2")

			l_array.extend(1)

			a_class1.set_client (a_client)
			a_client.set_rek_client (a_class1)
			a_class1.init_tuple
			a_class1.init_pointer
			a_class1.init_list
			a_class1.init_empty
			a_class1.init_array
			a_class1.init_array2
			a_class1.init_array3
			a_class1.init_table
			a_class1.init_table2
			a_class1.set_self_reference

			create a_par.make ("test",void)

			create tc_special.make

			create tc_tuple.make

			tc_large := Current

		end


feature --attributes

	a_class1:MY_CLASS1
	a_client:A_CLIENT

	a_par:A_PARENT
	tc_special:TC_SPECIAL
	tc_tuple:TC_TUPLE
	client:A_CLIENT

	tc_large:TC_LARGE

end
