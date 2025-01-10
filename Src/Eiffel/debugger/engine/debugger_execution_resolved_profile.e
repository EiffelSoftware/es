note
	description: "Objects that contains an debugging execution parameters"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	DEBUGGER_EXECUTION_RESOLVED_PROFILE

create
	make_from_profile

feature {NONE} -- Initialization

	make_from_profile (a_profile: DEBUGGER_EXECUTION_PROFILE)
			-- Create debugger parameters
		require
			a_profile_attached: a_profile /= Void
		local
			p: detachable DEBUGGER_EXECUTION_PROFILE
		do
			uuid := a_profile.uuid
			version := a_profile.version
			title := a_profile.title
			group := a_profile.group

			p := a_profile.parent
			if p /= Void then
				parent_uuid := p.uuid
				parent_version := p.version
			end

				--| Arguments
			if attached a_profile.arguments as args then
				arguments := args
			else
				if p /= Void and then attached p.arguments as p_args then
					arguments := p_args
				else
					create arguments.make_empty
				end
			end

				--| Working copy
			if attached a_profile.working_directory as wd then
				working_directory := wd
			elseif p /= Void and then attached p.working_directory as p_wd then
				working_directory := p_wd
			else
				create working_directory.make_empty --| Fake value that will be updated by `resolve'
			end

				--| Environment_files
			if attached a_profile.environment_files as env_files and then not env_files.is_empty then
				across
					env_files as loc_ic
				loop
					import_environment_variables_from_file (loc_ic.item)
				end
			end

				--| Environment_variables (it overwrites variables from files)
			if attached a_profile.environment_variables as envs and then not envs.is_empty then
				environment_variables := envs.deep_twin
			end

			resolve
		ensure
			envs_set: (attached a_profile.environment_variables as el_envs and then not el_envs.is_empty) implies (attached environment_variables as el_r_envs and then not el_r_envs.is_empty)
		end

	resolve
			-- Resolve parameters
		local
			envi: STRING_ENVIRONMENT_EXPANDER
			shared_eiffel: SHARED_EIFFEL_PROJECT
			d: STRING_32
		do
				--| Resolution
			create envi
			create shared_eiffel

				--| Argument
			if not arguments.is_empty then
				arguments := envi.expand_string_32 (arguments, True)
			end

				--| Working_directory
			if
				not attached working_directory as wd or else
				wd.is_empty
			then
				d := shared_eiffel.Eiffel_project.lace.directory_name
			else
				d := envi.expand_string_32 (wd.name, True)
			end
			d := d.twin; d.left_adjust; d.right_adjust
			create working_directory.make_from_string (d)
		end

	import_environment_variables_from_file (a_file_location: PATH)
		local
			vars: like environment_variables
			f: PLAIN_TEXT_FILE
			line: STRING_32
			p: INTEGER
			n,v: STRING_32
			loc: PATH
			shared_eiffel: SHARED_EIFFEL_PROJECT
		do
			if vars = Void then
				create vars.make (1)
				environment_variables := vars
			end
			if a_file_location.is_absolute then
				loc := a_file_location
			else
				create shared_eiffel
				create loc.make_from_string (shared_eiffel.Eiffel_project.Lace.directory_name)
				loc := loc.extended_path (a_file_location)
			end
			create f.make_with_path (loc)
			if f.exists and then f.is_access_readable then
				f.open_read
				from
					f.start
				until
					f.exhausted or f.end_of_file
				loop
					f.read_unicode_line
					line := f.last_string_32
					line.left_adjust
					if line.is_empty or else line [1] = '#' then
							-- Ignore (empty or commented line)
					else
						p := line.index_of ('=', 1)
						if p > 0 then
							n := line.head (p - 1)
							n.right_adjust
							v := line.substring (p + 1, line.count)
							v.right_adjust
							vars [n] := v
						else
							-- unexpected ...
						end
					end
				end
				f.close
			end
		end

feature -- Properties

	uuid: UUID
			-- Unique identifier

	group: detachable STRING_32
			-- Optional group

	title: detachable STRING_32
			-- Optional title

	arguments: STRING_32
			-- Command line arguments (not Void)

	working_directory: PATH
			-- Working directory for execution

	environment_variables: detachable HASH_TABLE [STRING_32, STRING_32]
			-- Modified environment variables

	parent_uuid: like uuid
			-- Unique identifier of parent

	parent_version: like version

	version: NATURAL_32
			-- Version of the parameters
			-- used to track changes

feature -- Status report

	same_profile_parameters (p: DEBUGGER_EXECUTION_PROFILE): BOOLEAN
			-- Has `p' same parameters as Current?
		require
			p_attached: p /= Void
		do
			Result := uuid ~ p.uuid and then version = p.version
			if Result and parent_uuid /= Void then
				Result := attached p.parent as par and then parent_uuid ~ par.uuid and then parent_version = par.version
			end
		end

feature -- Element change

	set_arguments (v: like arguments)
			-- Set `arguments'
		require
			v_attached: v /= Void
		do
			arguments := v
		end

	set_working_directory (v: like working_directory)
			-- Set `working_directory'
		require
			v_attached: v /= Void
		do
			working_directory := v
		end

invariant
	uuid_set: uuid /= Void
	arguments_attached: arguments /= Void
	working_directory_attached: working_directory /= Void
	parent_set_if_not_void: parent_uuid /= Void implies parent_version > 0

note
	copyright:	"Copyright (c) 1984-2025, Eiffel Software"
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

end
