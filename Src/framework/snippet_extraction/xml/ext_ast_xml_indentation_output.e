note
	description: "Summary description for {EXT_AST_XML_INDENTATION_OUTPUT}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_XML_INDENTATION_OUTPUT

inherit
	ETR_AST_STRUCTURE_OUTPUT_I
		redefine
			set_block_depth
		end

create
	make_with_xml_root

feature {NONE} -- Creation

	make_with_xml_root (a_xml_root_name: STRING; a_xml_ns: XML_NAMESPACE)
			-- Create with XML details.
		local
			l_xml_root_element: XML_ELEMENT
			l_xml_pi_version: XML_PROCESSING_INSTRUCTION
		do
			indentation_string := default_indentation_string
			create current_indentation.make_empty

			create xml_document.make

			create l_xml_pi_version.make (Void, "xml", "version=%"1.0%" encoding=%"UTF-8%"")
			xml_document.force_last (l_xml_pi_version)

			create l_xml_root_element.make (Void, a_xml_root_name, a_xml_ns)
			xml_document.set_root_element (l_xml_root_element)

			create {LINKED_STACK [XML_ELEMENT]} xml_node_stack.make
			xml_node_stack.put (xml_document.root_element)

			is_character_data_enabled := True

			last_xml_was_newline := True
		end

feature -- Access

	last_xml_document: XML_DOCUMENT
			-- A copy of the last created document.
		do
			Result := xml_document.twin
		end

	current_indentation: STRING
			-- Current level of indentation

	is_character_data_enabled: BOOLEAN
		assign set_character_data_enabled
			-- Are {XML_CHARACTER_DATA} written to the output?

	set_character_data_enabled (a_enabled: BOOLEAN)
			-- Sets `is_character_data_enabled'.
		require
			attached a_enabled
		do
			is_character_data_enabled := a_enabled
		end

feature -- Constants

	default_indentation_string: STRING
			-- The default indentation string
		once
			Result := "%T"
		end

feature -- Attributes

	indentation_string: STRING

feature -- Operations

	set_block_depth (a_block_depth: like block_depth)
			-- Set `block_depth' to `a_block_depth'.
		local
			l_index: INTEGER
		do
			from
				l_index := 1
				create current_indentation.make_empty
			until
				l_index > a_block_depth
			loop
				current_indentation.append (indentation_string)
				l_index := l_index + 1
			end

			block_depth := a_block_depth
		end

	set_indentation_string (an_indentation_string: like indentation_string)
			-- Set `indentation_string'
		require
			not_void: an_indentation_string /= void
		do
			indentation_string := an_indentation_string
		end

	reset
			-- Resets the internals state.
		do
			current_indentation := ""
			block_depth := 0
		end

	enter_block
			-- Enters a new indentation-block.
		do
			current_indentation := current_indentation + indentation_string
			block_depth := block_depth + 1
		end

	exit_block
			-- Exits an indentation-block.
		do
			if current_indentation.count >= indentation_string.count then
				current_indentation.remove_tail (indentation_string.count)
			end
			block_depth := block_depth - 1
		end

	enter_child (a_child: detachable ANY)
			-- Enters a new child.
		do
			-- unused
		end

	exit_child
			-- Exits a child.
		do
			-- unused
		end

feature {NONE} -- Implementation

	xml_document: XML_DOCUMENT
			-- XML document representing the traversed AST.

	xml_node_stack: STACK [XML_ELEMENT]
			-- Stack to keep track of current open element.

	last_xml_was_newline: BOOLEAN
			-- Was the last symbol a newline?

feature -- Basic Operations

	xml_element_open (a_name: STRING; a_xml_ns: XML_NAMESPACE)
		local
			l_element: XML_ELEMENT
			l_xml_node: XML_CHARACTER_DATA
		do
			if last_xml_was_newline then
				create l_xml_node.make_last (xml_node_stack.item, current_indentation.twin)
				last_xml_was_newline := False
			end

			create l_element.make_last (xml_node_stack.item, a_name, a_xml_ns)
			xml_node_stack.put (l_element)
		end

	xml_element_close (a_name: STRING; a_xml_ns: XML_NAMESPACE)
		require
			attached a_name
			attached a_xml_ns
		do
			check
				not xml_node_stack.is_empty
				xml_node_stack.item.name ~ a_name
				xml_node_stack.item.namespace ~ a_xml_ns
			end

			xml_node_stack.remove
		end

	xml_add_attribute (a_name: STRING; a_xml_ns: XML_NAMESPACE; a_value: STRING)
		require
			attached a_name
			attached a_xml_ns
			attached a_value
		do
			check
				not xml_node_stack.is_empty
			end

			xml_node_stack.item.add_attribute (a_name, a_xml_ns, a_value)
		end

	xml_add_unqualified_attribute (a_name: STRING; a_value: STRING)
		require
			attached a_name
			attached a_value
		do
			check
				not xml_node_stack.is_empty
			end

			xml_node_stack.item.add_unqualified_attribute (a_name, a_value)
		end

	xml_string_append, append_string (a_string: STRING)
		local
			l_xml_node: XML_CHARACTER_DATA
		do
			if is_character_data_enabled then
				if last_xml_was_newline then
					create l_xml_node.make_last (xml_node_stack.item, current_indentation.twin)
					last_xml_was_newline := False
				end

				create l_xml_node.make_last (xml_node_stack.item, a_string)

				if a_string.ends_with ("%N") then
					last_xml_was_newline := True
				else
					last_xml_was_newline := False
				end
			end
		end

end
