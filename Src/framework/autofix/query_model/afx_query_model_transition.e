note
	description: "Summary description for {AFX_QUERY_MODEL_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_TRANSITION

inherit
	EPA_HASH_CALCULATOR

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

	DEBUG_OUTPUT
		undefine
		    copy,
		    is_equal
		end

create
    make

feature -- Initialization

	make (a_feature_call: AUT_CALL_BASED_REQUEST)
			-- Initialize
		do
		    feature_call := a_feature_call
		end

feature -- Access

	feature_call: AUT_CALL_BASED_REQUEST
			-- Feature call as the transition label.

	source: detachable AFX_QUERY_MODEL_STATE assign set_source
			-- Source state.

	destination: detachable AFX_QUERY_MODEL_STATE assign set_destination
			-- Destination state.

feature -- Status report

	is_ready: BOOLEAN
			-- Is transition good for use?
		do
		    Result := source /= Void and destination /= Void
		end

	is_about_same_feature (a_transition: like Current): BOOLEAN
			-- Are `Current' and  `a_transition' about the same feature?
		do
		    Result := feature_call.class_of_target_type.class_id = a_transition.feature_call.class_of_target_type.class_id
		    		and then feature_call.feature_to_call.feature_id = a_transition.feature_call.feature_to_call.feature_id
		end

	debug_output: STRING
			-- <Precursor>
		do
		    create Result.make (1024)
		    Result.append (feature_call.target_type.associated_class.name)
		    Result.append (".")
		    Result.append (feature_call.feature_to_call.feature_name)
		    Result.append ("%N")
		    if attached source then
		        Result.append ("--Src--%N")
		    	Result.append (source.debug_output)
		    	Result.append ("%N")
		    end
		    if attached destination then
		        Result.append ("--Des--%N")
		    	Result.append (destination.debug_output)
		    	Result.append ("%N")
		    end
		end

feature -- Setter

	set_source (a_src: attached like source)
			-- Set source to be `a_src'.
		require
		    	-- types of `a_src' should be type conforming to that of `feature_call'
		    type_conforming:
		do
		    source := a_src
		end

	set_destination (a_dest: attached like destination)
			-- Set destination to be `a_dest'
		require
		    	-- types of `a_dest' should be type conforming to that of `feature_call'
		    type_conforming:
		do
		    destination := a_dest
		end

feature{NONE} -- Implementation

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
