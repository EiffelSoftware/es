note
	description: "Creates a WEKA_ARFF_ATTRIBUTE from a string in arff file"
	author: "Nikolay Kazmin"
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_ATTRIBUTE_FACTORY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature
	is_attribute(a_line: STRING):BOOLEAN
			-- True if a_line is an attribute line in an arff file
		do
			if a_line.starts_with ({WEKA_CONSTANTS}.attr) then
				Result := True
			end
		end

	create_attribute(a_attr_line: STRING):WEKA_ARFF_ATTRIBUTE
			-- Creates a weka_arff_attribute object by analyzing the a_line argument
		require
			line_is_an_attribute: is_attribute(a_attr_line)
		local
			l_name: STRING
			l_type: STRING
			l_set: DS_HASH_SET [STRING]
			l_line: STRING
		do
			l_line := a_attr_line.twin
			-- "@attribute".count is 10
			l_line.keep_tail (l_line.count - 10)
			l_line.prune_all_leading(' ')
			l_line.prune_all_leading('%T')
			l_line.prune_all_trailing (' ')
			l_line.prune_all_trailing ('%T')
			l_name := parse_attr_name(l_line)
			l_type := cut_off_name(l_line)
			if l_type.has_substring ({WEKA_CONSTANTS}.numeric) then
				create {WEKA_ARFF_NUMERIC_ATTRIBUTE} Result.make(l_name)
			elseif l_type.has_substring ({WEKA_CONSTANTS}.str)  then
				create {WEKA_ARFF_STRING_ATTRIBUTE} Result.make(l_name)
			else
				l_set := nominal_values_set (l_type)
				if l_set.count = 2 and l_set.has ("True") and l_set.has ("False") then
					create {WEKA_ARFF_BOOLEAN_ATTRIBUTE} Result.make (l_name)
				else
					create {WEKA_ARFF_NOMINAL_ATTRIBUTE} Result.make (l_name, l_set)
				end
			end
		end

feature {NONE}

	nominal_values_set(a_type:STRING): DS_HASH_SET [STRING]
			-- Extracts the values list for a nominal attribute
		local
			l_values: STRING
			l_values_list: LIST [STRING]
			l_value: STRING
			l_start_index: INTEGER
		do
			create Result.make (5)
			Result.set_equality_tester (string_equality_tester)
			l_start_index := a_type.last_index_of ('{', a_type.count)
			if l_start_index > 0 then
				l_values := a_type.substring (l_start_index + 1, a_type.index_of ('}', l_start_index + 1) - 1)

				l_values_list := l_values.split (',')
				from l_values_list.start until l_values_list.after loop
					l_value := l_values_list.item_for_iteration
					l_value.prune_all_leading (' ')
					l_value.prune_all_trailing (' ')
					Result.force_last (l_value)
					l_values_list.forth
				end
			end
		end

	parse_attr_name(a_line:STRING): STRING
			--parses the name of the attribute
		require
			attribute_is_cut_out: not a_line.starts_with ({WEKA_CONSTANTS}.attr)
			spaces_are_cut_out: not a_line.starts_with (" ") and not a_line.starts_with ("%T")
		local
			l_end_index: INTEGER
		do
			l_end_index := attribute_name_end_index(a_line)
			if a_line.starts_with ("%"") then
				Result := a_line.substring (2, l_end_index-1)
			else
				Result := a_line.substring (1, l_end_index)
			end
		end

	cut_off_name(a_line:STRING):STRING
			-- removes the attribute name from the line and returns the result
		require
			attribute_is_cut_out: not a_line.starts_with ({WEKA_CONSTANTS}.attr)
			spaces_are_cut_out: not a_line.starts_with (" ") and not a_line.starts_with ("%T")
		do
			Result := a_line.substring (attribute_name_end_index (a_line)+1, a_line.count)
			Result.prune_all_leading (' ')
			Result.prune_all_leading ('%T')
		ensure
			leading_spaces_removed: not Result.starts_with (" ") and not Result.starts_with ("%T")
			name_removed: a_line.count >= attribute_name_end_index (a_line) + Result.count
		end

	attribute_name_end_index(a_line:STRING):INTEGER
			-- finds where the attribute name ends and returns that index
		require
			attribute_is_cut_out: not a_line.starts_with ({WEKA_CONSTANTS}.attr)
			spaces_are_cut_out: not a_line.starts_with (" ") and not a_line.starts_with ("%T")
		local
			space_index, tab_index: INTEGER
		do
			if a_line.starts_with ("%"") then
				Result := a_line.index_of ('"', 2)
			else
				space_index := a_line.index_of (' ', 1) - 1
				tab_index := a_line.index_of ('%T', 1) - 1
				-- if some of the indices is 0 then we don't want to pick it so we make it huge
				if space_index = 0 then
					space_index := 10000
				end
				if tab_index = 0 then
					tab_index := 10000
				end
				-- if both of them exists then we take the minimal
				if space_index < tab_index then
					Result := space_index
				else
					Result := tab_index
				end

--				if a_line.index_of (' ', 1) = 0 then
--					-- if no spaces found we look for tabs
--					Result := a_line.index_of ('%T', 1) - 1
--				else
--					Result :=  a_line.index_of (' ', 1) - 1
--				end
			end
		end
end
