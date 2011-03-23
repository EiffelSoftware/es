-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLElement"
class
	JS_HTML_ELEMENT

inherit
	JS_ELEMENT

feature -- Added by http://www.w3.org/TR/cssom-view

	offset_parent: JS_ELEMENT
		external "C" alias "offsetParent" end

	offset_top: INTEGER
		external "C" alias "offsetTop" end

	offset_left: INTEGER
		external "C" alias "offsetLeft" end

	offset_width: INTEGER
		external "C" alias "offsetWidth" end

	offset_height: INTEGER
		external "C" alias "offsetHeight" end

feature -- DOM tree accessors

	get_elements_by_class_name (a_class_names: STRING): JS_NODE_LIST
			-- Returns a NodeList of the elements in the object on which the method was
			-- invoked (a Document or an Element) that have all the classes given by
			-- classes. The classes argument is interpreted as a space-separated list of
			-- classes.
		external "C" alias "getElementsByClassName($a_class_names)" end

feature -- dynamic markup insertion

	inner_html: STRING assign set_inner_html
			-- Returns a fragment of HTML or XML that represents the element's contents.
			-- Can be set, to replace the contents of the element with nodes parsed from
			-- the given string. In the case of XML documents, will throw an
			-- INVALID_STATE_ERR if the element cannot be serialized to XML, and a
			-- SYNTAX_ERR if the given string is not well-formed.
		external "C" alias "innerHTML" end

	set_inner_html (a_inner_html: STRING)
			-- See inner_html
		external "C" alias "innerHTML=$a_inner_html" end

	outer_html: STRING assign set_outer_html
			-- Returns a fragment of HTML or XML that represents the element and its
			-- contents. Can be set, to replace the element with nodes parsed from the
			-- given string. In the case of XML documents, will throw an INVALID_STATE_ERR
			-- if the element cannot be serialized to XML, and a SYNTAX_ERR if the given
			-- string is not well-formed. Throws a NO_MODIFICATION_ALLOWED_ERR exception if
			-- the parent of the element is the Document node.
		external "C" alias "outerHTML" end

	set_outer_html (a_outer_html: STRING)
			-- See outer_html
		external "C" alias "outerHTML=$a_outer_html" end

	insert_adjacent_html (a_position: STRING; a_text: STRING)
			-- Parses the given string text as HTML or XML and inserts the resulting nodes
			-- into the tree in the position given by the position argument, as follows:
			-- "beforebegin" - Before the element itself. "afterbegin" - Just inside the
			-- element, before its first child. "beforeend" - Just inside the element,
			-- after its last child. "afterend" - After the element itself. Throws a
			-- SYNTAX_ERR exception if the arguments have invalid values (e.g., in the case
			-- of XML documents, if the given string is not well-formed). Throws a
			-- NO_MODIFICATION_ALLOWED_ERR exception if the given position isn't possible
			-- (e.g. inserting elements after the root element of a Document).
		external "C" alias "insertAdjacentHTML($a_position, $a_text)" end

