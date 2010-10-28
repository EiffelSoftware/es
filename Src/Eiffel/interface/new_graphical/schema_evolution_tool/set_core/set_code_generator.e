note
	description: "The code generator for conversion functions."
	author: "Teseo Schneider, Marco Piccioni"
	date: "09.04.09"

class
	SET_CODE_GENERATOR

	create
		make

feature{NONE} --fields

	const: SET_UTILITY_AND_CONSTANTS
		-- Utilities and constants.

feature --message

	converter_messages: STRING
		-- Store information about converters.

feature -- Creation

	make
			-- Default creation.
		do
			create const
			converter_messages := ""
		end

feature -- Code generation

	filter_code (class_name: STRING; default_fields_value: DS_HASH_TABLE [STRING, STRING]): STRING
			-- The filter of the class `class_name' and default field values.
		require
			class_name_exist: class_name /= Void and then not class_name.is_empty
			default_fields_value_exist: default_fields_value /= Void
		do
			class_name.to_upper
			Result := (filter_content(class_name,default_fields_value))
		ensure
			result_not_void: Result /= Void
		end

feature -- Code instrumentation

	add_inheritance_clause_from_filtered_class (source_code, class_name: STRING): STRING
			-- Add inheritance clause from filtered_class.
		require
			class_name_exists: class_name /= Void and then not class_name.is_empty
			source_code_exists: source_code /= Void
		local
			--file: PLAIN_TEXT_FILE
			current_line: STRING
			is_filtered_class_written, is_filter_written: BOOLEAN
			content: STRING
			lines: LIST[STRING]
		do
			--create file.make_open_read (dir.name)
			is_filtered_class_written := false
			is_filter_written := false
			content := ""
			lines := source_code.split ('%N')

			from lines.start until lines.after loop
				current_line := lines.item_for_iteration

				if current_line.has_substring ("inherit") and not is_filtered_class_written then
					is_filtered_class_written := true
					content := content + current_line + "%N" +
					"%T" + const.filtered_class + "%N%N"
					lines.forth
					current_line := lines.item_for_iteration
				elseif (current_line.has_substring ("create") or current_line.has_substring ("feature")) and not is_filtered_class_written then
					is_filtered_class_written := true
					content := content + "inherit" + "%N" +
					"%T" + const.filtered_class + "%N%N"
				end
				if current_line.has_substring ("feature") and not is_filter_written then
					is_filter_written := true
					content := content + "feature -- Filter implementation%N" +
						"%Tfilter: STRING is%N" +
						"%T%T%T-- The filter of the class%N" +
						"%T%Tdo%N" +
						"%T%T%TResult:=%"" + class_name + const.Filter_suffix + "%"%N" +
						"%T%Tend%N"
				end
				content := content + current_line + "%N"
				lines.forth
			end
			Result := content
		ensure
			result_exists: Result /= Void and then not Result.is_empty
		end

feature -- Handlers management

	update_main_handler_code (source_code_input, class_name: STRING): STRING
			-- Add handler of class `class_name' to the main handler code.
		require
			souce_code_no_void: source_code_input /= Void
			class_name_exist: class_name /= Void and then not class_name.is_empty
		local
			is_found: BOOLEAN
			line, content: STRING
			lines: LIST[STRING]
			source_code: STRING
		do
			if source_code_input.is_empty then
				source_code := get_main_handler_body
			else
				source_code := source_code_input
			end
			lines := source_code.split ('%N')
			is_found := false
			content := ""
			class_name.to_upper
			from lines.start until lines.after loop
				line := lines.item_for_iteration

				if line.has_substring ("end") and not is_found then
					content := content + "%T%T%Tpatch.force_last (create {" + class_name + const.Schema_evolution_handler_suffix + "}.make, %"" + class_name + "%")%N"
					is_found := true
				end
				content := content + line + "%N"
				lines.forth
			end
			Result := content
		ensure
			result_not_void: Result /= Void
		end

	update_class_handler_code (source_code: STRING; ver1,ver2: INTEGER; attribute_list_v1, attribute_list_v2: DS_HASH_TABLE [STRING, STRING]): STRING
			-- Updates the existing handler code.
		require
			souce_code_exists: source_code /= Void
			attribute_list_version1_exists: attribute_list_v1 /= Void
			attribute_list_version2_exists: attribute_list_v2 /= Void
		local
			line: STRING
			is_creation_feature_inserted, is_function_inserted: BOOLEAN
			last_end: INTEGER
			lines: LIST[STRING]
		do
			Result := ""
			is_creation_feature_inserted := false
			is_function_inserted := false
			converter_messages := ""
			lines := source_code.split ('%N')
			from lines.start until lines.after loop
				line := lines.item_for_iteration
				Result.append(line + "%N")
				if not is_creation_feature_inserted and then line.has_substring ("Precursor {" + const.Schema_evolution_handler_class + "}") then
					Result.append ("%T%Tset_conversion_function (" + ver1.out + "," + ver2.out + "," + function_name (ver1, ver2) + ")%N")
					is_creation_feature_inserted := true
				end
				if not is_function_inserted and then line.has_substring ("feature {NONE} --version " + ver1.out) then
					Result.append (conversion_function (ver1, ver2,attribute_list_v1,attribute_list_v2))
					is_function_inserted := true
				end
				if line.has_substring ("end") then
					last_end := Result.count - 4
				end
				lines.forth
			end
			if not is_function_inserted then
				line :=
				"%Nfeature {NONE} --version " + ver1.out + "%N" +
				conversion_function (ver1,ver2,attribute_list_v1,attribute_list_v2) + "%N"
				Result.insert_string (line, last_end)
			end
		ensure
			result_not_void: Result /= Void
		end

	class_handler_code (ver1,ver2: INTEGER; class_name: STRING; attribute_list_v1, attribute_list_v2: DS_HASH_TABLE [STRING, STRING]): STRING
			-- The class handler body.
		require
			class_name_exist: class_name /= Void and then not class_name.is_empty
			attribute_list_version1_exists: attribute_list_v1 /= Void
			attribute_list_version2_exists: attribute_list_v2 /= Void
		do
			converter_messages := ""
			class_name.to_upper
			Result := "indexing%N" +
			"%Tdescription: %"Schema evolution handler for the " + class_name + " class%"%N%N" +
			"class%N" +
			"%T" + class_name + const.Schema_evolution_handler_suffix + "%N%N" +
			"inherit%N" +
			"%T" + const.Schema_evolution_handler_class + "%N" +
			"%T%Tredefine%N" +
			"%T%T%T%Tmake%N" +
			"%T%Tend%N%N" +
			"create make%N%N" +
			"feature%N" +
			"%Tmake is%N" +
			"%T%T%T--constructor%N" +
			"%Tdo%N" +
			"%T%TPrecursor {" + const.Schema_evolution_handler_class + "}%N" +
			"%T%Tset_convertion_function (" + ver1.out + "," + ver2.out + "," + function_name(ver1,ver2) + ")%N" +
			"%Tend%N%N" +
			"feature {NONE} --version " + ver1.out + "%N" +
			conversion_function (ver1, ver2, attribute_list_v1, attribute_list_v2) +
			"%Nend"
		ensure
			result_exists: Result /= Void
		end

