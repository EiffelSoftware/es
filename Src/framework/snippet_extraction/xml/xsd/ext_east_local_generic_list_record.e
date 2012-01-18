note
	description: "Configuaration record to synthesize local elements of generic type in the Eiffel AST XML Schema definition."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_LOCAL_GENERIC_LIST_RECORD

inherit
	EXT_XSD_LOCAL_RECORD

	EXT_XML_CONSTANTS

	EXT_AST_NODE_TO_XML_MAPPING

create
	make_from_argument_list

feature {NONE} -- Initialization

	make_from_argument_list (a_parent_node: STRING; a_generic_node: STRING)
			-- Initialization arguments to fill local record template.
		do
			parent_node		:= a_parent_node
			generic_node	:= a_generic_node
				-- Default.
			mixed			:= True
		end

feature -- Access

	generic_node: STRING
		-- Node indentifier of the generic node.			

	mixed: detachable BOOLEAN
		-- Does the local element support mixed content?

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML element and add is content to `a_parent'.
		do
			if attached as_xsd_element as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end
		end

feature -- DEBUG OUTPUT

	debug_output: STRING
			-- String representation.
		do
			create Result.make_empty
			Result.append (generic_node)
			Result.append (" [ from ")
			Result.append (parent_node)
			Result.append ("]")
		end

feature {NONE} -- Implementation

	xml_generic_group_name: like generic_node
			-- Generate reference to the XML Schema group definition corresponding to `Current'.
		do
			Result := ast_node_to_xml_tag_group (generic_node)
		end

	as_xsd_element: XML_ELEMENT
			-- Process `Current' as XML element.
		do
			create Result.make (Void, "group", xml_ns_xsd)
			Result.add_unqualified_attribute ("ref", xml_generic_group_name)
			Result.add_unqualified_attribute ("minOccurs", "0")
			Result.add_unqualified_attribute ("maxOccurs", "unbounded")
		end

end

