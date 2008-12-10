indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 74256 $"

class
	SAT_SHARED_NAMES

feature -- Section names in configure or log files

	fac_section_name: STRING is "FAC"
			-- Section name for feature access coverage

	dcs_section_name: STRING is "DCS"
			-- Section name for decision access coverage

	setting_section_name: STRING is "SET"
			-- Section name for setting

	dcs_branch_count_name: STRING is "dcs_branch_count"

	dcs_slot_count_name: STRING is "dcs_slot_count"

	dcs_branch_id_set: STRING is "branch_id_set"

	location_name: STRING is "location"

	slot_id_name: STRING is "slot_id"

	local_slot_id_name: STRING is "local_slot_id"

	is_feature_entry_name: STRING is "is_feature_entry"

	is_rescue_entry_name: STRING is "is_rescue_entry"

end
