-- enum wrapper
class CGLINE_JOIN_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = kcglinejoinmiter or a_value = kcglinejoinround or a_value = kcglinejoinbevel
		end

	kcglinejoinmiter: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGLineJoinMiter"
		end

	kcglinejoinround: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGLineJoinRound"
		end

	kcglinejoinbevel: INTEGER is
		external
			"C macro use <Carbon/Carbon.h>"
		alias
			"kCGLineJoinBevel"
		end

end
