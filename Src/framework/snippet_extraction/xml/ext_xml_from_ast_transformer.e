note
	description: "Injects XML elements by using processing hooks based upon a configuration."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_FROM_AST_TRANSFORMER

inherit
	ETR_AST_STRUCTURE_PRINTER_WITH_HOOKS
		export
			{NONE} all
			{ANY} is_valid
		redefine
				-- AST Structure Printer
			output,
			output_as_string,
			print_ast_to_output,
				-- AST Iteration
			process_variant_as,
			process_external_as,
			process_external_lang_as,
			process_feature_list_as,
			process_guard_as,
				-- AST Iteration (Attributes)
			process_bool_as,
			process_id_as,
			process_precursor_as,
			process_result_as,
			process_current_as,
			process_access_inv_as,
			process_access_feat_as,
			process_access_id_as
		end

	EXT_AST_NODE_CONSTANTS

	EXT_AST_NODE_CONFIGURATOR

	EXT_AST_NODE_TO_XML_MAPPING

	EXT_HOLE_UTILITY
		export
			{NONE} all
		end

	EXT_XML_CONSTANTS

	EXT_EAST_CONFIG

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
				-- Initialize configurator.
			initialize_ast_node_configurator
				-- Apply default setup to configurator.
--			Current.allow_all
			Current.deny_all
--			Current.allow_node (node_instr_call_as)
--			Current.allow_node (node_nested_as)

			process_hook := agent xml_injection_hook
			process_list_with_separator_hook := agent xml_injection_hook_list

			reset
		end

feature -- Configuration

	reset
			-- Resets the XML file to start a new transformation.
		do
			create output.make_with_xml_root (xml_root_name, xml_ns_east_core)
			output.set_character_data_enabled (xml_character_data_enabled)
		end

feature -- Access

	transform (a_as: AST_EIFFEL)
			-- Transform `a_as' into an XML format and make it available
			-- as `xml_document'.
		do
			process (a_as, Void, 1)
		end

	xml_root_name: STRING
			-- Document root XML element name.
		once
			Result := east_root_element
		end

	xml_document: XML_DOCUMENT
			-- XML document representing the traversed AST.
		do
			Result := output.last_xml_document
		end

	xml_character_data_enabled: BOOLEAN
		once
			Result := True
		end

feature -- Output

	output: EXT_AST_XML_INDENTATION_OUTPUT
			-- Keeping track of XML nodes.

	output_as_string: STRING
			-- unused
		do
		end

	print_ast_to_output (a_ast: detachable AST_EIFFEL)
			-- unused
		do
		end

feature {NONE} -- Implementation (Processing - Add-On)

	branch_to_xml_mapping: HASH_TABLE [STRING, STRING]
		local
			l_local_record_map: LIST [EXT_XSD_LOCAL_RECORD]
			l_tmp_debug_list: SORTED_TWO_WAY_LIST [STRING]
			l_tmp_debug_string: STRING
		once
			create Result.make (127)
			Result.compare_objects

			across record_map.current_keys as l_key_cursor loop
					-- Collect local record items and inhereted elements from type hierarchy.

				create {LINKED_LIST [EXT_XSD_LOCAL_RECORD]} l_local_record_map.make

				if attached local_record_map.at (l_key_cursor.item) as l_tmp_list then
					l_local_record_map.append (l_tmp_list)
				end

					-- Process ancestor hierarchy and collect inherited records.
				across record_ancestor_map.at (l_key_cursor.item) as l_ancestor_cursor loop
					if attached local_record_map.at (l_ancestor_cursor.item) as l_tmp_list then
						l_local_record_map.append (l_tmp_list)
					end
				end

					-- Process collected local record items and create `Result.
					-- Key entries (`to_key') have to be unique.

				across l_local_record_map as l_local_record_cursor loop
					if attached {EXT_EAST_LOCAL_RECORD} l_local_record_cursor.item as l_local_element_record then
						Result.put (l_local_element_record.element_name, to_key ([l_key_cursor.item, l_local_element_record.processing_id]))

						check
							no_conflict: Result.inserted
						end
					end
				end

			end
		end

	to_key (a_tuple: TUPLE [node_name: READABLE_STRING_8; branch_id: INTEGER]): STRING
			-- Utiltiy function to compose index used by `branch_to_xml_mapping'.
			-- Composes elements name and branch id.
			-- Example: feature `{CLASS_AS}.top_indexes' results to "top_indexes:1"
		do
			create Result.make_empty
			Result.append (a_tuple.node_name)
			Result.append (":")
			Result.append_integer (a_tuple.branch_id)
		end

