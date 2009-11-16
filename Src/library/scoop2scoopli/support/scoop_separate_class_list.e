indexing
	description: "Summary description for {SCOOP_SEPARATE_CLASS_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE_CLASS_LIST

create
	make

feature -- Initialisation

	make
			-- Initialise
		do
			create class_list.make
		end

feature -- List access

	has_class (a_class: CLASS_C): BOOLEAN is
			-- query based on a class_c
		do
			if class_list.has (a_class) then
				Result := true
			else
				Result := false
			end
		end

	has (a_class_name: STRING): BOOLEAN is
			-- query based on the class_name
		local
			i: INTEGER
			exist: BOOLEAN
		do
			exist := false
			from i := 1 until i > class_list.count loop
				if class_list.i_th (i).name_in_upper.is_equal (a_class_name) then
					exist := true
				end
				i := i + 1
			end

			Result := exist
		end

	extend (a_class: CLASS_C) is
			-- extends the list with a new element
		do
			if not has (a_class.name_in_upper) and then not a_class.is_class_any and then
			not a_class.is_basic then
				class_list.extend (a_class)
			end
		end

	is_empty: BOOLEAN is
			-- returns the current state of the class lis.
		do
			if class_list.count > 0 then
				Result := false
			else
				Result := true
			end
		end

	count: INTEGER is
			-- returns the number of elements in the list.
		do
			Result := class_list.count
		end

feature -- Element access

	first: CLASS_C is
			-- returns the first element of the list
		do
			Result := class_list.first
		end

	item (i: INTEGER): CLASS_C is
			-- returns the ith element
		require
			valid_i: i > 0 and i <= count
		do
			Result := class_list.i_th (i)
		end

	remove_first is
			-- deletes the first element of the list
		do
			class_list.start
			class_list.remove
		end

feature -- Debug

	print_all is
			-- debug: prints all elements of the list.
		local
			i: INTEGER
		do
			from i := 1 until i > class_list.count loop
				io.put_string (" - " + class_list.i_th (i).name_in_upper)
				io.put_new_line
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	class_list: LINKED_LIST [CLASS_C]

end
