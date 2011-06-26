-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:MutationEvent"
class
	JS_MUTATION_EVENT

inherit
	JS_EVENT

feature -- attrChangeType

	MODIFICATION: INTEGER
			-- The Attr was modified in place.
		external "C" alias "#1" end

	ADDITION: INTEGER
			-- The Attr was just added.
		external "C" alias "#2" end

	REMOVAL: INTEGER
			-- The Attr was just removed.
		external "C" alias "#3" end

	related_node: JS_NODE
			-- relatedNode shall be used to identify a secondary node related to a mutation
			-- event. For example, if a mutation event is dispatched to a node indicating
			-- that its parent has changed, the relatedNode shall be the changed parent. If
			-- an event is instead dispatched to a subtree indicating a node was changed
			-- within it, the relatedNode shall be the changed node. In the case of the
			-- DOMAttrModified event it indicates the Attr node which was modified, added,
			-- or removed.
		external "C" alias "relatedNode" end

	prev_value: STRING
			-- prevValue indicates the previous value of the Attr node in DOMAttrModified
			-- events, and of the CharacterData node in DOMCharacterDataModified events.
		external "C" alias "prevValue" end

	new_value: STRING
			-- newValue indicates the new value of the Attr node in DOMAttrModified events,
			-- and of the CharacterData node in DOMCharacterDataModified events.
		external "C" alias "newValue" end

	attr_name: STRING
			-- attrName indicates the name of the changed Attr node in a DOMAttrModified
			-- event.
		external "C" alias "attrName" end

	attr_change: INTEGER
			-- attrChange indicates the type of change which triggered the DOMAttrModified
			-- event. The values can be MODIFICATION, ADDITION, or REMOVAL.
		external "C" alias "attrChange" end

	init_mutation_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_related_node_arg: JS_NODE; a_prev_value_arg: STRING; a_new_value_arg: STRING; a_attr_name_arg: STRING; a_attr_change_arg: INTEGER)
			-- Initializes attributes of a MutationEvent object. This method has the same
			-- behavior as Event.initEvent().
		external "C" alias "initMutationEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_related_node_arg, $a_prev_value_arg, $a_new_value_arg, $a_attr_name_arg, $a_attr_change_arg)" end
end