feature {NONE} -- Hooks

	output_local_elements: BOOLEAN = True
			-- Flag indicating if addtional named local elements should be inserted in the XML document.


	xml_injection_hook_list (a_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: detachable AST_EIFFEL; a_branch: INTEGER; a_open: BOOLEAN)
			-- Add surrounding XML element(s) to `output'.
		do
			xml_injection_hook (a_as, a_parent, a_branch, a_open)
		end


	xml_injection_hook (a_as: detachable AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER; a_open: BOOLEAN)
			-- Add surrounding XML element(s) to `output'.
			-- If contained in local configuration, optionally output named local element.
			-- Additionally output typed element.
		local
			l_local_allowed, l_current_allowed: BOOLEAN
			l_local_tag, l_current_tag: STRING

			l_add_xml_element: ROUTINE[ANY, TUPLE [BOOLEAN, BOOLEAN, STRING]]
		do
			l_add_xml_element := agent (allowed, open: BOOLEAN; tag: STRING)
			     require
			         allowed_not_void: attached allowed
			         open_not_void: attached open
			         tag_not_void: allowed implies attached tag
			     do
			         if allowed then
			         	if open then
				         	output.xml_element_open  (tag, xml_ns_east_core)
			         	else
				         	output.xml_element_close (tag, xml_ns_east_core)
			         	end
			         end
			     end


			if attached a_as as l_as then

				l_local_allowed :=
							(output_local_elements and has_local_tag_name (l_as, a_parent, a_branch) and
							attached a_parent as l_parent) and then allow_set.has (l_parent.generator)

				if l_local_allowed then
					l_local_tag := resolve_local_tag_name (l_as, a_parent, a_branch)
				end

				l_current_allowed := allow_set.has (l_as.generator) and not is_hole (l_as)

				if l_current_allowed then
					l_current_tag := resolve_current_tag_name (l_as, a_parent, a_branch)
				end

				if a_open then
						-- Add opening tags.
					l_add_xml_element.call ([l_local_allowed, True, l_local_tag])
					l_add_xml_element.call ([l_current_allowed, True, l_current_tag])
				else
						-- Add opening tags in reverse order.
					l_add_xml_element.call ([l_current_allowed, False, l_current_tag])
					l_add_xml_element.call ([l_local_allowed, False, l_local_tag])
				end
			end
		end


	resolve_current_tag_name (a_as: AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER): STRING
			-- Resolves the XML elment name to hightlight output.
		require
			a_as_not_void: attached a_as
		local
			l_as_generating_type: STRING
		do
				-- rename `node_static_access_as' in context of `node_interval_as'.
			if attached a_parent as l_parent and then
				(a_as.generator ~ node_static_access_as and (l_parent.generator ~ node_interval_as))
			then
				l_as_generating_type := node_static_access_expr_as
			else
				l_as_generating_type := a_as.generating_type
			end

			Result := ast_node_to_xml_tag (l_as_generating_type)
		end


	resolve_local_tag_name (a_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER): STRING
			-- Resolves the XML elment name to hightlight output.
		require
			a_as_not_void: attached a_as
			a_parent_not_void: attached a_parent
			a_as_has_local_tag: has_local_tag_name (a_as, a_parent, a_branch)
		local
			l_as_generating_type: STRING
		do
			Result := branch_to_xml_mapping.at (to_key ([a_parent.generating_type.name, a_branch]))
		end


	has_local_tag_name (a_as: AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER): BOOLEAN
			-- Resolves the XML elment name to hightlight output.
		require
			a_as_not_void: attached a_as
		do
			Result := attached a_parent as l_parent and then branch_to_xml_mapping.has (to_key ([l_parent.generator, a_branch]))
		end


