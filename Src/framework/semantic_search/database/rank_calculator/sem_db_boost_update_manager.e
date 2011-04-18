note
	description: "SQL_Statement_Creater application root class"
	date       : "$Date$"
	revision   : "$Revision$"

class
	SEM_DB_BOOST_UPDATE_MANAGER

create
	make

feature

	primary_database_connection_client: MYSQL_CLIENT

	make (host_address: STRING_8; username: STRING_8; password: STRING_8; database_name: STRING_8; a_port: INTEGER)
			--Startup
			-- make (a_connection: MYSQL_CLIENT; a_log_manager: ELOG_LOG_MANAGER)
		do
			create primary_database_connection_client.make_with_database (host_address, username, password, database_name, a_port)
			primary_database_connection_client.connect
			print ("Manager Created%N%N")
		end

	run_table_update (class_name: STRING_8; feature_name: STRING_8)
			--Method for updating all table values for the given class and feature value.
		local
			creater: SEM_SQL_STATEMENT_CREATER
			all_properties_query_doc: STRING_8
			i: INTEGER_32
			properties_list: LINKED_LIST [STRING_8]
			property_name: STRING_8
		do
			create creater.make
			create properties_list.make

			if primary_database_connection_client.is_connected then
					--No errors occured in creating a connection to the MySQL database
				if primary_database_connection_client.last_error.is_equal ("") then
					print("No errors in connecting!%N%N")

					from
						i := 1
					until
						i > 9
					loop
							--Set up SQL document for all properties of the feature
						creater.wipe_out
						get_mysql_query_for_property_values (creater, class_name, feature_name, i)

							--Local storage of query for all properties
						all_properties_query_doc := creater.get_mysql_select_doc

							--Execute the SQL query for all peroperties
						primary_database_connection_client.execute_query (all_properties_query_doc)
						if primary_database_connection_client.last_error.is_equal ("") then
							print ("No errors in generating ")
							print (i)
							print ("-variable table%N%N")

								--Update all values in the SQL table for the properties of the given feature.	
							update_table_boost_values (class_name, feature_name, i)
						else
							print (all_properties_query_doc)
							print ("An error occured in generating ")
							print (i)
							print ("-variable table%N%N")
							print (primary_database_connection_client.last_error)
							print ("%N%N")
						end
						i := i + 1
					end

				else
						--Errors occured in connecting
					print("last error = %N%T")
					print(primary_database_connection_client.last_error)
				end
			else
				print ("could not connect")
			end
		end

feature -- Main helper methods

	update_table_boost_values (
			class_name: STRING_8;
			feature_name: STRING_8;
			num_args: INTEGER_32)
			--Function called to actually oversee the insertion of new boost values into the MYSQL database
		local
			current_result: MYSQL_RESULT
			update_client: MYSQL_CLIENT
			result_table: ARRAY [ARRAY [STRING_8]]
			result_table_iterator: INDEXABLE_ITERATION_CURSOR [ARRAY [STRING_8]]
			stop_next: BOOLEAN
		do
				--Create a new client used for the updates, as the old one will not be able to do a new query without
				--destroying the data in the SQL_RESULT from the properties query

--			create secondary_database_connection_client.make_with_database ("127.0.0.1", "root", "root", "semantic_search")
			if primary_database_connection_client.has_result then
				current_result := primary_database_connection_client.last_result
				result_table := current_result.all_data

				result_table_iterator := result_table.new_cursor

				from
					result_table_iterator.start
				until
					result_table_iterator.after
				loop
