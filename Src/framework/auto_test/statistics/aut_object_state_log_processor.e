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

	AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

	AFX_SHARED_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER

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

-- experiment variables
			l_boolean_model: AFX_BOOLEAN_MODEL
			l_summary_manager: AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER
			l_transition_list: DS_LINEAR [AFX_BOOLEAN_MODEL_TRANSITION]
			l_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER
		do
				-- Load log file.
			create l_log_stream.make (configuration.log_file_path)
			l_log_stream.open_read
			create l_log_parser.make (system, session.error_handler)
			l_log_parser.add_observer (Current)
			l_log_parser.parse_stream (l_log_stream)
			l_log_stream.close

-- experiment code
			create l_manager.make_default
			set_boolean_state_manager (l_manager)
				-- boolean model
			create l_boolean_model.make_from_query_model (last_model)
			l_transition_list := l_boolean_model.to_transition_list
				-- summary manager
			create l_summary_manager.make_default
			set_state_transition_summary_manager (l_summary_manager)
			l_transition_list.do_all (agent l_summary_manager.summarize_transition)
		end

feature{NONE} -- Process

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- <Precursor>
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
		do
			Precursor (a_request)

				-- variable information
			l_class := a_request.type.associated_class
			check l_class /= Void end
--			l_type := a_request.type
--			check l_type /= Void end
			l_var_index := a_request.variable.index
			check l_var_index >= 0 end

			l_is_good := False
			if attached {AUT_OBJECT_STATE_RESPONSE} a_request.response as l_response then
			    if not (l_response.is_bad or l_response.is_error)  then
			        fixme ("check for the conditions where the response may be useless")

						-- create state
					l_results := l_response.query_results
--					create l_state.make_for_type (l_results.count, l_type)
					create l_state.make_from_object_state (l_results, l_class, Void)
--					l_state.construct_from_query_result (l_results)

				    	-- source state of feature call, just put the state into `mock_heap'
					mock_heap.force (l_state, l_var_index)

					if attached last_call_based_request as l_call_request then
						if expected_object_states.last.o_id = l_var_index and then expected_object_states.last.o_class.class_id = l_class.class_id then
							l_is_good := True

								-- one more relevant state available, remove it from expecting list
							expected_object_states.remove_last

							if expected_object_states.is_empty then
									-- all expected states have been reported, start constructing the transition
							    check last_transition /= Void end
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

feature{NONE} -- implementation

	process_call_based_request (a_request: AUT_CALL_BASED_REQUEST)
			-- process call based request, by create an AFX_TRANSITION object with the source from `mock_heap'
		local
		    l_state: AFX_QUERY_MODEL_STATE
		    l_transition: AFX_QUERY_MODEL_TRANSITION
		do
		    create l_state.make (a_request.operand_indexes.count)
		    l_state.extract_state (mock_heap, a_request, True)

			create l_transition.make (a_request)
			l_transition.set_source (l_state)

				-- transition to be finished
			last_call_based_request := a_request
			last_transition := l_transition
			extract_expected_object_states (a_request)
		end


	extract_expected_object_states (a_request: AUT_CALL_BASED_REQUEST)
			-- extract the list of operand types and ids.
			-- stored in the order the object states would be queried, which is in reverse to the original order
		local
		    l_expected_object_states: like expected_object_states
		    i: INTEGER
		    l_count: INTEGER
		    l_target_type: TYPE_A
		    l_indexes: SPECIAL[INTEGER]
		    l_index: INTEGER
		    l_class: CLASS_C
		    l_args: FEAT_ARG
		do
		    l_target_type := a_request.target_type

		    l_expected_object_states := expected_object_states
		    	-- reset `expected_object_states'
		    l_expected_object_states.wipe_out

		    l_count := a_request.operand_indexes.count
		    l_expected_object_states.resize (l_count)

		    l_indexes := a_request.operand_indexes

		    	-- receiver if any
		    if attached {AUT_INVOKE_FEATURE_REQUEST} a_request as l_request and then l_request.is_feature_query then
		        l_count := l_count - 1
		        l_expected_object_states.force_last ([l_request.feature_to_call.type.actual_type
		        			.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class,
		        			l_indexes [l_count]])
--    		        l_class_id := l_args.item_for_iteration.actual_type
--    		        		.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class.class_id
		    end

				-- argument objects
			l_args := a_request.feature_to_call.arguments
			if l_args /= Void then
    		    from
    		        l_args.finish
    		        i := l_count - 1
    		    until
    		        l_args.before
    		    loop
    				l_class := l_args.item_for_iteration.actual_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id).associated_class
    				check i >= 0 end
    		        l_index := l_indexes[i]
    		        l_expected_object_states.force_last ([l_class, l_index])

    		        l_args.back
    		        i := i - 1
    		    end
    		    check i = 0 end
			end

				-- target object
			l_expected_object_states.force_last ([a_request.target_type.associated_class, a_request.target.index])
		end

	last_call_based_request: detachable AUT_CALL_BASED_REQUEST
			-- last call based request

	last_transition: detachable AFX_QUERY_MODEL_TRANSITION
			-- most recently constructed transition

	last_model: AFX_QUERY_MODEL
			-- constructed model

	mock_heap: DS_HASH_TABLE [AFX_STATE, INTEGER]
			-- mock heap to cache responses to object state requests.
			-- the key of the hash table is the index of variable.

	expected_object_states: DS_ARRAYED_LIST [TUPLE[o_class: CLASS_C; o_id: INTEGER] ]
			-- list for logging the object states expected to finish the last call transition



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
