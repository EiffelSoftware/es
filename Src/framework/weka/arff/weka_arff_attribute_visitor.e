note
	description: "Process {WEKA_ARFF_ATTRIBUTE} objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEKA_ARFF_ATTRIBUTE_VISITOR

feature -- Process

	process_boolean_attribute (a_attribute: WEKA_ARFF_BOOLEAN_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_numeric_attribute (a_attribute: WEKA_ARFF_NUMERIC_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_nominal_attribute (a_attribute: WEKA_ARFF_NOMINAL_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_string_attribute (a_attribute: WEKA_ARFF_STRING_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

end