--						--On every iteration, handle a new distinct property, operand placement, value triple
--						--method automatically increments
					if result_table_iterator.item.count /= 0 then
						handle_next_property_type_considering_operand_placement_and_evaluated_value (
							result_table_iterator,
							class_name,
							feature_name,
							num_args)
					else
						result_table_iterator.forth
					end
				end
			end
		end

	handle_next_property_type_considering_operand_placement_and_evaluated_value (
			result_table_iterator: INDEXABLE_ITERATION_CURSOR [ARRAY [STRING_8]];
			class_name: STRING_8;
			feature_name: STRING_8;
			num_args: INTEGER_32)
			--Given a MYSQL_RESULT table containing the results of a properties query, the name of the class and feature
			--currently being examined, and the number of operands properties currently being considered have.  A separate
			--boost value is calculated for each different value produced by evaluation of the property.

			--It is assumed that the columns of the MYSQL_RESULT table are query id as a string, value that the property
			--in the query id evaluates to as a string, and the number of times that the property evaluates to this
			--value as an integer
		local
			i: INTEGER_32
			current_property_name: STRING_8
			current_property_name_without_position_info: STRING_8
			frequency_table: HASH_TABLE [TUPLE[INTEGER_32, INTEGER_32], STRING_8]
			boost_value_table: HASH_TABLE [TUPLE[INTEGER_32, DOUBLE], STRING_8]
			total_property_occurences: INTEGER_32
			is_precondition: BOOLEAN
			key_str: STRING_8
			creater: SEM_SQL_STATEMENT_CREATER
		do
			create creater.make
			create frequency_table.make (50)
			create boost_value_table.make (50)

				--Gets the name of the property currently being investigated
			create current_property_name.make_empty
			current_property_name.copy (result_table_iterator.item.at (1))

			if not property_operand_is_decimal (current_property_name) then
					--Gets the name of the currently property with the operand position information removed
				current_property_name_without_position_info := standard_name_without_property_position (current_property_name)
				total_property_occurences := 0
					--Preconditions start with a 2 in the database, while postconditions start with a 3, 4, or 5
				is_precondition := result_table_iterator.item.at (1).at (1) = '2'
				from
