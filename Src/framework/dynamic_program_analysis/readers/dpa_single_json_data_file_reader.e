note
	description: "A reader that reads the data from a dynamic program analysis from disk using one JSON data file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_SINGLE_JSON_DATA_FILE_READER

inherit
	DPA_JSON_DATA_FILE_READER

create
	make

feature {NONE} -- Initialization

	make (a_path: like path; a_file_name: like file_name)
			--
		require
			a_path_not_void: a_path /= Void
			a_file_name_not_void: a_file_name /= Void
		local
			l_reader: JSON_FILE_READER
			l_parser: JSON_PARSER
			l_file_name: FILE_NAME
		do
			path := a_path
			file_name := a_file_name

			create l_file_name.make_from_string (path + file_name + ".txt")
			check valid_file_name: l_file_name.is_valid end
			create l_reader
			create l_parser.make_parser (l_reader.read_json_from (l_file_name.string))
			check attached {JSON_OBJECT} l_parser.parse as l_json_object then
				-- Extract class
				class_ := string_from_json (l_json_object.item (class_json_string))

				-- Extract feature
				feature_ := string_from_json (l_json_object.item (feature_json_string))

				-- Extract analysis order
				internal_analysis_order_pairs := analysis_order_pairs_from_json_value (l_json_object.item (analysis_order_pairs_json_string))

				-- Extract collected data
				internal_expression_value_transitions := expression_value_transitions_from_json_value (l_json_object.item (expression_value_transitions_json_string))
			end
		ensure
			path_set: path.is_equal (a_path)
			file_name_set: file_name.is_equal (a_file_name)
		end

