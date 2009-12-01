note
	description: "Summary description for {AFX_QUERY_MODEL_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_STATE

inherit
	DS_ARRAYED_LIST [AFX_STATE]
		redefine
		    make
		end

	AFX_HASH_CALCULATOR
    	undefine
    		is_equal,
    		copy
    	end

create
    make

feature -- initialization

	make (a_size: INTEGER)
			-- <Precursor>
		do
		    Precursor (a_size)
		    set_equality_tester (create {AFX_STATE_EQUALITY_TESTER})
		    is_good := True
		end

feature -- state extraction

	extract_state (a_heap: DS_HASH_TABLE [AFX_STATE, INTEGER]; a_request: AUT_CALL_BASED_REQUEST; is_before_request: BOOLEAN)
			-- extract the model state
			-- ======================================= fixme: rewrite the feature ===========================================
		local
		    l_size: INTEGER
		    l_indexes: SPECIAL[INTEGER]
		    l_type_names: SPECIAL[STRING]
		    l_index: INTEGER
		    l_class: CLASS_C
		    l_class_id: INTEGER
		    l_args: FEAT_ARG
		    l_type: TYPE_A
		    l_target_type: TYPE_A
		    l_type_name: STRING
		    l_state: AFX_STATE
		    i, l_start, l_end: INTEGER
		    l_need_chaos_receiver, l_need_receiver: BOOLEAN
		do
		    l_size := a_request.operand_indexes.count
		    l_target_type := a_request.target_type

		    if attached {AUT_CREATE_OBJECT_REQUEST} a_request as l_creation then
		        if is_before_request then
        		    	-- target object to be created
        		    create l_state.make_chaos (l_creation.target_type.associated_class)
        		    force_last (l_state)

        		    l_start := 1
        		else
        		    l_start := 0
		        end
       		    l_end := l_size - 1
       		elseif attached {AUT_INVOKE_FEATURE_REQUEST} a_request as l_invocation  then
       		    l_start := 0
       		    if l_invocation.is_feature_query then
       		        l_need_receiver := True
       		    	if is_before_request then
       		        		-- skip the receiver
       		        	l_need_chaos_receiver := True
       		        end
       		        l_end := l_size - 2
       		    else
       		        l_end := l_size - 1
       		    end
		    end

		        -- extract target object in normal situation
		    if l_start = 0 then
		        l_class_id := l_target_type.associated_class.class_id
		        l_index := a_request.target.index

		        a_heap.search (l_index)
--		        ll_state := a_heap.found_item
--		        check ll_state /= Void and then  end
		        if attached a_heap.found_item as ll_state and then ll_state.class_.class_id = l_class_id then
		            force_last (ll_state)
		        else
		        		-- necessary starting state is missing
		        	check False end
		            is_good := False
		        end
		        l_start := l_start + 1
		    end

				-- extract the arguments from heap
		    l_indexes := a_request.operand_indexes
		    l_args := a_request.feature_to_call.arguments
		    if l_args /= Void then
    		    from
    		        i := l_start
    		        l_args.start
    		    until
    		        i > l_end or not is_good
    		    loop
    		        check not l_args.after end
    		        	-- instantiate generic types in the context of target type
    		        l_class_id := l_args.item_for_iteration.actual_type
    		        		.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class.class_id
    		        l_index := l_indexes[i]

    		        a_heap.search (l_index)
    		        if attached a_heap.found_item as ll_state and then ll_state.class_.class_id = l_class_id then
    		            force_last (ll_state)
    		        else
    		        		-- necessary starting state is missing
    		        	check False end
    		            is_good := False
    		        end

    		        l_args.forth
    		        i := i + 1
    		    end
		    end

				-- for receiver in queries
		    if is_good and then attached {AUT_INVOKE_FEATURE_REQUEST} a_request as l_invoc then
		    	if l_need_chaos_receiver then
    		    		    	-- instantiate generic types
           		    create l_state.make_chaos (l_invoc.feature_to_call.type.actual_type
           		    		.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class)
           		    force_last (l_state)
           		elseif l_need_receiver then
           			l_class_id := l_invoc.feature_to_call.type.actual_type
           					.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class.class_id
           			l_index := l_invoc.receiver.index
           			a_heap.search (l_index)
    				if attached a_heap.found_item as ll_state and then ll_state.class_.class_id = l_class_id then
    					force_last (ll_state)
    				else
    					check False end
    					is_good := False
    				end
           		end
		    end
		ensure
		    same_size: is_good implies a_request.operand_indexes.count = count
		end

feature -- Status report

	is_good: BOOLEAN
			-- is this model state good for use?

feature{NONE} -- implementation

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
