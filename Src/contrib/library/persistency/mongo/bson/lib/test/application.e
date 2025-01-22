note
	description: "test application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			print ("Test BSON from JSON%N")
			test_creeate_bson_from_json
			print ("Test BSON Empty Document%N")
			test_create_empty_document
			print ("%N Test BSON Document%N")
			test_bson_document
			print ("%N Test BSON Sub Document%N")
			test_bson_sub_document
			print ("%N Test BSON Sub Array%N")
			test_bson_sub_array
			print ("%N Test BSON Binary%N")
			test_bson_binary
			print ("%N Test BSON Null%N")
			test_bson_null
			print ("%N Test BSON OID%N")
			test_bson_oid
			print ("%N Test BSON append OID%N")
			test_bson_append_oid
			print ("%N Test BSON Bool%N")
			test_bson_bool
			print ("%N Test BSON time_t%N")
			test_bson_time_t
			print ("%N Test BSON timestamp%N")
			test_bson_timestamp
			print ("%N Test BSON regex%N")
			test_bson_regex
			print ("%N Test BSON max and min keys%N")
			test_bson_max_min_keys
			print ("%N Test BSON Big Decimal%N")
			test_bson_big_decimal
			print ("%N Test BSON code%N")
			test_bson_code
			print ("%N Test BSON code with scope%N")
			test_bson_code_scope
			print ("%N Test BSON array as json%N")
			test_bson_array_as_json
			print ("%N Test BSON json reader%N")
			test_json_bson_reader
			print ("%N Test BSON json iterator%N")
			test_iterator

		end

	time
		local
			l_time: DATE_TIME
			l_time2: DATE_TIME
			l_dur: DATE_TIME_DURATION
		do
			create l_time2.make_now_utc
			create l_time.make_from_epoch (0)

			print ("%Nl_time2:" +l_time2.out)
			l_dur := l_time2.relative_duration (l_time)
			print ("%Nl_time1:"  +l_time.out)
			print ("%N Duration:" + l_dur.seconds_count.out)
		end

	decimal_128
		local
			l_dec: BSON_DECIMAL_128
		do
			create l_dec.make
			l_dec.set_high (0x302a000000000000)
			l_dec.set_low (0x00000000075aef40)
			print (l_dec.to_string)
			io.put_new_line
			create l_dec.make_with_string ("0.1234567890123456789012345678901234")
			print (l_dec.to_string)
			io.put_new_line
			print (l_dec.high)
			io.put_new_line
			print (l_dec.low)
