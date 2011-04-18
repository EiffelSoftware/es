note
	description: "SQL_Statement_Creater application root class"
	date       : "$Date$"
	revision   : "$Revision$"

class
	SEM_SQL_STATEMENT_CREATER

create
	make

feature {NONE} -- Initialization

	make
		do
			create select_arguments.make
			create from_arguments.make
			create where_clause_arguments.make
			group_by_value := ""
			create query_col_values.make
			concat_string := ""
			create update_arguments.make
			create set_arguments.make
			create case_statement_arguments.make
			case_default_set := false
		end

feature --Variables

	select_arguments: LINKED_LIST [STRING_8]

	from_arguments: LINKED_LIST [STRING_8]

	where_clause_arguments: LINKED_LIST [STRING_8]

	group_by_value: STRING_8

	query_col_values: LINKED_LIST [STRING_8]

	concat_string: STRING_8

	update_arguments: LINKED_LIST [STRING_8]

	set_arguments: LINKED_LIST [STRING_8]

	case_statement_arguments: LINKED_LIST [TUPLE[STRING_8, DOUBLE]]

	case_default_set: BOOLEAN

	case_default_value: DOUBLE

feature --Change State

	wipe_out_case_statement
		--Completely deletes all information stored for making a case statement
		do
			case_default_set := false
			case_statement_arguments.wipe_out
		end

	wipe_out_concat_statment
		--Completely deletes all information stored for making a case statement
		do
			concat_string.wipe_out
		end

	wipe_out
		--Standard wipe out function.  effectively resets all internal variables
		do
			select_arguments.wipe_out
			from_arguments.wipe_out
			where_clause_arguments.wipe_out
			group_by_value.wipe_out
			query_col_values.wipe_out
			concat_string.wipe_out
			update_arguments.wipe_out
			set_arguments.wipe_out
			case_statement_arguments.wipe_out
			case_default_set := false
		end

feature --Access queries

	get_mysql_select_doc: STRING_8
		--Based on all of the information entered that is related to selet, from, where, and group by clauses,
		--returns a MySQL document of the form (peretheses included for simplified nesting)
		--(
		--SELECT ......
		--FROM ......
		--WHERE ......
		--GROUP BY ......
		--)
		local
			returnstring: STRING_8
		do

			returnstring := "("

				--Adding select statement components
			returnstring.append ("SELECT ")
			from
				select_arguments.start
			until
				select_arguments.exhausted
			loop
				returnstring.append (select_arguments.item)
				select_arguments.forth
				if not (select_arguments.exhausted) then
				returnstring.append (", ")
				end
			end

			returnstring.append ("%N")

				--Adding from statement components
			returnstring.append ("FROM ")
			from
				from_arguments.start
			until
				from_arguments.exhausted
			loop
				returnstring.append (from_arguments.item)
				from_arguments.forth
				if not (from_arguments.exhausted) then
				returnstring.append (", ")
				end
			end

			returnstring.append ("%N")

				--Adding and statement components
			returnstring.append ("WHERE")
			from
				where_clause_arguments.start
			until
				where_clause_arguments.exhausted
			loop
				returnstring.append ("%N")
				returnstring.append (where_clause_arguments.item)
				where_clause_arguments.forth
			end

			if (not group_by_value.is_equal ("")) then
				returnstring.append ("%NGROUP BY ")
				returnstring.append (group_by_value)
			end
			returnstring.append (")")
			Result := returnstring
		end

	get_mysql_update_doc: STRING_8
		--Based on all of the information entered that is related to update, set, where, and group by clauses,
		--returns a MySQL document of the form
		--(
		--SELECT ......
		--FROM ......
		--WHERE ......
		--GROUP BY ......
		--)
		--**peretheses included for simplified nesting
		local
			returnstring: STRING_8
		do

			returnstring := ""

				--Adding select statement components
			returnstring.append ("UPDATE ")
			from
				update_arguments.start
			until
				update_arguments.exhausted
			loop
				returnstring.append (update_arguments.item)
				update_arguments.forth
				if not (update_arguments.exhausted) then
				returnstring.append (", ")
				end
			end

			returnstring.append ("%N")

				--Adding from statement components
			returnstring.append ("SET ")
			from
				set_arguments.start
			until
				set_arguments.exhausted
			loop
				returnstring.append (set_arguments.item)
				set_arguments.forth
				if not (set_arguments.exhausted) then
				returnstring.append (", ")
				end
			end

			returnstring.append ("%N")

				--Adding and statement components
			returnstring.append ("WHERE")
			from
				where_clause_arguments.start
			until
				where_clause_arguments.exhausted
			loop
				returnstring.append ("%N")
				returnstring.append (where_clause_arguments.item)
				where_clause_arguments.forth
			end
			Result := returnstring
		end

