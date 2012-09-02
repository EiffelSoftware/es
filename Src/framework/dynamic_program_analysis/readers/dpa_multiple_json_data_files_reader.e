note
	description: "A reader that reads the data from a dynamic program analysis from disk using one or multiple JSON data files."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MULTIPLE_JSON_DATA_FILES_READER

inherit
	DPA_JSON_DATA_FILE_READER

	KL_SHARED_STRING_EQUALITY_TESTER

create
	make

feature {NONE} -- Initialization

	make (a_path: like path; a_file_name_prefix: like file_name_prefix)
			-- Initialize current reader.
		require
			a_path_not_void: a_path /= Void
			a_file_name_prefix_not_void: a_file_name_prefix /= Void
		local
			l_file: PLAIN_TEXT_FILE
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			i: INTEGER
			l_class, l_feature: STRING
		do
			path := a_path
			file_name_prefix := a_file_name_prefix

			create l_file_name.make_from_string (path + file_name_prefix + "_1.txt")
			check valid_file_name: l_file_name.is_valid end
			create l_file.make (l_file_name.string)
			check l_file.exists and l_file.is_readable end
			l_file.open_read
			l_file.read_stream (l_file.count)
			create l_parser.make_parser (l_file.last_string)
			check attached {JSON_OBJECT} l_parser.parse as l_json_object then
				-- Extract class
				class_ := string_from_json (l_json_object.item (class_json_string))

				-- Extract feature
				feature_ := string_from_json (l_json_object.item (feature_json_string))
			end
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
				create l_parser.make_parser (l_file.last_string)
				check attached {JSON_OBJECT} l_parser.parse as l_json_object then
					-- Extract class
					l_class := string_from_json (l_json_object.item (class_json_string))
					check class_.is_equal (l_class) end

					-- Extract feature
					l_feature := string_from_json (l_json_object.item (feature_json_string))
					check feature_.is_equal (l_feature) end
				end

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
		end

