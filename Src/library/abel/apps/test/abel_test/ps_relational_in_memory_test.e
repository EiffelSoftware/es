note
	description: "Tests the relational stack with an in-memory 'database'."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_IN_MEMORY_TEST
inherit
	PS_CRUD_TESTS
	PS_CRITERIA_TESTS


feature{NONE}

	on_prepare
		do
			create int_repo.make (create {PS_IN_MEMORY_DATABASE}.make)
			repository := int_repo
			initialize_tests_general
			initialize_criteria_tests
			initialize_crud_tests
		end


	int_repo: PS_RELATIONA_IN_MEMORY_REPOSITORY

feature

	test_criteria_in_relational_memory
	do
		insert_data
		test_criteria_agents
		test_criteria_predefined
		test_criteria_agents_and_predefined
	end


	test_crud_flat_in_memory
		do
			test_flat_class_store
			test_flat_class_all_crud
		end

--	test_crud_structures_in_memory
--		do
--			test_data_structures_store
--			test_update_on_reference
--		end




	test_initial_insert
		local
			ref_executor: PS_CRUD_EXECUTOR--[REFERENCE_CLASS_1]
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			original, one, two, three:REFERENCE_CLASS_1
			ref_list: LINKED_LIST[REFERENCE_CLASS_1]
			eq: BOOLEAN
		do
			repository.clean_db_for_testing
--			flat_executor.insert (test_data.flat_class)
			create ref_executor.make_with_repository (repository)
			ref_executor.insert (test_data.reference_1)
--			print (int_repo.disassembler.disassembled_object.to_string)
--			structures_executor.insert (test_data.data_structures_1)

--			print (int_repo.memory_db.string_representation)
			create query.make
			ref_executor.execute_query (query)

			assert ("The result is empty", not query.result_cursor.after)

			create ref_list.make

			across query as cursor loop
				ref_list.extend (cursor.item)
			end

			-- here we have the problem that the result is not sorted...
--			one:= query.result_cursor.item
--			query.result_cursor.forth
--			two:= query.result_cursor.item
--			query.result_cursor.forth
--			three:= query.result_cursor.item

			original:= test_data.reference_1

			eq:= original.is_deep_equal (ref_list[1]) or original.is_deep_equal (ref_list[2]) or original.is_deep_equal (ref_list[3])

--			eq:= original.is_deep_equal (one) or original.is_deep_equal (two) or original.is_deep_equal (three)
--			print ( three.tagged_out+ attach (three.refer).tagged_out + attach (attach (three.refer).refer).tagged_out + "%N")
--			print ( original.tagged_out+ attach (original.refer).tagged_out + attach (attach (original.refer).refer).tagged_out)

--			print (original.ref_arrays.out + ref_list[3].ref_arrays.out)
--			print (original.ref_arrays.area.count.out + " " + ref_list[3].ref_arrays.area.count.out)

			assert ("The results are not the same", eq)
		end


	test_very_simple
		local
			ref1, ref2, ref4:REFERENCE_CLASS_1
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			ref_executor: PS_CRUD_EXECUTOR--[REFERENCE_CLASS_1]
			reflection:INTERNAL
		do
			create reflection
			create ref_executor.make_with_repository (repository)
			create ref1.make (1)
			create ref2.make (1)
			create query.make
			repository.clean_db_for_testing

			ref_executor.insert (ref1)
			ref_executor.execute_query (query)

			check attached{REFERENCE_CLASS_1} query.result_cursor.item as ref3 then

--				print (ref1.tagged_out + ref2.tagged_out + query.result_cursor.item.tagged_out)
--				print (ref1.deep_twin.tagged_out + ref1.deep_twin.is_deep_equal (ref1).out)
--				print (ref1.is_deep_equal (ref3))
				ref4:= query.result_cursor.item
--				print (reflection.dynamic_type (ref3).out + "%N")
--				print (reflection.dynamic_type (ref2).out + "%N")
--				print (reflection.dynamic_type (ref4).out + "%N")
--				print (reflection.dynamic_type (ref1).out)

--				print (reflection.is_attached_type (reflection.dynamic_type (ref3)))
--				print (reflection.class_name (ref2))
--				print (reflection.class_name (ref3))
				assert ("equality", ref3.is_deep_equal (attach (ref1)))
			end

		end

	internal_test
		local
			reflection:INTERNAL
			ref1:REFERENCE_CLASS_1
			list:LINKED_LIST[REFERENCE_CLASS_1]
			i:INTEGER
		do
			create reflection
			create ref1.make (1)

			check
				attached {REFERENCE_CLASS_1}
					reflection.new_instance_of (reflection.detachable_type (reflection.dynamic_type (ref1))) as ref2
				and attached {REFERENCE_CLASS_1}
					reflection.new_instance_of (reflection.attached_type (reflection.dynamic_type (ref1))) as ref3
				then

				from i:=1
				until i> reflection.field_count (ref2)
				loop
					if reflection.field_name (i, ref2).is_case_insensitive_equal ("ref_class_id") then
						reflection.set_integer_32_field (i, ref2, 1)
						reflection.set_integer_32_field (i, ref3, 1)
					elseif reflection.field_name (i, ref2).is_case_insensitive_equal ("references")  then
						create list.make
						reflection.set_reference_field (i, ref2, list)
						create list.make
						reflection.set_reference_field (i, ref3, list)
					end

					i:=i+1
				end

--				print (ref2.tagged_out + ref3.tagged_out)

				assert ("both_types_detachable", ref1.is_deep_equal (ref2))
				assert ("attached_and_detachable_wont_work", not ref1.is_deep_equal (ref3))
			end
		end


	internal_special_experiment
		local
			person_special: SPECIAL[PERSON]
			ref_special: SPECIAL[REFERENCE_CLASS_1]
			detached_ref_special: SPECIAL[detachable REFERENCE_CLASS_1]
			generated_special: ANY
			reflection:INTERNAL
		do
			create reflection

			create person_special.make_empty (10)
			create ref_special.make_empty (10)

			print (reflection.dynamic_type (person_special).out + "%N" )
			print (reflection.dynamic_type (ref_special).out + "%N")
			print (reflection.generic_dynamic_type (person_special, 1).out + "%N" )
			print (reflection.generic_dynamic_type (ref_special, 1).out + "%N")

			--generated_special:= reflection.new_special_any_instance (reflection.generic_dynamic_type (person_special, 1), 10)
			generated_special:= reflection.new_special_any_instance (reflection.dynamic_type (person_special), 10)

			print (reflection.dynamic_type (generated_special).out + "%N" )
			print (generated_special.is_deep_equal (person_special))

			print (person_special.out)
			print (ref_special.out)
			create detached_ref_special.make_filled (Void, 10)
			print (detached_ref_special.out)

		end


	test_generic_objects_type
		local
			list: LIST[ANY]
		do
			create {LINKED_LIST[ANY]} list.make
			print (attached{LIST[PERSON]} list)
			list.extend (create {PERSON}.make("a", "b", 0))
			print (attached{LIST[PERSON]} list)


		end

end
