note
	description: "Utility for test case serialization"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_TEST_CASE_SERIALIZATION_UTILITY

feature -- Access

	serialized_object (a_object: ANY): STRING is
	        -- Serialize `a_object'.
			-- Fixme: The STREAM class is used because for the moment,
			-- the SED related classes do not support expanded types.
			-- Once this is fixed, use the following commented `deserialize' feature. Jasonw 2009.10.12
	    require
	        a_object_not_void: a_object /= Void
		local
			l_stream: STREAM
	    do
	    	create l_stream.make_with_size (512)
	    	l_stream.independent_store (a_object)
	    	Result := string_from_pointer (l_stream.item, l_stream.object_stored_size)
	    	l_stream.close
	    ensure
	        serialize_not_void: Result /= Void
	    end

	deserialized_object (a_string: STRING): detachable ANY is
			-- Object deserialized from `a_string'
			-- Fixme: The STREAM class is used because for the moment,
			-- the SED related classes do not support expanded types.
			-- Once this is fixed, use the following commented `deserialize' feature. Jasonw 2009.10.12
		local
			l_stream: STREAM
			l_mptr: MANAGED_POINTER
			l_count: INTEGER
			i: INTEGER
		do
			l_count := a_string.count
			create l_stream.make_with_size (l_count)
			create l_mptr.share_from_pointer (l_stream.item, l_count)

			from
				i := 0
			until
				i = l_count
			loop
				l_mptr.put_character (a_string.item (i + 1), i)
				i := i + 1
			end

			Result := l_stream.retrieved
			l_stream.close
		end

--	serialized_object (a_object: ANY): STRING is
--	        -- Serialize `a_object'.
--	    require
--	        a_object_not_void: a_object /= Void
--	    local
--	        l_sed_rw: SED_MEMORY_READER_WRITER
--	        l_sed_ser: SED_INDEPENDENT_SERIALIZER
--	        l_cstring: C_STRING
--	        l_cnt: INTEGER
--	    do
--	        create l_sed_rw.make
--	        l_sed_rw.set_for_writing
--	        create l_sed_ser.make (l_sed_rw)
--	        l_sed_ser.set_root_object (a_object)
--	        l_sed_ser.encode
--	            -- the `count' gives us the number of bytes
--	            -- we have to read and put into the string.
--	        l_cnt := l_sed_rw.count
--	        create l_cstring.make_by_pointer_and_count (l_sed_rw.buffer.item, l_cnt)
--	        Result := l_cstring.substring (1, l_cnt)
--	    ensure
--	        serialize_not_void: Result /= Void
--	    end

--	deserialized_object (a_string: STRING): detachable ANY is
--	        -- Deserialize `a_string'.
--	    require
--	        a_string_not_void: a_string /= Void
--	    local
--	        l_sed_rw: SED_MEMORY_READER_WRITER
--	        l_sed_ser: SED_INDEPENDENT_DESERIALIZER
--	        l_cstring: C_STRING
--	    do
--	        create l_cstring.make (a_string)
--	        create l_sed_rw.make_with_buffer (l_cstring.managed_data)
--	        l_sed_rw.set_for_reading
--	        create l_sed_ser.make (l_sed_rw)
--	        l_sed_ser.decode (True)
--	        Result := l_sed_ser.last_decoded_object
--	    end

feature{NONE} -- Implementation

	string_from_pointer (a_pointer: POINTER; a_size: INTEGER): STRING is
			-- String containing data stored in `a_pointer' with `a_size' bytes
		local
			l_mptr: MANAGED_POINTER
			i: INTEGER
		do
			create l_mptr.make_from_pointer (a_pointer, a_size)
			create Result.make_filled ('0', a_size)
			from
				i := 0
			until
				i = a_size
			loop

				Result.put (l_mptr.read_character (i), i + 1)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
			result_valid: Result.count = a_size
		end


note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
