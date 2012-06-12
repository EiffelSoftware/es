note
	description: "Some experiments done during the development of ABEL."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_EXPERIMENTS

inherit
	EQA_TEST_SET


feature

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
