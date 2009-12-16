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
