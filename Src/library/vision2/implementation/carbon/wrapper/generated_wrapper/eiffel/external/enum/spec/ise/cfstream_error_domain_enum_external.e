-- enum wrapper
class CFSTREAM_ERROR_DOMAIN_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcfstreamerrordomaincustom or a_value = kcfstreamerrordomainposix or a_value = kcfstreamerrordomainmacosstatus
		end

	kcfstreamerrordomaincustom: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStreamErrorDomainCustom"
		end

	kcfstreamerrordomainposix: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStreamErrorDomainPOSIX"
		end

	kcfstreamerrordomainmacosstatus: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCFStreamErrorDomainMacOSStatus"
		end

end
