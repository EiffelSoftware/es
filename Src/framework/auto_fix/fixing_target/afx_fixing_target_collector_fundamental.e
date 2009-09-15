note
	description: "Summary description for {AFX_FIXING_TARGET_COLLECTOR_FUNDAMENTAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	AFX_FIXING_TARGET_COLLECTOR_FUNDAMENTAL

inherit
    AFX_FIXING_TARGET_COLLECTOR_I

feature -- Access

	context_feature: detachable E_FEATURE
			-- <Precursor>

	fix_position: detachable AST_EIFFEL
			-- <Precursor>
			-- not used in this collector

	last_collection: HASH_TABLE [AFX_FIXING_TARGET_I, STRING]
			-- <Precursor>
		do
			if internal_fixing_target_collection = Void then
			    create internal_fixing_target_collection.make (5)
			end

			Result := internal_fixing_target_collection
		end

feature -- Access sub-collections

	object_test_variable_collection: like last_collection
			-- collection of all object test variables
		do
		    Result := target_collection_array.at (Object_test_local_collection_index)
		end

	local_variable_collection: like last_collection
			-- collection of all local variables
		do
		    Result := target_collection_array.at (Local_var_collection_index)
		end

	argument_collection: like last_collection
			-- collection of all object test variables
		do
		    Result := target_collection_array.at (Argument_collection_index)
		end

	attribute_collection: like last_collection
			-- collection of all object test variables
		do
		    Result := target_collection_array.at (Attribute_collection_index)
		end

feature -- Status report

	is_setting_valid (a_feature: like context_feature; a_position: like fix_position): BOOLEAN
			-- <Precursor>
		do
		    Result := a_feature /= Void
		end

feature -- Operation

	collect_fixing_targets (a_feature: attached like context_feature; a_position: like fix_position)
			-- <Precursor>
		do
		    context_feature := a_feature
		    fix_position := a_position

			initialize_collections

			collect_argument_targets
			collect_local_variable_targets
			collect_object_test_variable_targets
			collect_attribute_targets

			from target_collection_array.start
			until target_collection_array.after
			loop
			    internal_fixing_target_collection.merge (target_collection_array.item_for_iteration)
			    target_collection_array.forth
			end
		end

feature{NONE} -- Access

	internal_fixing_target_collection: detachable like last_collection
			-- internal storage for collection result

	target_collection_array: detachable DS_ARRAYED_LIST [detachable like last_collection]
			-- set of local variables, arguments, and attributes accessible at the fix position

	Object_test_local_collection_index: INTEGER = 1
	Local_var_collection_index: INTEGER = 2
	Argument_collection_index: INTEGER = 3
	Attribute_collection_index: INTEGER = 4
			-- index of the collection in the collection array

