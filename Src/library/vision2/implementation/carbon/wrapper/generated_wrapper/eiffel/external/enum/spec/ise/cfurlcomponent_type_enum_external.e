-- enum wrapper
class CFURLCOMPONENT_TYPE_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcfurlcomponentscheme or a_value = kcfurlcomponentnetlocation or a_value = kcfurlcomponentpath or a_value = kcfurlcomponentresourcespecifier or a_value = kcfurlcomponentuser or a_value = kcfurlcomponentpassword or a_value = kcfurlcomponentuserinfo or a_value = kcfurlcomponenthost or a_value = kcfurlcomponentport or a_value = kcfurlcomponentparameterstring or a_value = kcfurlcomponentquery or a_value = kcfurlcomponentfragment
		end

	kcfurlcomponentscheme: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentScheme"
		end

	kcfurlcomponentnetlocation: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentNetLocation"
		end

	kcfurlcomponentpath: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentPath"
		end

	kcfurlcomponentresourcespecifier: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentResourceSpecifier"
		end

	kcfurlcomponentuser: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentUser"
		end

	kcfurlcomponentpassword: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentPassword"
		end

	kcfurlcomponentuserinfo: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentUserInfo"
		end

	kcfurlcomponenthost: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentHost"
		end

	kcfurlcomponentport: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentPort"
		end

	kcfurlcomponentparameterstring: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentParameterString"
		end

	kcfurlcomponentquery: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentQuery"
		end

	kcfurlcomponentfragment: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFURLComponentFragment"
		end

end
