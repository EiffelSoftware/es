note
	description: "[
		Helper ghost objects that prevent hash set elements from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: sets
	manual_inv: true
	false_guards: true
	explicit: "all"

frozen class
	V_HASH_LOCK [G -> V_HASHABLE]

inherit
	V_LOCK [G]
		redefine
			sets
		end

feature -- Access	

	sets: MML_SET [V_HASH_SET [G]]
			-- Sets that might share elements owned by this lock.		

invariant
	valid_buckets: across sets as s all
		across s.item.set as x all
			s.item.buckets.count > 0 and then
			s.item.buckets [s.item.bucket_index (x.item.hash_code_, s.item.buckets.count)].has (x.item)
			end end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
