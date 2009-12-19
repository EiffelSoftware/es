note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BEHAVIOR_CONSTRUCTOR_I

feature -- Access

	config: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- Configuration of the fix construction.
		deferred
		end

	criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- Feature selection criteria.
		deferred
		end

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- List of state transition fixes.
		deferred
		end

	state_transition_model: AFX_STATE_TRANSITION_MODEL_I
			-- The model to be used in construction.
		deferred
		end

feature -- Constructor interface

	reset_constructor (an_objects: DS_HASH_TABLE[AFX_STATE, STRING];
					a_dest_objects: DS_HASH_TABLE[AFX_STATE, STRING];
					a_context_class: CLASS_C;
					a_class_set: detachable DS_HASH_SET [CLASS_C];
					a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I)
			-- Reset the constructor and get it ready for a new
			--		construction with `a_config' and `a_criteria'.
			-- Note: `state_transition_model' is NOT reset.
			-- 		Use `transition_summary_manager.clear_summary' to do that.
		deferred
		ensure
		    config_set: config /= Void
		    criteria_set: criteria /= Void
		    call_sequences_empty: call_sequences.is_empty
		end

	construct_behavior
			-- Construct behaviors to make the transition.
			-- Constructed fixes are stored in `fix_sequences'.
		require
		    state_transition_model_good: state_transition_model.is_good
		    config_good: config.is_good
		    criteria_set: criteria /= Void
		    call_sequences_empty: call_sequences.is_empty
		deferred
		end

feature -- Output

	call_sequences_as_string: STRING
			-- Represent the whole call sequences using a single string.
		require
		    fix_candidates_not_empty: call_sequences /= Void and then not call_sequences.is_empty
		local
		    l_fixes: like call_sequences
		    l_str: STRING
		    l_index: INTEGER
		do
		    l_fixes := call_sequences
		    create l_str.make (1024)
		    from
		    	l_index := 1
		    	l_fixes.start
		    until
		        l_fixes.after
		    loop
		        l_str.append ("  --- Sequence #")
		        l_str.append (l_index.out)
		        l_str.append (" ---%N")
		        l_str.append (l_fixes.item_for_iteration.out)
				l_str.append_character ('%N')

		        l_index := l_index + 1
		        l_fixes.forth
		    end
		    Result := l_str
		end


end
