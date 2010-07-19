class
	TEST
inherit
	INTERNAL
creation
	make
feature

	make
		do
			if attached external_routine as l_any then
				{RT_CAPTURE_REPLAY}.print_string (l_any.generating_type.name)
				{RT_CAPTURE_REPLAY}.print_string ("%N")
			end
		end;

	external_routine: ANY
		external
			"C inline use <eif_cecil.h>"
		alias
			"[
				int dtype_id;
				char *type_name = "ARRAYED_LIST [ARRAYED_LIST [INTEGER]]";
				dtype_id = eif_type_id (type_name);
				
				type_name = "ARRAYED_LIST [HASH_TABLE [TUPLE [PROCEDURE [ANY, TUPLE]], TUPLE [STRING_GENERAL]]]";
				
				return emalloc (eif_type_id (type_name));

			]"
		end

end

