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

--	serialized_object_through_file (a_object: ANY; a_file_name: STRING): STRING is
--	        -- Serialize `a_object'.
--			-- The serialiation is done through a file specified by `a_file_name'.
--			-- FIXME: This is a walkaround for the problem that the serialization through
--			-- FIXME: STREAM does not work. 31.5.2010 Jasonw
--	    require
--	        a_object_not_void: a_object /= Void
--		local
--			l_stream: STREAM
--			l_file: RAW_FILE
--	    do
--	    	create l_file.make_create_read_write (a_file_name)
--	    	l_file.independent_store (a_object)
--	    	l_file.start
--	    	l_file.read_stream (l_file.count)
--	    	Result := l_file.last_string.twin
--	    	l_file.close
--	    ensure
--	        serialize_not_void: Result /= Void
--	    end

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

	deserialized_object_through_file (a_file_name: STRING): detachable ANY is
			-- Object deserialized from `a_string'
			-- FIXME: This is a walkaround for the problem that the serialization through
			-- FIXME: STREAM does not work. 31.5.2010 Jasonw			
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_name)
			Result ?= l_file.retrieved
			l_file.close
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
			l_cstring: C_STRING
		do
			create l_cstring.make_shared_from_pointer_and_count (a_pointer, a_size)
			Result := l_cstring.substring (1, a_size)
		ensure
			result_attached: Result /= Void
			result_valid: Result.count = a_size
		end


    string_from_array (a_array: ARRAY [NATURAL_8]): STRING is
            -- String from `a_array'.
        local
            l_lower, l_upper: INTEGER
            i: INTEGER
            j: INTEGER
        do
            l_lower := a_array.lower
            l_upper := a_array.upper
            create Result.make_filled (' ', l_upper - l_lower + 1)
            from
                j := 1
                i := l_lower
            until
                i > l_upper
            loop
                Result.put (a_array.item (i).to_character_8, j)
                i := i + 1
                j := j + 1
            end
        end

    deserialized_variable_table (a_serialization: ARRAY [NATURAL_8]): HASH_TABLE [detachable ANY, INTEGER]
            -- Deserialize the objects from 'a_serialization'
            -- as object of type SPECIAL [detachable ANY] in format:
            -- [object1_index, object1, object2_index, object2, ... , objectn_index, objectn]
            -- and store the objects into the Result hashtable.
        local
            l_data: STRING
            l_obj_index: INTEGER
            l_variable_table: HASH_TABLE [detachable ANY, INTEGER]
            l_count: INTEGER
            i: INTEGER
        do
            l_data := string_from_array (a_serialization)
            if attached {SPECIAL [detachable ANY]} deserialized_object (l_data) as lt_variable then
            	l_count := lt_variable.count
                from
                    create l_variable_table.make (l_count + 1)
                    l_variable_table.compare_objects
                    i := 0
                until
                    i >= l_count - 1
                loop
                	l_obj_index ?= lt_variable.item (i)

                    l_variable_table.put (lt_variable.item (i + 1), l_obj_index)
                    i := i + 2
                end
            else
                create l_variable_table.make (0)
            end
            Result := l_variable_table
        end

feature{NONE} -- Implementation


    keys_from_table (a_tbl: HASH_TABLE [detachable ANY, INTEGER]): STRING
    		-- A string containing comma separated indexes of keys in `a_tbl'
    	local
    		l_cursor: CURSOR
    		i: INTEGER
    		l_count: INTEGER
    	do
    		l_cursor := a_tbl.cursor
    		create Result.make (64)
    		from
    			i := 1
    			l_count := a_tbl.count
    			a_tbl.start
    		until
    			a_tbl.after
    		loop
    			Result.append (a_tbl.key_for_iteration.out)
    			if i < l_count then
    				Result.append_character (',')
    			end
    			i := i + 1
    			a_tbl.forth
    		end
    		a_tbl.go_to (l_cursor)
    	end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
