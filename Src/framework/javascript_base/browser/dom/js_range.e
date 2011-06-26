-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Range"
class
	JS_RANGE

feature -- Basic Operation

	start_container: JS_NODE
			-- Node within which the Range begins
		external "C" alias "startContainer" end

	start_offset: INTEGER
			-- Offset within the starting node of the Range.
		external "C" alias "startOffset" end

	end_container: JS_NODE
			-- Node within which the Range ends
		external "C" alias "endContainer" end

	end_offset: INTEGER
			-- Offset within the ending node of the Range.
		external "C" alias "endOffset" end

	collapsed: BOOLEAN
			-- TRUE if the Range is collapsed
		external "C" alias "collapsed" end

	common_ancestor_container: JS_NODE
			-- The deepest common ancestor container of the Range's two boundary-points.
		external "C" alias "commonAncestorContainer" end

	set_start (a_ref_node: JS_NODE; a_offset: INTEGER)
			-- Sets the attributes describing the start of the Range.
		external "C" alias "setStart($a_ref_node, $a_offset)" end

	set_end (a_ref_node: JS_NODE; a_offset: INTEGER)
			-- Sets the attributes describing the end of a Range.
		external "C" alias "setEnd($a_ref_node, $a_offset)" end

	set_start_before (a_ref_node: JS_NODE)
			-- Sets the start position to be before a node
		external "C" alias "setStartBefore($a_ref_node)" end

	set_start_after (a_ref_node: JS_NODE)
			-- Sets the start position to be after a node
		external "C" alias "setStartAfter($a_ref_node)" end

	set_end_before (a_ref_node: JS_NODE)
			-- Sets the end position to be before a node.
		external "C" alias "setEndBefore($a_ref_node)" end

	set_end_after (a_ref_node: JS_NODE)
			-- Sets the end of a Range to be after a node
		external "C" alias "setEndAfter($a_ref_node)" end

	collapse (a_to_start: BOOLEAN)
			-- Collapse a Range onto one of its boundary-points
		external "C" alias "collapse($a_to_start)" end

	select_node (a_ref_node: JS_NODE)
			-- Select a node and its contents
		external "C" alias "selectNode($a_ref_node)" end

	select_node_contents (a_ref_node: JS_NODE)
			-- Select the contents within a node
		external "C" alias "selectNodeContents($a_ref_node)" end

feature -- CompareHow

	START_TO_START: INTEGER
			-- Compare start boundary-point of sourceRange to start boundary-point of Range
			-- on which compareBoundaryPoints is invoked.
		external "C" alias "#0" end

	START_TO_END: INTEGER
			-- Compare start boundary-point of sourceRange to end boundary-point of Range
			-- on which compareBoundaryPoints is invoked.
		external "C" alias "#1" end

	END_TO_END: INTEGER
			-- Compare end boundary-point of sourceRange to end boundary-point of Range on
			-- which compareBoundaryPoints is invoked.
		external "C" alias "#2" end

	END_TO_START: INTEGER
			-- Compare end boundary-point of sourceRange to start boundary-point of Range
			-- on which compareBoundaryPoints is invoked.
		external "C" alias "#3" end

	compare_boundary_points (a_how: INTEGER; a_source_range: JS_RANGE): INTEGER
			-- Compare the boundary-points of two Ranges in a document.
		external "C" alias "compareBoundaryPoints($a_how, $a_source_range)" end

	delete_contents
			-- Removes the contents of a Range from the containing document or document
			-- fragment without returning a reference to the removed content.
		external "C" alias "deleteContents()" end

	extract_contents: JS_DOCUMENT_FRAGMENT
			-- Moves the contents of a Range from the containing document or document
			-- fragment to a new DocumentFragment.
		external "C" alias "extractContents()" end

	clone_contents: JS_DOCUMENT_FRAGMENT
			-- Duplicates the contents of a Range
		external "C" alias "cloneContents()" end

	insert_node (a_new_node: JS_NODE)
			-- Inserts a node into the Document or DocumentFragment at the start of the
			-- Range. If the container is a Text node, this will be split at the start of
			-- the Range (as if the Text node's splitText method was performed at the
			-- insertion point) and the insertion will occur between the two resulting Text
			-- nodes. Adjacent Text nodes will not be automatically merged. If the node to
			-- be inserted is a DocumentFragment node, the children will be inserted rather
			-- than the DocumentFragment node itself.
		external "C" alias "insertNode($a_new_node)" end

	surround_contents (a_new_parent: JS_NODE)
			-- Reparents the contents of the Range to the given node and inserts the node
			-- at the position of the start of the Range.
		external "C" alias "surroundContents($a_new_parent)" end

	clone_range: JS_RANGE
			-- Produces a new Range whose boundary-points are equal to the boundary-points
			-- of the Range.
		external "C" alias "cloneRange()" end

	to_string: STRING
			-- Returns the contents of a Range as a string. This string contains only the
			-- data characters, not any markup.
		external "C" alias "toString()" end

	detach
			-- Called to indicate that the Range is no longer in use and that the
			-- implementation may relinquish any resources associated with this Range.
			-- Subsequent calls to any methods or attribute getters on this Range will
			-- result in a DOMException being thrown with an error code of
			-- INVALID_STATE_ERR.
		external "C" alias "detach()" end
end
