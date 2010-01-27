note
	description: "AutoTest log processor to analyze object states."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_LOG_PROCESSOR

inherit
	AUT_LOG_PROCESSOR

	AUT_PROXY_EVENT_RECORDER
		rename
			make as recorder_make
		redefine
			process_invoke_feature_request,
			process_create_object_request,
			process_object_state_request
		end

	AFX_SHARED_FORMAL_TYPE_MANAGER

		-- For local testing only
	KL_SHARED_STRING_EQUALITY_TESTER

	KL_SHARED_FILE_SYSTEM

	AFX_SHARED_BEHAVIOR_CONSTRUCTOR

	AFX_SHARED_SESSION

	AFX_UTILITY
		undefine
		    system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_config: like configuration; a_session: AUT_SESSION) is
			-- Initialize.
		require
			a_system_attached: a_system /= Void
			a_config_attached: a_config /= Void
			a_session_attached: a_session /= Void
		do
			system := a_system
			configuration := a_config
			session := a_session
			recorder_make (system)

			create mock_heap.make_default
			create expected_object_states.make_default
			create last_model.make_default
		end

feature -- Process

	process is
			-- Process log file specified in `configuration'.
		local
			l_log_publisher: AUT_RESULT_REPOSITORY_PUBLISHER
			l_log_stream: KL_TEXT_INPUT_FILE
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_log_parser: AUT_LOG_PARSER

			l_formal_type_manager: AFX_FORMAL_TYPE_MANAGER
			l_boolean_model: AFX_BOOLEAN_MODEL
			l_transition_list: DS_LINEAR [AFX_BOOLEAN_MODEL_TRANSITION]
			l_state_transition_model: AFX_STATE_TRANSITION_MODEL
			l_repository_dir_name: DIRECTORY_NAME
			l_repository_dir: KL_DIRECTORY
			l_class_name: STRING
			l_file_name: FILE_NAME

			l_is_testing_behavior_construction: BOOLEAN
			l_model_dir_name: DIRECTORY_NAME
			l_model_dir: KL_DIRECTORY
			l_model_file_name: FILE_NAME
		do

l_is_testing_behavior_construction := False
if not l_is_testing_behavior_construction then

				-- Formal type manager.
			create l_formal_type_manager.make_default
			set_formal_type_manager (l_formal_type_manager)

				-- Load log file.
			create l_log_stream.make (configuration.log_file_path)
			l_log_stream.open_read
			create l_log_parser.make (system, session.error_handler)
			l_log_parser.add_observer (Current)
			l_log_parser.parse_stream (l_log_stream)
			l_log_stream.close

				-- Construct state transition model.
   			create l_state_transition_model.make (100)
			create l_boolean_model.make_from_query_model (last_model)
			l_transition_list := l_boolean_model.to_transition_list
			l_transition_list.do_all (agent l_state_transition_model.summarize_transition)

				-- Create model directory.
				-- We don't same the model into the project directory to avoid the risk of being cleared.
--			create l_repository_dir_name.make_from_string (system.eiffel_project.project_directory.fixing_results_path)
			create l_repository_dir_name.make_from_string (directory_name_from_file_name (configuration.log_file_path))
			l_repository_dir_name.extend ("model")
			create l_repository_dir.make (l_repository_dir_name)
			if not l_repository_dir.exists then
			    l_repository_dir.recursive_create_directory
			end

				-- Save state transition model into file.
			l_class_name := class_name_from_file_name (configuration.log_file_path)
			create l_file_name.make_from_string (l_repository_dir_name)
			l_file_name.set_file_name (l_class_name)
			l_file_name.add_extension ("xml")

			io.putstring ("Saving model to: ")
			io.putstring (l_file_name)
			l_state_transition_model.save_to_file (l_file_name)
			io.putstring (" ...... Done!%N")
else
				-- Local testing.
			l_class_name := class_name_from_file_name (configuration.log_file_path)

				-- From file name...
			create l_repository_dir_name.make_from_string (directory_name_from_file_name (configuration.log_file_path))
			l_repository_dir_name.extend ("model")
			create l_file_name.make_from_string (l_repository_dir_name)
			l_file_name.set_file_name (l_class_name)
			l_file_name.add_extension ("xml")

				-- Make sure the model directory exists.
			create l_model_dir_name.make_from_string (system.eiffel_project.project_directory.fixing_results_path)
			l_model_dir_name.extend ("model")
			create l_model_dir.make (l_model_dir_name)
			if not l_model_dir.exists then
			    l_model_dir.recursive_create_directory
			end

				-- To file name...
			create l_model_file_name.make_from_string (l_model_dir_name)
			l_model_file_name.set_file_name (l_class_name)
			l_model_file_name.add_extension ("xml")

				-- Copy the model to project directory.
			file_system.copy_file (l_file_name, l_model_file_name)

				-- Test behavior construction.
			test_behavior_construction
end
		end

feature{NONE} -- Process

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- <Precursor>
		local
		    l_feature: FEATURE_I
		    l_type: TYPE_A
		    l_class: CLASS_C
		    l_list: CLASS_C
		    l_wclass: CLASS_C
		    l_formal_type: TYPE_A
		do
			Precursor (a_request)
			process_call_based_request (a_request)
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
			-- <Precursor>
		do
			Precursor (a_request)
			process_call_based_request (a_request)
		end

	state_from_query_result (a_state: HASH_TABLE [STRING_8, STRING_8]; a_class: CLASS_C; a_feature: detachable FEATURE_I)
				: detachable AFX_STATE
			-- Construct a afx_state object from the query result.
			-- Workaround: the state report may be meshy, this makes it possible to ignore the bad-formed states.
			-- 			Maybe this is overkilling, but since the expressions may contain also implications,
			--			there seems to be no easy way to check the validity without using exception handling.
		local
		    l_retried: BOOLEAN
		do
		    if not l_retried then
		        create Result.make_from_object_state (a_state, a_class, a_feature)
		    else
		        Result := Void
		    end
		rescue
		    l_retried := True
		    retry
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		local
		    l_type: TYPE_A
		    l_class: CLASS_C
		    l_var_index: INTEGER
		    l_results: HASH_TABLE [detachable STRING, STRING]
		    l_state: AFX_STATE
		    l_model_state: AFX_QUERY_MODEL_STATE
		    l_is_good: BOOLEAN
		    l_context_class: CLASS_C
		do
			Precursor (a_request)

				-- variable information
			l_type := a_request.type
			check l_type /= Void end
			l_class := a_request.type.associated_class

			l_var_index := a_request.variable.index
			check l_var_index >= 0 end

			l_is_good := False
			if attached {AUT_OBJECT_STATE_RESPONSE} a_request.response as l_response then
			    if not (l_response.is_bad or l_response.is_error)  then
			        fixme ("check for the conditions where the response may be useless")

						-- create state
					l_results := l_response.query_results
					l_state := state_from_query_result (l_results, l_type.associated_class, Void)
					if l_state /= Void then
    				    	-- source state of feature call, just put the state into `mock_heap'
    					mock_heap.force (l_state, l_var_index)

    					if attached last_call_based_request as l_call_request then
    						if expected_object_states.first.ob_id = l_var_index then
    							l_is_good := True

    								-- one more relevant state available, remove it from expecting list
    							expected_object_states.remove_first

    							if expected_object_states.is_empty then
    							    check last_transition /= Void end
    								debug("autofix") print (last_call_based_request.feature_to_call.feature_name + "(Before)%N") end
    									-- all expected states have been reported, start constructing the transition
    							    create l_model_state.make (last_call_based_request.operand_indexes.count)
    							    l_model_state.extract_state (mock_heap, last_call_based_request, False)
    								last_transition.set_destination (l_model_state)
    								last_model.add_transition (last_transition)

    									-- prepare for next transition
    								last_call_based_request := Void
    								last_transition := Void
    							end
    						else
    								-- unexpected object state, error
    							l_is_good := False
    						end
    					else		-- not (attached last_call_based_request as l_call_request)
    					    l_is_good := True
    					end
					end
				else 		-- not not (l_response.is_bad or l_response.is_error)
				    l_is_good := False
			    end
			else		-- not attached {AUT_OBJECT_STATE_RESPONSE} a_request.response as l_response
				l_is_good := False
			end

			if not l_is_good then
			    	-- remove current state from heap
			    mock_heap.remove (l_var_index)

			    	-- discard unfinished work
				last_call_based_request := Void
				last_transition := Void
				expected_object_states.wipe_out
			end
		end

