note
	description: "Dispensers where the latest added element is accessible."
	author: "Nadia Polikarpova"
	model: sequence
	manual_inv: true
	false_guards: true

deferred class
	V_STACK [G]

inherit
	V_DISPENSER [G]
		redefine
			extend
		end

feature -- Comparison

	is_equal_ (other: like Current): BOOLEAN
			-- Is list made of the same values in the same order as `other'?
			-- (Use reference comparison.)
		note
			status: impure
		require
			modify_model ("observers", [Current, other])
		local
			i, j: V_ITERATOR [G]
		do
			if other = Current then
				Result := True
			elseif count = other.count then
				from
					Result := True
					i := new_cursor
					j := other.new_cursor
				invariant
					1 <= i.index_ and i.index_ <= sequence.count + 1
					i.index_ = j.index_
					if Result
						then across 1 |..| (i.index_ - 1) as k all sequence [k.item] = other.sequence [k.item] end
						else sequence [i.index_ - 1] /= other.sequence [i.index_ - 1] end
					i.is_wrapped and j.is_wrapped
					modify_model ("index_", [i, j])
				until
					i.after or not Result
				loop
					Result := i.item = j.item
					i.forth
					j.forth
				variant
					sequence.count - i.index_
				end
				forget_iterator (i)
				other.forget_iterator (j)
			end
		ensure
			definition: Result = (sequence ~ other.sequence)
			observers_restored: observers ~ old observers
		end

feature -- Extension

	extend (v: G)
			-- Push `v' on the stack.
		deferred
		ensure then
			sequence_effect: sequence ~ old sequence.prepended (v)
		end

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
