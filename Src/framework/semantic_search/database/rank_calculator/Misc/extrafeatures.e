
feature --currently unused or outdated methods.  keeping just in case...

	--primitive and somewhat ineffective method of displaying results in console.  Values are
	--separated by tabs, so they can be loaded into excel as a csd file
	print_all_results (current_result: MYSQL_RESULT)
		local
			i: INTEGER_32
		do
			--print out the name of each column first
			from
				i := 1
			until
				i > current_result.field_count
			loop
				print (current_result.column_at (i))
				print ('%T')
				i := i + 1
			end
			print ("%N")

			--print out the results of each column, row by row.
			--outer loop prints by row
			from
				current_result.start
			until
				current_result.off
			loop
				--inner loop prints by column
				from
					i := 1
				until
					i > current_result.field_count
				loop
					print (current_result.at (i))
					print ('%T')
					i := i + 1
				end
				current_result.forth
				print ('%N')
			end
		end

	--this method depends on the way that the boost values are being calculated.
	--the only real difference is the conditions that define under what conditions two preconditions
	--are considered the same.  These differences arise exactly in the conditinos in the until
	--statement, where "differentness" defines when to stop looping (the until condition)
	--At the very least, every different precondition name is considered individually, then you can consider
	--the placement of oeprands for the next level of specificity, and finally you can calculate the boost values
	--for every different precondition, every different operand placement, and every different value of the property given
	--operand placement.  In this case, boost values will be generated with respect to the relative frequency as compared
	--with the values of the same preconditino with the same oeprand placement
	handle_next_property_type_simple (current_result:  MYSQL_RESULT)
		local
			i: INTEGER_32
			current_standard_name: STRING_8
			current_property_name: STRING_8
			frequency_table: HASH_TABLE [TUPLE[INTEGER_32, INTEGER_32], STRING_8]
			total_property_occurences: INTEGER_32
			is_precondition: BOOLEAN
			boost_value: DOUBLE
			key_str: STRING_8
		do
			create frequency_table.make (50)
			current_property_name := parse_out_property_name(current_result.at (1))
			total_property_occurences := 0
			is_precondition := current_result.at (1).at (1) = '2'
			from
				i := 0
			until
				current_result.off or
				(is_precondition and current_result.at (1).at (1) /= '2') or -- this signifies going from pre to post conditions for the
																		--same property name.  unlikely, but it could happen
				not current_property_name.is_equal (parse_out_property_name (current_result.at (1)))
			loop
				create key_str.make_empty
				key_str.append_string (current_result.at (1))
				key_str.append_character ('&')
				key_str.append_string (current_result.at (2))
				frequency_table.put ([current_result.at (2).to_integer_32, current_result.at (3).to_integer_32 ], key_str)
				total_property_occurences := total_property_occurences + current_result.at (3).to_integer_32
				current_result.forth
				i := i + 1
			end

			boost_value := calculate_single_boost_value (frequency_table, total_property_occurences)

		end


--TODO: UPDATE THIS METHOD AND ALL RELATED ONES TO MAKE THEM WORK WITH THE CURRENT SCHEME, OR ELSE
--GET RID OF THEM
	--implements the simplest method of calculating the boost value
	update_next_property_type_simple (frequency_table: HASH_TABLE [TUPLE [INTEGER_32, INTEGER_32], STRING_8];
										boost_value: DOUBLE)
		do
			from
				frequency_table.start
			until
				frequency_table.off
			loop
--				update_value (frequency_table.key_for_iteration, boost_value)
				frequency_table.forth
			end
		end

	--Given a MYSQL_RESULT table containing the results of a properties query, the name of the class and feature
	--currently being examined, and the number of operands properties currently being considered have.  The boost
	--value is calculated regardless of the value of each instance of the property.
	handle_next_property_type_considering_operand_placement (current_result:  MYSQL_RESULT; class_name: STRING_8;
																feature_name: STRING_8; num_args: INTEGER_32)
		local
			i: INTEGER_32
			current_property_name: STRING_8
			current_property_name_without_position_info: STRING_8
			frequency_table: HASH_TABLE [TUPLE[INTEGER_32, INTEGER_32], STRING_8]
			total_property_occurences: INTEGER_32
			is_precondition: BOOLEAN
			boost_value: DOUBLE
			key_str: STRING_8
			creater: SQL_STATEMENT_CREATER
		do
			create creater.make
			create frequency_table.make (50)
			current_property_name := current_result.at (1)
			current_property_name_without_position_info := standard_name_without_property_position (current_property_name)
			total_property_occurences := 0
			is_precondition := current_result.at (1).at (1) = '2'
			from
				i := 0
			until
				current_result.off or
				(((is_precondition and current_result.at (1).at (1) /= '2') or -- this signifies going from pre to post conditions for the
																		--same property name.  unlikely, but it could happen
				not current_property_name.is_equal (current_result.at (1)))
				and not
				(current_property_name_without_position_info.is_equal (standard_name_without_property_position (current_result.at (1)))))
			loop
				create key_str.make_empty
				key_str.append_string (current_result.at (1))
				key_str.append_character ('&')
				key_str.append_string (current_result.at (2))
				frequency_table.put ([current_result.at (2).to_integer_32, current_result.at (3).to_integer_32 ], key_str)
				total_property_occurences := total_property_occurences + current_result.at (3).to_integer_32
				current_result.forth
				i := i + 1
			end

			boost_value := calculate_single_boost_value (frequency_table, total_property_occurences)

			--print (current_property_name)

			get_update_boost_query_not_considering_value (creater, class_name,
															feature_name,
															current_property_name,
															boost_value,
															num_args)

		end


	end
