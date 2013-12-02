note
	description: "Summary description for {CA_CFG_TRAVERSAL_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	CA_CFG_TRAVERSAL_INFO

inherit
	ANY
		redefine default_create end

feature -- Properties

	default_create
		do
			traverse_default := True
		end

	traverse_default: BOOLEAN

	traverse_false: BOOLEAN
		do
			Result := traverse_default
		end

	set_traverse_default (a_t: BOOLEAN)
		do
			traverse_default := a_t
		end

	set_traverse_false (a_t: BOOLEAN)
		do
			traverse_default := a_t
		end

	traverse_true: BOOLEAN

	set_traverse_true (a_t: BOOLEAN)
		do
			traverse_true := a_t
		end

	traverse_loop: BOOLEAN
		do
			Result := traverse_true
		end

	set_traverse_loop (a_t: BOOLEAN)
		do
			traverse_true := a_t
		end

end
