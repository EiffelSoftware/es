indexing
	description : "Wrapper for anynymous enums from file TextEdit.h"

class
	TEXTEDIT_ANON_ENUMS

feature -- Carbon constants
	
	frozen teJustLeft: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustLeft"
	end	

	frozen teJustCenter: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustCenter"
	end
	
	frozen teJustRight: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustRight"
	end
	
	frozen teForceLeft: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustForceLeft"
	end
	
	frozen teFlushDefault: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustFlushDefault"
	end

	frozen teCenter: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teCenter"
	end

	frozen teFlushRight: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustFlushRight"
	end

	frozen teFlushLeft: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"teJustFlushLeft"
	end
	
end