--			3457705539973125938
--			-2413264399770406926
			create l_dec.make
			l_dec.set_high (3457705539973125938)
			l_dec.set_low (-2413264399770406926)
			io.put_new_line
			print (l_dec.to_string)
		end

	test_create_empty_document
		local
			l_bson: BSON
		do
				-- This creates an empty document. In JSON, this would be the same as {}.
			create l_bson.make
			print (l_bson.bson_as_json)
		end



	test_creeate_bson_from_json
		local
			l_bson: BSON
		do
				-- This creates an empty document. In JSON, this would be the same as {}.
			create l_bson.make
			print (l_bson.bson_as_json)
		end

	test_bson_document
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_utf8 ("key", "value")
			l_bson.bson_append_boolean ("is_eiffel", True)
			l_bson.bson_append_integer_32 ("number", 10)
			l_bson.bson_append_double ("double", 5.12)
			print (l_bson.bson_as_json)
			io.put_new_line
			print (l_bson.bson_as_canonical_extended_json)
		end

	test_bson_sub_document
		local
			l_bson: BSON
			l_new_doc: BSON
		do
			create l_bson.make
			l_bson.bson_append_utf8 ("key", "value")
			l_bson.bson_append_boolean ("is_eiffel", True)
			l_bson.bson_append_integer_32 ("number", 10)
			l_bson.bson_append_double ("double", 5.12)
				-- Sub document
			l_new_doc := l_bson.bson_append_document_begin ("test")
			l_new_doc.bson_append_integer_32 ("baz", 1)
			l_bson.bson_append_document_end (l_new_doc)
			print (l_bson.bson_as_json)
			io.put_new_line
		end

	test_bson_sub_array
		local
			l_bson: BSON
			l_new_array: BSON
		do
			create l_bson.make
			l_bson.bson_append_utf8 ("key", "value")
			l_bson.bson_append_boolean ("is_eiffel", True)
			l_bson.bson_append_integer_32 ("number", 10)
			l_bson.bson_append_double ("double", 5.12)

			l_new_array := l_bson.bson_append_arrary_begin ("array")
			l_new_array.bson_append_integer_32 ("0", 1)
			l_new_array.bson_append_integer_32 ("1", 2)
			l_new_array.bson_append_integer_32 ("1", 3)
			l_bson.bson_append_array_end (l_new_array)

			print (l_bson.bson_as_json)
		end

	test_bson_binary
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_binary ("test", {BSON_SUBTYPE}.BSON_SUBTYPE_BINARY, {ARRAY [NATURAL_8]}<<0, 1, 2, 3, 4>>)
			print (l_bson.bson_as_json)
		end

	test_bson_null
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_null ("my_key")
			print (l_bson.bson_as_json)
		end

	test_bson_oid
		local
			l_oid: BSON_OID
		do
			create l_oid.make_with_string ("123412341234abcdabcdabcd")
			print (l_oid.oid_to_string)
		end

	test_bson_append_oid
		local
			l_bson: BSON
			l_oid: BSON_OID
		do
			create l_bson.make
			create l_oid.make_with_string ("123412341234abcdabcdabcd")
			l_bson.bson_append_oid ("oid", l_oid)
			print (l_bson.bson_as_json)
		end

	test_bson_bool
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_boolean ("true", True)
			l_bson.bson_append_boolean ("false", False)
			print (l_bson.bson_as_json)
		end


	test_bson_time_t
		local
			l_bson: BSON
			l_time: DATE_TIME
			l_time2: DATE_TIME
			l_dur: DATE_TIME_DURATION
		do
			create l_time2.make_now_utc
			create l_time.make_from_epoch (0)
			l_dur := l_time2.relative_duration (l_time)

			create l_bson.make
			l_bson.bson_append_time ("time_t", l_dur.seconds_count)
			print (l_bson.bson_as_json)
		end


	test_bson_timestamp
		local
			l_bson: BSON
			l_time: DATE_TIME
			l_time2: DATE_TIME
			l_dur: DATE_TIME_DURATION
		do
			create l_time2.make_now_utc
			create l_time.make_from_epoch (0)
			l_dur := l_time2.relative_duration (l_time)

			create l_bson.make
			l_bson.bson_append_timestamp ("time_t", l_dur.seconds_count, 1234)
			print (l_bson.bson_as_json)
		end

	test_bson_regex
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_regex ("regex", "^abcd", "xi")
			print (l_bson.bson_as_json)
		end

	test_bson_max_min_keys
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_maxkey ("max_key")
			l_bson.bson_append_minkey ("min_key")
			print (l_bson.bson_as_json)
		end


	test_bson_big_decimal
		local
			l_bson: BSON
			l_dec: BSON_DECIMAL_128
		do
			create l_dec.make_with_string ("0.1234567890123456789012345678901234")
			create l_bson.make
			l_bson.bson_append_decimal128 ("decimal_128", l_dec)
			print (l_bson.bson_as_json)
		end


	test_bson_code
		local
			l_bson: BSON
		do
			create l_bson.make
			l_bson.bson_append_code ("Code", "function() {}")
			print (l_bson.bson_as_json)
		end


	test_bson_code_scope
		local
			l_bson: BSON
			l_scope: BSON

		do
			create l_scope.make
			create l_bson.make
			l_bson.bson_append_code_scope ("CodeWithScope", "function() {}", l_scope)
			print (l_bson.bson_as_json)
		end

	test_bson_array_as_json
		local
			l_bson: BSON
		do
			--  BSON array is a normal BSON document with integer values for the keys,
    		-- starting with 0 and continuing sequentially
			create l_bson.make
			l_bson.bson_append_utf8 ("0", "foo")
			l_bson.bson_append_utf8 ("1", "bar")
			print (l_bson.bson_array_as_json)
   		end

   	test_json_bson_reader
   		local
   			l_bson_reader: BSON_JSON_READER
   			l_file: PATH
   			l_bson: BSON
   		do
   			create l_file.make_from_string ("test.json")
   			create l_bson_reader.make (l_file)
   			create l_bson.make
   			l_bson_reader.bson_json_reader_read (l_bson)
   			print (l_bson.bson_as_json)
   		end


	  test_iterator
   		local
   			l_bson_reader: BSON_JSON_READER
   			l_file: PATH
   			l_bson: BSON
   			l_iter: BSON_ITERATOR
   			l_bool: BOOLEAN
   		do
   			create l_file.make_from_string ("test.json")
   			create l_bson_reader.make (l_file)
   			create l_bson.make
   			l_bson_reader.bson_json_reader_read (l_bson)

   				-- Iterator
   			create l_iter.make
   			l_iter.bson_iter_init (l_bson)
   			from
   				l_bool := l_iter.bson_iter_next
   				if l_bool then
   					print ("%NKey :"+l_iter.bson_iter_key)
   				end

   			until
   				not l_bool
   			loop
   				l_bool := l_iter.bson_iter_next
   				if l_bool then
   					print ("%NKey :"+l_iter.bson_iter_key)
   				end
   			end

   		end


end
