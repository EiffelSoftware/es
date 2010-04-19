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

	scoop_proxy_class_prefix: STRING is "SCOOP_SEPARATE__"

	scoop_proxy_prefix: STRING is "scoop_separate__"

	proxy_conversion_feature_name: STRING is "proxy_"

	scoop_override_cluster_name: STRING is "scoop_override_cluster"

	scoop_library_name: STRING is "scoopli"

	scoop_library_path: STRING is "$ISE_LIBRARY\library\scoopli\scoopli.ecf"

	scoop_library_processor_setter_name: STRING is "set_processor_"

	scoop_library_processor_getter_name: STRING is "processor_"

	scoop_library_implementation_getter_name: STRING is "implementation_"

	scoop_library_implementation_setter_name: STRING is "set_implementation_"

	scoop_starter_class_name: STRING is "SCOOP_STARTER"

	scoop_starter_feature_name: STRING is "make"

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
