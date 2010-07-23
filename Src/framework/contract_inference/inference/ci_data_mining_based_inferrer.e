note
	description: "Contract inferrer based on data mining techniques"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_DATA_MINING_BASED_INFERRER

inherit
	CI_INFERRER

feature{NONE} -- Implementation

	arff_relation: WEKA_ARFF_RELATION
			-- ARFF relation

	value_sets: DS_HASH_TABLE [DS_HASH_SET [STRING_8], WEKA_ARFF_ATTRIBUTE]
			-- Table from attribute to values of that attributes in all instances
			-- Key is an attribute, value is the set of values that attribute have across all instances.

end
