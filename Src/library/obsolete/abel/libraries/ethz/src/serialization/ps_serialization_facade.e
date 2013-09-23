note
	description: "[
		Front-end for object serialization services.
		Use `store' to store one root object.
		Use `multi_store' to store multiple objects	on the same file.
		Deserialized object(s) are found in feature `retrieved' (`retrieved_many').
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SERIALIZATION_FACADE

inherit {NONE}

	PS_LIB_UTILS

	REFACTORING_HELPER

create
	make_with_classic_serializer, make_with_dadl_serializer, make_with_serializer

feature -- Initialization

	make_with_classic_serializer (a_file_name: STRING)
			-- Set {PS_CLASSIC_SERIALIZER} and format to store into a file named `a_file_name'.
		require
			a_file_name_exists: not a_file_name.is_empty
		local
			l_file_name: FILE_NAME
			a_file: RAW_FILE
		do
			create l_file_name.make_from_string (a_file_name)
			if l_file_name.is_valid then
				create a_file.make (l_file_name.string)
			else
				fixme ("insert log messages instead of print")
				print ("The provided file name: " + a_file_name + " is not valid in the current operating system.")
				print (" Using current directory and file name: " + Default_file_name)
				create a_file.make (Default_file_name)
			end
			create {PS_CLASSIC_SERIALIZER} serializer.make (a_file)
			create retrieved_many.make (Default_dimension)
		ensure
			serializer_set: serializer /= Void
			correct_serializer_set: serializer.generating_type.name.is_equal ("PS_CLASSIC_SERIALIZER")
		end

	make_with_dadl_serializer (a_file_name: STRING)
			-- Set {PS_DADL_SERIALIZER} and format to store into a file named `a_file_name'.
		require
			a_file_name_exists: not a_file_name.is_empty
		local
			l_file_name: FILE_NAME
			a_file: RAW_FILE
		do
			create l_file_name.make_from_string (a_file_name)
			if l_file_name.is_valid then
				create a_file.make (l_file_name.string)
			else
				fixme ("insert log messages instead of print")
				print ("The provided file name: " + a_file_name + " is not valid in the current operating system.")
				print (" Using current directory and file name: " + Default_file_name)
				create a_file.make (Default_file_name)
			end
			create {PS_DADL_SERIALIZER} serializer.make (a_file)
			create retrieved_many.make (Default_dimension)
		ensure
			serializer_set: serializer /= Void
			correct_serializer_set: serializer.generating_type.name.is_equal ("PS_DADL_SERIALIZER")
		end

	make_with_serializer (a_serializer: PS_SERIALIZER)
			-- Set `a_serializer' as a serializer.
		require
			a_serializer_exists: a_serializer /= Void
		do
			set_serializer (a_serializer)
			create retrieved_many.make (Default_dimension)
		ensure
			serializer_set: serializer = a_serializer
		end

feature -- Access

	retrieved_many: ARRAYED_LIST [detachable ANY]
			-- Object(s) retrieved in a multi-root-object scenario.

	retrieved: detachable ANY
			-- Object retrieved in a single-root-object scenario

	serializer: --detachable
		PS_SERIALIZER
			-- Pluggable serializer.

feature -- Status setting

	set_serializer (a_serializer: PS_SERIALIZER)
			-- Set `a_serializer' as a  serializer.
		do
			serializer := a_serializer
		ensure
			serializer_set: serializer = a_serializer
		end

feature -- Basic operations

	store (an_object: ANY)
			--	Serialize an_object.
		do
			serializer.store (an_object)
		ensure
			object_stored_correctly: serializer.last_store_successful
		end

	multi_store (an_object: ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.
		do
			serializer.multi_store (an_object)
		ensure
			object_stored_correctly: serializer.last_store_successful
		end

	retrieve
			-- Retrieve an object. Update `retrieved_item'.
		do
			serializer.retrieve
			retrieved := serializer.retrieved_items.i_th (1)
		end

	multi_retrieve
			-- Retrieve objects in a multi-object scenario. Update `retrieved_many'.
		do
			serializer.multi_retrieve
			retrieved_many := serializer.retrieved_items
		ensure
			retrieved_many_exists: retrieved_many /= Void
		end

feature {NONE} -- Implementation

end
