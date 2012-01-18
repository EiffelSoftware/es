note
	description: "Configuaration record to synthesize element in a XML Schema definition."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_XSD_LOCAL_RECORD

inherit
	EXT_XSD_RECORD

	DEBUG_OUTPUT

feature -- Access

	parent_node: STRING
		-- Parent node of the `Current' local record.

end
