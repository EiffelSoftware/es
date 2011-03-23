-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLBodyElement"
class
	JS_HTML_BODY_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine set_onload, set_onblur, onload, onblur, set_onscroll, onfocus, onerror, onscroll, set_onfocus, set_onerror end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('body')" end

feature -- Basic Operation

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

	onerror: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onerror
		external "C" alias "onerror" end

	set_onerror (a_onerror: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onerror=$a_onerror" end

	onfocus: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN] assign set_onfocus
		external "C" alias "onfocus" end

	set_onfocus (a_onfocus: FUNCTION [ANY, attached TUPLE [attached JS_FOCUS_EVENT], BOOLEAN])
		external "C" alias "onfocus=$a_onfocus" end

	onhashchange: FUNCTION [ANY, attached TUPLE [attached JS_HASH_CHANGE_EVENT], BOOLEAN] assign set_onhashchange
		external "C" alias "onhashchange" end

	set_onhashchange (a_onhashchange: FUNCTION [ANY, attached TUPLE [attached JS_HASH_CHANGE_EVENT], BOOLEAN])
		external "C" alias "onhashchange=$a_onhashchange" end

	onload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onload
		external "C" alias "onload" end

	set_onload (a_onload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onload=$a_onload" end

	onmessage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onmessage
		external "C" alias "onmessage" end

	set_onmessage (a_onmessage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onmessage=$a_onmessage" end

	onoffline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onoffline
		external "C" alias "onoffline" end

	set_onoffline (a_onoffline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onoffline=$a_onoffline" end

	ononline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_ononline
		external "C" alias "ononline" end

	set_ononline (a_ononline: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "ononline=$a_ononline" end

	onpopstate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpopstate
		external "C" alias "onpopstate" end

	set_onpopstate (a_onpopstate: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpopstate=$a_onpopstate" end

	onpagehide: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpagehide
		external "C" alias "onpagehide" end

	set_onpagehide (a_onpagehide: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpagehide=$a_onpagehide" end

	onpageshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onpageshow
		external "C" alias "onpageshow" end

	set_onpageshow (a_onpageshow: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onpageshow=$a_onpageshow" end

	onredo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onredo
		external "C" alias "onredo" end

	set_onredo (a_onredo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onredo=$a_onredo" end

	onresize: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN] assign set_onresize
		external "C" alias "onresize" end

	set_onresize (a_onresize: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN])
		external "C" alias "onresize=$a_onresize" end

	onscroll: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN] assign set_onscroll
		external "C" alias "onscroll" end

	set_onscroll (a_onscroll: FUNCTION [ANY, attached TUPLE [attached JS_UI_EVENT], BOOLEAN])
		external "C" alias "onscroll=$a_onscroll" end

	onstorage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onstorage
		external "C" alias "onstorage" end

	set_onstorage (a_onstorage: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onstorage=$a_onstorage" end

	onundo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onundo
		external "C" alias "onundo" end

	set_onundo (a_onundo: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onundo=$a_onundo" end

	onunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onunload
		external "C" alias "onunload" end

	set_onunload (a_onunload: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onunload=$a_onunload" end
end
