note
	description: "Configuaration record to synthesize global elements in the Eiffel AST XML Schema definition."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_RECORD

inherit
	COMPARABLE
		redefine
			is_less
		select
			is_equal
		end

	EXT_XSD_RECORD
		rename
			is_equal as is_equal_record
		end

	EXT_XML_CONSTANTS
		rename
			is_equal as is_equal_constants
		end

	EXT_AST_NODE_TO_XML_MAPPING
		rename
			is_equal as is_equal_ast_node_to_xml_mapping
		end

create
	make_from_argument_list

feature {NONE} -- Initialization

	make_from_argument_list (a_parent_node, a_element_node: STRING; a_abstract: BOOLEAN)
			-- Initialization arguments to fill record template.
		do
			element_name		:= a_element_node
			substitution_group 	:= a_parent_node
			abstract 			:= a_abstract
			mixed 				:= True

			create {LINKED_LIST [EXT_XSD_LOCAL_RECORD]} extension_list.make
			create {LINKED_LIST [EXT_EAST_LOCAL_ATTRIBUTE]} attribute_list.make
		end

feature -- Access

	element_name: STRING
		-- Value for XML Schema attribute "name".	

	substitution_group: detachable STRING
		-- Value for XML Schema attribute "substitutionGroup".		

	abstract: detachable BOOLEAN
		-- Value for XML Schema attribute "abstract".

	mixed: detachable BOOLEAN
		-- Value for XML Schema attribute "mixed".

	extension_list: detachable LIST [EXT_XSD_LOCAL_RECORD]
		-- List of local records used to generate the XML Schema type definition.

	attribute_list: detachable LIST [EXT_EAST_LOCAL_ATTRIBUTE]
		-- List of local attributes to be synthesized for the XML Schema type definition.

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
			-- Used to sort XML elements in the XML Schema document.
		local
			l_agent: FUNCTION [ANY, TUPLE [a_argument: like Current], STRING]

			l_one, l_two: STRING
		do
			l_agent := agent (a_argument: like Current): STRING
				do
					create Result.make_empty
					if attached a_argument.substitution_group as l_group then
						Result.append (l_group)
						Result.append (":")
					end
					Result.append (element_name)
				end

			l_agent.call([Current])
			l_one := l_agent.last_result

			l_agent.call([other])
			l_two := l_agent.last_result

			Result := l_one < l_two
		end

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML element and add is content to `a_parent'.
		local
			l_xml_comment: XML_COMMENT
		do
				-- Add a header comment for this record.
			create l_xml_comment.make_last (a_parent, " " + element_name + " ")

				-- Synthesize XML Schema element.
			if attached as_xsd_element as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end

				-- Synthesize XML Schema type.
			if attached as_xsd_type as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end

				-- Synthesize XML Schema group.
			if attached as_xsd_group as l_item then
				l_item.set_parent (a_parent)
				a_parent.put_last (l_item)
			end
		end

feature {NONE} -- Implementation

	xml_element_id: like element_name
			-- Generate "id" attriute.
		do
			Result := ast_node_to_xml_tag (element_name)
			Result.to_upper
		end

	xml_element_name: like element_name
			-- Generate "name" attribute for element defintion.
			-- `ast_node_to_xml_tag' to rename `element_name'.
		do
			Result := ast_node_to_xml_tag (element_name)
		end

	xml_element_type_name: like element_name
			-- Generate "name" attribute for type definition.
			-- `ast_node_to_xml_tag_type' to rename `element_name'.	
		do
			Result := ast_node_to_xml_tag_type (element_name)
		end

	xml_element_group_name: like element_name
			-- Generate "name" attribute for type definition.
			-- `ast_node_to_xml_group_type' to rename `element_name'.	
		do
			Result := ast_node_to_xml_tag_group (element_name)
		end

	xml_parent_name: like substitution_group
			-- Generate "substitutionGroup" attribute for element definition.
			-- `ast_node_to_xml_tag' to rename `substitution_group'.		
		do
			if attached substitution_group as l_parent_name then
				Result := ast_node_to_xml_tag (l_parent_name)
			end
		end

	xml_parent_type_name: like substitution_group
			-- Generate "base" attribute for type definition.
			-- `ast_node_to_xml_tag_type' to rename `substitution_group'.	
		do
			if attached substitution_group as l_parent_name then
				Result := ast_node_to_xml_tag_type (l_parent_name)
			end
		end

	as_xsd_element: XML_ELEMENT
			-- Synthesize XML Schema element definition.
		do
			create Result.make (Void, "element", xml_ns_xsd)
			Result.add_unqualified_attribute ("id", xml_element_id)
			Result.add_unqualified_attribute ("name", xml_element_name)
			Result.add_unqualified_attribute ("type", xml_element_type_name)

				-- Add parent for actual record only if it does not directly inherit from `{AST_EIFFEL}'.
			if attached substitution_group as l_substitution_group then
				if not (l_substitution_group ~ "AST_EIFFEL") then
					Result.add_unqualified_attribute ("substitutionGroup", xml_parent_name)
				end
			end

			if attached abstract as l_abstract and then l_abstract then
				Result.add_unqualified_attribute ("abstract", "true")
			end
		end

	as_xsd_type: XML_ELEMENT
			-- Synthesize XML Schema type definition.	
		local
			l_xml_complex_content, l_xml_extension, l_xml_sequence, l_xml_extension_container: XML_ELEMENT
		do
			create Result.make (Void, "complexType", xml_ns_xsd)
			Result.add_unqualified_attribute ("name", xml_element_type_name)

			if attached abstract as l_abstract and then l_abstract then
				Result.add_unqualified_attribute ("abstract", "true")
			end

			if attached mixed as l_mixed and then l_mixed then
				Result.add_unqualified_attribute ("mixed", "true")
			end

				-- Add parent for actual record only if it does not directly inherit from `{AST_EIFFEL}'.
			if substitution_group ~ "AST_EIFFEL" then
				l_xml_extension_container := Result
			else
				create l_xml_complex_content.make_last (Result, "complexContent", xml_ns_xsd)

				create l_xml_extension.make_last (l_xml_complex_content, "extension", xml_ns_xsd)
				l_xml_extension.add_unqualified_attribute ("base", xml_parent_type_name)

				l_xml_extension_container := l_xml_extension
			end

				-- Process local records.
			if attached extension_list as l_extension_list then
				if not l_extension_list.is_empty then
						-- More than elements encapsulated by a XML Schema `xs:sequence'.
					create l_xml_sequence.make_last (l_xml_extension_container, "sequence", xml_ns_xsd)
					across l_extension_list as l_cursor loop l_cursor.item.process_with_parent (l_xml_sequence) end
				end
			end

				-- Process attributes.
			if attached attribute_list as l_attribute_list then
				across l_attribute_list as l_cursor loop l_cursor.item.process_with_parent (l_xml_extension_container) end
			end

		end

	as_xsd_group: XML_ELEMENT
			-- Synthesize XML Schema group definition.	
		local
			l_xml_ref, l_xml_choice: XML_ELEMENT
		do
			create Result.make (Void, "group", xml_ns_xsd)
			Result.add_unqualified_attribute ("name", xml_element_group_name)

			create l_xml_choice.make_last (Result, "choice", xml_ns_xsd)

			create l_xml_ref.make_last (l_xml_choice, "element", xml_ns_xsd)
			l_xml_ref.add_unqualified_attribute ("ref", xml_element_name)
		end

end