feature --Query Utilities

	begin_concat_statement ()
		--Must be called before any other concatenation-related methods are called
		do
			concat_string.wipe_out()
			concat_string.append("CONCAT(")
		end

	add_to_concat_statement (s: STRING_8)
		--Adds the string s to the list of values to be concatenated.  Note that if a string literal
		--is to be concatenated, it must be written in the form "%"{STRING_LITERAL}%""
		--Subsequent changes to the string s will not effect the inner storage of the string
		require
			concat_string.count /= 0
		do
			if not concat_string.is_equal ("CONCAT(") then
				concat_string.append (", ")
			end
			concat_string.append(s)
		end

	end_concat_statment ()
		--Must be called before running concat_get
		require
			concat_string.count /= 0
		do
			concat_string.append (")")
		end

	get_concat_statement: STRING_8
		--Get the entired concatenation statement.  All values inserted up to the last
		--call of wipe_out will be included
		require
			concat_string.count /= 0
			concat_string.at (concat_string.count) = ')'
		do
			Result := concat_string()
		end

	add_when_pair_to_case_statement (condition: STRING_8; value: DOUBLE)
		--Adds a when pair to the case statement.  This is more or less a test condition, and the
		--double value corresponding to that condition passing.
		--Subsequent changes to the string condition will not effect the inner storage of the string
		local s: STRING_8
		do
			create s.make_empty
			s.copy (condition)
			case_statement_arguments.extend ([s, value])
			case_statement_arguments.finish
		end

	set_case_statement_default (value: DOUBLE)
		--Set the default value for the case statement.  cannot go un initialized.
		require not case_default_set
		do
			case_default_set := true
			case_default_value := value
		end

	get_case_statement: STRING_8
		--Get the entire printout of the case statement as
		--CASE
		--{all "WHEN ... ELSE ..." conditions entered}
		--ELSE {default value entered}
		--END
		require
			case_default_set
		local
			s: STRING_8
		do
			s := "CASE "
			from
				case_statement_arguments.start
			until
				case_statement_arguments.off
			loop
				s.append_string (" WHEN ")
				s.append_string (case_statement_arguments.item.at(1).out)
				s.append_string (" THEN ")
				s.append_double (case_statement_arguments.item.at(2).out.to_double)
				case_statement_arguments.forth
			end
			s.append_string (" ELSE ")
			s.append_double (case_default_value)
			s.append_string (" END ")
			result := s
		end

feature --Search Refinement

	add_to_select_clause (variable: STRING_8)
		--Adds the string s to the list of values to be enumerated in the SELECT clause of the MySQL document
		--subsequent changes to the string s will not effect the inner storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append_string (variable)
			select_arguments.extend (str)
			select_arguments.finish
		end

	add_select_as_statement_to_select_clause (selected_variable: STRING_8; selected_as: STRING_8)
		--Adds the string selected_variable to the list of values to be enumerated in the SELECT clause of
		--the MySQL document, although in this case the table returned by the final query will have the
		--column of selected_value values listed under the selected_as name
		--Subsequent changes to the input strings will not effect the inner storage of the string
		local
			s: STRING_8
		do
			s := ""
			s.append (selected_variable)
			s.append (" as %"")
			s.append (selected_as)
			s.append ("%"")
			select_arguments.extend (selected_variable + " as %"" + selected_as + "%"")
			select_arguments.finish
			query_col_values.extend (selected_as)
			query_col_values.finish
		end

	add_to_from_clause_arguments (table_name_and_variable_name: STRING_8)
		--Adds to the from clause.  the string s must be of the form "{table_name} {variable_name}"
		--subsequent changes to the strings will not effect the inner storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append (table_name_and_variable_name)
			from_arguments.extend (str)
			from_arguments.finish
		end

	start_where_clause (where_clause_condition: STRING_8)
		--Must be called before any other values are added to the where clause.  should be a boolean condition
		--subsequent changes to the string s will not effect the inner storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append (where_clause_condition)
			where_clause_arguments.extend (str)
			where_clause_arguments.finish
		end

	add_to_where_clause_arguments (boolean_operator: STRING_8; where_clause_condition: STRING_8)
		--For all where clause conditions after the first, use this method.  must also include the value
		--of the relationship with the previous boolean condition ("AND" or "OR").  Nesting of boolean
		--statements in the where clause is not directly implemented
		--Subsequent changes to the input strings will not effect the inner storage of the string
		require
			boolean_operator.is_equal ("AND") or boolean_operator.is_equal ("OR")
		local
			str1: STRING_8
			str2: STRING_8
		do
			create str1.make_empty
			create str2.make_empty
			str1.append (boolean_operator)
			str2.append (where_clause_condition)
			where_clause_arguments.extend (str1)
			where_clause_arguments.extend (str2)
			where_clause_arguments.finish
		end

	add_group_by_statement (group_by_statement: STRING_8)
		--The group by statement for the query.
		--Subsequent changes to the string s will not effect the inner storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append_string (group_by_statement)
			group_by_value.append_string (str)
		end

	add_to_update_clause_arguments (table_and_variable_name: STRING_8)
		--Adds the value of table_ane_variable_name to the list of tables to be used in an updating
		--mysql document
		--Subsequent changes to the string table_and_variable_name will not effect the innter
		--storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append_string (table_and_variable_name)
			update_arguments.extend (str)
			update_arguments.finish
		end

	add_to_set_clause_arguments (variable_name: STRING_8; value: STRING_8)
		--Variable name should be of the form "{table variable}.{table_column}" and value should
		--be whatever value will be inserted in the table.
		--Subsequent changes to the strings variable_name adn value will not effect the innter
		--storage of the string
		local
			str: STRING_8
		do
			create str.make_empty
			str.append_string (variable_name)
			str.append_string (" = ")
			str.append_string (value)
			set_arguments.extend (str)
			set_arguments.finish
		end
end
