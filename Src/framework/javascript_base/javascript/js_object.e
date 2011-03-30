note
	javascript: "NativeStub"
class
	JS_OBJECT

feature -- Access

	window : attached JS_WINDOW
		external
			"C"
		alias "#window"
		end

	console : attached JS_CONSOLE
		external
			"C"
		alias "#console"
		end

feature -- Basic Operation

	toJSON: attached STRING
		external
			"C"
		alias "#JSON.stringify($TARGET)"
		end

feature {NONE} -- Force compilation

	base_any: EIFFEL_ANY
	base_array: EIFFEL_ARRAY[STRING]
	base_boolean: EIFFEL_BOOLEAN
	base_character: EIFFEL_CHARACTER
	base_double_math: EIFFEL_DOUBLE_MATH
	base_function: EIFFEL_FUNCTION[ANY, attached TUPLE[ANY], BOOLEAN]
	base_hash_table: EIFFEL_HASH_TABLE[STRING, attached STRING]
	base_integer: EIFFEL_INTEGER
	base_list: EIFFEL_LIST[STRING]
	base_procedure: EIFFEL_PROCEDURE[ANY, attached TUPLE[ANY]]
	base_real: EIFFEL_REAL
	base_set: EIFFEL_SET[attached STRING]
	base_string: EIFFEL_STRING
	base_tuple: EIFFEL_TUPLE

end
