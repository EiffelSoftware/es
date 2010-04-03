note
	description: "Degree 'SCOOP' during Eiffel compilation. Starts Proxy- and Client class creation."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	DEGREE_SCOOP

inherit
		-- for updating the root file to be the SCOOP_STARTER
	CONF_ACCESS

		-- for updating ANY to export `default_create' unrestricted
	COMPILER_EXPORTER

	DEGREE
		redefine
			make
		end

	SHARED_SERVER

	SCOOP_BASIC_TYPE

	SCOOP_WORKBENCH

create
	make

feature {NONE} -- Initialisation

	make
			-- Create new degree SCOOP
		do
			Precursor

			-- create directory name
			create_directory_name

			-- create name prefix
			create scoop_proxy_prefix.make_from_string ("scoop_separate__")
		end

feature -- Access

	Degree_number: INTEGER is 7
			-- Degree number

	is_degree_scoop_needed: BOOLEAN
			-- checks project if there is a separate keyword
		local
			i: INTEGER
			is_separate: BOOLEAN
			a_class: CLASS_C
			l_classes: ARRAY [CLASS_C]
			l_system: like system
		do
			l_system := system
			l_classes := l_system.classes

			is_separate := False

				-- iterate over all classes in the system
				-- and check the already processed 'is_separate_client' value.
			from i := 1 until i > l_classes.count loop
				a_class := l_classes.item (i)
				if a_class /= Void then -- and then a_class.degree_scoop_needed then
					if a_class.is_separate_client then
						is_separate := True
					end
				end
				i := i + 1
			end

			debug ("SCOOP")
				if is_separate then
					io.error.put_string ("SCOOP: keyword 'separate' found, start class creation.")
				else
					io.error.put_string ("SCOOP: keyword 'separate' not found, next: degree 4.")
				end
				io.error.put_new_line
			end

			Result := is_separate
		end

	set_degree_5 (a_degree_5: DEGREE_5) is
			-- set current degree 5
		require
			a_degree_5 /= Void
		do
			degree_5 := a_degree_5
		end

feature {SYSTEM_I} -- Profiling

	build_profile_information
			-- Build the profile information.
			-- Added by trosim on 2010-02-26
		local
			information: SCOOP_PROFILER_INFORMATION
			l_class_info: SCOOP_PROFILER_CLASS_INFORMATION
			l_feature_info: SCOOP_PROFILER_FEATURE_INFORMATION
			i, l_index: INTEGER
			l_feature: FEATURE_I
			l_name: STRING

			l_serializer: SED_MEDIUM_READER_WRITER
			l_store: SED_STORABLE_FACILITIES
			l_file_name: FILE_NAME
			l_file: RAW_FILE
			l_directory: DIRECTORY
		do
			-- Create profile directory
			create l_directory.make (system.project_location.location + Operating_environment.directory_separator.out + {SCOOP_LIBRARY_CONSTANTS}.Eifgens_directory)

			-- Create profile information file name
			create l_file_name.make
			l_file_name.set_directory (l_directory.name)
			l_file_name.set_file_name ({SCOOP_LIBRARY_CONSTANTS}.Information_file_name)
			if not {SCOOP_LIBRARY_CONSTANTS}.Information_file_extension.is_empty then
				l_file_name.add_extension ({SCOOP_LIBRARY_CONSTANTS}.Information_file_extension)
			end

			if universe.target.setting_scoop_profile then
				--| Profiling is enabled |--

				-- Create information object
				create information.make
				information.enable_profiling

				-- Produce profiling information for the classes
				from
					i := 1
				invariant
					i >= 1
					i <= system.class_types.count + 1
				until
					i > system.class_types.count
				loop
					-- Is this a class related to SCOOP?
					if attached {CLASS_TYPE} system.class_types.item (i) as l_type and then l_type.associated_class.group.name.is_equal ({SCOOP_SYSTEM_CONSTANTS}.Scoop_override_cluster_name) then
						create l_name.make_from_string (l_type.associated_class.name_in_upper)

						-- Remove scoop prefix
						if l_type.associated_class.name_in_upper.starts_with ({SCOOP_SYSTEM_CONSTANTS}.Scoop_proxy_class_prefix) then
							l_name.remove_head ({SCOOP_SYSTEM_CONSTANTS}.Scoop_proxy_class_prefix.count)
						end

						-- Do not profile scoop starter class
						if not l_name.is_equal ({SCOOP_SYSTEM_CONSTANTS}.Scoop_starter_class_name) then
							create l_class_info.make
							l_class_info.set_name (l_name)
							information.classes.extend (l_class_info, l_type.type_id)

							-- Produce profile information for features
							from
								l_type.associated_class.feature_table.start
							until
								l_type.associated_class.feature_table.after
							loop
								l_feature := l_type.associated_class.feature_table.item_for_iteration

								-- Process feature only if it is written in SCOOP classes (override cluster)
								if l_feature.written_class.group.name.is_equal ({SCOOP_SYSTEM_CONSTANTS}.Scoop_override_cluster_name) then
									-- Create feature information
									create l_feature_info.make

									-- Get feature name
									create l_name.make_from_string (l_feature.e_feature.name)
									if l_name.has_substring ({SCOOP_LIBRARY_CONSTANTS}.Separate_features_infix) then
										l_index := l_name.substring_index ({SCOOP_LIBRARY_CONSTANTS}.Separate_features_infix, 1)
										l_name.keep_head (l_index - 1)
									end
									if l_name.starts_with ({SCOOP_LIBRARY_CONSTANTS}.Effective_features_prefix) then
										l_name.keep_tail (l_name.count - {SCOOP_LIBRARY_CONSTANTS}.Effective_features_prefix.count)
									end
									l_feature_info.set_name (l_name)

									-- Check whether the feature has separate arguments
									if l_feature.arguments /= Void then
										from
											l_feature.arguments.start
										until
											l_feature.arguments.after
										loop
											if l_feature.arguments.item.actual_type.associated_class.group.name.is_equal ({SCOOP_SYSTEM_CONSTANTS}.Scoop_override_cluster_name) then
												l_feature_info.set_has_separate_arguments
											end
											l_feature.arguments.forth
										variant
											l_feature.arguments.count - l_feature.arguments.index + 1
										end
									end

									-- Extend class info
									l_class_info.features.extend (l_feature_info, l_feature.e_feature.feature_id)
								end
								l_type.associated_class.feature_table.forth
							end
						end
					end
					i := i + 1
				variant
					system.class_types.count - i + 1
				end

				-- Set directory where to put profile data
				information.set_directory (create {DIRECTORY}.make (system.project_location.target_path + Operating_environment.directory_separator.out + {SCOOP_LIBRARY_CONSTANTS}.Profile_directory))

				-- Write profile information to disk
				-- this will be read by the to-be-profiled program
				create l_store
				create l_file.make_open_write (l_file_name.out)
				create l_serializer.make (l_file)
				l_serializer.set_for_writing
				l_store.independent_store (information, l_serializer, True)
				l_file.close
			else
				-- Remove the file if we are not profiling
				create l_file.make (l_file_name.out)
				if l_file.exists then
					l_file.delete
				end
			end
		end

feature {SYSTEM_I, WORKBENCH_I} -- Processing

	execute
			-- Process all classes.
		local
			i: INTEGER
			l_class: CLASS_C
			l_degree_output: like degree_output
		do
			-- set degree values.
			l_degree_output := Degree_output
			l_degree_output.put_start_degree (Degree_number, count)

			debug ("SCOOP")
				io.error.put_string ("SCOOP: Processing 'execute'.")
				io.error.put_new_line
			end

			-- create cluster
			if not scoop_directory.exists then
				-- create directory
				create_directory
			end

			-- Collect classes which should become client and proxy code.
			collect_needed_classes

			debug ("SCOOP")
				io.error.put_string ("SCOOP: Processing classes.")
			end

			setup_starter_class

			-- iterate over all classes and create the new proxy- and client classes.
			from i := 1 until i > scoop_classes.count loop
				l_class := scoop_classes.item (i)
				if l_class.degree_scoop_needed then
					l_degree_output.put_degree_scoop (l_class, count - i + 1)

					execute_on_class (l_class)
				end
				i := i + 1
			end

--			system.force_rebuild
			l_degree_output.put_end_degree
		end

	execute_on_class (a_class: CLASS_C)
			-- Process 'a_class'.
		do
			debug ("SCOOP")
				io.error.put_string ("SCOOP: Processing class '" + a_class.name + "'.")
				io.error.put_new_line
			end

			-- set feature table in workbench
			-- was computed in degree 4.

				-- reset workbench
			scoop_workbench_objects.reset

				-- set current processed class in workbench
			set_current_class_c (a_class)
			set_current_class_as (a_class.ast)


			if a_class.feature_table /= Void then
				a_class.ast.set_feature_table (a_class.feature_table)
			end

			-- create original classes
			process_separate_client_creation (a_class)

			-- creation of proxy classes
			process_separate_proxy_creation (a_class)

			-- force system to check class again
			workbench.add_class_to_recompile (a_class.original_class)
			a_class.set_changed (True)
		end

feature {WORKBENCH_I, SYSTEM_I} -- WORKBENCH_I and SYSTEM_I support

	is_missing_class_ignored (a_class_name: STRING): BOOLEAN
			-- returns True if a missing class message should be ignored.
		do
			if a_class_name.is_equal ("PROCESSOR") then
				Result := True
			else
				Result := False
			end
		end

	remove_scoop_classes (a_class_name: STRING)
			-- removes scoop client and proxy class from cluster if there are any
		local
			l_file_name: FILE_NAME
			file: PLAIN_TEXT_FILE
		do
				-- prepare path
			create l_file_name.make
			l_file_name.set_directory (scoop_directory.name)
			l_file_name.add_extension ("e")

			-- delete client class
			l_file_name.set_file_name (a_class_name.as_lower)
			create file.make (l_file_name.string)
			if file.exists then
				file.delete
			end

			-- delete proxy class
			l_file_name.set_file_name (scoop_proxy_prefix + a_class_name)
			create file.make (l_file_name.string)
			if file.exists then
				file.delete
			end
		end

	scoop_override_cluster_path: STRING
			-- returns the path of the scoop cluster
		local
			l_scoop_path: DIRECTORY_NAME
		do
			-- create with home directory
			create l_scoop_path.make_from_string (workbench.project_location.eifgens_path.string)
			-- add project target cluster
			l_scoop_path.set_subdirectory (workbench.project_location.target)
			-- add cluster 'cluster'
			l_scoop_path.set_subdirectory ({SCOOP_SYSTEM_CONSTANTS}.scoop_override_cluster_name)

			Result := l_scoop_path.string
		end

feature {WORKBENCH_I, SYSTEM_I} -- Cluster handling implementation

	create_directory_name
			-- creates the scoop directory cluster name
		do
			create scoop_directory.make (scoop_override_cluster_path)
		end

	create_directory
			-- creates the scoop directory reference
		require
			scoop_directory_name_not_void: scoop_directory /= Void
		do
			-- create folder in system
			if not scoop_directory.exists then
				scoop_directory.create_dir
			end
		ensure
			scoop_directory_not_void: scoop_directory /= void
		end


	delete_scoop_cluster_content
			-- delete the content of the project cluster
		require
			scoop_directory_name_not_void: scoop_directory /= Void
		do
			if scoop_directory.exists and then not scoop_directory.is_empty then
				scoop_directory.delete_content
			end
		end

feature -- Element Change and Removal

	insert_class (a_class: CLASS_C)
			-- Add `a_class' to be processed.
		do
			a_class.add_to_degree_scoop
			count := count + 1
		end

	remove_class (a_class: CLASS_C)
			-- Remove `a_class'.
		do
			a_class.remove_from_degree_scoop
			count := count - 1
		end

	wipe_out
			-- Remove all classes.
		local
			i, nb: INTEGER
			classes: ARRAY [CLASS_C]
			a_class: CLASS_C
		do
			from
				i := 1
				nb := count
				classes := System.classes
			until
				nb = 0
			loop
				a_class := classes.item (i)
				if a_class /= Void then
					a_class.remove_from_degree_scoop
					nb := nb - 1
				end
				i := i + 1
			end
			count := 0
		end

	print_to_file (a_context, a_class_name: STRING; is_client_and_not_proxy: BOOLEAN)
			-- Print text of a_class_node.
		local
			file: PLAIN_TEXT_FILE
			l_local_file_name : STRING
			l_file_name: FILE_NAME
		do
				-- prepare path
			create l_file_name.make

			l_file_name.set_directory (scoop_directory.name)
			l_local_file_name := a_class_name.as_lower

			if not is_client_and_not_proxy then
				l_local_file_name := scoop_proxy_prefix + l_local_file_name
			end
			l_file_name.set_file_name (l_local_file_name)
			l_file_name.add_extension ("e")

				-- create file
			create file.make_create_read_write (l_file_name.string)

			file.put_string (a_context.string_representation)
			file.close

			debug ("SCOOP")
				if not is_client_and_not_proxy then
					io.error.put_string ("SCOOP: Proxy class 'SCOOP_SEPARATE__")
				else
					io.error.put_string ("SCOOP: Client class '")
				end
				io.error.put_string (a_class_name.as_lower + "' saved in '" + l_file_name + "'.")
				io.error.put_new_line
			end
		end

feature {NONE} -- Implementation

	collect_needed_classes
			-- takes currently all classes from 'system.classes'
			-- which are not basic classes
		local
			i: INTEGER
			l_classes: ARRAY [CLASS_C]
			l_class: CLASS_C
			l_system: like system
			l_scoop_classes: SCOOP_SEPARATE_CLASS_LIST
		do
			l_system := system
			l_classes := l_system.classes

			-- create class list
			create l_scoop_classes.make

			-- iterate over all classes
			from i := 1 until i > l_classes.count loop
				l_class ?= l_classes.item (i)

				if l_class /= Void and then not l_class.group.target.name.is_equal ({SCOOP_SYSTEM_CONSTANTS}.base_library_name) then
					l_scoop_classes.extend (l_class)
				end
				i := i + 1
			end

			-- set count
			count := l_scoop_classes.count

			-- set the classes in the workbench
			set_scoop_classes (l_scoop_classes)

			debug ("SCOOP")
				io.error.put_string ("SCOOP: Processing following classes:")
				io.error.put_new_line
				l_scoop_classes.print_all
			end
		end


--	collect_needed_classes is
--			-- visitor flags corresponding classes with the flag degree_scoop_needed
--			--	A SCOOP client and proxy class for class C should only be generated if
--			--	1) A separate type occures in C
--			--	2) C occures as separate type in an other class
--			--	3) D inherits from C and D occurs as separate type in another class.
--			--	4) D inherits from C and in C occures a separate type
--		local
--			i: INTEGER
--			l_str: STRING
--			l_classes: ARRAY [CLASS_C]
--			l_class: CLASS_C
--			l_system: like system
--			l_match_list: LEAF_AS_LIST
--			class_list_1, class_list_2, l_scoop_classes: SCOOP_SEPARATE_CLASS_LIST
--			l_separate_class_visitor: SCOOP_SEPARATE_CLASS_VISITOR
--		do
--			l_system := system
--			l_classes := l_system.classes
--			create class_list_1.make
--			create l_separate_class_visitor.make_with_separate_class_list (class_list_1)

--			from i := 1 until i > l_classes.count loop
--				l_class := l_classes.item (i)

--				if l_class /= Void and then l_class.is_separate_client then
--					-- class contains separate keyword

--						-- case 1)
--					if not class_list_1.has (l_class.name_in_upper) then
--						create l_str.make_from_string (l_class.name_in_upper)
--						class_list_1.extend (l_class)
--					end

--						-- case 2)
--					l_match_list := match_list_server.item (l_class.class_id)
--					l_separate_class_visitor.setup (l_class.ast, l_match_list, True, True)
--					l_separate_class_visitor.process_class_as (l_class.ast)
--				end

--				i := i + 1
--			end

--				-- case 3) add all parents
--			create class_list_2.make
--			from until class_list_1.is_empty loop
--				l_class := class_list_1.first
--				class_list_1.remove_first

--					-- insert current class
--				if not class_list_2.has_class (l_class) then
--					class_list_2.extend (l_class)
--				end

--					-- insert all not already processed parents in list 1
--				from i := 1 until i > l_class.parents_classes.count loop
--					if not class_list_2.has_class (l_class.parents_classes.i_th (i)) and then
--					   not class_list_1.has_class (l_class.parents_classes.i_th (i)) then
--						class_list_1.extend (l_class.parents_classes.i_th (i))
--					end

--					i := i + 1
--				end
--			end

--				-- case 4) add all descendants
--			create l_scoop_classes.make
--			from until class_list_2.is_empty loop
--				l_class := class_list_2.first
--				class_list_2.remove_first

--					-- insert current class
--				if not l_scoop_classes.has_class (l_class) then
--					l_scoop_classes.extend (l_class)
--				end

--					-- insert all not already processed descendants in list 2
--				from i := 1 until i > l_class.direct_descendants.count loop
--					if not l_scoop_classes.has_class (l_class.direct_descendants.i_th (i)) and then
--					   not class_list_2.has_class (l_class.direct_descendants.i_th (i)) then
--						class_list_2.extend (l_class.direct_descendants.i_th (i))
--					end

--					i := i + 1
--				end

--				-- set the classes in the workbench
--				scoop_workbench.set_scoop_classes (l_scoop_classes)

--				-- set count
--				count := l_scoop_classes.count
--			end

--			debug ("SCOOP")
--				io.error.put_string ("SCOOP: Processing following classes:")
--				io.error.put_new_line
--				l_scoop_classes.print_all
--			end
--		end

	setup_starter_class
		local
			starter : SCOOP_STARTER_CLASS
			root : CONF_ROOT
			root_class : STRING
		do
			create starter

			root := universe.lace.target.root

			root_class := root.class_type_name
			starter.create_starter_class (root_class, "make")

			print_to_file (starter.context , "SCOOP_STARTER" , True)
		end

--	any_class_c : CLASS_C

--	process_any_printer
--			-- Process client class of input class.
--		local
--			l_match_list: LEAF_AS_LIST
--			l_printer: SCOOP_ANY_ROUNDTRIP
--		do
--			debug ("SCOOP")
--				io.error.put_string ("SCOOP: removing {NONE} from ANY's `default_create'.")
--				io.error.put_new_line
--			end

