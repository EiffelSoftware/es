note
	description: "Summary description for {EQA_SERIALIZED_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_SERIALIZED_TEST_SET

inherit
	EQA_TEST_SET

	EQA_TEST_CASE_SERIALIZATION_UTILITY

feature -- Access

	pre_serialization: STRING
			-- Serialization data for objects before the test case execution.
		deferred
		end

	post_serialization: STRING
			-- Serialization data for objects after the test case execution.
		deferred
		end

    pre_operands_table: HASH_TABLE [detachable ANY, INTEGER]
    		-- Table of the feature operands and the variables reachable from these operands.
    		-- Key: variable index.
    		-- Value: object.
    	do
    		if pre_operands_table_cache = Void then
    			pre_operands_table_cache := deserialized_operands_table (pre_serialization)
    		end
    		Result := pre_operands_table_cache
    	end

    post_operands_table: HASH_TABLE [detachable ANY, INTEGER]
    		-- Table of the feature operands and the variables reachable from these operands.
    		-- Key: variable index.
    		-- Value: object.
    	do
    		if post_operands_table_cache = Void then
    			post_operands_table_cache := deserialized_operands_table (post_serialization)
    		end
    		Result := post_operands_table_cache
    	end

feature{NONE} -- Implementation

	pre_operands_table_cache: detachable like pre_operands_table
			-- Internal cache for `pre_operands_table'.

	post_operands_table_cache: detachable like post_operands_table
			-- Internal cache for `post_operands_table'.

    deserialized_operands_table (a_string: STRING): HASH_TABLE [detachable ANY, INTEGER]
            -- Deserialize the objects from 'a_string'
            -- (as object of type {SPECIAL [TUPLE [INTEGER, detachable ANY]]})
            -- and store the objects into the Result hashtable.
        local
            l_data: STRING
            l_index: INTEGER
            l_operands_table: HASH_TABLE [detachable ANY, INTEGER]
        do
            l_data := a_string
            if attached {SPECIAL [TUPLE [index: INTEGER; var: detachable ANY]]}deserialized_object (l_data) as lt_operands then
                from
                    create l_operands_table.make (lt_operands.count + 1)
                    l_operands_table.compare_objects
                    l_index := lt_operands.lower
                until
                    l_index > lt_operands.upper
                loop
                    l_operands_table.put (lt_operands[l_index].var, lt_operands[l_index].index)
                    l_index := l_index + 1
                end
            else
                check bad_serialization_data: False end
            end
            Result := l_operands_table
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
