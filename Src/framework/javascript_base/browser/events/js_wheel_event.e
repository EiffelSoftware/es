-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:WheelEvent"
class
	JS_WHEEL_EVENT

inherit
	JS_MOUSE_EVENT

feature -- DeltaModeCode

	DOM_DELTA_PIXEL: INTEGER
			-- The units of measurement for the delta shall be pixels. This is the most
			-- typical case in most operating system and implementation configurations.
		external "C" alias "#0x00" end

	DOM_DELTA_LINE: INTEGER
			-- The units of measurement for the delta shall be individual lines of text.
			-- This is the case for many form controls.
		external "C" alias "#0x01" end

	DOM_DELTA_PAGE: INTEGER
			-- The units of measurement for the delta shall be pages, either defined as a
			-- single screen or as a demarcated page.
		external "C" alias "#0x02" end

	delta_x: INTEGER
			-- The distance the wheel has rotated around the x-axis.
		external "C" alias "deltaX" end

	delta_y: INTEGER
			-- The distance the wheel has rotated around the y-axis.
		external "C" alias "deltaY" end

	delta_z: INTEGER
			-- The distance the wheel has rotated around the z-axis.
		external "C" alias "deltaZ" end

	delta_mode: INTEGER
			-- The deltaMode attribute contains an indication of to indicate the units of
			-- measurement for the delta values. The default value is DOM_DELTA_PIXEL
			-- (pixels). The value of deltaMode may be different for each of deltaX,
			-- deltaY, and deltaZ, based on system configuration.
		external "C" alias "deltaMode" end

	init_wheel_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_view_arg: ANY; a_detail_arg: INTEGER; a_screen_x_arg: INTEGER; a_screen_y_arg: INTEGER; a_client_x_arg: INTEGER; a_client_y_arg: INTEGER; a_button_arg: INTEGER; a_related_target_arg: JS_EVENT_TARGET; a_modifiers_list_arg: STRING; a_delta_x_arg: INTEGER; a_delta_y_arg: INTEGER; a_delta_z_arg: INTEGER; a_delta_mode: INTEGER)
			-- Initializes attributes of a WheelEvent object. This method has the same
			-- behavior as MouseEvent.initMouseEvent().
		external "C" alias "initWheelEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_view_arg, $a_detail_arg, $a_screen_x_arg, $a_screen_y_arg, $a_client_x_arg, $a_client_y_arg, $a_button_arg, $a_related_target_arg, $a_modifiers_list_arg, $a_delta_x_arg, $a_delta_y_arg, $a_delta_z_arg, $a_delta_mode)" end
end
