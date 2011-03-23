-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:Navigator"
class
	JS_NAVIGATOR

feature -- NavigatorID

	app_name: STRING
			-- Returns the name of the browser.
		external "C" alias "appName" end

	app_version: STRING
			-- Returns the version of the browser.
		external "C" alias "appVersion" end

	platform: STRING
			-- Returns the name of the platform.
		external "C" alias "platform" end

	user_agent: STRING
			-- Returns the complete User-Agent header.
		external "C" alias "userAgent" end

feature -- NavigatorOnLine

	on_line: BOOLEAN
		external "C" alias "onLine" end

feature -- NavigatorAbilities

feature -- content handler registration

	register_protocol_handler (a_scheme: STRING; a_url: STRING; a_title: STRING)
		external "C" alias "registerProtocolHandler($a_scheme, $a_url, $a_title)" end

	register_content_handler (a_mime_type: STRING; a_url: STRING; a_title: STRING)
		external "C" alias "registerContentHandler($a_mime_type, $a_url, $a_title)" end

	yield_for_storage_updates
		external "C" alias "yieldForStorageUpdates()" end
end
