note
	description: "Container to store the parent class along a XML Schema attribute."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_LOCAL_ATTRIBUTE

create
	make_from_argument_list

feature {NONE} -- Initialization

	make_from_argument_list (a_parent_node: STRING; a_xsd_attribute: like xsd_attribute)
			-- Initialization arguments to fill local record template.		
		do
			parent_node	:= a_parent_node
			xsd_attribute := a_xsd_attribute
		end

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML element and add is content to `a_parent'.
		do
			if attached xsd_attribute.as_xml as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end
		end

feature -- Access

	parent_node: STRING_8
		-- The parent node where `xsd_attribute' belongs to.			

	xsd_attribute: EXT_XSD_ATTRIBUTE
		-- An XML Schema attribute belonging to `parent_node'.

end
