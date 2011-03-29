-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:Window"
class
	JS_WINDOW

inherit
	JS_BASE_WINDOW

feature -- the current browsing context

	window: JS_WINDOW
			-- These attributes all return window.
		external "C" alias "window" end

	self: JS_WINDOW
			-- These attributes all return window.
		external "C" alias "self" end

	document: attached JS_HTML_DOCUMENT
			-- Returns the active document.
		external "C" alias "document" end

	name: STRING assign set_name
			-- Returns the name of the window. Can be set, to change the name.
		external "C" alias "name" end

	set_name (a_name: STRING)
			-- See name
		external "C" alias "name=$a_name" end

	location: attached JS_LOCATION
		external "C" alias "location" end

	history: JS_HISTORY
		external "C" alias "history" end

	locationbar: JS_BAR_PROP
			-- Represents the user interface element that contains a control that displays
			-- the URL of the active document, or some similar interface concept.
		external "C" alias "locationbar" end

	menubar: JS_BAR_PROP
			-- Represents the user interface element that contains a list of commands in
			-- menu form, or some similar interface concept.
		external "C" alias "menubar" end

	personalbar: JS_BAR_PROP
			-- Represents the user interface element that contains links to the user's
			-- favorite pages, or some similar interface concept.
		external "C" alias "personalbar" end

	scrollbars: JS_BAR_PROP
			-- Represents the user interface element that contains a scrolling mechanism,
			-- or some similar interface concept.
		external "C" alias "scrollbars" end

	statusbar: JS_BAR_PROP
			-- Represents a user interface element found immediately below or after the
			-- document, as appropriate for the user's media. If the user agent has no such
			-- user interface element, then the object may act as if the corresponding user
			-- interface element was absent (i.e. its visible attribute may return false).
		external "C" alias "statusbar" end

	toolbar: JS_BAR_PROP
			-- Represents the user interface element found immediately above or before the
			-- document, as appropriate for the user's media. If the user agent has no such
			-- user interface element, then the object may act as if the corresponding user
			-- interface element was absent (i.e. its visible attribute may return false).
		external "C" alias "toolbar" end

	close
			-- Closes the window.
		external "C" alias "close()" end

	stop
			-- Cancels the document load.
		external "C" alias "stop()" end

	focus
		external "C" alias "focus()" end

	blur
		external "C" alias "blur()" end

feature -- other browsing contexts

	frames: JS_WINDOW
			-- These attributes all return window.
		external "C" alias "frames" end

	length: INTEGER
			-- Returns the number of child browsing contexts.
		external "C" alias "length" end

	top: JS_WINDOW
		external "C" alias "top" end

	opener: JS_WINDOW
		external "C" alias "opener" end

	parent: JS_WINDOW
		external "C" alias "parent" end

	frame_element: JS_ELEMENT
		external "C" alias "frameElement" end

	open (a_url: STRING; a_target: STRING; a_features: STRING; a_replace: STRING): JS_WINDOW
		external "C" alias "open($a_url, $a_target, $a_features, $a_replace)" end

feature -- getter WindowProxy (in unsigned long index);

feature -- getter any (in DOMString name);

feature -- the user agent

	navigator: JS_NAVIGATOR
		external "C" alias "navigator" end

feature -- readonly attribute ApplicationCache applicationCache;

feature -- user prompts

	alert (a_message: STRING)
		external "C" alias "alert($a_message)" end

	confirm (a_message: STRING): BOOLEAN
		external "C" alias "confirm($a_message)" end

	prompt (a_message: STRING; a_default: STRING): STRING
		external "C" alias "prompt($a_message, $a_default)" end

	js_print
		external "C" alias "print()" end

	show_modal_dialog (a_url: STRING; a_argument: ANY): ANY
		external "C" alias "showModalDialog($a_url, $a_argument)" end

feature -- event handler IDL attributes

	onabort: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onabort
		external "C" alias "onabort" end

	set_onabort (a_onabort: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onabort=$a_onabort" end

	onafterprint: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onafterprint
		external "C" alias "onafterprint" end

	set_onafterprint (a_onafterprint: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onafterprint=$a_onafterprint" end

	onbeforeprint: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onbeforeprint
		external "C" alias "onbeforeprint" end

	set_onbeforeprint (a_onbeforeprint: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onbeforeprint=$a_onbeforeprint" end

	onbeforeunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onbeforeunload
		external "C" alias "onbeforeunload" end

	set_onbeforeunload (a_onbeforeunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onbeforeunload=$a_onbeforeunload" end

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

feature -- attribute Function oncuechange;

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

	onhashchange: FUNCTION [ANY, attached TUPLE [attached JS_HASH_CHANGE_EVENT], BOOLEAN] assign set_onhashchange
		external "C" alias "onhashchange" end

	set_onhashchange (a_onhashchange: FUNCTION [ANY, attached TUPLE [attached JS_HASH_CHANGE_EVENT], BOOLEAN])
		external "C" alias "onhashchange=$a_onhashchange" end

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

	onmessage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onmessage
		external "C" alias "onmessage" end

	set_onmessage (a_onmessage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onmessage=$a_onmessage" end

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

	onoffline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onoffline
		external "C" alias "onoffline" end

	set_onoffline (a_onoffline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onoffline=$a_onoffline" end

	ononline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ononline
		external "C" alias "ononline" end

	set_ononline (a_ononline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ononline=$a_ononline" end

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

	onpagehide: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpagehide
		external "C" alias "onpagehide" end

	set_onpagehide (a_onpagehide: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpagehide=$a_onpagehide" end

	onpageshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpageshow
		external "C" alias "onpageshow" end

	set_onpageshow (a_onpageshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpageshow=$a_onpageshow" end

	onpopstate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpopstate
		external "C" alias "onpopstate" end

	set_onpopstate (a_onpopstate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpopstate=$a_onpopstate" end

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

	onredo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onredo
		external "C" alias "onredo" end

	set_onredo (a_onredo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onredo=$a_onredo" end

	onreset: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onreset
		external "C" alias "onreset" end

	set_onreset (a_onreset: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onreset=$a_onreset" end

	onresize: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN] assign set_onresize
		external "C" alias "onresize" end

	set_onresize (a_onresize: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN])
		external "C" alias "onresize=$a_onresize" end

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

	onstorage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onstorage
		external "C" alias "onstorage" end

	set_onstorage (a_onstorage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onstorage=$a_onstorage" end

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

	onundo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onundo
		external "C" alias "onundo" end

	set_onundo (a_onundo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onundo=$a_onundo" end

	onunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onunload
		external "C" alias "onunload" end

	set_onunload (a_onunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onunload=$a_onunload" end

	onvolumechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onvolumechange
		external "C" alias "onvolumechange" end

	set_onvolumechange (a_onvolumechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onvolumechange=$a_onvolumechange" end

	onwaiting: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onwaiting
		external "C" alias "onwaiting" end

	set_onwaiting (a_onwaiting: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onwaiting=$a_onwaiting" end
end
