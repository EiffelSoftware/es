-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:MediaError"
class
	JS_MEDIA_ERROR

feature -- Basic Operation

	MEDIA_ERR_ABORTED: INTEGER
			-- The fetching process for the media resource was aborted by the user agent at
			-- the user's request.
		external "C" alias "#1" end

	MEDIA_ERR_NETWORK: INTEGER
			-- A network error of some description caused the user agent to stop fetching
			-- the media resource, after the resource was established to be usable.
		external "C" alias "#2" end

	MEDIA_ERR_DECODE: INTEGER
			-- An error of some description occurred while decoding the media resource,
			-- after the resource was established to be usable.
		external "C" alias "#3" end

	MEDIA_ERR_SRC_NOT_SUPPORTED: INTEGER
			-- The media resource indicated by the src attribute was not suitable.
		external "C" alias "#4" end

	code: INTEGER
			-- Returns the current error's error code, from the list above.
		external "C" alias "code" end
end
