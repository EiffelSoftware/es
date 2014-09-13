note
	description: "Summary description for {JSON_FORMAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_FORMAT

create
	make_empty

feature -- instantiate json object

	make_empty
			-- make an empty json object
		do
			json_object := "[JSON]{ "
			json_object.append ("%"" + Warning_key + "%": [ { ")
			create error_msg.make_empty
		end


feature -- json basic keys

	Error_key: STRING_8 = "error"

	Warning_key: STRING_8 = "warning"


feature -- json error only keys (can only appear in error)

	Error_msg_key: STRING_8 = "error_message"


feature -- json warning only keys (can only appear in warning)

	Warning_msg_key: STRING_8 = "warning_message"

	Unused_local_key: STRING_8 = "unused_local"


feature -- json warning and error keys (can appear in warning and error)

	Line_number_key: STRING_8 = "line_number"

	Class_key: STRING_8 = "class"

	Feature_key: STRING_8 = "feature"

	Identifier_key: STRING_8 = "identifier"

	File_name_key: STRING_8 = "file_name"

	Source_code_key: STRING_8 = "source_code"

	Syntax_msg_key: STRING_8 = "syntax_message"


feature -- json object

	json_object: STRING_8


feature -- json properties

	error_msg: STRING_8

feature -- modification of json object

	append_json(a_key: STRING_8; a_value: STRING_8)
			-- apend `a_key' and `a_value' to json object
		require
			a_key_not_void: a_key /= Void
			a_value_not_void: a_value /= Void
		do
			json_object.append ("%"" + a_key + "%": %"" + a_value + "%", ")
		end

	prepare_next
			-- prepare next msg
		require
			long_enough: json_object.count >= 2
		do
			json_object.remove_tail (2)
			json_object.append (" }, { ")
		end

	no_warnings
			-- make empty array if no warnings
		require
			long_enough: json_object.count >= 3
		do
			json_object.remove_tail (3)
			json_object.append ("], ")
		end

	no_errors
			-- make empty array if no errors
		require
			long_enough: json_object.count >= 3
		do
			json_object.remove_tail (3)
			json_object.append ("] }[/JSON]")
		end

	prepare_error_section
			-- init error key with array to be filled
		do
			json_object.append ("%"" + Error_key + "%": [ { ")
		end

	close_warning_section
			-- close warning array
		require
			long_enough: json_object.count >= 2
		do
			json_object.remove_tail (4)
			json_object.append (" ], ")
		end

	close_final_section
			-- close last array and close json file
		require
			long_enough: json_object.count >= 4
		do
			json_object.remove_tail (4)
			json_object.append (" ] }[/JSON]")
		end


feature --set fields of json object


	set_error_msg (an_error_msg: STRING_8)
		require
			an_error_msg_not_void: an_error_msg /= Void
		do
			append_json(Error_msg_key, an_error_msg)
		end

	set_line_number (a_line_number: INTEGER)
		require
			a_line_number_not_negative: a_line_number >= 0
		local
			helper_string: STRING_8
		do

			create helper_string.make_empty
			helper_string.append_integer (a_line_number)
			append_json(Line_number_key, helper_string)
		end

	set_class_name (a_class_name: STRING_8)
		require
			a_class_name_not_void: a_class_name /= Void
		do
			append_json(Class_key, a_class_name)
		end

	set_feature_name (a_feature_name: STRING_8)
		require
			a_feature_name_not_void: a_feature_name /= Void
		do
			append_json(Feature_key, a_feature_name)
		end

	set_identifier_name (an_identifier_name: STRING_8)
		require
			an_identifier_name_not_void: an_identifier_name /= Void
		do
			append_json(Identifier_key, an_identifier_name)
		end

	set_file_name (a_file_name: STRING_8)
		require
			a_file_name_not_void: a_file_name /= Void
		do
			append_json(File_name_key, a_file_name)
		end

	set_source_code (a_syntax_error: STRING_8)
		require
			a_syntax_error_not_void: a_syntax_error /= Void
		do
			append_json(Source_code_key, a_syntax_error)
		end

	set_warning_msg (a_warning_msg: STRING_8)
		require
			a_warning_not_void: a_warning_msg /= Void
		do
			append_json(Warning_msg_key, a_warning_msg)
		end

	set_syntax_msg (a_syntax_msg: STRING_8)
		require
			a_syntax_msg_not_void: a_syntax_msg /= Void
		do
			append_json (Syntax_msg_key, a_syntax_msg)
		end

	set_unused_local (a_unused_local: STRING_8)
		require
			a_unused_local_not_void: a_unused_local /= Void
		do
			append_json (Unused_local_key, a_unused_local)
		end




note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
