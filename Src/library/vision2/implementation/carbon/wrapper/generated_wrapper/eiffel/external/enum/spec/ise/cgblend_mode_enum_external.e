-- enum wrapper
class CGBLEND_MODE_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcgblendmodenormal or a_value = kcgblendmodemultiply or a_value = kcgblendmodescreen or a_value = kcgblendmodeoverlay or a_value = kcgblendmodedarken or a_value = kcgblendmodelighten or a_value = kcgblendmodecolordodge or a_value = kcgblendmodecolorburn or a_value = kcgblendmodesoftlight or a_value = kcgblendmodehardlight or a_value = kcgblendmodedifference or a_value = kcgblendmodeexclusion or a_value = kcgblendmodehue or a_value = kcgblendmodesaturation or a_value = kcgblendmodecolor or a_value = kcgblendmodeluminosity
		end

	kcgblendmodenormal: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeNormal"
		end

	kcgblendmodemultiply: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeMultiply"
		end

	kcgblendmodescreen: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeScreen"
		end

	kcgblendmodeoverlay: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeOverlay"
		end

	kcgblendmodedarken: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeDarken"
		end

	kcgblendmodelighten: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeLighten"
		end

	kcgblendmodecolordodge: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeColorDodge"
		end

	kcgblendmodecolorburn: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeColorBurn"
		end

	kcgblendmodesoftlight: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeSoftLight"
		end

	kcgblendmodehardlight: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeHardLight"
		end

	kcgblendmodedifference: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeDifference"
		end

	kcgblendmodeexclusion: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeExclusion"
		end

	kcgblendmodehue: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeHue"
		end

	kcgblendmodesaturation: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeSaturation"
		end

	kcgblendmodecolor: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeColor"
		end

	kcgblendmodeluminosity: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGBlendModeLuminosity"
		end

end
