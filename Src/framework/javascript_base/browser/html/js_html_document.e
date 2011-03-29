-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLDocument"
class
	JS_HTML_DOCUMENT

inherit
	JS_DOCUMENT

feature -- DocumentRange interface

	create_range: JS_RANGE
			-- This interface can be obtained from the object implementing the Document
			-- interface using binding-specific casting methods.
		external "C" alias "createRange()" end

feature -- resource metadata management

	location: JS_LOCATION
		external "C" alias "location" end

	url: STRING
			-- Returns the document's address.
		external "C" alias "URL" end

	domain: STRING assign set_domain
		external "C" alias "domain" end

	set_domain (a_domain: STRING)
		external "C" alias "domain=$a_domain" end

	referrer: STRING
			-- Returns the address of the Document from which the user navigated to this
			-- one, unless it was blocked or there was no such document, in which case it
			-- returns the empty string. The noreferrer link type can be used to block the
			-- referrer.
		external "C" alias "referrer" end

	cookie: STRING assign set_cookie
			-- Returns the HTTP cookies that apply to the Document. If there are no cookies
			-- or cookies can't be applied to this resource, the empty string will be
			-- returned. Can be set, to add a new cookie to the element's set of HTTP
			-- cookies. If the contents are sandboxed into a unique origin (in an iframe
			-- with the sandbox attribute) or the resource was labeled as
			-- text/html-sandboxed, a SECURITY_ERR exception will be thrown on getting and
			-- setting.
		external "C" alias "cookie" end

	set_cookie (a_cookie: STRING)
			-- See cookie
		external "C" alias "cookie=$a_cookie" end

	last_modified: STRING
			-- Returns the date of the last modification to the document, as reported by
			-- the server, in the form "MM/DD/YYYY hh:mm:ss", in the user's local time
			-- zone. If the last modification date is not known, the current time is
			-- returned instead.
		external "C" alias "lastModified" end

	compat_mode: STRING
			-- In a conforming document, returns the string "CSS1Compat". (In quirks mode
			-- documents, returns the string "BackCompat", but a conforming document can
			-- never trigger quirks mode.)
		external "C" alias "compatMode" end

	charset: STRING assign set_charset
			-- Returns the document's character encoding. Can be set, to dynamically change
			-- the document's character encoding. New values that are not IANA-registered
			-- aliases supported by the user agent are ignored.
		external "C" alias "charset" end

	set_charset (a_charset: STRING)
			-- See charset
		external "C" alias "charset=$a_charset" end

	character_set: STRING
			-- Returns the document's character encoding.
		external "C" alias "characterSet" end

	default_charset: STRING
			-- Returns what might be the user agent's default character encoding. (The user
			-- agent might return another character encoding altogether, e.g. to protect
			-- the user's privacy, or if the user agent doesn't use a single default
			-- encoding.)
		external "C" alias "defaultCharset" end

	ready_state: STRING
			-- Returns "loading" while the Document is loading, "interactive" once it is
			-- finished parsing but still loading sub-resources, and "complete" once it has
			-- loaded. The readystatechange event fires on the Document object when this
			-- value changes.
		external "C" alias "readyState" end

feature -- DOM tree accessors

