indexing
	description: "Summary description for {MY_CLASS3}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_CLASS3

feature --share

	shared:MY_SHARED


	put_shared(a_shared:MY_SHARED) is
			--
		do
			shared := a_shared
		end


end
