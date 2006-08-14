-- enum wrapper
class CGIMAGE_ALPHA_INFO_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcgimagealphanone or a_value = kcgimagealphapremultipliedlast or a_value = kcgimagealphapremultipliedfirst or a_value = kcgimagealphalast or a_value = kcgimagealphafirst or a_value = kcgimagealphanoneskiplast or a_value = kcgimagealphanoneskipfirst or a_value = kcgimagealphaonly
		end

	kcgimagealphanone: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaNone"
		end

	kcgimagealphapremultipliedlast: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaPremultipliedLast"
		end

	kcgimagealphapremultipliedfirst: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaPremultipliedFirst"
		end

	kcgimagealphalast: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaLast"
		end

	kcgimagealphafirst: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaFirst"
		end

	kcgimagealphanoneskiplast: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaNoneSkipLast"
		end

	kcgimagealphanoneskipfirst: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaNoneSkipFirst"
		end

	kcgimagealphaonly: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGImageAlphaOnly"
		end

end
