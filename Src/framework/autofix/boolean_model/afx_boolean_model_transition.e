note
	description: "Summary description for {AFX_BOOLEAN_MODEL_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL_TRANSITION

inherit
	AFX_HASH_CALCULATOR

create
    make

feature -- Initialization

    make (a_query_model_transition: like query_model_transition)
    		-- Initialize.
    	require
    	    query_model_transition_ready: a_query_model_transition.is_ready
    	local
    	    l_source, l_dest: AFX_QUERY_MODEL_STATE
    	do
			query_model_transition := a_query_model_transition

			l_source := a_query_model_transition.source
			l_dest := a_query_model_transition.destination
			create boolean_source.make (l_source)
			create boolean_destination.make (l_dest)
    	end

feature -- Access

	query_model_transition: AFX_QUERY_MODEL_TRANSITION
			-- Query model transition.

	boolean_source: AFX_BOOLEAN_MODEL_STATE
			-- Source boolean model state.

	boolean_destination: AFX_BOOLEAN_MODEL_STATE
			-- Destination boolean model state.

feature -- Status report

	class_: CLASS_C
			-- Associated class of this transition.
		require
		    query_model_transition_ready: query_model_transition.is_ready
		do
		    Result := query_model_transition.feature_call.class_of_target_type
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
	        create l_list.make (3)
	        l_list.force_last (boolean_source.hash_code)
	        l_list.force_last (boolean_destination.hash_code)
	        l_list.force_last (query_model_transition.hash_code)

	        Result := l_list
		end


end
