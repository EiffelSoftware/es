indexing
	description: "Summary description for {JS_HELPER_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_HELPER_ROUTINES

inherit
	SHARED_SERVER
		export {NONE} all end

	DOCUMENTATION_EXPORT
		export {NONE} all end

feature {NONE}

	name_for_argument (a_argument: !ARGUMENT_B): STRING
		do
			Result := "r" + a_argument.position.out
		end

	name_for_local (a_local: !LOCAL_B): STRING
		do
			Result := "l" + a_local.position.out
		end

	name_for_current: STRING
		do
			Result := "Current"
		end

	name_for_result: STRING
		do
			Result := "Result"
		end

	name_for_void: STRING
		do
			Result := "null"
		end

	attribute_designator (a_attribute: !ATTRIBUTE_B): STRING
		local
			c: TYPE_A
			t: TYPE_A
			n: STRING
		do
			c := system.class_of_id (a_attribute.written_in).actual_type
			t := system.class_of_id (a_attribute.written_in).feature_of_rout_id (a_attribute.routine_id).type.actual_type
			n := system.class_of_id (a_attribute.written_in).feature_of_rout_id (a_attribute.routine_id).feature_name
			Result := "<" + type_string(c) + ": " + type_string (t) + " " + n + ">"
		end

	attr_designator (a_feat: !FEATURE_I): STRING
		local
			c: TYPE_A
		do
			c := system.class_of_id (a_feat.written_in).actual_type
			Result := "<" + type_string (c) + ": " + type_string (a_feat.type) + " " + a_feat.feature_name + ">"
		end

	routine_signature (as_creation_procedure: BOOLEAN; a_feature: FEATURE_I): STRING
		local
			l_argument_name, l_argument_type: STRING
			at_least_one_arg: BOOLEAN
		do
			Result := type_string (a_feature.type.actual_type) + " "
			if as_creation_procedure then
				Result := Result + "<" + a_feature.feature_name + ">"
			else
				Result := Result + a_feature.feature_name
			end
			Result := Result + "("
			if {arguments: !FEAT_ARG} a_feature.arguments then
				from
					arguments.start
				until
					arguments.off
				loop
					l_argument_name := arguments.item.name
					l_argument_type := type_string (arguments.item.actual_type)

					if at_least_one_arg then
						Result := Result + ", "
					else
						at_least_one_arg := True
					end
					Result := Result + l_argument_type

					arguments.forth
				end
			end
			Result := Result + ")"
		end

	type_string (type: TYPE_A): !STRING
		do
			if type = Void then
				Result := "UnknownType!!!"
			elseif type.is_void then
				Result := "void"
			elseif type.is_integer or type.is_natural then
				Result := "int"
			elseif type.is_boolean then
				Result := "boolean"
			elseif type.associated_class = Void then
				Result := "ANY"
			else
				if {s: !STRING} type.actual_type.associated_class.name_in_upper then
					Result := s
				else
					Result := "UnknownType!!!"
				end
			end
		end

	unsupported (goodie: STRING)
		local
			l_exception: JS_NOT_SUPPORTED_EXCEPTION
		do
			create l_exception.make (goodie + " not supported")
			l_exception.raise
		end

	error (message: STRING)
		local
			l_exception: JS_ERROR
		do
			create l_exception.make (message)
			l_exception.raise
		end


	solved_path (a_executable_name: STRING): STRING
           -- Solved path of `a_executable_name'.
           -- If in Windows, Result will be equal to `a_executable_name'.
       local
           l_prc_factory: PROCESS_FACTORY
           l_prc: PROCESS
       do
           if {PLATFORM}.is_windows then
               Result := a_executable_name.twin
           else
               Result := output_from_program ("/bin/sh -c %"which " + a_executable_name + "%"", Void)
               Result.replace_substring_all ("%N", "")
           end
       end


	should_consider_class (a_class: CLASS_C): BOOLEAN
		do
			Result := a_class /= Void and then
				not a_class.is_expanded and then
				not a_class.is_external and then
				not a_class.is_class_any and then
				not a_class.is_class_none and then
				not has_ignores_info (a_class, a_class.ast.top_indexes) and then
				not has_ignores_info (a_class, a_class.ast.bottom_indexes)
		end

	should_consider_method (a_match_list: LEAF_AS_LIST; a_feature_as: !FEATURE_AS): BOOLEAN
		local
			comments: EIFFEL_COMMENTS
		do
			Result := True
			comments := a_feature_as.comment (a_match_list)
			if comments /= Void then
				from
					comments.start
				until
					comments.off or not Result
				loop
					if comments.item.content.has_substring ("sl_ignore") then
						Result := False
					end
					comments.forth
				end
			end
		end

	should_consider_routine (a_class: !CLASS_C; a_feature: !FEATURE_I): BOOLEAN
		local
			match_list: LEAF_AS_LIST
		do
			match_list := match_list_server.item (a_class.class_id)
			if {body: !FEATURE_AS} a_feature.body then
				Result := should_consider_method (match_list, body)
			end
		end

	has_ignores_info (a_class: CLASS_C; a_indexing_clause: INDEXING_CLAUSE_AS): BOOLEAN
		local
			l_content: STRING
		do
			if a_indexing_clause /= Void then
				from
					a_indexing_clause.start
				until
					a_indexing_clause.off
				loop
					if
						{l_index_as: !INDEX_AS} a_indexing_clause.item and then
						equal ("SL_INFO", l_index_as.tag.name.as_upper)
					then
						l_content := l_index_as.content_as_string
						l_content := l_content.substring (2, l_content.count - 1)
						if l_content.has_substring ("ignore") then
							Result := True
						end
					end
					a_indexing_clause.forth
				end
			end
		end

   output_from_program (a_command: STRING; a_working_directory: STRING): STRING
           -- Output from the execution of `a_command' in (possibly) `a_working_directory'.
           -- Note: You may need to prune the final new line character.
       local
           l_prc_factory: PROCESS_FACTORY
           l_prc: PROCESS
           l_buffer: STRING
       do
           create l_prc_factory
           l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
           create Result.make (1024)
           l_prc.redirect_output_to_agent (agent Result.append ({STRING}?))
           l_prc.launch
           if l_prc.launched then
               l_prc.wait_for_exit
           end
       end

end