feature -- getter any (in DOMString name);

	title: STRING assign set_title
			-- Returns the document's title, as given by the title element. Can be set, to
			-- update the document's title. If there is no head element, the new value is
			-- ignored. In SVG documents, the SVGDocument interface's title attribute takes
			-- precedence.
		external "C" alias "title" end

	set_title (a_title: STRING)
			-- See title
		external "C" alias "title=$a_title" end

	dir: STRING assign set_dir
		external "C" alias "dir" end

	set_dir (a_dir: STRING)
		external "C" alias "dir=$a_dir" end

	body: JS_HTML_ELEMENT assign set_body
			-- Returns the body element. Can be set, to replace the body element. If the
			-- new value is not a body or frameset element, this will throw a
			-- HIERARCHY_REQUEST_ERR exception.
		external "C" alias "body" end

	set_body (a_body: JS_HTML_ELEMENT)
			-- See body
		external "C" alias "body=$a_body" end

	head: JS_HTML_HEAD_ELEMENT
			-- Returns the head element.
		external "C" alias "head" end

	images: JS_HTML_COLLECTION
			-- Returns an HTMLCollection of the img elements in the Document.
		external "C" alias "images" end

	embeds: JS_HTML_COLLECTION
			-- Return an HTMLCollection of the embed elements in the Document.
		external "C" alias "embeds" end

	plugins: JS_HTML_COLLECTION
			-- Return an HTMLCollection of the embed elements in the Document.
		external "C" alias "plugins" end

	links: JS_HTML_COLLECTION
			-- Returns an HTMLCollection of the a and area elements in the Document that
			-- have href attributes.
		external "C" alias "links" end

	forms: JS_HTML_COLLECTION
			-- Return an HTMLCollection of the form elements in the Document.
		external "C" alias "forms" end

	scripts: JS_HTML_COLLECTION
			-- Return an HTMLCollection of the script elements in the Document.
		external "C" alias "scripts" end

	get_elements_by_name (a_element_name: STRING): JS_NODE_LIST
			-- Returns a NodeList of elements in the Document that have a name attribute
			-- with the value name.
		external "C" alias "getElementsByName($a_element_name)" end

	get_elements_by_class_name (a_class_names: STRING): JS_NODE_LIST
			-- Returns a NodeList of the elements in the object on which the method was
			-- invoked (a Document or an Element) that have all the classes given by
			-- classes. The classes argument is interpreted as a space-separated list of
			-- classes.
		external "C" alias "getElementsByClassName($a_class_names)" end

feature -- dynamic markup insertion

	inner_html: STRING assign set_inner_html
		external "C" alias "innerHTML" end

	set_inner_html (a_inner_html: STRING)
		external "C" alias "innerHTML=$a_inner_html" end

	open (a_type: STRING; a_replace: STRING): JS_HTML_DOCUMENT
		external "C" alias "open($a_type, $a_replace)" end

	open2 (a_url: STRING; a_name: STRING; a_features: STRING; a_replace: BOOLEAN): JS_WINDOW
		external "C" alias "open($a_url, $a_name, $a_features, $a_replace)" end

	close
		external "C" alias "close()" end

feature -- user interaction

	default_view: JS_WINDOW
		external "C" alias "defaultView" end

	active_element: JS_ELEMENT
		external "C" alias "activeElement" end

	has_focus: BOOLEAN
		external "C" alias "hasFocus()" end

	design_mode: STRING assign set_design_mode
		external "C" alias "designMode" end

	set_design_mode (a_design_mode: STRING)
		external "C" alias "designMode=$a_design_mode" end

	exec_command (a_command_id: STRING): BOOLEAN
		external "C" alias "execCommand($a_command_id)" end

	exec_command2 (a_command_id: STRING; a_show_u_i: BOOLEAN): BOOLEAN
		external "C" alias "execCommand($a_command_id, $a_show_u_i)" end

	exec_command3 (a_command_id: STRING; a_show_u_i: BOOLEAN; a_value: STRING): BOOLEAN
		external "C" alias "execCommand($a_command_id, $a_show_u_i, $a_value)" end

	query_command_enabled (a_command_id: STRING): BOOLEAN
		external "C" alias "queryCommandEnabled($a_command_id)" end

	query_command_indeterm (a_command_id: STRING): BOOLEAN
		external "C" alias "queryCommandIndeterm($a_command_id)" end

	query_command_state (a_command_id: STRING): BOOLEAN
		external "C" alias "queryCommandState($a_command_id)" end

	query_command_supported (a_command_id: STRING): BOOLEAN
		external "C" alias "queryCommandSupported($a_command_id)" end

	query_command_value (a_command_id: STRING): STRING
		external "C" alias "queryCommandValue($a_command_id)" end

	commands: JS_HTML_COLLECTION
		external "C" alias "commands" end

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
