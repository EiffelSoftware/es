note
	description: "A reader that reads the data from a dynamic program analysis from disk using serialized data files."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_SERIALIZED_DATA_FILE_READER

inherit
	DPA_DATA_READER

create
	make

feature {NONE} -- Initialization

	make (a_path: like path; a_file_name_prefix: like file_name_prefix)
			--
		require
			a_path_not_void: a_path /= Void
			a_file_name_prefix_not_void: a_file_name_prefix /= Void
		local
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			i, j: INTEGER
			l_data: LIST [STRING]
			l_stride: INTEGER
			l_stride_found: BOOLEAN
		do
			path := a_path
			file_name_prefix := a_file_name_prefix

			create l_file_name.make_from_string (path + file_name_prefix + "_1.txt")
			check valid_file_name: l_file_name.is_valid end
			create l_file.make (l_file_name.string)

			check l_file.exists and l_file.is_readable end
			l_file.open_read

			l_file.read_stream (l_file.count)

			l_data := l_file.last_string.split ('%N')

			class_ := l_data.i_th (1)
			feature_ := l_data.i_th (2)
			check l_data.last.is_equal ("EOF") end

			create strides_of_files.make_default

			from
				i := 4
				l_stride := 1
			until
				i > l_data.count or l_stride_found
			loop
				if l_data.i_th (i).occurrences (';') /= 1 then
					l_stride := l_stride + 1
				else
					l_stride_found := True
				end
				i := i + 1
			end
			strides_of_files.force_last (l_stride, 1)

			l_file.close

			from
				i := 2
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
			until
				not l_file.exists
			loop
				check l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				check class_.is_equal (l_data.i_th (1)) end
				check feature_.is_equal (l_data.i_th (2)) end
				check l_data.last.is_equal ("EOF") end

				from
					j := 4
					l_stride := 1
					l_stride_found := False
				until
					j > l_data.count or l_stride_found
				loop
					if l_data.i_th (j).occurrences (';') /= 1 then
						l_stride := l_stride + 1
					else
						l_stride_found := True
					end
					j := j + 1
				end
				strides_of_files.force_last (l_stride, i)

				l_file.close

				i := i + 1
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
			end

			number_of_data_files := i - 1
		ensure
			path_set: path.is_equal (a_path)
			file_name_prefix_set: file_name_prefix.is_equal (a_file_name_prefix)
			class_set: class_ /= Void and class_.count >= 1
			feature_set: feature_ /= Void and feature_.count >= 1
			number_of_data_files_set: number_of_data_files >= 1
		end

