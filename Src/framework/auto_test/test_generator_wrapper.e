note
	description: "[
		This is a wrapper for {TEST_GENERATOR}. Instead of directly generating tests it will first 
		write a speficif interpreter root class and compile the project.
		
		This is currently used in the EVE branch to provide the test generation process with more
		information by directly coding it into the new root class.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GENERATOR_WRAPPER

inherit
	TEST_GENERATOR
		redefine
			start_creation,
			remove_task,
			clean,
			compute_interpreter_root_class
		end

create
	make

feature {NONE} -- Status setting

	start_creation
			-- <Precursor>
		do
			interpreter_root_class_name_cell.put ("ITP_INTERPRETER_ROOT")
			random.start
			prepare
			compile_project (class_names)
		end

	remove_task (a_task: like sub_task; a_cancel: BOOLEAN)
			-- <Precursor>
		do
			if not a_cancel then
				if
					attached {like new_melt_task} sub_task as l_task and then
					l_task.is_successful
				then
					system.remove_explicit_root (interpreter_root_class_name, interpreter_root_feature_name)
					system.make_update (False)
					initiate_testing_task
				end
			end
			if not has_next_step then
				Precursor (a_task, a_cancel)
			end
		end

	clean
			-- <Precursor>
		do
			Precursor
			interpreter_root_class_cell.put (Void)
		end

	compute_interpreter_root_class
			-- <Precursor>
		local
			l_uni: UNIVERSE_I
		do
			l_uni := system.universe
			if
				attached l_uni.cluster_of_name ({TEST_SYSTEM_I}.eifgens_cluster_name) as l_cluster and then
				attached l_uni.class_named (interpreter_root_class_name, l_cluster) as l_class and then
				attached {EIFFEL_CLASS_C} l_class.compiled_class as l_eclass
			then
				interpreter_root_class_cell.put (l_eclass)
			else
				interpreter_root_class_cell.put (Void)
			end
		end

feature {NONE} -- Basic operations

	compile_project (a_class_name_list: like class_names)
			-- Compile `a_project' with new `a_root_class' and `a_root_feature'.
			--
			-- TODO: `class_names' should be retrieved from `session'
		local
			l_dir: PROJECT_DIRECTORY
			l_file: KL_TEXT_OUTPUT_FILE
			l_file_name: FILE_NAME
			l_source_writer: TEST_INTERPRETER_SOURCE_WRITER
			l_system: SYSTEM_I
			l_melt: like new_melt_task
		do
			l_system := system
			check l_system /= Void end
				-- Create actual root class in EIFGENs cluster
			l_dir := l_system.project_location
			create l_file_name.make_from_string (l_dir.eifgens_cluster_path)
			l_file_name.set_file_name (interpreter_root_class_name.as_lower)
			l_file_name.add_extension ("e")
			create l_file.make (l_file_name)
			if not l_file.exists then
				l_system.force_rebuild
			end
			l_file.recursive_open_write
			create l_source_writer.make (Current)
			if l_file.is_open_write then
				l_source_writer.write_class (l_file, a_class_name_list, l_system)
				l_file.flush
				l_file.close
			end

			if not l_system.is_explicit_root (interpreter_root_class_name, interpreter_root_feature_name) then
				l_system.add_explicit_root (Void, interpreter_root_class_name, interpreter_root_feature_name)
			end

			append_output (
				agent (a_formatter: TEXT_FORMATTER)
					do
						a_formatter.process_basic_text ("Compiling project%N")
					end, True)

			l_melt := new_melt_task
			l_melt.start (True)
			sub_task := l_melt
		end

feature {NONE} -- Factory

	new_melt_task: ETEST_MELT_TASK
			-- Create new task for compiling `system'.
		do
			create Result.make (etest_suite)
		end

note
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
