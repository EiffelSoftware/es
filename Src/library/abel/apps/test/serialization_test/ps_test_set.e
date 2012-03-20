note
	description: "Summary description for {PS_TEST_SET}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TEST_SET

inherit
	EQA_TEST_SET

feature {NONE} -- Factory

feature {MANUAL_TEST_HANDLER}-- Test routines for different strategies.

	test_flat_object_serialization_and_deserialization (test_object: FLAT_CLASS_1; serializer: PS_SERIALIZER)
			-- Test serialization and deserialization of an object containing numeric types, characters, booleans and strings.
		local
			retrieved_obj: detachable ANY
		do
			serializer.store (test_object)
			serializer.retrieve
			serializer.retrieved_items.start
			retrieved_obj := serializer.retrieved_items.item
			if attached {FLAT_CLASS_1_FOR_STORABLE} retrieved_obj as deserialized_obj then
				assert ("Deserialization of type FLAT_CLASS_1_FOR_STORABLE invalid", (create {FLAT_CLASS_1_FOR_STORABLE}.make).is_deep_equal (deserialized_obj))
			else
				if attached {FLAT_CLASS_1} retrieved_obj as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
				else
					assert ("The deserializated types are neither FLAT_CLASS_1 nor FLAT_CLASS_1_FOR_STORABLE.", False)
				end
			end
		end

	test_data_structures_1_serialization_and_deserialization (test_object: DATA_STRUCTURES_CLASS_1; serializer: PS_SERIALIZER)
			-- Test serialization and deserialization of an object containing various data structures.
		local
			temp_from_tuple: ANY
			retrieved_obj: detachable ANY
		do
			serializer.store (test_object)
			serializer.retrieve
			serializer.retrieved_items.start
			retrieved_obj := serializer.retrieved_items.item

			if attached {DATA_STRUCTURES_CLASS_1_FOR_STORABLE} retrieved_obj as deserialized_obj then
				assert ("Deserialization of type DATA_STRUCTURES_CLASS_1_FOR_STORABLE invalid", (create {DATA_STRUCTURES_CLASS_1_FOR_STORABLE}.make).is_deep_equal (deserialized_obj))
			else
				if attached {DATA_STRUCTURES_CLASS_1} retrieved_obj as deserialized_obj then
						assert ("Deserialization of type DATA_STRUCTURES_CLASS_1 invalid", (create {DATA_STRUCTURES_CLASS_1}.make).is_deep_equal (deserialized_obj))
					else
						assert ("The deserializated types are neither DATA_STRUCTURES_CLASS_1 nor DATA_STRUCTURES_CLASS_1_FOR_STORABLE.", False)
					end
			end
	end

	test_polymorphic_data_structures_serialization_and_deserialization (test_object: DATA_STRUCTURES_CLASS_2; manager: PS_SERIALIZER)
			-- Test serialization and deserialization of an object containing polymorphic data structures.
		local
			retrieved_obj: detachable ANY
		do
			manager.store (test_object)
			manager.retrieve
			manager.retrieved_items.start
			retrieved_obj := manager.retrieved_items.item

			if attached {DATA_STRUCTURES_CLASS_2_FOR_STORABLE} retrieved_obj as deserialized_obj then
				check_polymorphic_data_structures (deserialized_obj)
			else
				if attached {DATA_STRUCTURES_CLASS_2} retrieved_obj as deserialized_obj then
						check_polymorphic_data_structures (deserialized_obj)
				else
						assert ("The deserializated types are neither DATA_STRUCTURES_CLASS_21 nor DATA_STRUCTURES_CLASS_2_FOR_STORABLE.", False)
				end
			end
		end

