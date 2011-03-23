-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLAreaElement"
class
	JS_HTML_AREA_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('area')" end

feature -- Basic Operation

	alt: STRING assign set_alt
		external "C" alias "alt" end

	set_alt (a_alt: STRING)
		external "C" alias "alt=$a_alt" end

	coords: STRING assign set_coords
		external "C" alias "coords" end

	set_coords (a_coords: STRING)
		external "C" alias "coords=$a_coords" end

	shape: STRING assign set_shape
		external "C" alias "shape" end

	set_shape (a_shape: STRING)
		external "C" alias "shape=$a_shape" end

	href: STRING assign set_href
		external "C" alias "href" end

	set_href (a_href: STRING)
		external "C" alias "href=$a_href" end

	target: STRING assign set_target
		external "C" alias "target" end

	set_target (a_target: STRING)
		external "C" alias "target=$a_target" end

	rel: STRING assign set_rel
		external "C" alias "rel" end

	set_rel (a_rel: STRING)
		external "C" alias "rel=$a_rel" end

	rel_list: JS_DOM_TOKEN_LIST
		external "C" alias "relList" end

	media: STRING assign set_media
		external "C" alias "media" end

	set_media (a_media: STRING)
		external "C" alias "media=$a_media" end

	hreflang: STRING assign set_hreflang
		external "C" alias "hreflang" end

	set_hreflang (a_hreflang: STRING)
		external "C" alias "hreflang=$a_hreflang" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

feature -- URL decomposition IDL attributes

	protocol: STRING assign set_protocol
		external "C" alias "protocol" end

	set_protocol (a_protocol: STRING)
		external "C" alias "protocol=$a_protocol" end

	host: STRING assign set_host
		external "C" alias "host" end

	set_host (a_host: STRING)
		external "C" alias "host=$a_host" end

	hostname: STRING assign set_hostname
		external "C" alias "hostname" end

	set_hostname (a_hostname: STRING)
		external "C" alias "hostname=$a_hostname" end

	port: STRING assign set_port
		external "C" alias "port" end

	set_port (a_port: STRING)
		external "C" alias "port=$a_port" end

	pathname: STRING assign set_pathname
		external "C" alias "pathname" end

	set_pathname (a_pathname: STRING)
		external "C" alias "pathname=$a_pathname" end

	search: STRING assign set_search
		external "C" alias "search" end

	set_search (a_search: STRING)
		external "C" alias "search=$a_search" end

	hash: STRING assign set_hash
		external "C" alias "hash" end

	set_hash (a_hash: STRING)
		external "C" alias "hash=$a_hash" end
end