--				-- reset workbench
--			scoop_workbench_objects.reset

--				-- set current processed class in workbench
--			set_current_class_c (any_class_c)
--			set_current_class_as (any_class_c.ast)

--				-- set feature table in workbench
--				-- was computed in degree 4.
--			if any_class_c.feature_table /= Void then
--				any_class_c.ast.set_feature_table (any_class_c.feature_table)
--			end


--				-- create proxy visitor to process.
--			l_match_list := match_list_server.item (any_class_c.class_id)
--			create l_printer.make_with_default_context

--			l_printer.setup (class_as , l_match_list, True, False)

--			l_printer.process


--				-- print_content to file.
--			print_to_file (l_printer.text, any_class_c, True)

--			workbench.add_class_to_recompile (any_class_c.original_class)
--			any_class_c.set_changed (True)
--		end


--	id_printer (a_class_c : CLASS_C)
--			-- Process client class of input class.
--		local
--			l_match_list: LEAF_AS_LIST
--			l_printer: AST_ROUNDTRIP_PRINTER_VISITOR
--		do
--			debug ("SCOOP")
--				io.error.put_string ("SCOOP: removing {NONE} from ANY's `default_create'.")
--				io.error.put_new_line
--			end

--				-- reset workbench
--			scoop_workbench_objects.reset

