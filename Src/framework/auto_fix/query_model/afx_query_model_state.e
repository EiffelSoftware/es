note
	description:
		"[
			Each model state consists of (possibly) multiple object states, i.e. a list of {AFX_STATE}'s.
			Model states are used to represent the starting/ending states of feature call/transitions.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_STATE

inherit
	DS_ARRAYED_LIST [EPA_STATE]
		redefine
			make
		end

	EPA_HASH_CALCULATOR
    	undefine
    		is_equal,
    		copy
    	end

    AFX_SHARED_FORMAL_TYPE_MANAGER
    	undefine
    		is_equal,
    		copy
    	end

    DEBUG_OUTPUT
    	undefine
    		is_equal,
    		copy
    	end

create
    make

feature -- Initialization

	make (a_size: INTEGER)
			-- <Precursor>
		do
		    Precursor (a_size)
		    set_equality_tester (create {EPA_STATE_EQUALITY_TESTER})
		    is_good := True
		end

feature -- State extraction

	extract_state (a_heap: DS_HASH_TABLE [EPA_STATE, INTEGER]; a_request: AUT_CALL_BASED_REQUEST; is_before_request: BOOLEAN)
			-- Extract the model state for `a_request' from `a_heap'.
			-- If `is_before_request', create chaos states for creation object and query result.
		require
		    is_empty: is_empty
		local
		    l_formal_type_manager: like formal_type_manager
		    l_array_of_type: DS_ARRAYED_LIST[TYPE_A]
		    l_indexes: SPECIAL[INTEGER]
		    l_index: INTEGER
		    l_class: CLASS_C
		    l_type: TYPE_A
		    l_state: EPA_STATE
		    i: INTEGER
		    l_skip_creation_target, l_skip_query_result: BOOLEAN
		do
		    l_formal_type_manager := formal_type_manager
		    check l_formal_type_manager /= Void end

		    l_array_of_type := l_formal_type_manager.query_feature_formal_types (a_request.feature_to_call, a_request.target_type)
		    l_indexes := a_request.operand_indexes
		    check l_array_of_type.count = l_indexes.count end

		    from
		    	i := 0
		    	l_array_of_type.start
		    until
		    	i = l_indexes.count
		    loop
		        l_index := l_indexes.item (i)
		        l_type := l_array_of_type.item_for_iteration
		        l_class := l_type.associated_class

		        if i = 0 and then attached {AUT_CREATE_OBJECT_REQUEST} a_request as lt_creation and then is_before_request then
    		        	-- target object of creation in src state is chaos
            		create l_state.make_chaos (l_class)
           		    force_last (l_state)

           		    debug("autofix_state_extraction")
           		    	l_skip_creation_target := True
           		    end
           		elseif i = l_indexes.count - 1 and then attached {AUT_INVOKE_FEATURE_REQUEST} a_request as lt_invocation
           						and then lt_invocation.is_feature_query and then is_before_request then
           				-- query result in src state is chaos
           			create l_state.make_chaos (l_class)
           		    force_last (l_state)

           		    debug("autofix_state_extraction")
           		    	l_skip_query_result := True
           		    end
           		else
           		    	-- normal cases
           		    	-- Note that here we map the original state to a new state conforming to the object's static interface
           		    if attached a_heap.value(l_index) as lt_state then
	           		    create l_state.make_from_state (lt_state, l_type)
           		        force_last (l_state)
	           		else
	           		    is_good := False
	           		end
       		    end
		        l_array_of_type.forth
		        i := i + 1
		    end

            debug("autofix_state_extraction")
            	if l_skip_creation_target then print ("skip creation target.%N") end
            	do_all (agent (a_state: EPA_STATE) do print (a_state.debug_output) end)
            	if l_skip_query_result then print ("skip query result.%N") end
            end

		ensure
		    same_size: is_good implies a_request.operand_indexes.count = count
		end

feature -- Status report

	debug_output: STRING
			-- <Precursor>
		do
		    create Result.make (512)
		    do_all (
		    	agent (a_state: EPA_STATE; a_string: STRING)
		    		do
		    		    a_string.append ("++")
		    		    a_string.append (a_state.class_.name)
		    		    a_string.append ("++%N")
		    		    a_string.append (a_state.debug_output)
		    		    a_string.append ("%N")
		    		end (?, Result))
		end

	is_good: BOOLEAN
			-- Is this model state good for use?

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (count)
			from start
			until after
			loop
				l_list.force_last (item_for_iteration.hash_code)
				forth
			end

			Result := l_list
		end


;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
