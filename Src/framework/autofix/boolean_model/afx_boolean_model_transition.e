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

feature

    make (a_query_model_transition: like query_model_transition)
    		-- initialize
    	require
    	    query_model_transition_ready: a_query_model_transition.is_ready
    	local
    	    l_source, l_dest: AFX_QUERY_MODEL_STATE
    	do
			query_model_transition := a_query_model_transition

			l_source := a_query_model_transition.source
			l_dest := a_query_model_transition.destination
			check l_source /= Void and then l_dest /= Void end
			create boolean_source.make (l_source)
			create boolean_destination.make (l_dest)
    	end

feature -- access

	query_model_transition: AFX_QUERY_MODEL_TRANSITION
			-- query model transition

	boolean_source: AFX_BOOLEAN_MODEL_STATE
			-- boolean source model state

	boolean_destination: AFX_BOOLEAN_MODEL_STATE
			-- boolean dest model state

feature -- status report

	class_: CLASS_C
			-- associated class of this transition
		require
		    query_model_transition_ready: query_model_transition.is_ready
		do
		    Result := query_model_transition.feature_call.class_of_target_type
		end

	is_object_creation: BOOLEAN
			-- is this an object creation?
		do
		    Result := query_model_transition.is_object_creation
		end

feature{NONE} -- implementation

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
