-- enum wrapper
class CFSTRING_BUILT_IN_ENCODINGS_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcfstringencodingmacroman or a_value = kcfstringencodingwindowslatin1 or a_value = kcfstringencodingisolatin1 or a_value = kcfstringencodingnextsteplatin or a_value = kcfstringencodingascii or a_value = kcfstringencodingunicode or a_value = kcfstringencodingutf8 or a_value = kcfstringencodingnonlossyascii or a_value = kcfstringencodingutf16 or a_value = kcfstringencodingutf16be or a_value = kcfstringencodingutf16le or a_value = kcfstringencodingutf32 or a_value = kcfstringencodingutf32be or a_value = kcfstringencodingutf32le
		end

	kcfstringencodingmacroman: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingMacRoman"
		end

	kcfstringencodingwindowslatin1: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingWindowsLatin1"
		end

	kcfstringencodingisolatin1: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingISOLatin1"
		end

	kcfstringencodingnextsteplatin: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingNextStepLatin"
		end

	kcfstringencodingascii: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingASCII"
		end

	kcfstringencodingunicode: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUnicode"
		end

	kcfstringencodingutf8: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF8"
		end

	kcfstringencodingnonlossyascii: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingNonLossyASCII"
		end

	kcfstringencodingutf16: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF16"
		end

	kcfstringencodingutf16be: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF16BE"
		end

	kcfstringencodingutf16le: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF16LE"
		end

	kcfstringencodingutf32: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF32"
		end

	kcfstringencodingutf32be: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF32BE"
		end

	kcfstringencodingutf32le: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStringEncodingUTF32LE"
		end

end
