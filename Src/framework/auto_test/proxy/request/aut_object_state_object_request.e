note
	description: "Request to acquire states for a set of objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_OBJECT_REQUEST

inherit
	AUT_OBJECT_STATE_REQUEST

create
	make_with_objects

feature{NONE} -- Initialization

	make_with_objects (a_variables: HASH_TABLE [TYPE_A, INTEGER]; a_config: AUT_OBJECT_STATE_CONFIG)
			-- Make current to retrieve states for objects specified in `a_variables'.
			-- `a_variables' is a table, key is object index, value is the type of that object.
		do
			variables := a_variables
			config := a_config
		end

feature -- Access

	byte_code_for_object_state_retrieval: STRING
			-- String representation of the byte-code needed to retrieve object states
		local
			l_feat_generator: AUT_OBJECT_STATE_RETRIEVAL_FEATURE_GENERATOR
			l_class: EIFFEL_CLASS_C
			l_map: HASH_TABLE [STRING, STRING]
			l_text: STRING
			l_obj_index: STRING
			l_feat_text_tbl: like feature_text_table
			l_feature: AUT_FEATURE_OF_TYPE
			l_pre_text: STRING
			l_post_text: STRING
			l_variables: like variables
		do
			create l_feat_generator
			l_feat_generator.set_config (config)
			l_feat_generator.generate_for_objects (variables)
			l_text := l_feat_generator.feature_text.twin

			l_variables := variables
			create l_map.make (l_variables.count)
			l_map.compare_objects
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_obj_index := l_variables.key_for_iteration.out
				l_map.put (l_obj_index, anonymous_variable_name (l_variables.key_for_iteration))
				l_map.put (once "v_" + l_obj_index, double_square_surrounded_integer (l_variables.key_for_iteration))
				l_variables.forth
			end

				-- Change `l_text' to mention real object ids.
			from
				l_map.start
			until
				l_map.after
			loop
				l_text.replace_substring_all (l_map.key_for_iteration, l_map.item_for_iteration)
				l_map.forth
			end

				-- Compile text into byte code.
			l_class ?= interpreter_root_class
			Result := feature_byte_code_with_text (l_class, feature_for_byte_code_injection, once "feature " + l_text, True).byte_code
		end


;note
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