feature -- Access

	path: STRING
			-- Path where one or multiple JSON data files are stored.

	file_name_prefix: STRING
			-- File name prefix of the JSON data file or files.

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature that was analyzed.

	analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			i, j: INTEGER
			l_file: PLAIN_TEXT_FILE
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			l_analysis_order_count: INTEGER
			l_pre_state_bp, l_post_state_bp: INTEGER
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
				create l_parser.make_parser (l_file.last_string)
				if attached {JSON_OBJECT} l_parser.parse as l_json_object then
					if attached {JSON_ARRAY} l_json_object.item (analysis_order_pairs_json_string) as l_analysis_order then
						from
							j := 1
							l_analysis_order_count := l_analysis_order.count
						until
							j > l_analysis_order_count
						loop
							if attached {JSON_OBJECT} l_analysis_order.i_th (i) as l_json_analysis_order_pair then
								l_pre_state_bp := string_from_json (l_json_analysis_order_pair.item (pre_bp_json_string)).to_integer
								l_post_state_bp := string_from_json (l_json_analysis_order_pair.item (post_bp_json_string)).to_integer
								Result.extend ([l_pre_state_bp, l_post_state_bp])
							end
							j := j + 1
						end
					end
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
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			l_analysis_order_count: INTEGER
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
				create l_parser.make_parser (l_file.last_string)
				if attached {JSON_OBJECT} l_parser.parse as l_json_object then
					if attached {JSON_ARRAY} l_json_object.item (analysis_order_pairs_json_string) as l_analysis_order then
						from
							j := 1
							l_analysis_order_count := l_analysis_order.count
						until
							j > l_analysis_order_count
						loop
							if attached {JSON_OBJECT} l_analysis_order.i_th (i) as l_json_analysis_order_pair then
								Result := Result + 1
							end
							j := j + 1
						end
					end
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
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_analysis_order_count: INTEGER
			l_pre_state_bp, l_post_state_bp: INTEGER
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
				create l_parser.make_parser (l_file.last_string)
				if attached {JSON_OBJECT} l_parser.parse as l_json_object then
					if attached {JSON_ARRAY} l_json_object.item (analysis_order_pairs_json_string) as l_analysis_order then
						from
							j := 1
							l_analysis_order_count := l_analysis_order.count
						until
							j > l_analysis_order_count or Result.count = l_number_of_pairs
						loop
							if attached {JSON_OBJECT} l_analysis_order.i_th (i) as l_json_analysis_order_pair then
								l_pairs_count := l_pairs_count + 1
								if a_lower_bound <= l_pairs_count and l_pairs_count <= a_upper_bound then
									l_pre_state_bp := string_from_json (l_json_analysis_order_pair.item (pre_bp_json_string)).to_integer
									l_post_state_bp := string_from_json (l_json_analysis_order_pair.item (post_bp_json_string)).to_integer
									Result.extend ([l_pre_state_bp, l_post_state_bp])
								end
							end
							j := j + 1
						end
					end
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
			l_parser: JSON_PARSER
			l_expression: STRING
			l_location: INTEGER
			l_expression_location: LIST [STRING]
			l_keys_of_file: ARRAY [JSON_STRING]
			l_keys: DS_HASH_SET [STRING]
		do
			create l_keys.make_default
			l_keys.set_equality_tester (string_equality_tester)
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
				create l_parser.make_parser (l_file.last_string)
				check attached {JSON_OBJECT} l_parser.parse as l_json_object then
					check attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_transitions then
						l_keys_of_file := l_transitions.current_keys
						from
							j := 1
						until
							j > l_keys_of_file.count
						loop
							l_keys.force_last (string_from_json (l_keys_of_file.item (j)))
							j := j + 1
						end
					end
				end

				l_file.close

				i := i + 1
			end

			from
				l_keys.start
			until
				l_keys.after
			loop
				l_expression_location :=  l_keys.item_for_iteration.split (';')
				l_location := l_expression_location.i_th (1).to_integer
				l_expression := l_expression_location.i_th (2)
				Result.extend ([l_expression, l_location])

				l_keys.forth
			end
		end

	expression_value_transitions_count (a_expression: STRING; a_location: INTEGER): INTEGER
			-- Number of value transitions of `a_expression' evaluated at `a_location'.
		local
			i: INTEGER
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_parser: JSON_PARSER
			l_loc_expr: STRING
		do
			l_loc_expr := a_location.out + ";" + a_expression
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
				create l_parser.make_parser (l_file.last_string)
				check attached {JSON_OBJECT} l_parser.parse as l_json_object then
					check attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_transitions then
						if attached {JSON_ARRAY} l_transitions.item (json_string_from_string (l_loc_expr)) as l_expression_value_transitions then
							Result := Result + l_expression_value_transitions.count
						end
					end
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
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			l_value, l_type, l_class_id, l_address: STRING
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_value_transition: EPA_VALUE_TRANSITION
			l_loc_expr: STRING
			l_transitions_count: INTEGER
		do
			l_loc_expr := a_location.out + ";" + a_expression
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
				create l_parser.make_parser (l_file.last_string)
				check attached {JSON_OBJECT} l_parser.parse as l_json_object then
					check attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_transitions then
						if attached {JSON_ARRAY} l_transitions.item (json_string_from_string (l_loc_expr)) as l_expression_value_transitions then
							l_transitions_count := l_expression_value_transitions.count
							from
								j := 1
							until
								j > l_transitions_count
							loop
								check attached {JSON_OBJECT} l_expression_value_transitions.i_th (j) as l_transition then
									-- Extract pre-state and post-state values

									-- Extract pre-state value
									l_pre_state_bp := string_from_json (l_transition.item (pre_bp_json_string)).to_integer
									l_value := string_from_json (l_transition.item (pre_value_json_string))
									l_type := string_from_json (l_transition.item (pre_type_json_string))
									if l_type.is_equal (reference_value) then
										l_class_id := string_from_json (l_transition.item (pre_ref_class_id_json_string))
										l_pre_state_value := ref_value_from_data (l_value, l_class_id)
									elseif l_type.is_equal (string_value) then
										l_address := string_from_json (l_transition.item (pre_string_address_json_string))
										l_pre_state_value := string_value_from_data (l_value, l_address)
									else
										l_pre_state_value := value_from_data (l_value, l_type)
									end

									-- Extract post-state value
									l_post_state_bp := string_from_json (l_transition.item (post_bp_json_string)).to_integer
									l_value := string_from_json (l_transition.item (post_value_json_string))
									l_type := string_from_json (l_transition.item (post_type_json_string))
									if l_type.is_equal (reference_value) then
										l_class_id := string_from_json (l_transition.item (post_ref_class_id_json_string))
										l_post_state_value := ref_value_from_data (l_value, l_class_id)
									elseif l_type.is_equal (string_value) then
										l_address := string_from_json (l_transition.item (post_string_address_json_string))
										l_post_state_value := string_value_from_data (l_value, l_address)
									else
										l_post_state_value := value_from_data (l_value, l_type)
									end

									create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

									Result.extend (l_value_transition)
								end
								j := j + 1
							end
						end
					end
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
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
			l_value, l_type, l_class_id, l_address: STRING
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_value_transition: EPA_VALUE_TRANSITION
			l_loc_expr: STRING
			l_transitions_count: INTEGER
		do
			l_pairs_count := 0
			l_number_of_pairs := a_upper_bound - a_lower_bound + 1
			l_loc_expr := a_location.out + ";" + a_expression
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
				create l_parser.make_parser (l_file.last_string)
				check attached {JSON_OBJECT} l_parser.parse as l_json_object then
					check attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_transitions then
						if attached {JSON_ARRAY} l_transitions.item (json_string_from_string (l_loc_expr)) as l_expression_value_transitions then
							l_transitions_count := l_expression_value_transitions.count
							from
								j := 1
							until
								j > l_transitions_count or Result.count = l_number_of_pairs
							loop
								l_pairs_count := l_pairs_count + 1
								if a_lower_bound <= l_pairs_count and l_pairs_count <= a_upper_bound then
									check attached {JSON_OBJECT} l_expression_value_transitions.i_th (j) as l_transition then
										-- Extract pre-state and post-state values

										-- Extract pre-state value
										l_pre_state_bp := string_from_json (l_transition.item (pre_bp_json_string)).to_integer
										l_value := string_from_json (l_transition.item (pre_value_json_string))
										l_type := string_from_json (l_transition.item (pre_type_json_string))
										if l_type.is_equal (reference_value) then
											l_class_id := string_from_json (l_transition.item (pre_ref_class_id_json_string))
											l_pre_state_value := ref_value_from_data (l_value, l_class_id)
										elseif l_type.is_equal (string_value) then
											l_address := string_from_json (l_transition.item (pre_string_address_json_string))
											l_pre_state_value := string_value_from_data (l_value, l_address)
										else
											l_pre_state_value := value_from_data (l_value, l_type)
										end

										-- Extract post-state value
										l_post_state_bp := string_from_json (l_transition.item (post_bp_json_string)).to_integer
										l_value := string_from_json (l_transition.item (post_value_json_string))
										l_type := string_from_json (l_transition.item (post_type_json_string))
										if l_type.is_equal (reference_value) then
											l_class_id := string_from_json (l_transition.item (post_ref_class_id_json_string))
											l_post_state_value := ref_value_from_data (l_value, l_class_id)
										elseif l_type.is_equal (string_value) then
											l_address := string_from_json (l_transition.item (post_string_address_json_string))
											l_post_state_value := string_value_from_data (l_value, l_address)
										else
											l_post_state_value := value_from_data (l_value, l_type)
										end

										create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

										Result.extend (l_value_transition)
									end
								end
								j := j + 1
							end
						end
					end
				end

				l_file.close

				i := i + 1
			end
		end

feature {NONE} -- Implementation

	number_of_data_files: INTEGER
			-- Number of data files.

end
