-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:Location"
class
	JS_LOCATION

feature -- Basic Operation

	href: STRING assign set_href
			-- Returns the current page's location. Can be set, to navigate to another
			-- page.
		external "C" alias "href" end

	set_href (a_href: STRING)
			-- See href
		external "C" alias "href=$a_href" end

	js_assign (a_url: STRING)
			-- Navigates to the given page.
		external "C" alias "assign($a_url)" end

	replace (a_url: STRING)
			-- Removes the current page from the session history and navigates to the given
			-- page.
		external "C" alias "replace($a_url)" end

	reload
			-- Reloads the current page.
		external "C" alias "reload()" end

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

feature -- resolving relative URLs

	resolve_url (a_url: STRING): STRING
			-- Resolves the given relative URL to an absolute URL.
		external "C" alias "resolveURL($a_url)" end
end
