-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/cssom-view/. Copyright © 2009 W3C® (MIT, ERCIM, Keio),
		All Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:ClientRect"
class
	JS_CLIENT_RECT

feature -- Basic Operation

	top: REAL
			-- The top attribute, on getting, must return the y-coordinate, relative to the
			-- viewport origin, of the top of the rectangle box.
		external "C" alias "top" end

	right: REAL
			-- The right attribute, on getting, must return the x-coordinate, relative to
			-- the viewport origin, of the right of the rectangle box.
		external "C" alias "right" end

	bottom: REAL
			-- The bottom attribute, on getting, must return the y-coordinate, relative to
			-- the viewport origin, of the bottom of the rectangle box.
		external "C" alias "bottom" end

	left: REAL
			-- The left attribute, on getting, must return the x-coordinate, relative to
			-- the viewport origin, of the left of the rectangle box.
		external "C" alias "left" end

	width: REAL
			-- The width attribute, on getting, must return the width of the rectangle box.
			-- This is identical to right minus left.
		external "C" alias "width" end

	height: REAL
			-- The height attribute, on getting, must return the height of the rectangle
			-- box. This is identical to bottom minus top.
		external "C" alias "height" end
end
