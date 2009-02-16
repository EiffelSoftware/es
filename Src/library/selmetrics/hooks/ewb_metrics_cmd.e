class
	EWB_METRICS_CMD

inherit
	QL_UTILITY

	QL_SHARED

	SHARED_WORKBENCH

create
	make

feature -- Properties

	arg_name : STRING

	type_name : STRING

feature -- Creation

	make (a_arg_name: STRING; a_metric_type : STRING) is
			-- hook into eiffel workbench
		do
			arg_name := a_arg_name
			type_name := a_metric_type
		end

feature -- Computation

	execute is
		local
			metric : METRIC
		do
			-- signalize that we are in our hook
			io.put_string ("%N%N%N")
			io.put_string ("*** WORKBENCH HOOK ***%N")
			io.put_string ("argument: "+arg_name+"%N")
			io.put_string ("type: "+type_name+"%N")
			io.put_new_line

			-- decide which metric to use
			if type_name.is_equal ("halstaed_class") then
				create {METRIC_HALSTAED}metric.make (get_class_from_argument)
			elseif type_name.is_equal ("halstaed_group") then
				create {METRIC_HALSTAED}metric.make (get_library_from_argument)
			elseif type_name.is_equal ("halstaed_feature") then
				create {METRIC_HALSTAED}metric.make (get_feature_from_argument)
			elseif type_name.is_equal ("cc_feature") then
				create {METRIC_CC}metric.make (get_feature_from_argument)
			elseif type_name.is_equal ("cc_class") then
				create {METRIC_CC}metric.make (get_class_from_argument)
			elseif type_name.is_equal ("cc_group") then
				create {METRIC_CC}metric.make (get_library_from_argument)
			elseif type_name.is_equal ("inst") then
				create {METRIC_INSTABILITY}metric.make (get_library_from_argument)
			elseif type_name.is_equal ("mi") then
				create {METRIC_MI}metric.make (get_library_from_argument)
			elseif type_name.is_equal ("abst") then
				create {METRIC_ABSTRACTION}metric.make (get_library_from_argument)
			elseif type_name.is_equal ("adp") then
				create {METRIC_ADP}metric.make (get_library_from_argument)
			end

			-- evaluate the metric
			metric.evaluate

			-- do some debug output
			io.put_string (metric.debug_output)
		end

feature {NONE} -- Implementation

	get_class_from_argument : QL_CLASS is
		do
			Result := query_class_item_from_class_i (universe.classes_with_name (arg_name).first)
		end

	get_library_from_argument : QL_GROUP is
		do
			Result := query_group_item_from_conf_group (universe.group_of_name (arg_name))
		end

	get_feature_from_argument : QL_FEATURE is
		local
			wheres_dot : INTEGER
			class_name : STRING
			feature_name : STRING
		do
			wheres_dot := arg_name.index_of ('.', 1)
			class_name := arg_name.substring (1, wheres_dot-1)
			feature_name := arg_name.substring (wheres_dot+1, arg_name.count)

			Result := query_feature_item_from_e_feature (universe.classes_with_name (class_name).first.compiled_class.feature_named (feature_name).e_feature)
		end

end