--TODO: TALK TO JASON ABOUT THIS HACK
						--Dummy value.  Don't know how to start the loop otherwise
					i := 0
				until
					result_table_iterator.after or
					((
						--The following test ensures that the names 2_$.has and 3_$.has are not treated as the
						--same property, while also ensuring that instances of 2_$.has($)_0_1 and 2_$.has($)_0_2 are
						--not treated as the same property
					(is_precondition and result_table_iterator.item.at (1).at (1) /= '2') or
					not current_property_name.is_equal (result_table_iterator.item.at (1))
					)
					and not
						--The table cursor has incremented to a new property
					(current_property_name_without_position_info.is_equal (standard_name_without_property_position (result_table_iterator.item.at (1))))
					)
				loop
					create key_str.make_empty
						--This will be the key for the frequency table.  Each different ID (which contains the
						--property name and operand placement information) is appended with the value the
						--property evaluates to.  This is not implemented as a tuple pair because this method
						--of storage is simple enough to use for stripping off the value in order to get the
						--original name of the ID
					key_str.append_string (result_table_iterator.item.at (1))
					if not is_precondition then
						remove_property_position_from_standard_name (key_str)
						key_str.prepend_string ("3_")
					end
					key_str.append_character ('&')
					key_str.append_string (result_table_iterator.item.at (2))
					if not frequency_table.has (key_str) then
						frequency_table.put ([result_table_iterator.item.at (2).to_integer, 0], key_str)
					end
					frequency_table.at (key_str).at (2) := frequency_table.at (key_str).at (2).out.to_integer_32 + result_table_iterator.item.at (3).to_integer_32
					--frequency_table.put ([result_table_iterator.item.at (2).to_integer_32, result_table_iterator.item.at (3).to_integer_32 + frequency_table.item (key_str) ], key_str)
					total_property_occurences := total_property_occurences + result_table_iterator.item.at (3).to_integer_32
					result_table_iterator.forth
					i := i + 1
				end

					--This method fills the boost_value_table for later use
				fill_boost_value_table (frequency_table, boost_value_table, total_property_occurences)
				get_boost_update_query_considering_value(creater,
															class_name,
															feature_name,
															boost_value_table,
															num_args,
															is_precondition)

				primary_database_connection_client.execute_query (creater.get_mysql_update_doc)

				if not primary_database_connection_client.last_error.is_equal ("") then
						--Hopefully no errors!
					print ("********************error!******************%N%N")
					print (primary_database_connection_client.last_error)
					print ("%N%N")
				end


			else
					--Gets the name of the currently property with the operand position information removed
				current_property_name_without_position_info := standard_name_without_property_position (current_property_name)

					--Preconditions start with a 2 in the database, while postconditions start with a 3, 4, or 5
				is_precondition := result_table_iterator.item.at (1).at (1) = '2'

				from
						--Dummy value because I don't know how to start the loop otherwise
					i := 0
				until
					result_table_iterator.after or
					(((is_precondition and result_table_iterator.item.at (1).at (1) /= '2') or -- this signifies going from pre to post conditions for the
																			--same property name.  unlikely, but it could happen
					not current_property_name.is_equal (result_table_iterator.item.at (1)))
					and not
						--The table cursor has incremented to a new property
					(current_property_name_without_position_info.is_equal (standard_name_without_property_position (result_table_iterator.item.at (1)))))
				loop
					result_table_iterator.forth
					i := i + 1
				end
			end
		end

	fill_boost_value_table (frequency_table :HASH_TABLE [TUPLE[INTEGER_32, INTEGER_32], STRING_8];
													boost_value_table: HASH_TABLE [TUPLE[INTEGER_32, DOUBLE], STRING_8];
													total_property_occurences: INTEGER_32)
			--Fills boost_value_table with all of the values of the properties contained in the frequency table.  This boost
			--value is calculated as the frequency of a given value that a property evaluates to over the total number of
			--occurences of that value.  properties consider the placement of operands as a distinguishing characteristic
		local
			i: INTEGER_32
		do
			from
				frequency_table.start
			until
				frequency_table.off
			loop
				boost_value_table.put (
					[
						frequency_table.item_for_iteration.at (1).out.to_integer_32,
						frequency_table.item_for_iteration.at (2).out.to_double / total_property_occurences
					],
					frequency_table.key_for_iteration)
				frequency_table.forth
			end
		end

	get_value_from_value_appended_string (value_appended_string: STRING_8): INTEGER_32
			--Given a string that contains a number at the end separated from the string by an '&' character,
			--returns the number as an INTEGER_32.  '&' must appear exactly once in this string, and it must
			--appear immediately preceding an integer value
		local
			str: STRING_8
			index: INTEGER_32
		do
			create str.make_empty
			index := value_appended_string.index_of ('&', 1)
			str.append (value_appended_string.substring (index + 1, value_appended_string.count))
			Result := str.to_integer_32
		end

	get_value_appended_string_with_value_removed (value_appended_string: STRING_8): STRING_8
			--If a string is of the form {first half}&{second half}, the value of first half is returned
			--in a new string object
		do
			Result := value_appended_string.substring (1, value_appended_string.index_of ('&', 1) - 1)
		end

	remove_value_from_appended_standard_name (value_appended_string: STRING_8)
			--For a string of the form {substring1}&{substring2} manipulates the string so that it only contains the
			--value of substring2 after the function call
		do
			value_appended_string.remove_substring (value_appended_string.index_of ('&', 1), value_appended_string.count)
		end

	remove_property_position_from_standard_name (value_appended_string: STRING_8)
			--For a string of form {substring1}_{substring2} manipulates the string so that it only contains the value of
			--substring2 after the function call
		do
			value_appended_string.remove_substring (1, value_appended_string.index_of ('_', 1))
		end

	standard_name_without_property_position (standard_name: STRING_8): STRING_8
			--Given a string of the form [1, 2, 3, 4, 5]_$.{property_name}($ ", $"*)_{operand placement info} returns
			--a string that no longer contains the "[1, 2, 3, 4, 5]_" portion of the input standard
			--name
		do
			Result := standard_name.substring (standard_name.index_of ('_', 1) + 1, standard_name.count)
		end

	property_operand_is_decimal (standard_name: STRING_8): BOOLEAN
			--Given a string of the form {first part}({paren contents}){second part} returns a boolean that is true
			--exactly when paren contents is a decimal not considering ' ' characters contained in the name
		local
			operand_contents: STRING_8
			open_paren_position: INTEGER_32
			close_paren_position: INTEGER_32
		do
			create operand_contents.make_empty
			open_paren_position := standard_name.index_of ('(', 1)
			close_paren_position := standard_name.index_of (')', 1)
			operand_contents.copy (standard_name.substring (open_paren_position + 1, close_paren_position - 1))
			operand_contents.prune_all_leading (' ')
			operand_contents.prune_all_trailing (' ')
			Result := operand_contents.is_integer_32
		end

	parse_out_property_name (standard_name: STRING_8): STRING_8
			--Given a name written as [1, 2, 3, 4, 5]_$.{property_name}($ ", $"*)_{operand placement info} returns
			--the string contained in the "property_name" position
		local
			i: INTEGER_32
			first_period_in_string_position: INTEGER_32
		do
			result := ""
			first_period_in_string_position := standard_name.index_of ('.', 1)
			from
				i := first_period_in_string_position + 1
			until
				i = standard_name.index_of (' ', first_period_in_string_position + 1)
			loop
				result.append_character (standard_name.at (i))
				i := i + 1
			end
		end

	calculate_single_boost_value (
			frequency_table: HASH_TABLE [TUPLE [INTEGER_32, INTEGER_32], STRING_8];
			total_property_occurences: INTEGER_32): DOUBLE
			--Given a HASH_TABLE of STRING_8s (property ids) pointing to tuples containing the value of the property
			--in position 1 and the number of times the property occurs in position two, calculates the boost value
			--as the number of times a given value of a property occurs, times the value of that property, divided
			--by the total number of times that the given property occurs overall.
		local
			total_number_of_occurences: INTEGER_32
		do
			result := 0
			total_number_of_occurences := 0
			from
				frequency_table.start
			until
				frequency_table.off
			loop
					--Value that the property evaluates to times the number of times it appeared
				result := result + frequency_table.item_for_iteration.at (1).out.to_integer_32 * frequency_table.item_for_iteration.at (2).out.to_integer_32
					--Increment the value of the total number of occurences of the property
				total_number_of_occurences := total_number_of_occurences + (frequency_table.item_for_iteration.at (2).out.to_integer_32)
				frequency_table.forth
			end
			result := result / total_number_of_occurences
		end

