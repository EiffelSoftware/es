note
	description: "SCOOP System level constants."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SYSTEM_CONSTANTS

inherit
	SYSTEM_CONSTANTS

feature -- Scoop system constants
	original_code_processor_class_name: STRING is "PROCESSOR"

	general_generated_entity_name: STRING is "scoop_object_"

	proxy_class_prefix: STRING is "SCOOP_SEPARATE__"

	proxy_conversion_feature_name: STRING is "proxy_"

	override_cluster_name: STRING is "scoop_override_cluster"

	caller_formal_argument_name: STRING is "a_caller_"

	scoop_library_name: STRING is "scoopli"

	scoop_library_path: STRING is "$ISE_LIBRARY\library\scoopli\scoopli.ecf"

	scoop_library_processor_setter_name: STRING is "set_processor_"

	scoop_library_processor_getter_name: STRING is "processor_"

	scoop_library_locked_processors_query_name: STRING is "locked_processors"

	scoop_library_synchronous_processors_query_name: STRING is "synchronous_processors"

	scoop_library_locked_processors_has_query_name: STRING is "locked_processors_has"

	scoop_library_locked_processors_count_query_name: STRING is "locked_processors_count"

	scoop_library_synchronous_processors_count_query_name: STRING is "synchronous_processors_count"

	scoop_library_locked_processors_push_whole_stack_command_name: STRING is "locked_processors_push_whole_stack"

	scoop_library_locked_processors_trim_command_name: STRING is "locked_processors_trim"

	scoop_library_synchronous_processors_push_whole_stack_command_name: STRING is "synchronous_processors_push_whole_stack"

	scoop_library_synchronous_processors_trim_command_name: STRING is "synchronous_processors_trim"

	scoop_library_implementation_getter_name: STRING is "implementation_"

	scoop_library_implementation_setter_name: STRING is "set_implementation_"

	scoop_library_asynchronous_execute_feature_name: STRING is "scoop_asynchronous_execute"

	scoop_library_synchronous_execute_feature_name: STRING is "scoop_synchronous_execute"

	scoop_library_separate_type_class_name: STRING is "SCOOP_SEPARATE_TYPE"

	scoop_library_separate_client_class_name: STRING is "SCOOP_SEPARATE_CLIENT"

	scoop_library_separate_proxy_class_name: STRING is "SCOOP_SEPARATE_PROXY"

	scoop_library_starter_class_name: STRING is "SCOOP_STARTER"

	scoop_library_starter_feature_name: STRING is "make"

	lock_passing_detector_local_name: STRING is "scoop_passing_locks"

	lock_passing_detector_local_type: STRING is "BOOLEAN"

	locked_processors_stack_size_local_name: STRING is "scoop_locked_processors_stack_size"

	locked_processors_stack_size_local_type: STRING is "INTEGER"

	synchronous_processors_stack_size_local_name: STRING is "scoop_synchronous_processors_stack_size"

	synchronous_processors_stack_size_local_type: STRING is "INTEGER"

	thread_library_name: STRING is "thread"

	thread_library_path: STRING is "$ISE_LIBRARY\library\thread\thread.ecf"

	multithreading_enabled_setting: STRING is "True"

	base_precompile_filename: STRING is "base.ecf"

	base_mt_precompile_filename: STRING is "base-mt.ecf"

	base_library_name: STRING is "base"

	net_library_name: STRING = "net"

	nonseparate_result: STRING is "nonseparate_result"

	creation_object: STRING is "creation_object"

	create_creation_wrapper: STRING is "create_creation_wrapper"

	general_wrapper_name_additive: STRING is "_scoop_separate_"

	individual_separate_postcondition_wrapper_name_additive: STRING is "_spc_"

	unseparated_postcondition_attribute_name_additive: STRING is "_unseparated_postconditions"

	unseparated_postcondition_attribute_type: STRING is "LINKED_LIST [ROUTINE [ANY, TUPLE]]"

	enclosing_routine_name_additive: STRING is "_enclosing_routine"

	wait_condition_wrapper_name_additive: STRING is "_wait_condition"

	separate_postcondition_wrapper_name_additive: STRING is "_separate_postcondition"

	non_separate_postcondition_wrapper_name_additive: STRING is "_non_separate_postcondition"

	effective_creation_routine_wrapper_name_additive: STRING is "effective_"

	assigner_mediator_name_additive: STRING is "assigner_"

	assigner_mediator_source_formal_argument_name: STRING is "assign_source_"

	client_agent_local_name: STRING is "a_function_to_evaluate"

	client_agent_local_result_query_name: STRING is "last_result"

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_SYSTEM_CONSTANTS
