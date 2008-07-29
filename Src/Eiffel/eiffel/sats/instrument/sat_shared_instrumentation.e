indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_SHARED_INSTRUMENTATION

inherit
	SHARED_WORKBENCH

feature -- Access


feature -- Status report

	is_decision_coverage_enabled: BOOLEAN is
			-- Is decision coverage recording enabled?
		do
			Result := decision_coverage_enabled.item
		ensure
			good_result:  Result = decision_coverage_enabled.item
		end

	is_feature_coverage_enabled: BOOLEAN is
			-- Is feature coverage recording enabled?
		do
			Result := feature_coverage_enabled.item
		ensure
			good_result:  Result = feature_coverage_enabled.item
		end

	instrument_config_file_name: STRING is
			-- File containing config information for decision coverage
		once
			create Result.make (256)
		end

feature -- Setting

	set_is_decision_coverage_enabled (b: BOOLEAN) is
			-- Set `is_decision_coverage_enabled' with `b'.
		do
			decision_coverage_enabled.put (b)
		ensure
			is_decision_coverage_enabled_set: is_decision_coverage_enabled = b
		end

	set_is_feature_coverage_enabled (b: BOOLEAN) is
			-- Set `is_feature_coverage_enabled' with `b'.
		do
			feature_coverage_enabled.put (b)
		ensure
			is_feature_coverage_enabled_set: is_feature_coverage_enabled = b
		end

	set_instrument_config_file_name (a_name: like instrument_config_file_name) is
			-- Set `instrument_config_file_name' with `a_name'.
		require
			a_name_attached: a_name /= Void
		do
			instrument_config_file_name.wipe_out
			instrument_config_file_name.append (a_name)
		ensure
			instrument_config_file_name_set: instrument_config_file_name.is_equal (a_name)
		end

feature{NONE} -- Implementation

	decision_coverage_enabled: CELL [BOOLEAN] is
			--
		once
			create Result.put (False)
		end

	feature_coverage_enabled: CELL [BOOLEAN] is
			--
		once
			create Result.put (False)
		end

end