feature --MYSQL query generators

	get_mysql_query_for_property_values (
			creater: SEM_SQL_STATEMENT_CREATER;
			class_name: STRING_8;
			feature_name: STRING_8;
			num_args: INTEGER_32)
			--Generates a MYSQL document in the SQL_STATEMENT_CREATER that retrieves information about all
			--properties that have num_args arguments of the feature feature_name, which is a part of the
			--class class_name.
		local
			sub_creater: SEM_SQL_STATEMENT_CREATER
			char: CHARACTER_8
			str: STRING_8
			i: INTEGER_32
		do
			create sub_creater.make

			--SELECT clause

			str := "CONCAT(CAST(p1.prop_kind AS CHAR(1)), %'_%', p.text"
			from
				i := 1
			until
				i > num_args
			loop
				str.append_string (", %'_%', CAST(v")
				str.append_integer (i)
				str.append_string (".position AS CHAR(1))")
				i := i + 1
			end
			str.append (")")

				--Specify which values to select
			creater.add_select_as_statement_to_select_clause (str,	"id")
			creater.add_select_as_statement_to_select_clause ("p1.value", "value")
			creater.add_select_as_statement_to_select_clause ("COUNT(*)", "number of occurences")

				--FROM clause

				--Specify which tables to search
			creater.add_to_from_clause_arguments ("Queryables q")
			str.wipe_out
			str.append_string ("PropertyBindings")
			str.append_integer (num_args)
			str.append_string (" p1")
			creater.add_to_from_clause_arguments (str)
				--Create a number of PropertyBindings1 variables that corresponds to the num_args
				--variable.
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("PropertyBindings1 v")
				str.append_integer (i)
				creater.add_to_from_clause_arguments (str)
				i := i + 1
			end
			creater.add_to_from_clause_arguments ("Properties p")

				--WHERE clause

				--Specify class and feature
			creater.start_where_clause ("q.class = %"" + class_name + "%"")
			creater.add_to_where_clause_arguments ("AND", "q.feature = %"" + feature_name + "%"")

				--Generate a sub query for all properties with prop_id = "$".
				--This will be used for each PropertyBindings1 variable, each of which corresponds
				--to each different operand in a query
			sub_creater.add_to_select_clause ("prop_id")
			sub_creater.add_to_from_clause_arguments ("Properties")
			sub_creater.start_where_clause ("text = %"$%"")
				--Prepare the variables corresponding to each operand in a property
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".prop_id = (" + sub_creater.get_mysql_select_doc + ")")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".qry_id = q.qry_id")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_string ("(v")
				str.append_integer (i)
				str.append_string (".position BETWEEN 0 AND q.operand_count - 1)")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

				--This portion of the query corresponds to ensuring that each operand
				--variable corresponds to a unique operand in the property
			creater.add_to_where_clause_arguments ("AND", "p1.qry_id = q.qry_id")
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("p1.var")
				str.append_integer (i)
				str.append_string (" = v")
				str.append_integer (i)
				str.append_string (".var1")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

				--Ensures that each operator instance refers to the same property instance
			creater.add_to_where_clause_arguments ("AND", "p1.prop_id = p.prop_id")
			from
				i := 2
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("v1.prop_kind = v")
				str.append_integer (i)
				str.append_string (".prop_kind")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end
			creater.add_to_where_clause_arguments ("AND", "((v1.prop_kind = 2 AND p1.prop_kind = 2) OR (p1.prop_kind >=3 AND v1.prop_kind >= 3))")

			str.wipe_out
			str.append_string ("(p1.prop_kind != 2), p.text, ")
			from
				i := 1
			until
				i > num_args
			loop
				str.append_string ("v")
				str.append_integer (i)
				str.append_string (".position, ")
				i := i + 1
			end
			str.append_string ("p1.prop_kind, value")

			creater.add_group_by_statement (str)
		end

	get_boost_update_query_considering_value (
			creater: SEM_SQL_STATEMENT_CREATER;
			class_name: STRING_8;
			feature_name: STRING_8;
			boost_value_table: HASH_TABLE [TUPLE[INTEGER_32, DOUBLE], STRING_8];
			num_args: INTEGER_32;
			is_precondition: BOOLEAN)
			--Extension of get_update_boost_query_not_considering_value. this one adds an extra clause
			--ensuring that only the the property with a specific value is updated
		local
			sub_creater: SEM_SQL_STATEMENT_CREATER
			char: CHARACTER_8
			str: STRING_8
			i: INTEGER_32
			j: INTEGER_32
			property_name: STRING_8
		do
			create sub_creater.make
			create property_name.make_empty
			boost_value_table.start
			property_name.copy (boost_value_table.key_for_iteration)
			remove_property_position_from_standard_name (property_name)
			remove_value_from_appended_standard_name (property_name)
			str := ""
			creater.add_to_update_clause_arguments ("Queryables q")
			str.wipe_out
			str.append_string ("PropertyBindings")
			str.append_integer (num_args)
			str.append_string (" p1")
			creater.add_to_update_clause_arguments (str)
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("PropertyBindings1 v")
				str.append_integer (i)
				creater.add_to_update_clause_arguments (str)
				i := i + 1
			end
			creater.add_to_update_clause_arguments ("Properties p")

			from
				boost_value_table.start
			until
				boost_value_table.off
			loop
				str.wipe_out
				str.append_string ("p1.value = ")
				str.append (boost_value_table.item_for_iteration.at (1).out)
				creater.add_when_pair_to_case_statement (str, boost_value_table.item_for_iteration.at (2).out.to_double)
				boost_value_table.forth
			end

			creater.set_case_statement_default (0.000)

			str.wipe_out
			str.append_character ('(')
			str.append_string (creater.get_case_statement)
			str.append_character (')')

			creater.add_to_set_clause_arguments ("p1.boost", str)

			creater.start_where_clause ("q.class = %"" + class_name + "%"")
			creater.add_to_where_clause_arguments ("AND", "q.feature = %"" + feature_name + "%"")

			sub_creater.add_to_select_clause ("prop_id")
			sub_creater.add_to_from_clause_arguments ("Properties")
			sub_creater.start_where_clause ("text = %"$%"")

			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".prop_id = (" + sub_creater.get_mysql_select_doc + ")")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".qry_id = q.qry_id")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_string ("(v")
				str.append_integer (i)
				str.append_string (".position BETWEEN 0 AND q.operand_count - 1)")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

			creater.add_to_where_clause_arguments ("AND", "p1.qry_id = q.qry_id")
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("p1.var")
				str.append_integer (i)
				str.append_string (" = v")
				str.append_integer (i)
				str.append_string (".var1")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

			creater.add_to_where_clause_arguments ("AND", "p1.prop_id = p.prop_id")
			from
				i := 2
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("v1.prop_kind = v")
				str.append_integer (i)
				str.append_string (".prop_kind")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end
			creater.add_to_where_clause_arguments ("AND", "((v1.prop_kind = 2 AND p1.prop_kind = 2) OR (p1.prop_kind >=3 AND v1.prop_kind >= 3))")

			str.wipe_out
			if is_precondition then
				str.append_string ("CONCAT(CAST(p1.prop_kind AS CHAR(1)), %'_%', p.text")
				from
					i := 1
				until
					i > num_args
				loop
					str.append_string (", %'_%', CAST(v")
					str.append_integer (i)
					str.append_string (".position AS CHAR(1))")
					i := i + 1
				end
				str.append (")")
				str.append (" = ")
				str.append_character ('%"')
				str.append_integer (2)
				str.append_character ('_')
				str.append (property_name)
				str.append_character ('%"')
			else
				str.append_character ('(')
				from
					j := 3
				until
					j = 6
				loop
					str.append_string ("CONCAT(CAST(p1.prop_kind AS CHAR(1)), %'_%', p.text")
					from
						i := 1
					until
						i > num_args
					loop
						str.append_string (", %'_%', CAST(v")
						str.append_integer (i)
						str.append_string (".position AS CHAR(1))")
						i := i + 1
					end
					str.append (")")
					str.append (" = ")
					str.append_character ('%"')
					str.append_integer (j)
					str.append_character ('_')
					str.append (property_name)
					str.append_character ('%"')
					if j /= 5 then
						str.append (" OR ")
					end
					j := j + 1
				end
				str.append_character (')')
			end

			creater.add_to_where_clause_arguments ("AND", str)
		end

	get_update_boost_query_not_considering_value (creater: SEM_SQL_STATEMENT_CREATER;
					class_name: STRING_8;
					feature_name: STRING_8;
					property_name: STRING_8;
					boost_value: DOUBLE;
					num_args: INTEGER_32)
			--Creates a query to update all all properties with property_name that refer to the feature feature_name
			--which is a part of the class class_name
		local
			sub_creater: SEM_SQL_STATEMENT_CREATER
			char: CHARACTER_8
			str: STRING_8
			i: INTEGER_32
		do
			create sub_creater.make
			str := ""
			creater.add_to_update_clause_arguments ("Queryables q")
			str.wipe_out
			str.append_string ("PropertyBindings")
			str.append_integer (num_args)
			str.append_string (" p1")
			creater.add_to_update_clause_arguments (str)
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("PropertyBindings1 v")
				str.append_integer (i)
				creater.add_to_update_clause_arguments (str)
				i := i + 1
			end
			creater.add_to_update_clause_arguments ("Properties p")

			str.wipe_out
			str.append_double (boost_value)

			creater.add_to_set_clause_arguments ("p1.boost", str)

			creater.start_where_clause ("q.class = %"" + class_name + "%"")
			creater.add_to_where_clause_arguments ("AND", "q.feature = %"" + feature_name + "%"")

			sub_creater.add_to_select_clause ("prop_id")
			sub_creater.add_to_from_clause_arguments ("Properties")
			sub_creater.start_where_clause ("text = %"$%"")

			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".prop_id = (" + sub_creater.get_mysql_select_doc + ")")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_character ('v')
				str.append_integer (i)
				str.append_string (".qry_id = q.qry_id")
				creater.add_to_where_clause_arguments ("AND", str)
				str.wipe_out
				str.append_string ("(v")
				str.append_integer (i)
				str.append_string (".position BETWEEN 0 AND q.operand_count - 1)")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

			creater.add_to_where_clause_arguments ("AND", "p1.qry_id = q.qry_id")
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("p1.var")
				str.append_integer (i)
				str.append_string (" = v")
				str.append_integer (i)
				str.append_string (".var1")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end

			creater.add_to_where_clause_arguments ("AND", "p1.prop_id = p.prop_id")
			from
				i := 1
			until
				i > num_args
			loop
				str.wipe_out
				str.append_string ("v1.prop_kind = v")
				str.append_integer (i)
				str.append_string (".prop_kind")
				creater.add_to_where_clause_arguments ("AND", str)
				i := i + 1
			end
			creater.add_to_where_clause_arguments ("AND", "((v1.prop_kind = 2 AND p1.prop_kind = 2) OR (p1.prop_kind >=3 AND v1.prop_kind >= 3))")

			str.wipe_out
			str.append_string ("CONCAT(CAST(p1.prop_kind AS CHAR(1)), %'_%', p.text")
			from
				i := 1
			until
				i > num_args
			loop
				str.append_string (", %'_%', CAST(v")
				str.append_integer (i)
				str.append_string (".position AS CHAR(1))")
				i := i + 1
			end
			str.append (")")
			str.append (" = ")
			str.append_character ('%"')
			str.append (property_name)
			str.append_character ('%"')

			creater.add_to_where_clause_arguments ("AND", str)
		end
	end