feature -- Access

	path: STRING
			-- Path where the JSON data file is stored.

	file_name: STRING
			-- File name of the JSON data file.

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature that was analyzed.

	analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		do
			create Result.make
			internal_analysis_order_pairs.do_all (agent Result.extend)
		end

	analysis_order_pairs_count: INTEGER
			-- Number of pre-state / post-state breakpoint pairs.
		do
			Result := internal_analysis_order_pairs.count
		end

	limited_analysis_order_pairs (a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- Limited list of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `analysis_order_pairs_count'
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		local
			i: INTEGER
		do
			create Result.make
			from
				i := a_lower_bound
			until
				i > a_upper_bound
			loop
				Result.extend (internal_analysis_order_pairs.i_th (i))
				i := i + 1
			end
		end

	expressions_and_locations: LINKED_LIST [TUPLE [expression: STRING; location: INTEGER]]
			-- Expressions and locations at which they were evaluted during the analysis.
		local
			l_key: LIST [STRING]
			l_loc, l_expr: STRING
		do
			create Result.make
			from
				internal_expression_value_transitions.start
			until
				internal_expression_value_transitions.after
			loop
				l_key := internal_expression_value_transitions.key_for_iteration.split (';')
				l_loc := l_key.i_th (1)
				l_loc.right_adjust
				l_loc.left_adjust
				l_expr := l_key.i_th (2)
				l_expr.right_adjust
				l_expr.left_adjust
				Result.extend ([l_expr, l_loc.to_integer])
				internal_expression_value_transitions.forth
			end
		end

	expression_value_transitions_count (a_expression: STRING; a_location: INTEGER): INTEGER
			-- Number of value transitions of `a_expression' evaluated at `a_location'.
		do
			Result := internal_expression_value_transitions.item (a_location.out + ";" + a_expression).count
		end

	expression_value_transitions (a_expression: STRING; a_location: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Value transitions of `a_expression' evaluated at `a_location'.
		do
			create Result.make
			internal_expression_value_transitions.item (a_location.out + ";" + a_expression).do_all (agent Result.extend)
		end

	limited_expression_value_transitions (a_expression: STRING; a_location: INTEGER; a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Limited value transitions of `a_expression' evaluated at `a_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `expression_value_transitions_count'
		local
			l_values: ARRAYED_LIST [EPA_VALUE_TRANSITION]
			i: INTEGER
		do
			create Result.make
			l_values := internal_expression_value_transitions.item (a_location.out + ";" + a_expression)
			from
				i := a_lower_bound
			until
				i > a_upper_bound
			loop
				Result.extend (l_values.i_th (i))
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	internal_analysis_order_pairs: ARRAYED_LIST [TUPLE [INTEGER, INTEGER]]
			--

	internal_expression_value_transitions: DS_HASH_TABLE [ARRAYED_LIST [EPA_VALUE_TRANSITION], STRING]
			--

feature {NONE} -- Implementation

	analysis_order_pairs_from_json_value (a_json_value: JSON_VALUE): ARRAYED_LIST [TUPLE [INTEGER, INTEGER]]
			-- List of pre-state / post-state pairs in the order they were analyzed
			-- if `a_json_value' is a JSON_ARRAY.
		require
			a_json_value_not_void: a_json_value /= Void
		local
			l_pre_state_bp, l_post_state_bp: INTEGER
			i: INTEGER
			l_json_array_count: INTEGER
		do
			if attached {JSON_ARRAY} a_json_value as l_json_array then
				l_json_array_count := l_json_array.count
				create Result.make (l_json_array_count)
				from
					i := 1
				until
					i > l_json_array_count
				loop
					if attached {JSON_OBJECT} l_json_array.i_th (i) as l_json_object then
						l_pre_state_bp := string_from_json (l_json_object.item (pre_bp_json_string)).to_integer
						l_post_state_bp := string_from_json (l_json_object.item (post_bp_json_string)).to_integer
						Result.extend ([l_pre_state_bp, l_post_state_bp])
					end
					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	expression_value_transitions_from_json_value (a_json_value: JSON_VALUE): DS_HASH_TABLE [ARRAYED_LIST [EPA_VALUE_TRANSITION], STRING]
			-- Runtime data collected through dynamic means if `a_json_value' is a JSON_OBJECT.
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.
		require
			a_json_value_not_void: a_json_value /= Void
		local
			i, j: INTEGER
			l_keys: ARRAY [JSON_STRING]
			l_values: ARRAYED_LIST [EPA_VALUE_TRANSITION]
			l_value, l_type, l_class_id, l_address: STRING
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_value_transition: EPA_VALUE_TRANSITION
			l_json_array_count: INTEGER
		do
			if attached {JSON_OBJECT} a_json_value as l_json_map then
				-- Iterate over keys of the JSON object.
				l_keys := l_json_map.current_keys
				create Result.make (l_keys.count)
				from
					i := 1
				until
					i > l_keys.count
				loop
					if attached {JSON_ARRAY} l_json_map.item (l_keys.item (i)) as l_json_array then
						-- Iterate over the JSON array containing pre-state and post-state values.
						l_json_array_count := l_json_array.count
						create l_values.make (l_json_array_count)
						from
							j := 1
						until
							j > l_json_array_count
						loop
							if attached {JSON_OBJECT} l_json_array.i_th (j) as l_json_data then
								-- Extract pre-state and post-state values

								-- Extract pre-state value
								l_pre_state_bp := string_from_json (l_json_data.item (pre_bp_json_string)).to_integer
								l_value := string_from_json (l_json_data.item (pre_value_json_string))
								l_type := string_from_json (l_json_data.item (pre_type_json_string))
								if l_type.is_equal (reference_value) then
									l_class_id := string_from_json (l_json_data.item (pre_ref_class_id_json_string))
									l_pre_state_value := ref_value_from_data (l_value, l_class_id)
								elseif l_type.is_equal (string_value) then
									l_address := string_from_json (l_json_data.item (pre_string_address_json_string))
									l_pre_state_value := string_value_from_data (l_value, l_address)
								else
									l_pre_state_value := value_from_data (l_value, l_type)
								end

								-- Extract post-state value
								l_post_state_bp := string_from_json (l_json_data.item (post_bp_json_string)).to_integer
								l_value := string_from_json (l_json_data.item (post_value_json_string))
								l_type := string_from_json (l_json_data.item (post_type_json_string))
								if l_type.is_equal (reference_value) then
									l_class_id := string_from_json (l_json_data.item (post_ref_class_id_json_string))
									l_post_state_value := ref_value_from_data (l_value, l_class_id)
								elseif l_type.is_equal (string_value) then
									l_address := string_from_json (l_json_data.item (post_string_address_json_string))
									l_post_state_value := string_value_from_data (l_value, l_address)
								else
									l_post_state_value := value_from_data (l_value, l_type)
								end

								create l_value_transition.make (l_pre_state_bp, l_pre_state_value, l_post_state_bp, l_post_state_value)

								l_values.extend (l_value_transition)
							end
							j := j + 1
						end
					end
					Result.force_last (l_values, string_from_json (l_keys.item (i)))
					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

end