feature {MANUAL_TEST_HANDLER} -- Default {PS_SERIALIZATION_FACADE} API tests

	test_facade_with_classic_serializer (test_object: FLAT_CLASS_1; name: STRING)
			-- Test class {PS_SERIALIZATION_FACADE} using classic serializer.
		local
			facade: PS_SERIALIZATION_FACADE
		do
			create facade.make_with_classic_serializer (create {FILE_NAME}.make_from_string (name))
			if attached  {PS_CLASSIC_SERIALIZER} facade.serializer as ser then
				facade.store (test_object)
				facade.retrieve
				if attached {FLAT_CLASS_1_FOR_STORABLE} facade.retrieved as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1_FOR_STORABLE invalid", (create {FLAT_CLASS_1_FOR_STORABLE}.make).is_deep_equal (deserialized_obj))
				else
					if attached {FLAT_CLASS_1} facade.retrieved as deserialized_obj then
						assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
					else
						assert ("The deserializated types are neither FLAT_CLASS_1 nor FLAT_CLASS_1_FOR_STORABLE.", False)
					end
				end
			else
				assert ("The default serializer is not the intended one: PS_CLASSIC_SERIALIZER", false)
			end
		end

	test_facade_after_setting_serializer (test_object: FLAT_CLASS_1; serializer: PS_SERIALIZER)
			-- Test pluggable serializer for class {PS_SERIALIZATION_FACADE}.
		local
			facade: PS_SERIALIZATION_FACADE
		do
			if attached serializer as ser then
				assert ("The default serializer is not one of the intended one: PS_CLASSIC_SERIALIZER or PS_SED_SERIALIZER", ser.generating_type.name.is_equal ("PS_CLASSIC_SERIALIZER") OR ser.generating_type.name.is_equal ("PS_SED_SERIALIZER"))
				create facade.make_with_serializer (ser)
				facade.store (test_object)
				facade.retrieve
				if attached {FLAT_CLASS_1_FOR_STORABLE} facade.retrieved as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1_FOR_STORABLE invalid", (create {FLAT_CLASS_1_FOR_STORABLE}.make).is_deep_equal (deserialized_obj))
				else
					if attached {FLAT_CLASS_1} facade.retrieved as deserialized_obj then
						assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
					else
						assert ("The deserializated types are neither FLAT_CLASS_1 nor FLAT_CLASS_1_FOR_STORABLE.", False)
					end
				end
			else
				assert ("serializer argument is void", false)
			end
		end

	test_facade_with_different_serializers_for_storing_and_retrieving (test_object: FLAT_CLASS_1; serializer_1, serializer_2: PS_SERIALIZER)
				-- Test facade with `serializer_1' storing and `serializer_2' retrieving the same object.
		local
			facade_1, facade_2: PS_SERIALIZATION_FACADE
			retrieved_obj: detachable ANY
		do
			if attached serializer_1 as ser_1 and attached serializer_2 as ser_2 then
				create facade_1.make_with_serializer (ser_1)
				create facade_2.make_with_serializer (ser_2)
				facade_1.store (test_object)
				facade_2.retrieve
				if attached facade_2.retrieved as retriv then
					assert ("%NThe two serializers of type: " + ser_1.generating_type.name + " and " + ser_2.generating_type.name +" are not compatible. ", retriv.is_deep_equal (test_object))
				end
			else
				assert ("serializer_1 or serializer_2 are void", False)
			end
		end


