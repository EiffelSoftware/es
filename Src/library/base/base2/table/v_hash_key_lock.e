note
	description: "[
		Helper ghost objects that prevent hash table keys from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: tables
	manual_inv: true
	false_guards: true
	explicit: "all"

frozen class
	V_HASH_KEY_LOCK [K -> V_HASHABLE]

inherit
	V_KEY_LOCK [K]
		redefine
			tables
		end

feature -- Access	

	tables: MML_SET [V_HASH_TABLE [K, ANY]]
			-- Tables that might share elements owned by this lock.

invariant
	valid_buckets: across tables as t all
		across t.item.map.domain as x all
			t.item.buckets_.count > 0 and then
			t.item.buckets_ [t.item.bucket_index (x.item.hash_code_, t.item.buckets_.count)].has (x.item)
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
