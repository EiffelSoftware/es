note
	description: "Configuaration record to synthesize global elements in a XML Schema definition."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_XSD_RECORD

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML and add it to `a_parent'.
		deferred
		end

end
