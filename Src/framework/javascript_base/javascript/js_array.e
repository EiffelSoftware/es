note
	javascript: "NativeStub"
class
	JS_ARRAY[G]

create
	make,
	make_as_obj

feature {NONE} -- Initialization

	make
		external "C" alias "[]" end

	make_as_obj
		external "C" alias "{}" end

feature -- Basic Operation

	get_item_by_name (a_item_name: STRING): G
		external "C" alias "[$a_item_name]" end

	set_item_by_name (a_item_name: STRING; a_item_value: G)
		external "C" alias "[$a_item_name]=$a_item_value" end

	has_item_by_name (a_item_name: STRING): BOOLEAN
		external "C" alias "#$a_item_name in $TARGET" end

	remove_item_by_name (a_item_name: STRING)
		external "C" alias "#delete $TARGET[$a_item_name]" end

	item alias "[]" (a_index: INTEGER) : G
		external "C" alias "[$a_index]" end

	index_of (a_item: G) : INTEGER
		external "C" alias "indexOf($a_item)" end

	index_of2 (a_item: G; a_index: INTEGER) : INTEGER
		external "C" alias "indexOf($a_item, $a_index)" end

	set_item (a_item: G; a_index: INTEGER)
		external "C" alias "[$a_index]=$a_item" end

	length: INTEGER
		external "C" alias "length" end

	push (a_item: G)
		external "C" alias "push($a_item)" end

	splice0 (a_index: INTEGER; a_count: INTEGER)
		external "C" alias "splice($a_index,$a_count)" end

	splice1 (a_index: INTEGER; a_count: INTEGER; a_item: G)
		external "C" alias "splice($a_index,$a_count,$a_item)" end

	as_eiffel_array: attached ARRAY[G]
		external "C" alias "([1].concat($TARGET))" end

end
