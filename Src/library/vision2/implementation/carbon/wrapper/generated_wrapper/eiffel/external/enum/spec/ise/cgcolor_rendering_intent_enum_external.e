-- enum wrapper
class CGCOLOR_RENDERING_INTENT_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcgrenderingintentdefault or a_value = kcgrenderingintentabsolutecolorimetric or a_value = kcgrenderingintentrelativecolorimetric or a_value = kcgrenderingintentperceptual or a_value = kcgrenderingintentsaturation
		end

	kcgrenderingintentdefault: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGRenderingIntentDefault"
		end

	kcgrenderingintentabsolutecolorimetric: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGRenderingIntentAbsoluteColorimetric"
		end

	kcgrenderingintentrelativecolorimetric: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGRenderingIntentRelativeColorimetric"
		end

	kcgrenderingintentperceptual: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGRenderingIntentPerceptual"
		end

	kcgrenderingintentsaturation: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGRenderingIntentSaturation"
		end

end
