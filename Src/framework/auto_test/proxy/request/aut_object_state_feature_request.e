note
	description: "Request to acquire states for operands of a feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_FEATURE_REQUEST

inherit
	AUT_OBJECT_STATE_REQUEST
		redefine
			is_for_feature
		end

create
	make_with_request

feature{NONE} -- Initialization

	make_with_request (a_request: AUT_CALL_BASED_REQUEST; a_prestate: BOOLEAN; a_config: AUT_OBJECT_STATE_CONFIG)
			-- Make current to retrieve states for operands of the feature specified by `a_request'.
			-- `a_prestate' indicates if the state is before the invocation to `a_feature'.
		local
			l_types: SPECIAL [TYPE_A]
			l_index: INTEGER
			l_count: INTEGER
			l_variables: like variables
			l_operand_indexes: SPECIAL [INTEGER]
		do
			make_with_feature (a_request.class_of_target_type, a_request.feature_to_call, a_request.operand_variable_index_table, a_request.is_creation, a_prestate)
			config := a_config
			type := a_request.target_type

				-- Create `variables'.
			l_types := a_request.operand_types
			l_count := l_types.count
			if a_prestate and then a_request.is_creation then
				l_index := 1
			else
				l_index := 0
			end
			if a_prestate and then a_request.is_feature_query then
				l_count := l_count - 1
			end

			create variables.make (l_count)
			l_variables := variables
			l_operand_indexes := a_request.operand_indexes
			from until l_index = l_count loop
				l_variables.put (l_types.item (l_index), l_operand_indexes.item (l_index))
				l_index := l_index + 1
			end
		end

	make_with_feature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_operand_map: like operand_map; a_creation: BOOLEAN; a_prestate: BOOLEAN)
			-- Make current to retrieve states for operands of `a_feature' viewed in `a_context_class'.
			-- `a_creation' indicates if `a_feature' is used as a creation procedure.
			-- `a_prestate' indicates if the state is before the invocation to `a_feature'.
		do
			context_class := a_context_class
			feature_ := a_feature
			operand_map := a_operand_map
			is_creation := a_creation
			is_for_pre_state := a_prestate
		end

feature -- Access

	type: TYPE_A
			-- Type of `feature_' viewed in `context_class'

	context_class: CLASS_C

	feature_: FEATURE_I

	operand_map: HASH_TABLE [INTEGER, INTEGER]
			-- Map from opreand index to object index in the object pool.
			-- Key is 0-based operand index.
			-- Value is object id (used in the object pool) for that operand.

	byte_codes: TUPLE [pre_state_byte_code: STRING; post_state_byte_code: detachable STRING]
			-- Strings representing the byte-code needed to retrieve object states
			-- `pre_state_byte_code' is to be executed before the test case execution.
			-- `post_state_byte_code' is to be executed after the test case execution.
		local
			l_feat_generator: AUT_OBJECT_STATE_RETRIEVAL_FEATURE_GENERATOR
			l_class: EIFFEL_CLASS_C
			l_map: HASH_TABLE [STRING, STRING]
			l_text: STRING
			l_operand_map: like operand_map
			l_obj_index: STRING
			l_feat_text_tbl: like feature_text_table
			l_feature: AUT_FEATURE_OF_TYPE
			l_pre_text: STRING
			l_post_text: STRING
		do
			l_feat_text_tbl := feature_text_table
			if is_creation then
				create l_feature.make_as_creator (feature_, type)
			else
				create l_feature.make (feature_, type)
			end

				-- Lookup if the object state retrieval feature text is already pre-generated.
				-- If so, use that text directly, otherwise, generate the feature text, and put
				-- it in cache `feature_text_table'.
			l_feat_text_tbl.search (l_feature)
			if l_feat_text_tbl.found then
				l_pre_text := l_feat_text_tbl.found_item.pre_state_text
				l_post_text := l_feat_text_tbl.found_item.post_state_text
			else
				create l_feat_generator
				l_feat_generator.set_config (config)

					-- Generate text for feature to retrieve object states.
				l_feat_generator.generate_for_feature (context_class, feature_, True, is_creation)
				l_pre_text := l_feat_generator.feature_text.twin
				l_feat_generator.generate_for_feature (context_class, feature_, False, is_creation)
				l_post_text := l_feat_generator.feature_text.twin
				l_feat_text_tbl.force_last ([l_pre_text, l_post_text], l_feature)

				if is_for_pre_state then
					l_text := l_pre_text.twin
				else
					l_text := l_post_text.twin
				end
			end

				-- Create operand index to varaible index map.
			l_operand_map := operand_map
			create l_map.make (l_operand_map.count)
			l_map.compare_objects
			from
				l_operand_map.start
			until
				l_operand_map.after
			loop
				l_obj_index := l_operand_map.item_for_iteration.out
				l_map.put (l_obj_index, anonymous_variable_name (l_operand_map.key_for_iteration))
				l_map.put (once "v_" + l_obj_index, double_square_surrounded_integer (l_operand_map.key_for_iteration))
				l_operand_map.forth
			end

				-- Change `l_text' to mention real object ids.
			from
				l_map.start
			until
				l_map.after
			loop
				l_pre_text.replace_substring_all (l_map.key_for_iteration, l_map.item_for_iteration)
				l_post_text.replace_substring_all (l_map.key_for_iteration, l_map.item_for_iteration)
				l_map.forth
			end

				-- Compile text into byte code.
			l_class ?= interpreter_root_class
			Result :=
				[feature_byte_code_with_text (l_class, feature_for_byte_code_injection, once "feature " + l_pre_text, True).byte_code,
				 feature_byte_code_with_text (l_class, feature_for_byte_code_injection, once "feature " + l_post_text, True).byte_code]
		end

feature -- Status report

	is_for_feature: BOOLEAN = True
			-- Is the state to be retrieved for operands of a feature?

	is_creation: BOOLEAN
			-- Is `feature_' used as a creation procedure?

	is_for_pre_state: BOOLEAN
			-- Is the state to be retrieved before the test case execution?

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
