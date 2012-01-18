note
	description: "Constants of XML namespaces, elements, attributes, etcetera."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_CONSTANTS

feature -- Constants (EAST namespaces)

	xml_ns_east_core: XML_NAMESPACE
		once
			create Result.make ("ast", "http://se.inf.ethz.ch/east/xsd/core")
		end

	xml_ns_east_hole: XML_NAMESPACE
		once
			create Result.make ("hole", "http://se.inf.ethz.ch/east/xsd/hole")
		end

	xml_ns_east_envelope: XML_NAMESPACE
		once
			create Result.make ("env", "http://se.inf.ethz.ch/east/xsd/envelope")
		end

	xml_ns_east_annotation: XML_NAMESPACE
		once
			create Result.make ("ann", "http://se.inf.ethz.ch/east/xsd/annotation")
		end

feature -- Constants (XSD namespaces)

	xml_ns_xsd: XML_NAMESPACE
		once
			create Result.make ("xs", "http://www.w3.org/2001/XMLSchema")
		end

feature -- Constants (xml_ns_east_core)

	east_root_element: STRING = "eiffel"

feature -- Constants (xml_ns_east_envelope)

	envelope_root_element: STRING = "envelope"

feature -- Constants (xml_ns_east_hole)

	expr_hole_element: STRING = "expr_hole"

	instruction_hole_element: STRING = "instruction_hole"

end
