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

	CDD_CLASS_PRINTER
		rename
			finish as finish_printing
		export
			{NONE} all
		end

	CDD_ROUTINES
		export
			{NONE} all
		end

create
	make_with_cluster

feature -- Initialization

	make_with_cluster, set_cluster (a_cluster: like cluster) is
			-- Set `a_cluster' to cluster
		require
			a_cluster_not_void: a_cluster /= Void
		do
			cluster := a_cluster
		ensure
			cluster_set: cluster = a_cluster
		end

feature -- Access

	is_initialized: BOOLEAN is
			--
		do
			Result := failed or else is_output_stream_valid
		end

	cluster: CLUSTER_I
			-- Cluster in which test cases will be created

feature	-- Basic operations

	start_capturing (a_feature: E_FEATURE; a_class: CLASS_C; a_cs_uuid: UUID; a_cs_level: INTEGER) is
			-- Start capturing state for `a_feature' in `a_class'.
			-- `a_cs_uuid' is an ID for the call stack and `a_cs_level' is the
			-- index of the frame beeing captured.
		local
			l_class_name: STRING
			an_output_file: KL_TEXT_OUTPUT_FILE
		do
			failed := False
			printed_objects := 0
			l_class_name := new_class_name (a_class)
			if l_class_name = Void then
				failed := True
			else
				create an_output_file.make (cluster.location.build_path ("", l_class_name.as_lower + ".e"))
				an_output_file.open_write
				if not an_output_file.is_open_write then
					failed := True
				else
					initialize (an_output_file)

						-- Print test class headers
					put_indexing (a_cs_uuid.out, a_cs_level)
					put_class_header (l_class_name)

					put_set_up (a_feature, is_creation_feature (a_feature))
					put_access (a_class.name_in_upper, a_feature)

					put_line ("feature -- Context%N")

						-- Context
					increase_indent
					put_line ("context: ARRAY [TUPLE [STRING, STRING, BOOLEAN, ARRAY [STRING]]] is")
					increase_indent
					put_comment ("Context for executing test case")
					put_comment ("NOTE: by definition first element is operand for calling `routine_under_test'")
					put_line ("once")
					increase_indent
					put_line ("Result := <<")
					increase_indent
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
					put_string (",%N")
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
				put_string (indent)
				put_string ("[%"" + an_id + "%", %"" + a_type + "%", " + an_inv.out + ", " + l_attrs + "]")
			end
		rescue
			failed := True
			retry
		end

	finish_capturing is
			-- Set `output_stream' to `Void'.
		do
			if not failed then
				decrease_indent
				put_string ("%N")
				put_line (">>")
				decrease_indent
				put_line ("end")
				decrease_indent
				put_class_footer
				output_stream.flush
				output_stream.close
				finish_printing
			end
		rescue
			failed := True
			retry
		end

