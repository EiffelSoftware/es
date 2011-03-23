-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:MutationNameEvent"
class
	JS_MUTATION_NAME_EVENT

inherit
	JS_MUTATION_EVENT

feature -- Basic Operation

	prev_namespace_uri: STRING
			-- The previous value of the relatedNode's namespaceURI.
		external "C" alias "prevNamespaceURI" end

	prev_node_name: STRING
			-- The previous value of the relatedNode's nodeName.
		external "C" alias "prevNodeName" end

feature -- Introduced in DOM Level 3:

	init_mutation_name_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_related_node_arg: JS_NODE; a_prev_namespace_uri_arg: STRING; a_prev_node_name_arg: STRING)
			-- Initializes attributes of a MutationNameEvent object. This method has the
			-- same behavior as MutationEvent.initMutationEvent().
		external "C" alias "initMutationNameEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_related_node_arg, $a_prev_namespace_uri_arg, $a_prev_node_name_arg)" end
end