feature {MANUAL_TEST_HANDLER} -- Multi-object serialization tests

	test_multi_object_serialization_and_deserialization_with_one_object (test_object_1: FLAT_CLASS_1; serializer: PS_SED_SERIALIZER)
				-- Test multi_object serialization and deserialization of one object.
		local
			facade: PS_SERIALIZATION_FACADE
			index: INTEGER
		do
			create facade.make_with_serializer (serializer)
			facade.multi_store (test_object_1)
			assert ("Number of objects stored: " +  serializer.objects_stored_count.out + " is not what expected: 1", serializer.objects_stored_count.is_equal (1))
			facade.multi_retrieve
			from
				facade.retrieved_many.start
				index := 1
			until
				facade.retrieved_many.after
			loop
				if attached {FLAT_CLASS_1}facade.retrieved_many.item as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
				else
					assert ("The deserialization process didn't produce the expected type FLAT_CLASS_1 at position " + index.out, False)
				end
				facade.retrieved_many.forth
				index := index + 1
			end
				assert ("Number of objects retrieved: " +  facade.retrieved_many.count.out + " is not what expected: 1", facade.retrieved_many.count.is_equal (1))
		end

	test_multi_object_serialization_and_deserialization_with_two_objects_of_same_type (test_object_1, test_object_2: FLAT_CLASS_1; serializer: PS_SED_SERIALIZER)
				-- Test multi_object serialization and deserialization of two objects of the same type in the same file.
		local
			facade: PS_SERIALIZATION_FACADE
			index: INTEGER
		do
			create facade.make_with_serializer (serializer)
			facade.multi_store (test_object_1)
			assert ("Number of objects stored: " +  serializer.objects_stored_count.out + " is not what expected: 1", serializer.objects_stored_count.is_equal (1))
			facade.multi_store (test_object_2)
			assert ("Number of objects stored: " +  serializer.objects_stored_count.out + " is not what expected: 2", serializer.objects_stored_count.is_equal (2))
			facade.multi_retrieve
			from
				facade.retrieved_many.start
				index := 1
			until
				facade.retrieved_many.after
			loop
				if attached {FLAT_CLASS_1} facade.retrieved_many.item as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
				else
					assert ("The deserialization process didn't produce the expected type FLAT_CLASS_1 at position " + index.out, False)
				end
				facade.retrieved_many.forth
				index := index + 1
			end
			assert ("Number of objects retrieved: " +  facade.retrieved_many.count.out + " is not what expected: 2", facade.retrieved_many.count.is_equal (2))
		end

	test_multi_object_serialization_and_deserialization_with_two_objects_of_different_type (test_object_1: FLAT_CLASS_1; test_object_2: DATA_STRUCTURES_CLASS_1; serializer: PS_SED_SERIALIZER)
				-- Test multi_object serialization and deserialization of two objects of the same type in the same file.
		local
			facade: PS_SERIALIZATION_FACADE
			index: INTEGER
		do
			create facade.make_with_serializer (serializer)
			facade.multi_store (test_object_1)
			assert ("Number of objects stored: " +  serializer.objects_stored_count.out + " is not what expected: 1", serializer.objects_stored_count.is_equal (1))
			facade.multi_store (test_object_2)
			assert ("Number of objects stored: " +  serializer.objects_stored_count.out + " is not what expected: 2", serializer.objects_stored_count.is_equal (2))
			facade.multi_retrieve
			from
				facade.retrieved_many.start
				index := 1
			until
				facade.retrieved_many.after
			loop
				if attached {FLAT_CLASS_1} facade.retrieved_many.item as deserialized_obj then
					assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {FLAT_CLASS_1}.make).is_deep_equal (deserialized_obj))
				else
					if attached {DATA_STRUCTURES_CLASS_1} facade.retrieved_many.item as deserialized_obj then
						assert ("Deserialization of type FLAT_CLASS_1 invalid", (create {DATA_STRUCTURES_CLASS_1}.make).is_deep_equal (deserialized_obj))
					else
						assert ("The deserialization process didn't produce the expected type at position " + index.out, False)
					end
				end
				facade.retrieved_many.forth
				index := index + 1
			end
			assert ("Number of objects retrieved: " +  facade.retrieved_many.count.out + " is not what expected: 2", facade.retrieved_many.count.is_equal (2))
		end

feature {MANUAL_TEST_HANDLER} -- Tests for exceptional conditions

	test_facade_with_non_existing_file_name_for_retrieval (test_object: FLAT_CLASS_1; file_name_1, file_name_2: STRING)
				-- Test facade attempting a retrieval from a different file with respect to the one used for storing an object.
		local
			facade_1, facade_2: PS_SERIALIZATION_FACADE
			retrieved_obj: detachable ANY
		do
			create facade_1.make_with_classic_serializer (create {FILE_NAME}.make_from_string (file_name_1))
			create facade_2.make_with_classic_serializer (create {FILE_NAME}.make_from_string (file_name_2))
			facade_1.store (test_object)
			facade_2.retrieve
			assert ("The retrieved element in the objects list is supposed to be Void but it is not. ", facade_2.retrieved = Void)
		end



feature {NONE}	-- Implementation

	check_polymorphic_data_structures (deserialized_obj: DATA_STRUCTURES_CLASS_2)
				-- Check {DATA_STRUCTURES_CLASS_2} objects.
		do
			if attached {LINKED_LIST[ANY]} deserialized_obj.polymorphic_linked_list as ll then
				print ("Number of elements:" + ll.count.out)
				ll.start
				if attached {STRING} ll.item as str then
					assert ("Deserialization of the STRING content of LINKED_LIST [ANY] attribute 'polymorphic_linked_list' in class DATA_STRUCTURES_CLASS_2 has value " + str.out + " instead of the expected value %"7%" ", str.is_equal ("7"))
				else
					assert ("The deserialization process didn't produce the expected type STRING from DATA_STRUCTURES_CLASS_2.LINKED_LIST.item", False)
				end
		--		ll.forth
		--		if attached {INTEGER} ll.item as int then
		--			assert ("Deserialization of the INTEGER content of LINKED_LIST [ANY] attribute 'polymorphic_linked_list' in class DATA_STRUCTURES_CLASS_2 has value " + int.out + " instead of the expected value 3", int = 3)
		--		else
		--			assert ("The deserialization process didn't produce the expected type INTEGER from DATA_STRUCTURES_CLASS_2.LINKED_LIST.item", False)
		--		end
			else
				assert ("The deserialization process didn't produce the expected type DATA_STRUCTURES_CLASS_2.LINKED_LIST", False)
			end
		end
end
