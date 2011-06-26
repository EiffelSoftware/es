-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:KeyboardEvent"
class
	JS_KEYBOARD_EVENT

inherit
	JS_UI_EVENT

feature -- KeyLocationCode

	DOM_KEY_LOCATION_STANDARD: INTEGER
			-- The key activation shall not be distinguished as the left or right version
			-- of the key, and did not originate from the numeric keypad (or did not
			-- originate with a virtual key corresponding to the numeric keypad). Example:
			-- the 'Q' key on a PC 101 Key US keyboard.
		external "C" alias "#0x00" end

	DOM_KEY_LOCATION_LEFT: INTEGER
			-- The key activated shall be in the left key location (there is more than one
			-- possible location for this key). Example: the left 'Control' key on a PC 101
			-- Key US keyboard.
		external "C" alias "#0x01" end

	DOM_KEY_LOCATION_RIGHT: INTEGER
			-- The key activation shall be in the right key location (there is more than
			-- one possible location for this key). Example: the right 'Shift' key on a PC
			-- 101 Key US keyboard.
		external "C" alias "#0x02" end

	DOM_KEY_LOCATION_NUMPAD: INTEGER
			-- The key activation originated on the numeric keypad or with a virtual key
			-- corresponding to the numeric keypad. Example: the '1' key on a PC 101 Key US
			-- keyboard located on the numeric pad.
		external "C" alias "#0x03" end

	DOM_KEY_LOCATION_MOBILE: INTEGER
			-- The key activation originated on a mobile device, either on a physical
			-- keypad or a virtual keyboard. Example: the '#' key or softkey on a mobile
			-- device.
		external "C" alias "#0x04" end

	DOM_KEY_LOCATION_JOYSTICK: INTEGER
			-- The key activation originated on a game controller or a joystick on a mobile
			-- device. Example: the 'DownLeft' key on a game controller.
		external "C" alias "#0x05" end

	char: STRING
			-- char holds the character value of the key pressed. The value must be a
			-- Unicode character string, conforming to the algorithm for determining the
			-- key value defined in this specification. For a key associated with a macro
			-- to insert multiple characters, the value of the char attribute will hold the
			-- entire sequence of characters. For a key which does not have a character
			-- representation, the value must be null.
		external "C" alias "char" end

	key: STRING
			-- key holds the key value of the key pressed. If the value is a character, it
			-- must match the value of the KeyboardEvent.char attribute; if the value is a
			-- control key which has no printed representation, it must be one of the key
			-- values defined in the key values set, as determined by the algorithm for
			-- determining the key value. Implementations that are unable to identify a key
			-- must use the key value 'Unidentified'.
		external "C" alias "key" end

	key_code: INTEGER
			-- keyCode holds a system- and implementation-dependent numerical code
			-- signifying the unmodified identifier associated with the key pressed. Unlike
			-- the KeyboardEvent.key or KeyboardEvent.char attributes, the set of possible
			-- values are not defined in this specification; typically, these value of the
			-- keyCode should represent the decimal codepoint in ASCII [RFC20][US-ASCII] or
			-- Windows 1252 [WIN1252], but may be drawn from a different appropriate
			-- character set. Implementations that are unable to identify a key must use
			-- the key value 0.
		external "C" alias "keyCode" end

	location: INTEGER
			-- The location attribute contains an indication of the location of the key on
			-- the device, as described in Keyboard event types.
		external "C" alias "location" end

	ctrl_key: BOOLEAN
			-- true if the control (Ctrl) key modifier is activated.
		external "C" alias "ctrlKey" end

	shift_key: BOOLEAN
			-- true if the shift (Shift) key modifier is activated.
		external "C" alias "shiftKey" end

	alt_key: BOOLEAN
			-- true if the alternative (Alt) key modifier is activated.
		external "C" alias "altKey" end

	meta_key: BOOLEAN
			-- true if the meta (Meta) key modifier is activated. Note: The 'Command' key
			-- modifier on Macintosh systems must be represented using this key modifier.
		external "C" alias "metaKey" end

	repeat: BOOLEAN
			-- true if the key has been pressed in a sustained manner. Depending on the
			-- system configuration, holding down a key results may result in multiple
			-- consecutive keydown events, keypress events, and textinput events, for
			-- appropriate keys. For mobile devices which have long-key-press behavior, the
			-- first key event with a repeat attribute value of 'true' shall serve as an
			-- indication of a long-key-press. The length of time that the key must be
			-- pressed in order to begin repeating is configuration-dependent.
		external "C" alias "repeat" end

	get_modifier_state (a_key_arg: STRING): BOOLEAN
			-- Queries the state of a modifier using a key value. See also Modifier keys.
		external "C" alias "getModifierState($a_key_arg)" end

	init_keyboard_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_view_arg: ANY; a_key_arg: STRING; a_location_arg: INTEGER; a_modifiers_list_arg: STRING; a_repeat: BOOLEAN)
			-- Initializes attributes of a KeyboardEvent object. This method has the same
			-- behavior as UIEvent.initUIEvent(). The value of UIEvent.detail remains
			-- undefined.
		external "C" alias "initKeyboardEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_view_arg, $a_key_arg, $a_location_arg, $a_modifiers_list_arg, $a_repeat)" end
end
