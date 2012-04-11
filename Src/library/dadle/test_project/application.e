indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	TC_PLAYER

create
	make

feature -- Initialization

	make is
			-- Run application.
		local
			string:STRING
			obj:ANY
			l_sed_ser: SED_INDEPENDENT_SERIALIZER
			file:RAW_FILE
			client:A_CLIENT
			l_array:ARRAYED_LIST[INTEGER]
			l_int:INTEGER
			l_char:CHARACTER
			a_par:A_PARENT
			tc_special:TC_SPECIAL
			tc_tuple:TC_TUPLE
			tc_large:TC_LARGE
			tc_void:TC_VOID
			custom_ser:SERIALIZED_FORM
			ser:DADL_SERIALIZER
		do
--			create l_array.make(5)

--			create a_class1
--			a_class1.set_my_int (12)
--			a_class1.set_my_bool (false)
--			a_class1.set_my_string ("test_string")
--			a_class1.set_my_string2 ("test_string2")
--			a_class1.set_my_natural (4)
--			a_class1.set_my_real (0.5)
--			a_class1.set_my_char ('t')
--			create client
--			a_class1.set_client2 (client)


--			create a_client
--			a_client.set_my_int (50)
--			a_client.set_parent
--			a_client.set_my_bool (true)
--			a_client.set_my_string ("client_string1")
--			a_client.set_my_string2 ("client_string2")

--			l_array.extend(1)

--			a_class1.set_client (a_client)
--			a_client.set_rek_client (a_class1)
--			--a_class1.init_tuple
--			a_class1.init_pointer
--			--a_class1.init_list
--			a_class1.init_empty
--			--a_class1.init_array
--			--a_class1.init_array2
--			a_class1.init_array3
--			a_class1.init_table
--			--a_class1.init_table2
--			a_class1.set_self_reference

--			create a_par.make ("test",void)

--			create tc_special.make

--			create tc_tuple.make

--			create tc_large.make

--			create tc_void.make

--			obj := deserialize_binary(object_store_path+object3_name)

--			create ser
--			ser.serialize ("c:/tessssst.adls", tc_large)

--			obj := ser.deserialize ("c:/tessssst.adls")

