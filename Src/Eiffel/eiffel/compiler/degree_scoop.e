indexing
	description: "Summary description for {DEGREE_SCOOP}."
	author: ""
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

	is_degree_scoop_needed: BOOLEAN is
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

feature {SYSTEM_I} -- Processing

	execute is
			-- Process all classes.
		local
			i: INTEGER
			a_class: CLASS_C
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
				a_class := scoop_classes.item (i)


				l_degree_output.put_degree_scoop (a_class, count - i + 1)

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


				if not is_basic_type (a_class.name_in_upper) and not a_class.is_basic then
					-- create original classes
					process_separate_client_creation (a_class)

					-- creation of proxy classes
					process_separate_proxy_creation (a_class)
				end

				-- force system to check class again
				workbench.add_class_to_recompile (a_class.original_class)
				a_class.set_changed (True)

				i := i + 1
			end

			system.any_class.compiled_class.feature_named ("default_create").set_export_status (create {EXPORT_ALL_I})

			if not system.is_explicit_root ("SCOOP_STARTER", "make") then
				system.add_explicit_root (Void, "SCOOP_STARTER", "make")
			end


			l_degree_output.put_end_degree
		end

feature {SYSTEM_I} -- SYSTEM_I support

	is_missing_class_ignored (a_class_name: STRING): BOOLEAN is
			-- returns true if a missing class message should be ignored.
		do
			if a_class_name.is_equal ("PROCESSOR") then
				Result := true
			else
				Result := false
			end
		end

	reset_scoop_processing is
			-- reset SCOOP processing environment
		do
			-- delete old generated classes
			delete_scoop_cluster_content
		end

	get_scoop_cluster_path: STRING is
			-- returns the path of the scoop cluster as string
		do
			Result := get_cluster_path.string
		end

	remove_scoop_classes (a_class_name: STRING) is
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

feature {NONE} -- Cluster handling implementation

	create_directory_name is
			-- creates the scoop directory cluster name
		do
			create scoop_directory.make (get_scoop_cluster_path.string)
		end

	create_directory is
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

	get_cluster_path: DIRECTORY_NAME is
			-- returns the path of the scoop cluster
		local
			l_scoop_path: DIRECTORY_NAME
		do
			-- create with home directory
			create l_scoop_path.make_from_string (workbench.project_location.eifgens_path.string)
			-- add project target cluster
			l_scoop_path.set_subdirectory (workbench.project_location.target)
			-- add cluster 'cluster'
			l_scoop_path.set_subdirectory ("scoop_cluster")

			Result := l_scoop_path
		end

	group_exists (a_group: STRING; a_target: CONF_TARGET): BOOLEAN is
			-- Check if 'a_target' or any child of 'a_target' already has 'a_group'.
		require
			a_group_ok: a_group /= Void and then not a_group.is_empty
		local
			l_groups: HASH_TABLE [CONF_GROUP, STRING_8]
		do
			l_groups := a_target.groups
			Result := l_groups.has_key (a_group.as_lower) and then l_groups.found_item.name.is_equal (a_group.as_lower)
			if not Result then
				Result := a_target.child_targets.there_exists (agent group_exists(a_group.as_lower, ?))
			end
		end

	delete_scoop_cluster_content is
			-- delete the content of the project cluster
		require
			scoop_directory_name_not_void: scoop_directory /= Void
		do
			if scoop_directory.exists and then not scoop_directory.is_empty then
				scoop_directory.delete_content
			end
		end

feature -- Element Change and Removal

	insert_class (a_class: CLASS_C) is
			-- Add `a_class' to be processed.
		do
			a_class.add_to_degree_scoop
			count := count + 1
		end

	remove_class (a_class: CLASS_C) is
			-- Remove `a_class'.
		do
			a_class.remove_from_degree_scoop
			count := count - 1
		end

	wipe_out is
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

feature {NONE} -- Implementation

	collect_needed_classes is
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

				if l_class /= Void and then
				   not l_class.is_basic and
				   not is_basic_type (l_class.name_in_upper) then
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
--					l_separate_class_visitor.setup (l_class.ast, l_match_list, true, true)
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

			print_to_file (starter.get_context , "SCOOP_STARTER" , true)

			root.set_class_type_name ("SCOOP_STARTER")
			root.set_feature_name ("make")


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

--			l_printer.setup (class_as , l_match_list, true, false)

--			l_printer.process


--				-- print_content to file.
--			print_to_file (l_printer.text, any_class_c, true)

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

--			l_printer.setup (class_as , l_match_list, true, false)

--			l_printer.process_ast_node (class_as)


--				-- print_content to file.
--			print_to_file (l_printer.text, a_class_c, true)

--			workbench.add_class_to_recompile (a_class_c.original_class)
--			a_class_c.set_changed (True)
--		end

	process_separate_client_creation (a_class_c: CLASS_C) is
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
			print_to_file (l_printer.get_context, a_class_c.name, true)
		end

	process_separate_proxy_creation (a_class_c: CLASS_C) is
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
			print_to_file (l_printer.get_context, a_class_c.name, false)
		end

	print_to_file (a_context, a_class_name: STRING; is_client_and_not_proxy: BOOLEAN) is
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

	scoop_directory: DIRECTORY
			-- SCOOP directory in EIFGENs folder

	degree_5: DEGREE_5
			-- reference to degree 5

	scoop_proxy_prefix: STRING
			-- name prefix for proxy classes

invariant
	scoop_directory_not_void: scoop_directory /= Void

note
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