feature {NONE} -- Implementation

	failed: BOOLEAN
			-- Has `Current' raised any exception since last call to `start_capturing'?

	printed_objects: INTEGER
			-- Number of objects printed to context since last `start_capturing'

	new_class_name (a_cud: CLASS_C): STRING is
			-- New unique test class name for testing `a_cud' in `a_cluster'.
			-- Note: Result is Void if there are already 99 test classes for `a_cud'.
		require
			a_cud_not_void: a_cud /= Void
		local
			l_prefix: STRING
			l_file: KL_TEXT_INPUT_FILE
			i: INTEGER
		do
			l_prefix := "CDD_TEST_" + a_cud.name + "_"
			from
				i := 1
			until
				Result /= Void or i > 99
			loop
				create Result.make_from_string (l_prefix)
				if i < 10 then
					Result.append_character ('0')
				end
				Result.append (i.out)
				create l_file.make (cluster.location.build_path ("", Result.as_lower + ".e"))
				if l_file.exists then
					Result := Void
				end
				i := i + 1
			end
		ensure
			not_empty: Result = Void or else not Result.is_empty
		end

	put_indexing (an_uuid: STRING; an_index: INTEGER) is
			-- Append indexing clause using `an_uuid' for call
			-- stack id and `an_index' for call stack index.
		require
			initialized: is_initialized
			an_uuid_not_empty: an_uuid /= Void and then not an_uuid.is_empty
			an_index_positive: an_index > 0
		do
			put_line ("indexing%N")
			increase_indent
			put_line ("description: %"Objects that represent a cdd test case%"")
			put_line ("call_stack_uuid: %"" + an_uuid + "%"")
			put_line ("call_stack_index: " + an_index.out + "")
			put_line ("author: %"CDD Tool%"")
			put_line ("date: %"$Date$%"")
			put_line ("revision: %"$Revision$%"")
			decrease_indent
			put_line ("")
		end

	put_class_header (a_class_name: STRING) is
			-- Append cdd test case class header with name `a_class_name' for testing `a_cut_name'.
			-- The feature under test takes the arguments listed in `a_arg_list'.
		require
			initialized: is_initialized
			a_class_name_not_empty: a_class_name /= Void and then not a_class_name.is_empty
		do
			put_line ("class")
			increase_indent
			put_line (a_class_name + "%N")
			decrease_indent
			put_line ("inherit")
			increase_indent
			put_line ("CDD_EXTRACTED_TEST_CASE%N")
			decrease_indent
			put_line ("create")
			increase_indent
			put_line ("make%N")
			decrease_indent
		end

	put_set_up (a_feature: E_FEATURE; an_is_creation_call: BOOLEAN) is
			-- Append class header text for 'test_class_name'
		require
			initialized: is_initialized
			a_feature_not_void: a_feature /= Void
		local
			i: INTEGER
			l_agent, l_class: STRING
		do
			put_line ("feature {NONE} -- Initialization%N")
			increase_indent
			put_line ("set_up_routine is")
			increase_indent
			put_comment ("Initialize agent that calls feature under test")
			put_line ("do")
			increase_indent
			l_class := a_feature.associated_class.name_in_upper
			l_agent := "routine_under_test := agent "
			if an_is_creation_call or a_feature.is_infix or a_feature.is_prefix then
				if a_feature.argument_count > 0 then
					l_agent.append ("(")
					from
						i := 1
					until
						i > a_feature.argument_count
					loop
						l_agent.append ("an_arg" + i.out + ": " + a_feature.arguments.i_th (i).associated_class.name_in_upper)
						if i < a_feature.argument_count then
							l_agent.append ("; ")
						end
						i := i + 1
					end
					l_agent.append (")")
				end
				if a_feature.has_return_value then
					l_agent.append (": " + a_feature.associated_class.name_in_upper)
				else
					l_agent.append (": " + l_class)
				end
				put_line (l_agent)
				increase_indent
				put_line ("do")
				increase_indent
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
				put_line (l_agent)
				decrease_indent
				put_line ("end")
				decrease_indent
			else
				put_line (l_agent + "{" + l_class + "}." + a_feature.name)
			end
			decrease_indent
			put_line ("end%N")
			decrease_indent
			decrease_indent
		end

	put_access (a_cut_name: STRING; a_feature: E_FEATURE) is
			-- Append class header text for `test_class_name'.
		require
			initialized: is_initialized
			a_cut_name_not_empty: a_cut_name /= Void and then not a_cut_name.is_empty
			a_feature_not_void: a_feature /= Void
		local
			l_feature_name: STRING
		do
			put_line ("feature -- Access%N")
			increase_indent
			put_line ("class_under_test: STRING is %"" + a_cut_name + "%"")
			put_comment ("Name of the class beeing tested%N")
			if a_feature.is_infix then
				l_feature_name := "infix %%%"" + a_feature.infix_symbol + "%%%""
			elseif a_feature.is_prefix then
				l_feature_name := "prefix %%%"" + a_feature.prefix_symbol + "%%%""
			else
				l_feature_name := a_feature.name
			end
			put_line ("feature_under_test: STRING is %"" + l_feature_name + "%"")
			put_comment ("Name of the feature beeing tested%N")
			decrease_indent
		end

	put_class_footer is
			-- Append class footer for test_class_name.
		do
			put_string ("%N%Nend -- class %N%N")
		end

end