--			run_performance_test

		end


	run_performance_test is
			-- performance tests
		local
			tc_perf5000:TC_STR_PERF5000
			tc_perf1000:TC_STR_PERF1000
			tc_perf500:TC_STR_PERF500
			tc_perf100:TC_STR_PERF100

			tc_int_perf5000:TC_INT_PERF5000
			tc_int_perf1000:TC_INT_PERF1000
			tc_int_perf500:TC_INT_PERF500
			tc_int_perf100:TC_INT_PERF100

			tc_shared_perf1000:TC_SHARED_PERF1000
			tc_shared_perf100:TC_SHARED_PERF100

			tc_custom_perf5000:TC_CUSTOM_PERF5000
			tc_custom_perf1000:TC_CUSTOM_PERF1000
			tc_custom_perf500:TC_CUSTOM_PERF500
			tc_custom_perf100:TC_CUSTOM_PERF100

			res:ANY
			time_start,time_end:TIME
		do
			create tc_perf5000.make
			create tc_perf1000.make
			create tc_perf500.make
			create tc_perf100.make

			create tc_int_perf5000.make
			create tc_int_perf1000.make
			create tc_int_perf500.make
			create tc_int_perf100.make

			create tc_shared_perf1000.make
			create tc_shared_perf100.make

			create tc_custom_perf5000.make
			create tc_custom_perf1000.make
			create tc_custom_perf500.make
			create tc_custom_perf100.make

			IO.put_string ("===STRING SERIALIZING===%N%N")

			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			serialize_binary (tc_perf5000, "z:\tc_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_perf5000_dadl.adls", tc_perf5000)
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_perf5000_c", tc_perf5000)
			create time_end.make_now
			IO.put_string ("C - STRING - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			serialize_binary (tc_perf1000, "z:\tc_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_perf1000_dadl.adls", tc_perf1000)
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_perf1000_c", tc_perf1000)
			create time_end.make_now
			IO.put_string ("C - STRING - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			IO.put_string ("__500__%N%N")
			create time_start.make_now
			serialize_binary (tc_perf500, "z:\tc_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_perf500_dadl.adls", tc_perf500)
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_perf500_c", tc_perf500)
			create time_end.make_now
			IO.put_string ("C - STRING - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			serialize_binary (tc_perf100, "z:\tc_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_perf100_dadl.adls", tc_perf100)
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_perf100_c", tc_perf100)
			create time_end.make_now
			IO.put_string ("C - STRING - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("===CUSTOM OBJECT SERIALIZING===%N%N")

			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			serialize_binary (tc_custom_perf5000, "z:\tc_custom_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_custom_perf5000_dadl.adls", tc_custom_perf5000)
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_custom_perf5000_c", tc_custom_perf5000)
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			serialize_binary (tc_custom_perf1000, "z:\tc_custom_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_custom_perf1000_dadl.adls", tc_custom_perf1000)
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_custom_perf1000_c", tc_custom_perf5000)
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__500__%N%N")
			create time_start.make_now
			serialize_binary (tc_custom_perf500, "z:\tc_custom_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_custom_perf500_dadl.adls", tc_custom_perf500)
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_custom_perf500_c", tc_custom_perf5000)
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			IO.put_string ("__100__%N%N")
			create time_start.make_now
			serialize_binary (tc_custom_perf100, "z:\tc_custom_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_custom_perf100_dadl.adls", tc_custom_perf100)
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_custom_perf100_c", tc_custom_perf5000)
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")



			IO.put_string ("===INTEGER SERIALIZING===%N%N")


			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			serialize_binary (tc_int_perf5000, "z:\tc_int_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_int_perf5000_dadl.adls", tc_int_perf5000)
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_int_perf5000_c", tc_int_perf5000)
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf5000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			serialize_binary (tc_int_perf1000, "z:\tc_int_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_int_perf1000_dadl.adls", tc_int_perf1000)
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_int_perf1000_c", tc_int_perf1000)
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__500__%N%N")
			create time_start.make_now
			serialize_binary (tc_int_perf500, "z:\tc_int_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_int_perf500_dadl.adls", tc_int_perf500)
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_int_perf500_c", tc_int_perf500)
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf500 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			serialize_binary (tc_int_perf100, "z:\tc_int_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_int_perf100_dadl.adls", tc_int_perf100)
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_int_perf100_c", tc_int_perf100)
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("===SHARED OBJECTS SERIALIZING===%N%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			serialize_binary (tc_shared_perf1000, "z:\tc_shared_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - SHARED - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_shared_perf1000_dadl.adls", tc_shared_perf1000)
			create time_end.make_now
			IO.put_string ("dADL - SHARED - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_shared_perf1000_c", tc_shared_perf1000)
			create time_end.make_now
			IO.put_string ("C - SHARED - Perf1000 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			serialize_binary (tc_shared_perf100, "z:\tc_shared_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - SHARED - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_dadl ("z:\tc_shared_perf100_dadl.adls", tc_shared_perf100)
			create time_end.make_now
			IO.put_string ("dADL - SHARED - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			serialize_c ("z:\tc_shared_perf100_c", tc_shared_perf1000)
			create time_end.make_now
			IO.put_string ("C - SHARED - Perf100 - Serializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("===STRING DESERIALIZING===%N%N")

			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_perf5000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_perf5000_c")
			create time_end.make_now
			IO.put_string ("C - STRING - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_perf1000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_perf1000_c")
			create time_end.make_now
			IO.put_string ("C - STRING - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__500__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_perf500_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_perf500_c")
			create time_end.make_now
			IO.put_string ("C - STRING - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - STRING - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_perf100_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - STRING - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_perf100_c")
			create time_end.make_now
			IO.put_string ("C - STRING - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			IO.put_string ("===CUSTOM OBJECT DESERIALIZING===%N%N")

			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_custom_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_custom_perf5000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_custom_perf5000_c")
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_custom_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_custom_perf1000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_custom_perf1000_c")
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__500__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_custom_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_custom_perf500_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_custom_perf500_c")
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")



			IO.put_string ("__100__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_custom_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - CUSTOM OBJECT - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_custom_perf100_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - CUSTOM OBJECT - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_custom_perf100_c")
			create time_end.make_now
			IO.put_string ("C - CUSTOM OBJECT - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")



			IO.put_string ("===INTEGER DESERIALIZING===%N%N")


			IO.put_string ("__5000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_int_perf5000_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_int_perf5000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_int_perf5000_c")
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf5000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_int_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_int_perf1000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_int_perf1000_c")
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__500__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_int_perf500_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_int_perf500_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_int_perf500_c")
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf500 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_int_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - INTEGER - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_int_perf100_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - INTEGER - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_int_perf100_c")
			create time_end.make_now
			IO.put_string ("C - INTEGER - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("===SHARED OBJECTS DESERIALIZING===%N%N")


			IO.put_string ("__1000__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_shared_perf1000_binary")
			create time_end.make_now
			IO.put_string ("Binary - SHARED - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_shared_perf1000_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - SHARED - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_shared_perf1000_c")
			create time_end.make_now
			IO.put_string ("C - SHARED - Perf1000 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")


			IO.put_string ("__100__%N%N")
			create time_start.make_now
			res := deserialize_binary ("z:\tc_shared_perf100_binary")
			create time_end.make_now
			IO.put_string ("Binary - SHARED - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_dadl ("z:\tc_shared_perf100_dadl.adls")
			create time_end.make_now
			IO.put_string ("dADL - SHARED - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")

			create time_start.make_now
			res := deserialize_c ("z:\tc_shared_perf100_c")
			create time_end.make_now
			IO.put_string ("C - SHARED - Perf100 - DEserializing: "+time_end.relative_duration (time_start).out+"%N")




			IO.read_line

		end



	deserialize_binary(a_path:STRING):ANY is
			--
		local
			file:RAW_FILE
			ind_des:SED_INDEPENDENT_DESERIALIZER
			te:STRING
			obj:ANY
		do
			create file.make(a_path)
			create serializer.make(file)
			file.open_read
			serializer.set_for_reading
			Result := store_handler.retrieved (serializer, false)
			create ind_des.make (serializer)
		end

	serialize_binary(a_obj:ANY;a_path:STRING) is
			--
		local
			file:RAW_FILE
		do
			create file.make(a_path)
			create serializer.make(file)
			if file.exists then
				file.open_write
			else
				file.open_write
			end
			serializer.set_for_writing
			store_handler.independent_store (a_obj,serializer,false)

		end


	serialize_c(a_path:STRING;a_obj:ANY) is
			--
		local
			file:RAW_FILE
		do
			create file.make(a_path)
			if file.exists then
				file.open_write
			else
				file.open_write
			end
			file.independent_store (a_obj)
		end

	deserialize_c(a_path:STRING):ANY is
			--
		local
			file:RAW_FILE
		do
			create file.make(a_path)
			file.open_read
			Result := file.retrieved
		end



feature --access

--	store_handler:DECODE_FACILITY
	store_handler:SED_STORABLE_FACILITIES
	serializer: SED_MEDIUM_READER_WRITER

	object_store_path:STRING is "W:\masterthesis\mas\test_objects\"
	object1_name:STRING is "amy1"
	object2_name:STRING is "amy2"
	object3_name:STRING is "_save2"
	object4_name:STRING is "_save2_old"

	a_class1:MY_CLASS1
	a_client:A_CLIENT



end -- class APPLICATION