feature{NONE} -- Implementation

	initialize_collections
			-- initialize internal storage
		local
		    l_collection: like last_collection
		    i: INTEGER
		do
			if internal_fixing_target_collection = Void then
			    create internal_fixing_target_collection.make (5)
			else
			    internal_fixing_target_collection.wipe_out
			end

				-- prepare collection storage for each category
			create target_collection_array.make (4)
			from i := 1
			until i > 4
			loop
			    create l_collection.make (5)
			    target_collection_array.force_last (l_collection)
			    i := i + 1
			end
		end

	collect_object_test_variable_targets
			-- collect all object test local variabel targets
		local
		    l_server: DEBUGGER_AST_SERVER
		    l_feature: E_FEATURE

		    l_ot_local_table: ARRAYED_LIST [TUPLE [id: ID_AS; li: LOCAL_INFO]]
		    l_local_info: LOCAL_INFO
		    l_local_name: STRING
		    l_ot_var_target: AFX_FIXING_TARGET_VARIABLE_OBJECT_TEST
		do
		    l_feature := context_feature

		    create l_server.make(10)
		    l_ot_local_table := l_server.object_test_locals (l_feature, 0, 0)

		    if l_ot_local_table /= Void then
    		    from
    		        l_ot_local_table.start
    		    until
    		        l_ot_local_table.after
    		    loop
    		        l_local_info := l_ot_local_table.item.li
    		        l_local_name := l_ot_local_table.item.id.name
    		        l_local_name.to_lower

    		        create l_ot_var_target.make (l_local_name, l_local_info.actual_type, l_feature)
    		        object_test_variable_collection.put (l_ot_var_target, l_local_name)

    		        l_ot_local_table.forth
    		    end
		    end

		end

	collect_local_variable_targets
			-- collect all local variable targets
		local
		    l_server: DEBUGGER_AST_SERVER
		    l_feature: E_FEATURE

		    l_local_table: detachable HASH_TABLE [LOCAL_INFO, INTEGER]
		    l_local_info: LOCAL_INFO
		    l_local_id: INTEGER_32
		    l_local_name: STRING
		    l_list_type_as: detachable EIFFEL_LIST[TYPE_DEC_AS]
		    l_type_as: TYPE_DEC_AS
		    l_id_list: IDENTIFIER_LIST
		    i: INTEGER
		    l_local_var_target: AFX_FIXING_TARGET_VARIABLE_LOCAL
		do
		    l_feature := context_feature

		    create l_server.make(10)
		    l_local_table := l_server.local_table (l_feature)

		    l_list_type_as := l_feature.locals
		    if l_list_type_as /= Void then
    		    from
    		        l_list_type_as.start
    		    until
    		        l_list_type_as.after
    		    loop
    		        l_type_as := l_list_type_as.item
    		        l_id_list := l_type_as.id_list

    		        from
    		            i := 1
    		        until
    		            i > l_id_list.count
    		        loop
    		            l_local_id := l_id_list.at (i)
    		            l_local_name := l_type_as.item_name (i)
    		            l_local_name.to_lower
    		            l_local_info := l_local_table.at (l_local_id)

						create l_local_var_target.make (l_local_name, l_local_info.type.actual_type, l_feature)
						local_variable_collection.put (l_local_var_target, l_local_name)

    		            i := i + 1
    		        end

    		        l_list_type_as.forth
    		    end
		    end

   				-- add `Result' as a special local variable
			if l_feature.type /= Void then
			    l_local_name := "result"
			    create l_local_var_target.make (l_local_name, l_feature.type.actual_type, l_feature)
			    local_variable_collection.put (l_local_var_target, l_local_name)
			end
		end

	collect_argument_targets
			-- collect all argument targets
		local
		    l_feature: E_FEATURE
		    l_argument_list: E_FEATURE_ARGUMENTS
		    l_argument_name_list: LIST[STRING]
		    l_argument_name: STRING
		    l_argument_target: AFX_FIXING_TARGET_VARIABLE_ARGUMENT
		do
		    l_feature := context_feature

			if l_feature.argument_count > 0 then
    		    l_argument_list := l_feature.arguments
    		    l_argument_name_list := l_argument_list.argument_names

    		    	-- add arguments into the argument list
    		    from
    		        l_argument_list.start
    		    until
    		        l_argument_list.after
    		    loop
    		        if l_argument_list.item /= Void then
    		            l_argument_name := l_argument_name_list.i_th(l_argument_list.index)
    		            l_argument_name.to_lower
    		            	-- due to the possible anchored types, we need to use the actual_type instead
    		            create l_argument_target.make (l_argument_name, l_argument_list.item.actual_type, l_feature)
    		            argument_collection.put (l_argument_target, l_argument_name)
    		        end
    		        l_argument_list.forth
    		    end
			end

				-- add `Current' as a special argument
			l_argument_name := "current"
			create l_argument_target.make (l_argument_name, l_feature.associated_class.actual_type, l_feature)
			argument_collection.put (l_argument_target, l_argument_name)
		end

	collect_attribute_targets
			-- collect attribute targets
		local
		    l_feature: E_FEATURE
		    l_class: CLASS_C

			l_feature_table: FEATURE_TABLE
			l_feature_or_attribute: FEATURE_I
			l_attribute_target: AFX_FIXING_TARGET_VARIABLE_ATTRIBUTE
			l_attribute_name: STRING
		do
		    l_feature := context_feature
			l_class := l_feature.associated_class
			l_feature_table := l_class.feature_table

			if l_feature_table /= Void then
    			from
    			    l_feature_table.start
    			until
    			    l_feature_table.after
    			loop
    			    l_feature_or_attribute := l_feature_table.item_for_iteration
    			    if l_feature_or_attribute.is_attribute and then not l_feature_or_attribute.is_constant then
    			        l_attribute_name := l_feature_or_attribute.feature_name
    			        l_attribute_name.to_lower
						create l_attribute_target.make (l_attribute_name, l_feature_or_attribute.type.actual_type, l_feature)
						attribute_collection.put (l_attribute_target, l_attribute_name)
    			    end

    			    l_feature_table.forth
    			end
			end
		end


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
