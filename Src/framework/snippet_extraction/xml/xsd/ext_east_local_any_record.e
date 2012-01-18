note
	description: "Configuaration record to synthesize a local element in the Eiffel AST XML Schema definition that supports arbitrary elements."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_LOCAL_ANY_RECORD

inherit
	EXT_XSD_LOCAL_RECORD

	EXT_XML_CONSTANTS

create
	make_from_argument_list

feature {NONE} -- Initialization

	make_from_argument_list (a_parent_node: STRING)
			-- Initialization arguments to fill record template.	
		do
			parent_node	:= a_parent_node
		end

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML element and add is content to `a_parent'.
		do
			if attached as_xsd_local_element as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end
		end

feature -- DEBUG OUTPUT

	debug_output: STRING
			-- String representation.
		do
			create Result.make_empty
			Result.append ("[ from ")
			Result.append (parent_node)
			Result.append ("]")
		end

feature {NONE} -- Implementation

	as_xsd_local_element: XML_ELEMENT
			-- Process `Current' as XML element.
		do
			create Result.make (Void, "any", xml_ns_xsd)

			Result.add_unqualified_attribute ("minOccurs", "0")
			Result.add_unqualified_attribute ("maxOccurs", "unbounded")
		end

end
