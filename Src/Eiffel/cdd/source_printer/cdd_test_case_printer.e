indexing
	description: "Objects that print class text for a test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CASE_PRINTER

inherit

	CDD_CAPTURE_OBSERVER
		rename
			start as start_capturing,
			finish as finish_capturing
		end

	CDD_ROUTINES
		export
			{NONE} all
		end

	EB_CLUSTER_MANAGER_OBSERVER
		rename
			manager as cluster_manager
		end

	CONF_ACCESS
		export
			{NONE} all
		end

	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		end

	SHARED_FLAGS
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_cdd_manager: like cdd_manager) is
			-- Initialize `Current'.
		require
			a_cdd_manager_not_void: a_cdd_manager /= Void
		do
			cdd_manager := a_cdd_manager
		ensure
			cdd_manager_set: cdd_manager = a_cdd_manager
		end

feature -- Access

	is_initialized: BOOLEAN is
			-- Can we currently write any class text?
		do
			Result := failed or else (output_stream /= Void and then output_stream.is_open_write)
		end

	target: CONF_TARGET is
			-- Target in which test cases will be created
		do
			Result := cdd_manager.test_suite.target
		end

	cdd_manager: CDD_MANAGER
			-- CDD Manager

feature	-- Basic operations

	start_capturing (an_adv: ABSTRACT_DEBUG_VALUE; a_feature: E_FEATURE; a_class: CLASS_C; a_csid: STRING; a_cs_level: INTEGER) is
			-- Start capturing state for `a_feature' in `a_class'.
			-- `a_cs_uuid' is an ID for the call stack and `a_cs_level' is the
			-- index of the frame beeing captured.
		local
			l_prefix, l_new_path: STRING
			l_loc: CONF_LOCATION
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_paths: DS_LINKED_LIST [STRING]
			l_cluster: CONF_CLUSTER
			l_fs: KL_FILE_SYSTEM
			i: INTEGER
		do
			failed := False
			printed_objects := 0

				-- Build path list in which test case shall be stored
			create l_paths.make
			from
				l_cluster ?= a_class.group
			until
				l_cluster = Void
			loop
				l_paths.put_first (l_cluster.name)
				l_cluster := l_cluster.parent
			end
			l_paths.put_first (target.name)
			l_paths.put_first ("cdd_tests")

				-- Create directories from path list
			l_loc := conf_factory.new_location_from_path (".\", target)
			l_fs := file_system
			l_new_path := l_loc.build_path ("", "")
			from
				l_paths.start
			until
				l_paths.after or failed
			loop
				l_new_path := l_fs.pathname (l_new_path, l_paths.item_for_iteration)
				if not l_fs.directory_exists (l_new_path) then
					l_fs.create_directory (l_new_path)
					if not l_fs.directory_exists (l_new_path) then
						io.put_string ("%Tfailed%N")
						failed := True
					end
				end
				l_paths.forth
			end

			check new_path_not_void: l_new_path /= Void end

			if not failed then
				l_prefix := class_name_prefix + a_class.name + "_"
				from
					i := 1
				until
					l_output_file /= Void or i > 99
				loop
					create new_class_name.make_from_string (l_prefix)
					if i < 10 then
						new_class_name.append_character ('0')
					end
					new_class_name.append (i.out)
					create l_output_file.make (l_fs.pathname(l_new_path, new_class_name.as_lower + ".e"))
					if l_output_file.exists then
						l_output_file := Void
					end
					i := i + 1
				end
				if l_output_file = Void then
					failed := True
				end
			end

			if not failed then
				l_output_file.open_write
				if not l_output_file.is_open_write then
					failed := True
				else
					-- To here...
					create output_stream.make (l_output_file)

						-- Print test class headers
					put_indexing
					put_class_header (a_feature)

					put_set_up (an_adv, a_feature, is_creation_feature (a_feature))
					put_test_routine (a_class, a_feature, a_csid, a_cs_level)
					put_context_header

					--create new_class_path.make_from_string (l_new_path)
					create new_class_path.make_empty
					l_paths.remove_first
					l_paths.remove_first
					l_paths.do_all (agent (a_path, a_dir: STRING)
						do
							a_path.append ("/" + a_dir)
						end (new_class_path, ?))
				end
			end
		end

	put_object (an_id, a_type: STRING; an_inv: BOOLEAN; some_attributes: DS_LIST [STRING]) is
			-- Add a captured object of type `a_type' and attributes `some_attributes'.
			-- `an_id' is the associated id for reconstructing the state and `an_inv'
			-- indicated if the object has to fulfill its invariants.
		local
			l_attrs: STRING
			l_cursor: DS_LIST_CURSOR [STRING]
		do
			if not failed then
				if printed_objects > 0 then
					output_stream.put_string (",%N")
				end
				printed_objects := printed_objects + 1
				create l_attrs.make_from_string ("<< ")
				l_cursor := some_attributes.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					l_attrs.append ("%"" + l_cursor.item + "%"")
					if not l_cursor.is_last then
						l_attrs.append (", ")
					end
					l_cursor.forth
				end
				l_attrs.append (" >>")
				output_stream.indent
				output_stream.put_string ("[%"" + an_id + "%", %"" + a_type + "%", " + an_inv.out + ", " + l_attrs + "]")
				output_stream.dedent
			end
		rescue
			failed := True
			retry
		end

	finish_capturing is
			-- Set `output_stream' to `Void'.
		local
			l_cluster_name: STRING
			l_tests_cluster: CONF_CLUSTER
			l_cluster_list: LIST [CONF_CLUSTER]
			l_loc: CONF_DIRECTORY_LOCATION
			l_directory: KL_DIRECTORY
			l_new_test_class: CDD_TEST_CLASS
		do
			if not failed then
				output_stream.dedent
				output_stream.put_new_line
				output_stream.put_line (">>")
				output_stream.dedent
				output_stream.put_line ("end")
				output_stream.dedent
				put_class_footer
					-- TODO: Do we really need to flush before closing?
					-- Try to remove it?
				output_stream.flush
				output_stream.close

				l_cluster_name := target.name + "_tests"
				l_tests_cluster := cdd_manager.project.system.system.eiffel_universe.cluster_of_name (l_cluster_name)
				if l_tests_cluster = Void Then
					create l_directory.make (target.system.directory)
					l_cluster_list := cdd_manager.project.system.system.eiffel_universe.cluster_of_location (l_directory.name)
					if l_cluster_list.is_empty then
						-- Note (Arno): first version prints absolute path to cluster
						--cluster_manager.add_cluster (current_cluster.cluster_name + cluster_name_suffix, current_cluster, l_directory.name)

						-- Note: need to replace {EB_CLUSTERS}.add_cluster with own routine
						-- cluster_manager.add_cluster (l_cluster_name, Void, ".\" + l_cluster_name)
						l_loc := conf_factory.new_location_from_path (".\cdd_tests\" + target.name, target)
						l_tests_cluster := conf_factory.new_cdd_cluster (l_cluster_name, l_loc, target)
						l_tests_cluster.set_recursive (True)
						l_tests_cluster.set_classes (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))
						l_tests_cluster.set_classes_by_filename (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))

						target.add_cluster (l_tests_cluster)
						cdd_manager.project.system.system.set_config_changed (True)
						cluster_manager.refresh
					else
						l_tests_cluster := l_cluster_list.first
					end
				end
				cdd_manager.project.system.system.set_rebuild (True)
				if is_gui then
					cluster_manager.add_class_to_cluster (new_class_name.as_lower + ".e", l_tests_cluster, new_class_path)
				end
				parse_output_stream
				if not has_parse_error then
					create l_new_test_class.make_with_ast (last_parsed_class)
					cdd_manager.test_suite.add_test_class (l_new_test_class)
				end
			else
				if output_stream /= Void then
					output_stream.close
				end
				output_stream := Void
				failed := False
			end
		rescue
			failed := True
			retry
		end

feature {NONE} -- Parsing

	has_parse_error: BOOLEAN
			-- Did an error occur during last 'parse_class_file'?

	last_parsed_class: CLASS_AS
			-- AST generated by last call to `parse_class_file'.

	parse_output_stream is
			-- Parse eiffel class written to `output_stream'
			-- and store ast in `last_parsed_class'. If an
			-- error occurs, set `has_parse_error' to True.
		require
			output_stream_not_void: output_stream /= Void
		do
			has_parse_error := False
			safe_parse_class_file
		end

	safe_parse_class_file is
			-- Parse eiffel class written to `output_stream'
			-- and store ast in `last_parsed_class'. If an
			-- error occurs, catch any exceptions and set
			-- `has_parse_error' to True.
		require
			output_stream_not_void: output_stream /= Void
			has_parse_error_reset: has_parse_error = False
		local
			l_file: KL_BINARY_INPUT_FILE
		do
			if not has_parse_error then
				last_parsed_class := Void
				create l_file.make (output_stream.name)
				l_file.open_read
				eiffel_parser.parse (l_file)
				last_parsed_class := eiffel_parser.root_node
				if eiffel_parser.error_count > 0 then
					has_parse_error := True
					last_parsed_class := Void
				end
			end
		ensure
			parsed_or_error: (last_parsed_class /= Void) xor has_parse_error
		rescue
			has_parse_error := True
			last_parsed_class := Void
			retry
		end

feature {NONE} -- Implementation

	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output stream

	failed: BOOLEAN
			-- Has `Current' raised any exception since last call to `start_capturing'?

	new_class_name: STRING
			-- Class name of the new test case

	new_class_path: STRING
			-- Path to new class

	printed_objects: INTEGER
			-- Number of objects printed to context since last `start_capturing'

	put_indexing is
			-- Append indexing clause using `an_uuid' for call
			-- stack id and `an_index' for call stack index.
		require
			initialized_and_not_failed: is_initialized and not failed
		do
			output_stream.put_line ("indexing%N")
			output_stream.indent
			output_stream.put_line ("description: %"Automatically extracted test class%"")
			output_stream.put_line ("author: %"EiffelStudio CDD Tool%"")
			output_stream.dedent
			output_stream.put_line ("")
		end

	put_class_header (a_feature: E_FEATURE) is
			-- Append cdd test case class header with name `a_class_name' for testing `a_cut_name'.
			-- The feature under test takes the arguments listed in `a_arg_list'.
		require
			initialized_and_not_failed: is_initialized and not failed
			a_feature_not_void: a_feature /= Void
		do
			output_stream.put_line ("class")
			output_stream.indent
			output_stream.put_line (new_class_name + "%N")
			output_stream.dedent
			output_stream.put_line ("inherit")
			output_stream.put_new_line
			output_stream.indent
			output_stream.put_line ("CDD_EXTRACTED_TEST_CASE")
			output_stream.indent
			output_stream.put_line ("rename")
			output_stream.indent
			output_stream.put_line ("test as test_" + a_feature.name)
			output_stream.dedent
			output_stream.put_line ("redefine")
			output_stream.indent
			output_stream.put_line ("test_" + a_feature.name)
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
			output_stream.dedent
			output_stream.put_new_line
		end

	put_set_up (an_adv: ABSTRACT_DEBUG_VALUE; a_feature: E_FEATURE; an_is_creation_call: BOOLEAN) is
			-- Append class header text for 'test_class_name'
		require
			initialized_and_not_failed: is_initialized and not failed
			a_feature_not_void: a_feature /= Void
		local
			i: INTEGER
			l_agent, l_class: STRING
			l_is_fix: BOOLEAN
			l_ops: DS_LINKED_LIST [STRING]
			l_cursor: DS_LINKED_LIST_CURSOR [STRING]
		do
			output_stream.put_line ("feature {NONE} -- Setup%N")
			output_stream.indent
			output_stream.put_line ("set_up_routine is")
			output_stream.indent
			output_stream.indent
			output_stream.put_line ("-- Initialize agent that calls feature under test.")
			output_stream.dedent
			output_stream.put_line ("do")
			output_stream.indent
			l_class := an_adv.dump_value.generating_type_representation (True) -- a_feature.associated_class.name_in_upper
			l_agent := "routine_under_test := agent"
			l_is_fix := a_feature.is_infix or a_feature.is_prefix
			if an_is_creation_call or l_is_fix then
				create l_ops.make
				if a_feature.argument_count > 0 or l_is_fix then
					if l_is_fix then
						l_ops.put_last (l_class)
					end
					from
						i := 1
					until
						i > a_feature.argument_count
					loop
						l_ops.put_last (a_feature.arguments.i_th (i).associated_class.name_in_upper)
						i := i + 1
					end

					create l_cursor.make (l_ops)
					l_agent.append (" (")
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						l_agent.append ("an_arg" + l_cursor.index.out + ": " + l_cursor.item)
						if not l_cursor.is_last then
							l_agent.append ("; ")
						end
						l_cursor.forth
					end
					l_agent.append (")")
				end
				if a_feature.has_return_value then
					l_agent.append (": " + a_feature.type.dump)
				else
					l_agent.append (": " + l_class)
				end
				output_stream.put_line (l_agent)
				output_stream.indent
				output_stream.put_line ("do")
				output_stream.indent
				if an_is_creation_call then
					l_agent := "Result := create {" + l_class + "}." + a_feature.name
					if a_feature.argument_count > 0 then
						l_agent.append (" (")
						from
							i := 1
						until
							i > a_feature.argument_count
						loop
							l_agent.append ("an_arg" + i.out)
							if i < a_feature.argument_count then
								l_agent.append (", ")
							end
							i := i + 1
						end
						l_agent.append (")")
					end
				elseif a_feature.is_infix then
					l_agent := "Result := an_arg1 " + a_feature.infix_symbol + " an_arg2"
				else
					l_agent := "Result := " + a_feature.prefix_symbol + "an_arg1"
				end
				output_stream.put_line (l_agent)
				output_stream.dedent
				output_stream.put_line ("end")
				output_stream.dedent
			else
				output_stream.put_line (l_agent + " {" + l_class + "}." + a_feature.name)
			end
			output_stream.dedent
			output_stream.put_line ("end%N")
			output_stream.dedent
			output_stream.dedent
		end

	put_context_header is
			-- Print feature definition for context.
		require
			initialized_and_not_failed: is_initialized and not failed
		do

			output_stream.put_line ("feature -- Extracted data%N")

				-- Context
			output_stream.indent
			output_stream.put_line ("context: ARRAY [TUPLE [id: STRING; type: STRING; inv: BOOLEAN; attributes: ARRAY [STRING]]] is")
			output_stream.indent
			output_stream.indent
			output_stream.put_line ("-- Context for executing test case")
			output_stream.put_line ("-- NOTE: by definition first element is operand for calling `routine_under_test'.")
			output_stream.dedent
			output_stream.put_line ("once")
			output_stream.indent
			output_stream.put_line ("Result := <<")
			output_stream.indent
		end

	put_test_routine (a_class: CLASS_C; a_feature: E_FEATURE; a_csid: STRING; a_csindex: INTEGER) is
			-- Append class header text for `test_class_name'.
		require
			initialized_and_not_failed: is_initialized and not failed
			a_feature_not_void: a_feature /= Void
			a_csid_not_empty: a_csid /= Void and then not a_csid.is_empty
			a_csindex_positive: a_csindex > 0
		local
			l_feature_name: STRING
		do
			output_stream.put_line ("feature -- Testing%N")
			output_stream.indent
			output_stream.put_line ("test_" + a_feature.name + " is")
			output_stream.indent
			output_stream.indent
			output_stream.put_line ("-- Execute routine under test")
			output_stream.dedent

			if a_feature.is_infix then
				l_feature_name := "infix %%%"" + a_feature.infix_symbol + "%%%""
			elseif a_feature.is_prefix then
				l_feature_name := "prefix %%%"" + a_feature.prefix_symbol + "%%%""
			else
				l_feature_name := a_feature.name
			end
			output_stream.put_line ("indexing")
			output_stream.indent
			output_stream.put_line ("tag: %"covers." + a_class.name_in_upper + "." + a_feature.name + "%"")
			output_stream.put_line ("tag: %"failure." + a_csid + "." + a_csindex.out + ": " + a_feature.name + "%"")
			output_stream.dedent
			output_stream.put_line ("do")
			output_stream.indent
			output_stream.put_line ("Precursor {CDD_EXTRACTED_TEST_CASE}")
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
			output_stream.dedent
			output_stream.put_new_line
		end

	put_class_footer is
			-- Append class footer for test_class_name.
		require
			initialized_and_not_failed: is_initialized and not failed
		do
			output_stream.put_line ("%N%Nend")
		end

	conf_factory: CONF_COMP_FACTORY is
			-- Factory for creating CONF_LOCATION
		once
			create Result
		end

invariant
	initialized_and_not_failed_implies_valid_class_name:
		(is_initialized and not failed) implies new_class_name /= Void
	initialized_and_not_failed_implies_valid_path_:
		(is_initialized and not failed) implies new_class_path /= Void
	cdd_manager_not_void: cdd_manager /= Void
end
