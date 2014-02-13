note
	description: "Summary description for {PR_ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PR_ERROR

inherit
	ANY
		redefine
			out
		end

create
	default_create,
	make

feature
	make
		local
			l_cstring: C_STRING
			l_length: INTEGER_32
		do
			code := c.pr_geterror
			create l_cstring.make_empty (c.pr_geterrortextlength)
			l_length := c.pr_geterrortext (l_cstring.item)
			check l_length <= l_cstring.capacity end
			create description.make_from_c (l_cstring.item)
			tag := c.get_tag(code)
		end

	code: INTEGER_32

	tag: ESTRING_8

	description: ESTRING_8

	is_timeout: BOOLEAN
		do
			Result := code = c.pr_io_timeout_error
		end

	out: STRING_8
		do
			Result := code.out + "(" + tag + "): " + description
		end

	c: PR_ERROR_C

end
