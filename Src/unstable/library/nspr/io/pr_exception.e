note
	description: "{PR_EXCEPTION} wraps NSPR errors in an exception."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PR_EXCEPTION

inherit
	DEVELOPER_EXCEPTION
		redefine
			tag
		end
create
	make

feature {NONE} -- Initialization
	make
		local
			l_cstring: C_STRING
			l_error_code: INTEGER_32
			l_length: INTEGER_64
		do
			l_error_code := c.pr_geterror
			create l_cstring.make_empty (c.pr_geterrortextlength)
			l_length := c.pr_geterrortext (l_cstring.item)
			check l_length <= l_cstring.capacity end
			c_description := l_cstring
			create tag.make_from_string_8(c.get_tag(l_error_code))
--			code := l_error_code.as_integer_32
		end

feature -- Access

--	frozen code: INTEGER
			-- Exception code

	tag: IMMUTABLE_STRING_32

feature {NONE} -- Implementation
	c: PR_ERROR_C

end
