class
	METRIC_MI

inherit
	METRIC
	redefine
		make,
		evaluate,
		last_result,
		debug_output,
		process_real_feature,
		process_class,
		process_group
	end

	QL_UTILITY

	METRIC_UTILITY

	QL_SHARED

	SHARED_SERVER

create
	make

feature -- Creation

	make (an_item : QL_ITEM) is
		do
			ql_item := an_item
		end

feature -- Evaluation

	evaluate is
		do
			-- reset
			count_features := 0
			count_cc := 0
			count_volume := 0
			count_loc := 0

			-- process the item
			ql_item.process (Current)
		end

feature -- Result

	last_result : QL_QUANTITY is
		local
			math : DOUBLE_MATH
			value : DOUBLE
		do
			create math

			value := mi_start
			value := value - mi_volume_weight*math.log (count_volume/count_features)
			value := value - mi_cc_weight*(count_cc/count_features)
			value := value - mi_loc_weight*(count_loc/count_features)

			create Result.make_with_value (value)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "MI METRIC%N"
			Result := Result + "total CC:%T"+count_cc.out+"%N"
			Result := Result + "total V:%T"+count_volume.out+"%N"
			Result := Result + "total LOC:%T"+count_loc.out+"%N%N"
			Result := Result + "avg(g'):%T"+(count_cc/count_features).out+"%N"
			Result := Result + "avg(V):%T%T"+(count_volume/count_features).out+"%N"
			Result := Result + "avg(LOC):%T"+(count_loc/count_features).out+"%N"
			Result := Result + "%NMI:%T%T"+last_result.value.out+"%N"
		end

feature {NONE} -- Implementation (QL Visitor)

	process_real_feature (l_as : QL_REAL_FEATURE) is
		local
			metric_cc : METRIC_CC
			metric_halstaed : METRIC_HALSTAED
			list : LIST[DOUBLE]
		do
			create metric_cc.make (l_as)
			create metric_halstaed.make (l_as)

			metric_cc.evaluate
			metric_halstaed.evaluate

			count_cc := count_cc + metric_cc.last_result.value

			list ?= metric_halstaed.last_result.data
			if list /= Void then
				count_volume := count_volume + list.i_th (metric_halstaed.r_volume_index)
			end

			count_loc := count_loc + lines_of_code_of_item (l_as)

			count_features := count_features + 1
		end

	process_class (l_as: QL_CLASS) is
		do
			process_real_features_in_class (l_as)
		end

	process_group (l_as: QL_GROUP) is
		do
			process_classes_in_group (l_as)
		end

feature {NONE} -- Properties

	ql_item : QL_ITEM

	count_features : INTEGER
		-- counts the number of features that have been
		-- processed

	count_cc : DOUBLE
		-- the total cyclomatic complexity of all processed
		-- features

	count_volume : DOUBLE
		-- the total haelstaed volume size of all processed
		-- features

	count_loc : DOUBLE
		-- the total number of lines of all processed
		-- features

feature {NONE} -- Configuration

	mi_start : DOUBLE is 171.0
	mi_volume_weight : DOUBLE is 5.2
	mi_cc_weight : DOUBLE is 0.23
	mi_loc_weight : DOUBLE is 16.2
		-- configuration parameters for calculating MI

invariant
	ql_item_set: ql_item /= Void

end
