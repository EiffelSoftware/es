note
	description: "Summary description for {CMS_STRING_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STRING_CHAIN_RESOLVER [G -> READABLE_STRING_GENERAL]

inherit
	CMS_STRING_RESOLVER [G]

create
	make,
	make_with_next

feature {NONE} -- Initialization

	make (a_resolver: like active)
		do
			active := a_resolver
		end

	make_with_next (a_resolver: like active; a_next: like next)
		do
			make (a_resolver)
			next := a_next
		end

feature -- Access

	value (n: READABLE_STRING_GENERAL): detachable G
		do
			Result := active.value (n)
			if Result = Void and then attached next as nxt then
				Result := nxt.value (n)
			end
		end

feature -- Access / resolvers

	active: CMS_STRING_RESOLVER [G]

	next: detachable like active

invariant
	active /= Void

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