feature{NONE} -- Testing

	class_name_from_file_name (a_file_name: STRING): STRING
			-- Parse the class name from `a_file_name'.
		local
		    l_pre_str, l_post_str: STRING
		    l_start_pos, l_end_pos: INTEGER
		do
		    l_pre_str := "ps_"
		    l_post_str := "_state_log"
		    l_start_pos := a_file_name.substring_index (l_pre_str, 1)
		    l_end_pos := a_file_name.substring_index (l_post_str, 1)
		    l_start_pos := l_start_pos + l_pre_str.count
		    l_end_pos := l_end_pos - 1
		    Result := a_file_name.substring (l_start_pos, l_end_pos)
		end

	directory_name_from_file_name (a_file_name: STRING): STRING
			-- Parse the directory name from `a_file_name'.
		local
		    l_last_index: INTEGER
		    l_directory_name: STRING
		do
		    l_last_index := a_file_name.last_index_of ('\', a_file_name.count)
		    l_directory_name := a_file_name.substring (1, l_last_index - 1)
		    Result := l_directory_name
		end

	test_behavior_construction
			-- Testing scaffold for behavior construction.
		local
		    l_class_name: STRING
		    l_class: CLASS_C
		    l_before_property, l_after_property: HASH_TABLE [STRING, STRING]
		    l_before_state, l_after_state: AFX_STATE
		    l_before_objects, l_after_objects: DS_HASH_TABLE [AFX_STATE, STRING]
		    l_fixes: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
		    l_config: AFX_CONFIG
		    l_str: STRING
		do
		    l_class_name := class_name_from_file_name (configuration.log_file_path)
		    l_class := first_class_starts_with_name (l_class_name)

		    create l_before_property.make (3)
		    l_before_property.force ("False", "before")
		    l_before_property.force ("False", "after")
		    l_before_property.force ("False", "off")
		    create l_before_state.make_from_object_state (l_before_property, l_class, Void)
		    create l_before_objects.make (1)
		    l_before_objects.set_key_equality_tester (string_equality_tester)
		    l_before_objects.force (l_before_state, "obj")

		    create l_after_property.make (3)
		    l_after_property.force ("True", "off")
		    l_after_property.force ("True", "before")
		    create l_after_state.make_from_object_state (l_after_property, l_class, Void)
			create l_after_objects.make (1)
			l_after_objects.set_key_equality_tester (string_equality_tester)
			l_after_objects.force (l_after_state, "obj")

				-- Shared autofix configuration.
			create l_config.make (system)
			set_autofix_config (l_config)

		    l_fixes := state_transitions_from_model (l_before_objects, l_after_objects, l_class,
		    		{AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}.model_guidance_style_relaxed, Void, Void, True)

		    l_str := ""
		    from l_fixes.start
		    until l_fixes.after
		    loop
		        l_str.append (l_fixes.item_for_iteration.out)
		        l_fixes.forth
		    end
		end

feature{NONE} -- implementation

	process_call_based_request (a_request: AUT_CALL_BASED_REQUEST)
			-- process call based request, by create an AFX_TRANSITION object with the source from `mock_heap'
		local
		    l_state: AFX_QUERY_MODEL_STATE
		    l_transition: AFX_QUERY_MODEL_TRANSITION
		    l_formal_type_manager: like formal_type_manager
		    l_type_array: DS_ARRAYED_LIST[TYPE_A]
		    l_index_array: SPECIAL[INTEGER]
		    l_index: INTEGER
		do
			if a_request.response.is_normal and then not a_request.response.is_exception then
    		    l_formal_type_manager := formal_type_manager
    			l_type_array := l_formal_type_manager.query_feature_formal_types (a_request.feature_to_call, a_request.target_type)
    			l_index_array := a_request.operand_indexes
    			check operand_index_type_match: l_type_array.count = l_index_array.count end

    		    create l_state.make (l_index_array.count)

    			debug("autofix") print (a_request.feature_to_call.feature_name + "(Before)%N") end
    		    l_state.extract_state (mock_heap, a_request, True)

    			create l_transition.make (a_request)
    			l_transition.set_source (l_state)

    				-- transition to be finished
    			last_call_based_request := a_request
    			last_transition := l_transition

    				-- put the <type, id> pair into `expected_object_states'
    			expected_object_states.wipe_out
    			from
    				l_index := 0
    				l_type_array.start
    			until
    			    l_index = l_index_array.count
    			loop
    			    expected_object_states.force_last ([l_type_array.item_for_iteration, l_index_array.item (l_index)])

    			    l_index := l_index + 1
    			    l_type_array.forth
    			end
    		else
    			last_call_based_request := Void
    			last_transition := Void
    		    expected_object_states.wipe_out
			end
		end

	last_call_based_request: detachable AUT_CALL_BASED_REQUEST
			-- Last call based request.

	is_last_call_based_requeset_suitable: BOOLEAN
			-- Is `last_call_based_request' going to be used to build the model?
			-- If not, the object states are only used to update the `mock_heap' and no transition will be added into the model.

	last_transition: detachable AFX_QUERY_MODEL_TRANSITION
			-- Most recently constructed transition.

	last_model: AFX_QUERY_MODEL
			-- Constructed query model.

	mock_heap: DS_HASH_TABLE [AFX_STATE, INTEGER]
			-- Mock heap to cache responses to object state requests.
			-- The key of the hash table is the index of variable.

	expected_object_states: DS_ARRAYED_LIST [TUPLE[ob_type: TYPE_A; ob_id: INTEGER] ]
			-- List of expected object states to finish the last call transition.

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