feature -- metadata attributes

	id: STRING assign set_id
			-- The id attribute specifies its element's unique identifier (ID). The value
			-- must be unique amongst all the IDs in the element's home subtree and must
			-- contain at least one character. The value must not contain any space
			-- characters.
		external "C" alias "id" end

	set_id (a_id: STRING)
			-- See id
		external "C" alias "id=$a_id" end

	title: STRING assign set_title
			-- The title attribute represents advisory information for the element, such as
			-- would be appropriate for a tooltip. On a link, this could be the title or a
			-- description of the target resource; on an image, it could be the image
			-- credit or a description of the image; on a paragraph, it could be a footnote
			-- or commentary on the text; on a citation, it could be further information
			-- about the source; and so forth. The value is text.
		external "C" alias "title" end

	set_title (a_title: STRING)
			-- See title
		external "C" alias "title=$a_title" end

	lang: STRING assign set_lang
			-- The lang attribute (in no namespace) specifies the primary language for the
			-- element's contents and for any of the element's attributes that contain
			-- text. Its value must be a valid BCP 47 language tag, or the empty string.
			-- Setting the attribute to the empty string indicates that the primary
			-- language is unknown.
		external "C" alias "lang" end

	set_lang (a_lang: STRING)
			-- See lang
		external "C" alias "lang=$a_lang" end

	dir: STRING assign set_dir
			-- The dir attribute specifies the element's text directionality. The attribute
			-- is an enumerated attribute with the keyword ltr mapping to the state ltr,
			-- and the keyword rtl mapping to the state rtl. The attribute has no invalid
			-- value default and no missing value default.
		external "C" alias "dir" end

	set_dir (a_dir: STRING)
			-- See dir
		external "C" alias "dir=$a_dir" end

	class_name: STRING assign set_class_name
			-- Every HTML element may have a class attribute specified. The attribute, if
			-- specified, must have a value that is a set of space-separated tokens
			-- representing the various classes that the element belongs to. The classes
			-- that an HTML element has assigned to it consists of all the classes returned
			-- when the value of the class attribute is split on spaces. (Duplicates are
			-- ignored.)
		external "C" alias "className" end

	set_class_name (a_class_name: STRING)
			-- See class_name
		external "C" alias "className=$a_class_name" end

	class_list: JS_DOM_TOKEN_LIST
			-- The className and classList IDL attributes must both reflect the class
			-- content attribute.
		external "C" alias "classList" end

	dataset: JS_DOM_STRING_MAP
			-- Returns a DOMStringMap object for the element's data-* attributes.
			-- Hyphenated names become camel-cased. For example, data-foo-bar="" becomes
			-- element.dataset.fooBar.
		external "C" alias "dataset" end

feature -- user interaction

	hidden: BOOLEAN assign set_hidden
			-- All HTML elements may have the hidden content attribute set. The hidden
			-- attribute is a boolean attribute. When specified on an element, it indicates
			-- that the element is not yet, or is no longer, relevant. User agents should
			-- not render elements that have the hidden attribute specified.
		external "C" alias "hidden" end

	set_hidden (a_hidden: BOOLEAN)
			-- See hidden
		external "C" alias "hidden=$a_hidden" end

	click
			-- Acts as if the element was clicked.
		external "C" alias "click()" end

	scroll_into_view (a_top: BOOLEAN)
			-- Scrolls the element into view. If the top argument is true, then the element
			-- will be scrolled to the top of the viewport, otherwise it'll be scrolled to
			-- the bottom. The default is the top.
		external "C" alias "scrollIntoView($a_top)" end

	tab_index: INTEGER assign set_tab_index
			-- The tabindex content attribute specifies whether the element is focusable,
			-- whether it can be reached using sequential focus navigation, and the
			-- relative order of the element for the purposes of sequential focus
			-- navigation. The name "tab index" comes from the common use of the "tab" key
			-- to navigate through the focusable elements. The term "tabbing" refers to
			-- moving forward through the focusable elements that can be reached using
			-- sequential focus navigation. The tabindex attribute, if specified, must have
			-- a value that is a valid integer.
		external "C" alias "tabIndex" end

	set_tab_index (a_tab_index: INTEGER)
			-- See tab_index
		external "C" alias "tabIndex=$a_tab_index" end

	focus
			-- Focuses the element.
		external "C" alias "focus()" end

	blur
			-- Unfocuses the element. Use of this method is discouraged. Focus another
			-- element instead. Do not use this method to hide the focus ring if you find
			-- the focus ring unsightly. Instead, use a CSS rule to override the 'outline'
			-- property.
		external "C" alias "blur()" end

	access_key: STRING assign set_access_key
			-- All HTML elements may have the accesskey content attribute set. The
			-- accesskey attribute's value is used by the user agent as a guide for
			-- creating a keyboard shortcut that activates or focuses the element. If
			-- specified, the value must be an ordered set of unique space-separated tokens
			-- that are case-sensitive, each of which must be exactly one Unicode code
			-- point in length.
		external "C" alias "accessKey" end

	set_access_key (a_access_key: STRING)
			-- See access_key
		external "C" alias "accessKey=$a_access_key" end

	access_key_label: STRING
			-- The accessKeyLabel IDL attribute must return a string that represents the
			-- element's assigned access key, if any. If the element does not have one,
			-- then the IDL attribute must return the empty string.
		external "C" alias "accessKeyLabel" end

	draggable: BOOLEAN assign set_draggable
			-- The draggable IDL attribute, whose value depends on the content attribute's
			-- in the way described below, controls whether or not the element is
			-- draggable. Generally, only text selections are draggable, but elements whose
			-- draggable IDL attribute is true become draggable as well.
		external "C" alias "draggable" end

	set_draggable (a_draggable: BOOLEAN)
			-- See draggable
		external "C" alias "draggable=$a_draggable" end

	content_editable: STRING assign set_content_editable
			-- Returns "true", "false", or "inherit", based on the state of the
			-- contenteditable attribute. Can be set, to change that state. Throws a
			-- SYNTAX_ERR exception if the new value isn't one of those strings.
		external "C" alias "contentEditable" end

	set_content_editable (a_content_editable: STRING)
			-- See content_editable
		external "C" alias "contentEditable=$a_content_editable" end

	is_content_editable: BOOLEAN
			-- Returns true if the element is editable; otherwise, returns false.
		external "C" alias "isContentEditable" end

	context_menu: JS_HTML_MENU_ELEMENT assign set_context_menu
			-- The contextmenu attribute gives the element's context menu. The value must
			-- be the ID of a menu element in the DOM. If the node that would be obtained
			-- by the invoking the getElementById() method using the attribute's value as
			-- the only argument is null or not a menu element, then the element has no
			-- assigned context menu. Otherwise, the element's assigned context menu is the
			-- element so identified.
		external "C" alias "contextMenu" end

	set_context_menu (a_context_menu: JS_HTML_MENU_ELEMENT)
			-- See context_menu
		external "C" alias "contextMenu=$a_context_menu" end

	spellcheck: BOOLEAN assign set_spellcheck
			-- Returns true if the element is to have its spelling and grammar checked;
			-- otherwise, returns false. Can be set, to override the default and set the
			-- spellcheck content attribute.
		external "C" alias "spellcheck" end

	set_spellcheck (a_spellcheck: BOOLEAN)
			-- See spellcheck
		external "C" alias "spellcheck=$a_spellcheck" end