feature -- AST Traversal

	process_variant_as (l_as: VARIANT_AS)
			-- Fix processing index that is used in `{ETR_AST_STRUCTURE_PRINTER}.process_variant_as'.			
		do
				-- id was `1'
			process_child(l_as.expr, l_as, 2)
		end


	process_external_as (l_as: EXTERNAL_AS)
			-- Fix processing shortcut that is used in `{ETR_AST_STRUCTURE_PRINTER}.process_external_as'.		
		do
			output.append_string (ti_external_keyword+ti_New_line)
			output.enter_block
			if l_as.is_built_in then
				output.append_string ("%"built_in%"")
			else
				process(l_as.language_name, l_as, 1)
			end
			output.exit_block
			output.append_string (ti_New_line)

			if processing_needed (l_as.alias_name_literal, l_as, 2) then
				output.append_string (ti_alias_keyword+ti_New_line)
				process_block (l_as.alias_name_literal, l_as, 2)
				output.append_string (ti_New_line)
			end
		end


	process_external_lang_as (l_as: EXTERNAL_LANG_AS)
			-- Fix processing shortcut that is used in `{ETR_AST_STRUCTURE_PRINTER}.process_external_lang_as'.	
		do
			process(l_as.language_name, l_as, 1)
		end


	process_feature_list_as (l_as: FEATURE_LIST_AS)
			-- Fix processing shortcut that is used in `{ETR_AST_STRUCTURE_PRINTER}.process_feature_list_as'.		
		do
			process (l_as.features, l_as, 1)
		end


	process_guard_as (l_as: GUARD_AS)
			-- Fix processing shortcut that is used in `{ETR_AST_STRUCTURE_PRINTER}.process_guard_as'.
		do
			if attached l_as.check_list as l_check_list then
				process (l_check_list, l_as, 1)
			end
			if attached l_as.compound as l_compound then
				process (l_compound, l_as, 2)
			end
		end


feature {NONE} -- AST Attributes

	process_bool_as (l_as: BOOL_AS)
			-- Adding XML attributes to `l_as'.	
		local
			l_value: STRING
		do
			l_value := l_as.string_value
			l_value.to_lower

			if allow_set.has (node_bool_as) then
				output.xml_add_unqualified_attribute ("value", l_value)
			end

			Precursor (l_as)
		end


	process_id_as (l_as: ID_AS)
			-- Adding XML attributes to `l_as'.	
		do
			if allow_set.has (node_id_as) then
				output.xml_add_unqualified_attribute ("name", l_as.name)
			end

			Precursor (l_as)
		end


	process_precursor_as (l_as: PRECURSOR_AS)
			-- Adding XML attributes to `l_as'.
		do
			if allow_set.has (node_precursor_as) then
				output.xml_add_unqualified_attribute ("name", "Precursor")
			end

			Precursor (l_as)
		end


	process_result_as (l_as: RESULT_AS)
			-- Adding XML attributes to `l_as'.		
		do
			if allow_set.has (node_result_as) then
				output.xml_add_unqualified_attribute ("name", l_as.access_name_8)
			end

			Precursor (l_as)
		end


	process_current_as (l_as: CURRENT_AS)
			-- Adding XML attributes to `l_as'.		
		do
			if allow_set.has (node_current_as) then
				output.xml_add_unqualified_attribute ("name", l_as.access_name_8)
			end

			Precursor (l_as)
		end


	process_access_inv_as (l_as: ACCESS_INV_AS)
			-- Adding XML attributes to `l_as'.				
		do
			if allow_set.has (node_access_inv_as) then
				output.xml_add_unqualified_attribute ("name", l_as.access_name_8)
			end

			Precursor (l_as)
		end


	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- Adding XML attributes to `l_as'.		
		do
			if allow_set.has (node_access_feat_as) then
				output.xml_add_unqualified_attribute ("name", l_as.access_name_8)
			end

			Precursor (l_as)
		end


	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Adding XML attributes to `l_as'.	
		do
			if allow_set.has (node_access_id_as) then
				output.xml_add_unqualified_attribute ("name", l_as.access_name_8)
			end

			Precursor (l_as)
		end

end