feature -- Access

	path: STRING
			-- Path where one or multiple serialized data files are stored.

	file_name_prefix: STRING
			-- File name prefix of the serialized data file or files.

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature that was analyzed.

	analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			i, j, l_upper_bound: INTEGER
			l_locations: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_data: LIST [STRING]
			l_stride: INTEGER
		do
			create Result.make
			from
				i := 1
			until
				i > number_of_data_files
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 3
					l_stride := strides_of_files.item (i)
				until
					j > l_upper_bound
				loop
					check l_data.i_th (j).occurrences (';') = 1 then
						l_locations := l_data.i_th (j).split (';')
						Result.extend ([l_locations.i_th (1).to_integer, l_locations.i_th (2).to_integer])
					end
					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

	analysis_order_pairs_count: INTEGER
			-- Number of pre-state / post-state breakpoint pairs.
		local
			i, j: INTEGER
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_data: LIST [STRING]
			l_stride: INTEGER
			l_upper_bound: INTEGER
		do
			from
				i := 1
			until
				i > number_of_data_files
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 3
					l_stride := strides_of_files.item (i)
				until
					j > l_upper_bound
				loop
					check l_data.i_th (j).occurrences (';') = 1 then
						Result := Result + 1
					end
					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

	limited_analysis_order_pairs (a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- Limited list of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `analysis_order_pairs_count'
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			i, j, l_pairs_count, l_number_of_pairs: INTEGER
			l_locations: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_data: LIST [STRING]
			l_stride: INTEGER
			l_upper_bound: INTEGER
		do
			l_pairs_count := 0
			l_number_of_pairs := a_upper_bound - a_lower_bound + 1
			create Result.make
			from
				i := 1
			until
				i > number_of_data_files or Result.count = l_number_of_pairs
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 3
					l_stride := strides_of_files.item (i)
				until
					j > l_upper_bound or Result.count = l_number_of_pairs
				loop
					check l_data.i_th (j).occurrences (';') = 1 then
						l_pairs_count := l_pairs_count + 1
						if a_lower_bound <= l_pairs_count and l_pairs_count <= a_upper_bound then
							l_locations := l_data.i_th (j).split (';')
							Result.extend ([l_locations.i_th (1).to_integer, l_locations.i_th (2).to_integer])
						end
					end
					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

	expressions_and_locations: LINKED_LIST [TUPLE [expression: STRING; location: INTEGER]]
			-- Expressions and locations at which they were evaluted during the analysis.
		local
			i, j: INTEGER
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_current_line, l_expression: STRING
			l_location: INTEGER
			l_data, l_transition: LIST [STRING]
			l_locations: DS_HASH_SET [INTEGER]
			l_expressions_locations: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_upper_bound: INTEGER
		do
			create l_expressions_locations.make_default
			create Result.make
			from
				i := 1
			until
				i > number_of_data_files
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 4
				until
					j > l_upper_bound
				loop
					l_current_line := l_data.i_th (j)
					if l_current_line.occurrences (';') = 8 then
						l_transition := l_current_line.split (';')
						l_expression := l_transition.i_th (1)
						l_location := l_transition.i_th (2).to_integer
						if l_expressions_locations.has (l_expression) then
							l_locations := l_expressions_locations.item (l_expression)
							l_locations.force_last (l_location)
						else
							create l_locations.make_default
							l_locations.force_last (l_location)
							l_expressions_locations.force_last (l_locations, l_expression)
						end
					end

					j := j + 1
				end

				l_file.close

				i := i + 1
			end

			from
				l_expressions_locations.start
			until
				l_expressions_locations.after
			loop
				l_expression := l_expressions_locations.key_for_iteration
				l_locations := l_expressions_locations.item_for_iteration
				from
					l_locations.start
				until
					l_locations.after
				loop
					l_location := l_locations.item_for_iteration
					Result.extend ([l_expression, l_location])
					l_locations.forth
				end

				l_expressions_locations.forth
			end
		end

	expression_value_transitions_count (a_expression: STRING; a_location: INTEGER): INTEGER
			-- Number of value transitions of `a_expression' evaluated at `a_location'.
		local
			i, j: INTEGER
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_current_line: STRING
			l_data, l_transition: LIST [STRING]
			l_stride, l_upper_bound: INTEGER
		do
			from
				i := 1
			until
				i > number_of_data_files
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 4
					l_stride := 1
				until
					j > l_upper_bound
				loop
					l_current_line := l_data.i_th (j)
					if l_current_line.occurrences (';') = 8 then
						l_transition := l_current_line.split (';')
						if l_transition.i_th (1).is_equal (a_expression) and l_transition.i_th (2).to_integer = a_location then
							l_stride := strides_of_files.item (i)
							Result := Result + 1
						end
					end

					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

	expression_value_transitions (a_expression: STRING; a_location: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Value transitions of `a_expression' evaluated at `a_location'.
		local
			i, j: INTEGER
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_data, l_transition: LIST [STRING]
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_value_transition: EPA_VALUE_TRANSITION
			l_stride, l_upper_bound: INTEGER
		do
			create Result.make
			from
				i := 1
			until
				i > number_of_data_files
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 4
					l_stride := 1
				until
					j > l_upper_bound
				loop
					if l_data.i_th (j).occurrences (';') = 8 then
						l_stride := strides_of_files.item (i)
						l_transition := l_data.i_th (j).split (';')
						l_pre_state_bp := l_transition.i_th (2).to_integer
						if l_transition.i_th (1).is_equal (a_expression) and l_pre_state_bp = a_location then
							if l_transition.i_th (3).is_equal (reference_value) then
								l_pre_state_value := ref_value_from_data (l_transition.i_th (4), l_transition.i_th (5))
							elseif l_transition.i_th (5).is_equal (string_value) then
								l_pre_state_value := string_value_from_data (l_transition.i_th (4), l_transition.i_th (5))
							else
								l_pre_state_value := value_from_data (l_transition.i_th (4), l_transition.i_th (3))
							end

							l_post_state_bp := l_transition.i_th (6).to_integer
							if l_transition.i_th (7).is_equal (reference_value) then
								l_post_state_value := ref_value_from_data (l_transition.i_th (8), l_transition.i_th (9))
							elseif l_transition.i_th (7).is_equal (string_value) then
								l_post_state_value := string_value_from_data (l_transition.i_th (8), l_transition.i_th (9))
							else
								l_post_state_value := value_from_data (l_transition.i_th (8), l_transition.i_th (7))
							end

							create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

							Result.extend (l_value_transition)
						end
					end
					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

	limited_expression_value_transitions (a_expression: STRING; a_location: INTEGER; a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Limited value transitions of `a_expression' evaluated at `a_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `expression_value_transitions_count'
		local
			i, j, l_pairs_count, l_number_of_pairs: INTEGER
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_data, l_transition: LIST [STRING]
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_value_transition: EPA_VALUE_TRANSITION
			l_stride, l_upper_bound: INTEGER
		do
			l_pairs_count := 0
			l_number_of_pairs := a_upper_bound - a_lower_bound + 1
			create Result.make
			from
				i := 1
			until
				i > number_of_data_files or Result.count = l_number_of_pairs
			loop
				create l_file_name.make_from_string (path + file_name_prefix + "_" + i.out + ".txt")
				check valid_file_name: l_file_name.is_valid end
				create l_file.make (l_file_name.string)
				check l_file.exists and l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_data := l_file.last_string.split ('%N')

				l_upper_bound := l_data.count - 1
				from
					j := 4
					l_stride := 1
				until
					j > l_upper_bound or Result.count = l_number_of_pairs
				loop
					if l_data.i_th (j).occurrences (';') = 8 then
						l_stride := strides_of_files.item (i)
						l_transition := l_data.i_th (j).split (';')
						l_pre_state_bp := l_transition.i_th (2).to_integer
						if l_transition.i_th (1).is_equal (a_expression) and l_pre_state_bp = a_location then
							l_pairs_count := l_pairs_count + 1
							if a_lower_bound <= l_pairs_count and l_pairs_count <= a_upper_bound then
								if l_transition.i_th (3).is_equal (reference_value) then
									l_pre_state_value := ref_value_from_data (l_transition.i_th (4), l_transition.i_th (5))
								elseif l_transition.i_th (5).is_equal (string_value) then
									l_pre_state_value := string_value_from_data (l_transition.i_th (4), l_transition.i_th (5))
								else
									l_pre_state_value := value_from_data (l_transition.i_th (4), l_transition.i_th (3))
								end

								l_post_state_bp := l_transition.i_th (6).to_integer
								if l_transition.i_th (7).is_equal (reference_value) then
									l_post_state_value := ref_value_from_data (l_transition.i_th (8), l_transition.i_th (9))
								elseif l_transition.i_th (7).is_equal (string_value) then
									l_post_state_value := string_value_from_data (l_transition.i_th (8), l_transition.i_th (9))
								else
									l_post_state_value := value_from_data (l_transition.i_th (8), l_transition.i_th (7))
								end

								create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

								Result.extend (l_value_transition)
							end
						end
					end
					j := j + l_stride
				end

				l_file.close

				i := i + 1
			end
		end

feature {NONE} -- Implementation

	number_of_data_files: INTEGER
			-- Number of data files.

	strides_of_files: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Strides of files to speed up the retrieval of analysis order pairs
			-- and expression value transitions.
			-- Keys are the numbers of serialized data files and are in the interval
			-- between 1 and `number_of_data_files'.
			-- Values are the strides.

end
