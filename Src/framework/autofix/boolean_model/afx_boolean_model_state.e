note
	description: "Summary description for {AFX_BOOLEAN_MODEL_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL_STATE

inherit
    DS_ARRAYED_LIST [AFX_BOOLEAN_STATE]
    	rename
    		make as make_list
    	end

	AFX_HASH_CALCULATOR
    	undefine
    		is_equal,
    		copy
    	end

create
    make

feature -- Initialization

	make (a_query_model_state: like query_model_state)
			-- Initialize
		local
		    l_query_state: AFX_STATE
		    l_boolean_state: AFX_BOOLEAN_STATE
		do
		    query_model_state := a_query_model_state
		    make_list (a_query_model_state.count)

		    from a_query_model_state.start
		    until a_query_model_state.after
		    loop
		        l_query_state := a_query_model_state.item_for_iteration
		        create l_boolean_state.make_for_class (l_query_state.class_)
		        l_boolean_state.interpretate (l_query_state)
		        force_last (l_boolean_state)

		        a_query_model_state.forth
		    end
		    set_equality_tester (create {AFX_BOOLEAN_STATE_EQUALITY_TESTER})
		    is_good := True
		end

feature -- Access

	query_model_state: AFX_QUERY_MODEL_STATE
			-- Associated query model state.

feature -- Status report

	is_good: BOOLEAN
			-- Is this boolean model state good for use?

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (count + 1)
		    l_list.force_last (count)

			from start
			until after
			loop
				l_list.force_last (item_for_iteration.hash_code)
				forth
			end

			Result := l_list
		end

end
