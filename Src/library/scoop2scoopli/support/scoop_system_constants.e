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

feature --scoop system constants

	scoop_proxy_prefix: STRING is "scoop_separate__"

	scoop_processor: STRING is "processor_"

	scoop_client_implementation: STRING is "implementation_"

	scoop_proxy: STRING is "proxy_"

	scoop_override_cluster_name: STRING is "scoop_override_cluster"

	scoop_library_name: STRING is "scoopli"

	scoop_library_path: STRING is "$ISE_LIBRARY\library\scoopli\scoopli.ecf"

	scoop_starter_class_name: STRING is "SCOOP_STARTER"

	scoop_starter_feature_name: STRING is "make"

	thread_library_name: STRING is "thread"

	thread_library_path: STRING is "$ISE_LIBRARY\library\thread\thread.ecf"

	multithreading_enabled_setting: STRING is "true"

	base_precompile_filename: STRING is "base.ecf"

	base_mt_precompile_filename: STRING is "base-mt.ecf"

	base_library_name: STRING is "base"

feature {NONE}

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class SCOOP_SYSTEM_CONSTANTS