feature -- command API

	command_type: STRING
			-- The commandType attribute must return a string whose value is either
			-- "command", "radio", or "checkbox", depending on whether the Type of the
			-- command defined by the element is "command", "radio", or "checkbox"
			-- respectively. If the element does not define a command, it must return null.
		external "C" alias "commandType" end

	label: STRING
			-- The label attribute must return the command's Label, or null if the element
			-- does not define a command or does not specify a Label. This attribute will
			-- be shadowed by the label IDL attribute on various elements.
		external "C" alias "label" end

	icon: STRING
			-- The icon attribute must return the absolute URL of the command's Icon. If
			-- the element does not specify an icon, or if the element does not define a
			-- command, then the attribute must return null. This attribute will be
			-- shadowed by the icon IDL attribute on command elements.
		external "C" alias "icon" end

	disabled: BOOLEAN
			-- The disabled attribute must return true if the command's Disabled State is
			-- that the command is disabled, and false if the command is not disabled. This
			-- attribute is not affected by the command's Hidden State. If the element does
			-- not define a command, the attribute must return false. This attribute will
			-- be shadowed by the disabled IDL attribute on various elements.
		external "C" alias "disabled" end

	checked: BOOLEAN
			-- The checked attribute must return true if the command's Checked State is
			-- that the command is checked, and false if it is that the command is not
			-- checked. If the element does not define a command, the attribute must return
			-- false. This attribute will be shadowed by the checked IDL attribute on input
			-- and command elements.
		external "C" alias "checked" end

feature -- styling -- TODO ASSUMING CSS2 HERE original was CSSStyleDeclaration

	style: attached JS_CSS2_PROPERTIES
			-- All HTML elements may have the style content attribute set. This is a CSS
			-- styling attribute as defined by the CSS Styling Attribute Syntax
			-- specification. [CSSATTR] In user agents that support CSS, the attribute's
			-- value must be parsed when the attribute is added or has its value changed,
			-- according to the rules given for CSS styling attributes. [CSSATTR] Documents
			-- that use style attributes on any of their elements must still be
			-- comprehensible and usable if those attributes were removed.
		external "C" alias "style" end

