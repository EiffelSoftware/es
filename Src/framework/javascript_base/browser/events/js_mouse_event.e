-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:MouseEvent"
class
	JS_MOUSE_EVENT

inherit
	JS_UI_EVENT

feature -- Basic Operation

	screen_x: INTEGER
			-- The horizontal coordinate at which the event occurred relative to the origin
			-- of the screen coordinate system.
		external "C" alias "screenX" end

	screen_y: INTEGER
			-- The vertical coordinate at which the event occurred relative to the origin
			-- of the screen coordinate system.
		external "C" alias "screenY" end

	client_x: INTEGER
			-- The horizontal coordinate at which the event occurred relative to the
			-- viewport associated with the event.
		external "C" alias "clientX" end

	client_y: INTEGER
			-- The vertical coordinate at which the event occurred relative to the viewport
			-- associated with the event.
		external "C" alias "clientY" end

	ctrl_key: BOOLEAN
			-- Refer to the KeyboardEvent.ctrlKey attribute.
		external "C" alias "ctrlKey" end

	shift_key: BOOLEAN
			-- Refer to the KeyboardEvent.shiftKey attribute.
		external "C" alias "shiftKey" end

	alt_key: BOOLEAN
			-- Refer to the KeyboardEvent.altKey attribute.
		external "C" alias "altKey" end

	meta_key: BOOLEAN
			-- Refer to the KeyboardEvent.metaKey attribute.
		external "C" alias "metaKey" end

	button: INTEGER
			-- During mouse events caused by the depression or release of a mouse button,
			-- button shall be used to indicate which pointer device button changed state.
		external "C" alias "button" end

	buttons: INTEGER
			-- During mouse events caused by the depression or release of a mouse button,
			-- buttons shall be used to indicate which combination of mouse buttons are
			-- currently being pressed, expressed as a bitmask. Note: This should not be
			-- confused with the button attribute.
		external "C" alias "buttons" end

	related_target: JS_EVENT_TARGET
			-- Used to identify a secondary EventTarget related to a UI event, depending on
			-- the type of event.
		external "C" alias "relatedTarget" end

	init_mouse_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_view_arg: ANY; a_detail_arg: INTEGER; a_screen_x_arg: INTEGER; a_screen_y_arg: INTEGER; a_client_x_arg: INTEGER; a_client_y_arg: INTEGER; a_ctrl_key_arg: BOOLEAN; a_alt_key_arg: BOOLEAN; a_shift_key_arg: BOOLEAN; a_meta_key_arg: BOOLEAN; a_button_arg: INTEGER; a_related_target_arg: JS_EVENT_TARGET)
			-- Initializes attributes of a MouseEvent object. This method has the same
			-- behavior as UIEvent.initUIEvent().
		external "C" alias "initMouseEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_view_arg, $a_detail_arg, $a_screen_x_arg, $a_screen_y_arg, $a_client_x_arg, $a_client_y_arg, $a_ctrl_key_arg, $a_alt_key_arg, $a_shift_key_arg, $a_meta_key_arg, $a_button_arg, $a_related_target_arg)" end

feature -- Introduced in DOM Level 3:

	get_modifier_state (a_key_arg: STRING): BOOLEAN
			-- Queries the state of a modifier using a key value. See also Modifier keys.
		external "C" alias "getModifierState($a_key_arg)" end
end
