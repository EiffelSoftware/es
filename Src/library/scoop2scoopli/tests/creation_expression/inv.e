note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INV
inherit
	Y

invariant
		yup: test_separate_assertion(x)
    yup: test_separate_assertion(create {X}.make(True))
		yup: test_separate_assertion(create {separate X}.make(True))
		yup: test_separate_assertion(create {separate <x.handler> X}.make(True))
	--	yup: test_separate_assertion(create {separate <p> X}.make(True))
end
