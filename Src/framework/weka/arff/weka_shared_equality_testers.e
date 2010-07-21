note
	description: "Shared equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_SHARED_EQUALITY_TESTERS

feature -- Access

	weka_arff_attribute_equality_tester: WEKA_ARFF_ATTRIBUTE_EQUALITY_TESTER
			-- Equality tester for {WEKA_ARFF_ATTRIBUTE}
		once
			create Result
		end

end