feature {NONE} --Implementation

	conversion_function (ver1, ver2: INTEGER; attribute_list_v1, attribute_list_v2: DS_HASH_TABLE [STRING, STRING]): STRING
			-- generate the conversion function between the 2 versions
		require
			attribute_list_version1_exist: attribute_list_v1 /= Void
			attribute_list_version2_exist: attribute_list_v2 /= Void
		do
			Result :=
			"%T" + function_name(ver1, ver2) + ": DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE[LIST [ANY]], ANY]], STRING] is%N" +
			"%T%T%T-- Conversion table from " + ver1.out + " to " + ver2.out + "." + "%N" +
			"%Tlocal%N" +
			"%T%Ttmp: " + const.Conversion_functions_class + "%N" +
			"%Tdo%N" +
			"%T%T-- |auto-generated code%N" +
			"%T%Tcreate tmp%N" +
			"%T%Tcreate Result.make_default%N" +
			"%T" + converter(ver1, ver2, attribute_list_v1, attribute_list_v2) + "%N" +
			"%T%T-- |auto-generated code%N" +
			"%Tend%N"
		ensure
			result_exists: Result /= Void and then not Result.is_empty
		end

	converter (ver1,ver2: INTEGER; attribute_list_v1, attribute_list_v2: DS_HASH_TABLE [STRING, STRING]): STRING
			-- The converter from version `ver1' to version `ver2'.
		require
			field_list_version1_exist: attribute_list_v1 /= Void
			field_list_version2_exist: attribute_list_v2 /= Void
		local
			a_converter: CONVERTER_MAKE
		do
			create a_converter.make

			a_converter.set_first (ver1.out, attribute_list_v1)
			a_converter.set_second (ver2.out, attribute_list_v2)
			Result := a_converter.out
			converter_messages:= a_converter.message
		ensure
			result_exists: Result /= Void
		end

	function_name (ver1,ver2: INTEGER): STRING
			-- The function name.
		do
			Result := "v" + ver1.out + "_to_v" + ver2.out
		end

	get_main_handler_body: STRING
			-- get the main project patch
		do
			Result := "indexing%N" +
					"%Tdescription: %"Project Schema Evolution Handler%"%N%N" +
					"class%N%N" +
					"%T" + const.Project_manager_class + "%N%N" +
					"%Tcreate%N" +
					"%T%Tmake%N%N" +
					"feature -- Access%N" +
					"%Tschema_evolution_handler: DS_HASH_TABLE [" + const.Schema_evolution_handler_class + ", STRING]%N%N" +
					"feature	-- Creation%N" +
					"%Tmake is%N" +
					"%T%T%T-- Default creation.%N" +
					"%T%Tdo%N" +
					"%T%T%Tcreate schema_evolution_handler.make_default%N"+
					"%Tend%N" +
					"end"
		ensure
			result_exists: Result /= Void and then not Result.is_empty
		end

	filter_content (class_name_to_filter:STRING; default_fields_value: DS_HASH_TABLE[STRING,STRING]): STRING
			-- The filter body.
		require
			class_name_to_filter_exist: class_name_to_filter /= Void and then not class_name_to_filter.is_empty
			default_fields_value_not_void: default_fields_value /= Void
		do
			Result :=
			"class%N" +
			"%T" + class_name_to_filter.as_upper+const.Filter_suffix.as_upper+"%N%N" +
			"%Tinherit%N" +
			"%T%T" + const.filter_class + "%N" +
			"%T%Tredefine%N" +
			"%T%T%Tinitialize%N" +
			"%T%Tend%N%N" +
			"feature -- Initialization%N"+
			"%Tinitialize is%N" +
			"%T%T%T--init%N" +
			"%T%Tdo%N" +
			"%T%T%TPrecursor {" + const.filter_class + "}%N%N"
			from default_fields_value.start until default_fields_value.after loop
				Result := Result + ("%T%T%Tadd (%"" + default_fields_value.key_for_iteration + "%", " + default_fields_value.item_for_iteration + ")%N")
				default_fields_value.forth
			end
			Result := Result + ("%T%Tend%N%Nend")
		ensure
			result_not_void: Result /= Void and then not Result.is_empty
		end

	invariant
		constants_exists: const /= Void
		messages_exist: converter_messages /= Void
indexing
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
