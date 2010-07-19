class
	TEST
inherit
	INTERNAL
creation
	make
feature

	make
		local
			l_list: ARRAYED_LIST [HASH_TABLE [TUPLE [PROCEDURE [ANY, TUPLE]], TUPLE [STRING_GENERAL]]]
			l_field, l_dtype1, l_dtype2, l_dummy: INTEGER
		do
			l_dummy := dynamic_type_from_string ("ARRAY [STRING]")

			l_dtype1 := dynamic_type_from_string ("ARRAYED_LIST [HASH_TABLE [TUPLE [PROCEDURE [ANY, TUPLE]], TUPLE [STRING_GENERAL]]]")
			create l_list.make (0)
			l_dtype2 := l_list.generating_type.type_id

			if l_dtype1 = l_dtype2 then
				{RT_CAPTURE_REPLAY}.print_string ("OK%N")
			else
				{RT_CAPTURE_REPLAY}.print_string (l_dtype1.out + " /= ")
				{RT_CAPTURE_REPLAY}.print_string (l_dtype2.out + "%N")
			end

			l_dtype1 := dynamic_type_from_string ("SPECIAL [HASH_TABLE [TUPLE [PROCEDURE [ANY, TUPLE]], TUPLE [STRING_GENERAL]]]")
			from
				l_field := 1
			until
				l_field > field_count (l_list)
			loop
				if field_name (l_field, l_list).same_string ("area_v2") then
					l_dtype2 := field_static_type_of_type (l_field, dynamic_type (l_list))
				end
				l_field := l_field + 1
			end

			if l_dtype1 = l_dtype2 then
				{RT_CAPTURE_REPLAY}.print_string ("OK%N")
			else
				{RT_CAPTURE_REPLAY}.print_string (l_dtype1.out + " /= ")
				{RT_CAPTURE_REPLAY}.print_string (l_dtype2.out + "%N")
			end
		end;

	external_routine
		external
			"C inline use <stdio.h>"
		alias
			"[
				printf("external_routine output\n");
			]"
		end

end