--				-- set current processed class in workbench
--			set_current_class_c (a_class_c)
--			set_current_class_as (a_class_c.ast)

--				-- set feature table in workbench
--				-- was computed in degree 4.
--			if a_class_c.feature_table /= Void then
--				a_class_c.ast.set_feature_table (a_class_c.feature_table)
--			end


--				-- create proxy visitor to process.
--			l_match_list := match_list_server.item (a_class_c.class_id)
--			create l_printer.make_with_default_context

--			l_printer.setup (class_as , l_match_list, True, False)

--			l_printer.process_ast_node (class_as)


--				-- print_content to file.
--			print_to_file (l_printer.text, a_class_c, True)

--			workbench.add_class_to_recompile (a_class_c.original_class)
--			a_class_c.set_changed (True)
--		end

	process_separate_client_creation (a_class_c: CLASS_C)
			-- Process client class of input class.
		local
			l_match_list: LEAF_AS_LIST
			l_printer: SCOOP_SEPARATE_CLIENT_PRINTER
		do
			debug ("SCOOP")
				io.error.put_string ("SCOOP: Client class of class '" + a_class_c.name_in_upper + "'.")
				io.error.put_new_line
			end

				-- create proxy visitor to process.
			l_match_list := match_list_server.item (a_class_c.class_id)
			l_printer := scoop_visitor_factory.new_client_printer
			l_printer.process_class

			debug ("SCOOP")
				io.error.put_string (l_printer.get_context)
				io.error.put_new_line
			end

				-- print_content to file.
			print_to_file (l_printer.get_context, a_class_c.name, True)
		end

	process_separate_proxy_creation (a_class_c: CLASS_C)
			-- Create proxy class of input class.
		local
			l_match_list: LEAF_AS_LIST
			l_printer: SCOOP_SEPARATE_PROXY_PRINTER
		do
			debug ("SCOOP")
				io.error.put_string ("SCOOP: Proxy class of class '" + a_class_c.name_in_upper + "'.")
				io.error.put_new_line
			end

				-- create proxy visitor to process.
			l_match_list := match_list_server.item (a_class_c.class_id)
			l_printer := scoop_visitor_factory.new_proxy_printer
			l_printer.process

			debug ("SCOOP")
				io.error.put_string (l_printer.get_context)
				io.error.put_new_line
			end

				-- print_content to file.
			print_to_file (l_printer.get_context, a_class_c.name, False)
		end


feature {WORKBENCH_I, SYSTEM_I} -- Implementation

	scoop_directory: DIRECTORY
			-- SCOOP directory in EIFGENs folder

	degree_5: DEGREE_5
			-- reference to degree 5

	scoop_proxy_prefix: STRING
			-- name prefix for proxy classes

invariant
	scoop_directory_not_void: scoop_directory /= Void

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

end -- class DEGREE_SCOOP