feature -- event handler IDL attributes

	onabort: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onabort
		external "C" alias "onabort" end

	set_onabort (a_onabort: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onabort=$a_onabort" end

	onblur: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN] assign set_onblur
		external "C" alias "onblur" end

	set_onblur (a_onblur: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN])
		external "C" alias "onblur=$a_onblur" end

	oncanplay: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_oncanplay
		external "C" alias "oncanplay" end

	set_oncanplay (a_oncanplay: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "oncanplay=$a_oncanplay" end

	oncanplaythrough: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_oncanplaythrough
		external "C" alias "oncanplaythrough" end

	set_oncanplaythrough (a_oncanplaythrough: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "oncanplaythrough=$a_oncanplaythrough" end

	onchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onchange
		external "C" alias "onchange" end

	set_onchange (a_onchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onchange=$a_onchange" end

	onclick: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onclick
		external "C" alias "onclick" end

	set_onclick (a_onclick: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onclick=$a_onclick" end

	oncontextmenu: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_oncontextmenu
		external "C" alias "oncontextmenu" end

	set_oncontextmenu (a_oncontextmenu: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "oncontextmenu=$a_oncontextmenu" end

	ondblclick: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_ondblclick
		external "C" alias "ondblclick" end

	set_ondblclick (a_ondblclick: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "ondblclick=$a_ondblclick" end

	ondrag: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondrag
		external "C" alias "ondrag" end

	set_ondrag (a_ondrag: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondrag=$a_ondrag" end

	ondragend: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondragend
		external "C" alias "ondragend" end

	set_ondragend (a_ondragend: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondragend=$a_ondragend" end

	ondragenter: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondragenter
		external "C" alias "ondragenter" end

	set_ondragenter (a_ondragenter: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondragenter=$a_ondragenter" end

	ondragleave: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondragleave
		external "C" alias "ondragleave" end

	set_ondragleave (a_ondragleave: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondragleave=$a_ondragleave" end

	ondragover: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondragover
		external "C" alias "ondragover" end

	set_ondragover (a_ondragover: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondragover=$a_ondragover" end

	ondragstart: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondragstart
		external "C" alias "ondragstart" end

	set_ondragstart (a_ondragstart: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondragstart=$a_ondragstart" end

	ondrop: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondrop
		external "C" alias "ondrop" end

	set_ondrop (a_ondrop: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondrop=$a_ondrop" end

	ondurationchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ondurationchange
		external "C" alias "ondurationchange" end

	set_ondurationchange (a_ondurationchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ondurationchange=$a_ondurationchange" end

	onemptied: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onemptied
		external "C" alias "onemptied" end

	set_onemptied (a_onemptied: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onemptied=$a_onemptied" end

	onended: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onended
		external "C" alias "onended" end

	set_onended (a_onended: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onended=$a_onended" end

	onerror: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onerror
		external "C" alias "onerror" end

	set_onerror (a_onerror: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onerror=$a_onerror" end

	onfocus: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN] assign set_onfocus
		external "C" alias "onfocus" end

	set_onfocus (a_onfocus: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN])
		external "C" alias "onfocus=$a_onfocus" end

	onformchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onformchange
		external "C" alias "onformchange" end

	set_onformchange (a_onformchange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onformchange=$a_onformchange" end

	onforminput: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onforminput
		external "C" alias "onforminput" end

	set_onforminput (a_onforminput: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onforminput=$a_onforminput" end

	oninput: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_oninput
		external "C" alias "oninput" end

	set_oninput (a_oninput: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "oninput=$a_oninput" end

	oninvalid: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_oninvalid
		external "C" alias "oninvalid" end

	set_oninvalid (a_oninvalid: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "oninvalid=$a_oninvalid" end

	onkeydown: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN] assign set_onkeydown
		external "C" alias "onkeydown" end

	set_onkeydown (a_onkeydown: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN])
		external "C" alias "onkeydown=$a_onkeydown" end

	onkeypress: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN] assign set_onkeypress
		external "C" alias "onkeypress" end

	set_onkeypress (a_onkeypress: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN])
		external "C" alias "onkeypress=$a_onkeypress" end

	onkeyup: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN] assign set_onkeyup
		external "C" alias "onkeyup" end

	set_onkeyup (a_onkeyup: FUNCTION [ANY, attached TUPLE [attached JS_KEYBOARD_EVENT], BOOLEAN])
		external "C" alias "onkeyup=$a_onkeyup" end

	onload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onload
		external "C" alias "onload" end

	set_onload (a_onload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onload=$a_onload" end

	onloadeddata: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onloadeddata
		external "C" alias "onloadeddata" end

	set_onloadeddata (a_onloadeddata: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onloadeddata=$a_onloadeddata" end

	onloadedmetadata: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onloadedmetadata
		external "C" alias "onloadedmetadata" end

	set_onloadedmetadata (a_onloadedmetadata: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onloadedmetadata=$a_onloadedmetadata" end

	onloadstart: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onloadstart
		external "C" alias "onloadstart" end

	set_onloadstart (a_onloadstart: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onloadstart=$a_onloadstart" end

	onmousedown: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onmousedown
		external "C" alias "onmousedown" end

	set_onmousedown (a_onmousedown: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onmousedown=$a_onmousedown" end

	onmousemove: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onmousemove
		external "C" alias "onmousemove" end

	set_onmousemove (a_onmousemove: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onmousemove=$a_onmousemove" end

	onmouseout: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onmouseout
		external "C" alias "onmouseout" end

	set_onmouseout (a_onmouseout: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onmouseout=$a_onmouseout" end

	onmouseover: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onmouseover
		external "C" alias "onmouseover" end

	set_onmouseover (a_onmouseover: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onmouseover=$a_onmouseover" end

	onmouseup: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN] assign set_onmouseup
		external "C" alias "onmouseup" end

	set_onmouseup (a_onmouseup: FUNCTION [ANY, attached TUPLE [attached JS_MOUSE_EVENT], BOOLEAN])
		external "C" alias "onmouseup=$a_onmouseup" end

	onmousewheel: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onmousewheel
		external "C" alias "onmousewheel" end

	set_onmousewheel (a_onmousewheel: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onmousewheel=$a_onmousewheel" end

	onpause: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpause
		external "C" alias "onpause" end

	set_onpause (a_onpause: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpause=$a_onpause" end

	onplay: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onplay
		external "C" alias "onplay" end

	set_onplay (a_onplay: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onplay=$a_onplay" end

	onplaying: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onplaying
		external "C" alias "onplaying" end

	set_onplaying (a_onplaying: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onplaying=$a_onplaying" end

	onprogress: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onprogress
		external "C" alias "onprogress" end

	set_onprogress (a_onprogress: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onprogress=$a_onprogress" end

	onratechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onratechange
		external "C" alias "onratechange" end

	set_onratechange (a_onratechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onratechange=$a_onratechange" end

	onreadystatechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onreadystatechange
		external "C" alias "onreadystatechange" end

	set_onreadystatechange (a_onreadystatechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onreadystatechange=$a_onreadystatechange" end

	onreset: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onreset
		external "C" alias "onreset" end

	set_onreset (a_onreset: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onreset=$a_onreset" end

	onscroll: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN] assign set_onscroll
		external "C" alias "onscroll" end

	set_onscroll (a_onscroll: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN])
		external "C" alias "onscroll=$a_onscroll" end

	onseeked: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onseeked
		external "C" alias "onseeked" end

	set_onseeked (a_onseeked: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onseeked=$a_onseeked" end

	onseeking: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onseeking
		external "C" alias "onseeking" end

	set_onseeking (a_onseeking: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onseeking=$a_onseeking" end

	onselect: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onselect
		external "C" alias "onselect" end

	set_onselect (a_onselect: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onselect=$a_onselect" end

	onshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onshow
		external "C" alias "onshow" end

	set_onshow (a_onshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onshow=$a_onshow" end

	onstalled: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onstalled
		external "C" alias "onstalled" end

	set_onstalled (a_onstalled: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onstalled=$a_onstalled" end

	onsubmit: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onsubmit
		external "C" alias "onsubmit" end

	set_onsubmit (a_onsubmit: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onsubmit=$a_onsubmit" end

	onsuspend: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onsuspend
		external "C" alias "onsuspend" end

	set_onsuspend (a_onsuspend: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onsuspend=$a_onsuspend" end

	ontimeupdate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ontimeupdate
		external "C" alias "ontimeupdate" end

	set_ontimeupdate (a_ontimeupdate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ontimeupdate=$a_ontimeupdate" end

	onvolumechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onvolumechange
		external "C" alias "onvolumechange" end

	set_onvolumechange (a_onvolumechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onvolumechange=$a_onvolumechange" end

	onwaiting: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onwaiting
		external "C" alias "onwaiting" end

	set_onwaiting (a_onwaiting: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onwaiting=$a_onwaiting" end
end
