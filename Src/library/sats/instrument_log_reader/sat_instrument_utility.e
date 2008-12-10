indexing
	description: "Summary description for {SAT_INSTRUMENT_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_UTILITY

feature -- Access

	config_from_string (a_string: STRING): TUPLE [a_class_name: STRING; a_feature_name: STRING; a_properties: HASH_TABLE [STRING, STRING]] is
			-- Configs from `a_string'
			-- If there is no feature associated with `a_string', `a_feature_name' will be empty.
			-- `a_properties' stored a name-value table associated with current config. [value, name]
			-----------------------------------------------------------------------------------------
			-- One config line has one of the following formats:
			--  1. Class_name.feature_name TAB prop_name=value TAB prop_name=value
			--  2. Class_name TAB prop_name=value TAB prop_name=value
			--  There can be no propery in a config line.
			--  All strings in the config line is case-insensitive.
			-----------------------------------------------------------------------------------------
		require
			a_string_valid: a_string /= Void and then not a_string.is_empty
		local
			l_parts: LIST [STRING]
			l_code_section: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_property_tbl: HASH_TABLE [STRING, STRING]
		do
			create l_property_tbl.make (1)
			l_parts := a_string.split ('%T')

				-- Find out class name and (optional) feature name of current config.
			l_code_section := l_parts.first.split ('.')
			l_class_name := l_code_section.i_th (1).as_upper
			if l_code_section.count = 2 then
					-- We have a class name and a feature name.
				l_feature_name := l_code_section.i_th (2).as_lower
			else
				l_feature_name := ""
			end

				-- We have name-value pair properties.
			if l_parts.count > 1 then
				l_parts.start
				l_parts.remove
				l_property_tbl := property_table (l_parts)
			end
			Result := [l_class_name, l_feature_name, l_property_tbl]
		end

	property_table (a_strings: LIST [STRING]): HASH_TABLE [STRING, STRING] is
			-- Property table from a list of strings contains "=" separated pairs
			-- All strings will be transformed into lower case.
		require
			a_strings_attached: a_strings /= Void
		local
			l_property: LIST [STRING]
			l_prop_name: STRING
			l_prop_value: STRING
		do
			create Result.make (a_strings.count)
			Result.compare_objects
			if not a_strings.is_empty then
				from
					a_strings.start
				until
					a_strings.after
				loop
					if not a_strings.is_empty then
						l_property := a_strings.item.split ('=')
						check l_property.count = 2 end
						l_prop_name := l_property.i_th (1).as_lower
						l_prop_name.left_adjust
						l_prop_name.right_adjust
						l_prop_value := l_property.i_th (2).as_lower
						l_prop_value.left_adjust
						l_prop_value.right_adjust
						Result.force (l_prop_value, l_prop_name)
						a_strings.forth
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	has_property (a_property_name: STRING; a_value: STRING; a_property_table: HASH_TABLE [STRING, STRING]): BOOLEAN is
			-- Is `a_property_name' with `a_value' in `a_property_table'?
			-- Strings are case-insensitive.
		require
			a_property_name_attached: a_property_name /= Void
			not_a_property_name_is_empty: not a_property_name.is_empty
			a_value_attached: a_value /= Void
			not_a_value_is_empty: not a_value.is_empty
			a_property_table_attached: a_property_table /= Void
		local
			l_value: STRING
		do
			l_value := a_property_table.item (a_property_name.as_lower)
			Result := l_value /= Void and then l_value.is_case_insensitive_equal (a_value)
		end

end
