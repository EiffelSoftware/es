note
	description: "AutoTest request to check states of an object"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_OBJECT_STATE_REQUEST

inherit
	AUT_REQUEST
		rename
			make as make_old
		end

	EPA_COMPILATION_UTILITY

	AUT_SHARED_INTERPRETER_INFO

	EPA_STRING_UTILITY
		undefine
			system
		end

	AUT_SHARED_OBJECT_STATE_RETRIEVAL_CONTEXT

feature -- Access

	variables: HASH_TABLE [TYPE_A, INTEGER]
			-- Variables whose states are to be retrieved
			-- Key is object index (used in object pool), value is type of that variables.

	byte_codes: TUPLE [pre_state_byte_code: STRING; post_state_byte_code: detachable STRING]
			-- Strings representing the byte-code needed to retrieve object states
			-- `pre_state_byte_code' is to be executed before the test case execution.
			-- `post_state_byte_code' is to be executed after the test case execution.
		deferred
		end

	config: detachable AUT_OBJECT_STATE_CONFIG
			-- Configuration for object state retrieval

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_object_state_request (Current)
		end

feature{NONE} -- Implementation

	text_with_actual_objects (a_text: STRING; a_operand_map: HASH_TABLE [INTEGER, INTEGER]): STRING
			-- A piece of text from `a_text' where all place holders are replaced with actual
			-- variables in the object pool, as defined by `a_operand_mape'.
			-- `a_operand_map' is a mapping from opreand index to object index in the object pool.
			-- Key is 0-based operand index.
			-- Value is object id (used in the object pool) for that operand.
		local
			l_map: HASH_TABLE [STRING, STRING]
			l_obj_index: STRING
		do
			create Result.make_from_string (a_text)

				-- Create operand index to varaible index map.
			create l_map.make (a_operand_map.count)
			l_map.compare_objects
			across a_operand_map as l_operand_map loop
				l_obj_index := l_operand_map.item.out
				l_map.put (l_obj_index, anonymous_variable_name (l_operand_map.key))
				l_map.put ({ITP_SHARED_CONSTANTS}.variable_name_prefix + l_obj_index, double_square_surrounded_integer (l_operand_map.key))
			end

				-- Change `l_text' to mention real object ids.
			across l_map as l_maps loop
				Result.replace_substring_all (l_maps.key, l_maps.item)
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
