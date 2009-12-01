note
	description: "Summary description for {AFX_QUERY_MODEL_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_TRANSITION

inherit
	AFX_HASH_CALCULATOR

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

create
    make

feature -- initialization

	make (a_feature_call: AUT_CALL_BASED_REQUEST)
			-- initialize
		do
		    feature_call := a_feature_call
		end

feature -- status report

	feature_call: AUT_CALL_BASED_REQUEST
			-- feature call as the transition label

	source: detachable AFX_QUERY_MODEL_STATE assign set_source
			-- source state

	destination: detachable AFX_QUERY_MODEL_STATE assign set_destination
			-- destination state

	transition_distance: INTEGER
			-- distance cost of this transition

	is_ready: BOOLEAN
			-- is transition ready for use?
		do
		    Result := source /= Void and destination /= Void
		end

	is_object_creation: BOOLEAN
			-- is this transition an object creation?
		do
		    Result := attached {AUT_CREATE_OBJECT_REQUEST} feature_call
		end

	is_about_same_feature (a_transition: like Current): BOOLEAN
			-- are `Current' and  `a_transition' about the same feature?
		do
		    Result := feature_call.class_of_target_type.class_id = a_transition.feature_call.class_of_target_type.class_id
		    		and then feature_call.feature_to_call.feature_id = a_transition.feature_call.feature_to_call.feature_id
		end

feature -- setter

	set_source (a_src: attached like source)
			-- set source
		require
		    type_conforming: -- types of `a_src' should be type conforming to that of `feature_call'
		do
		    source := a_src
		end

	set_destination (a_dest: attached like destination)
			-- set destination
		require
		    type_conforming: -- types of `a_dest' should be type conforming to that of `feature_call'
		do
		    destination := a_dest
		end

feature{NONE} -- implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
	        create l_list.make (4)
	        l_list.force_last (source.hash_code)
	        l_list.force_last (destination.hash_code)
	        l_list.force_last (feature_call.target_type.hash_code)
	        l_list.force_last (feature_call.feature_to_call.feature_id)

	        Result := l_list
		end


end
