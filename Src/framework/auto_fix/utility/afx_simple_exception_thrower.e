note
	description: "Summary description for {AFX_SIMPLE_EXCEPTION_THROWER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AFX_SIMPLE_EXCEPTION_THROWER

feature

	throw_exception (a_msg: STRING)
		local
			l_exception: DEVELOPER_EXCEPTION
		do
			create l_exception
			l_exception.set_description (a_msg)
			l_exception.raise
		end
end
