note
	description: "Summary description for {EXT_XML_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_CONSTANTS

feature -- Constants

	xml_ns_eimala_core: XML_NAMESPACE
		once
			create Result.make ("ast", "http://se.inf.ethz.ch/eimala/xsd/core")
		end

	xml_ns_eimala_hole: XML_NAMESPACE
		once
			create Result.make ("hole", "http://se.inf.ethz.ch/eimala/xsd/hole")
		end

	xml_ns_eimala_envelope: XML_NAMESPACE
		once
			create Result.make ("env", "http://se.inf.ethz.ch/eimala/xsd/env")
		end

	xml_ns_eimala_annotation: XML_NAMESPACE
		once
			create Result.make ("ann", "http://se.inf.ethz.ch/eimala/xsd/annotation")
		end

end
