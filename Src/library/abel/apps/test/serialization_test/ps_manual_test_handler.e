note
	description: "Test launcher for manual tests."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_HANDLER

inherit
	PS_TEST_SET

		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create flat_1.make
			create flat_2.make
			create struct_1.make
			create struct_2.make
			create sto_flat_1.make
			create sto_struct_1.make
			create sto_struct_2.make
		end

	on_clean
			-- <Precursor>
		do

		end

feature -- Test attributes

	 flat_1, flat_2: FLAT_CLASS_1
	 struct_1: DATA_STRUCTURES_CLASS_1
	 struct_2: DATA_STRUCTURES_CLASS_2
	 sto_flat_1: FLAT_CLASS_1_FOR_STORABLE
	 sto_struct_1: DATA_STRUCTURES_CLASS_1_FOR_STORABLE
	 sto_struct_2: DATA_STRUCTURES_CLASS_2_FOR_STORABLE

feature -- Serialization tests.

	test_classic_binary_serializer
			-- Invoke tests for class {PS_CLASSIC_SERIALIZER}.
		do
			test_flat_object_serialization_and_deserialization (sto_flat_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_1")))
			test_flat_object_serialization_and_deserialization (flat_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_2")))
			test_data_structures_1_serialization_and_deserialization (sto_struct_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_3")))
			test_data_structures_1_serialization_and_deserialization (struct_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_4")))
			test_polymorphic_data_structures_serialization_and_deserialization (sto_struct_2, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_5")))
			test_polymorphic_data_structures_serialization_and_deserialization (struct_2, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_6")))
		end

	test_sed_binary_serializer
			-- Invoke tests for class {PS_SED_SERIALIZER}.
		do
			test_flat_object_serialization_and_deserialization (flat_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_7")))
			test_data_structures_1_serialization_and_deserialization (struct_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_8")))
			test_polymorphic_data_structures_serialization_and_deserialization (struct_2, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_9")))
		end

--	test_dadl_serializer
			-- Invoke tests for class {PS_DADL_SERIALIZER}.
			-- Uncomment after first release of DADL serialization
--		do
--			test_flat_object_serialization_and_deserialization (flat_1, create {PS_DADL_SERIALIZER}.make (create {RAW_FILE}.make ("file_10")))
--			test_data_structures_1_serialization_and_deserialization (struct_1, create {PS_DADL_SERIALIZER}.make (create {RAW_FILE}.make ("file_11")))
--			test_polymorphic_data_structures_serialization_and_deserialization (struct_2, create {PS_DADL_SERIALIZER}.make (create {RAW_FILE}.make ("file_12")))
--		end

	test_binary_serializer
			-- Invoke tests for class {PS_BINARY_SERIALIZER}.
			-- Uncomment after first release of new binary serialization
		local
			binary_serializer: PS_BINARY_SERIALIZER
			my_integer: INTEGER
		do
			create binary_serializer.make (create {RAW_FILE}.make ("file_13_1"))
			create my_integer
			my_integer := 5
			binary_serializer.traverse (my_integer)
			binary_serializer.print_serialized
			binary_serializer.traverse (flat_1)
			binary_serializer.print_serialized
			assert ("End of test", FALSE) -- needed to show internal debug messages

--			test_flat_object_serialization_and_deserialization (flat_1, create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_13")))
--			test_data_structures_1_serialization_and_deserialization (struct_1, create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_14")))
--			test_polymorphic_data_structures_serialization_and_deserialization (struct_2, create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_15")))
		end

	test_facade
			-- Test interface of class {PS_FACADE}.
		local
			retrieved_obj: detachable ANY
		do
			test_facade_with_classic_serializer (flat_1, "file_16")
		--	test_facade_with_dadl_serializer (flat_1, "file_17") uncomment after first release of DADL serialization
		--	test_facade_with_binary_serializer (flat_1, "file_18") uncomment after first release of new binary serialization
			test_facade_after_setting_serializer (flat_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_19")))
			test_facade_after_setting_serializer (flat_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_20")))
		--	test_facade_after_setting_serializer (flat_1, create {PS_DADL_SERIALIZER}.make (create {RAW_FILE}.make ("file_21"))) uncomment after first release of DADL serialization
		--	test_facade_after_setting_serializer (flat_1, create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_22"))) uncomment after first release of new binary serialization
		--	test_facade_with_different_serializers_for_storing_and_retrieving (flat_1, create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_23")), create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_23"))) uncomment after first release of new binary serialization
		--	test_facade_with_different_serializers_for_storing_and_retrieving (flat_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_24")), create {PS_BINARY_SERIALIZER}.make (create {RAW_FILE}.make ("file_24"))) uncomment after first release of new binary serialization
			test_facade_with_non_existing_file_name_for_retrieval (flat_1, "file_25", "file_26")
		end

	test_compatibility_between_classic_and_sed_serializers
			-- Can {PS_CLASSIC_SERIALIZER} retrieve an object stored using {PS_SED_SERIALIZER} and vice-versa?
		do
			test_facade_with_different_serializers_for_storing_and_retrieving (flat_1, create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_27")), create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_27")))
			test_facade_with_different_serializers_for_storing_and_retrieving (flat_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_28")), create {PS_CLASSIC_SERIALIZER}.make (create {RAW_FILE}.make ("file_28")))
		end

	test_binary_multi_object_serialization
			-- Test multi-object serialization mechanism.
		do
			test_multi_object_serialization_and_deserialization_with_one_object (flat_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_29")))
			test_multi_object_serialization_and_deserialization_with_two_objects_of_same_type (flat_1, flat_2, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_30")))
			test_multi_object_serialization_and_deserialization_with_two_objects_of_different_type (flat_1, struct_1, create {PS_SED_SERIALIZER}.make (create {RAW_FILE}.make ("file_31")))
		end

end
