note
	description: "Streams where values can be output one by one."
	author: "Nadia Polikarpova"
	model: off_

deferred class
	V_OUTPUT_STREAM [G]

feature -- Status report

	off: BOOLEAN
			-- Is current position off scope?
		require
			closed: closed
		deferred
		ensure
			defintion: Result = off_
		end

feature -- Replacement

	output (v: G)
			-- Put `v' into the stream and move to the next position.
		require
			not_off: not off
			subjects_wrapped: across subjects as s all s.item.is_wrapped end
			modify_model (["off_", "closed"], Current)
			modify (subjects)
		deferred
		ensure
			subjects_wrapped: across subjects as s all s.item.is_wrapped end
		end

	pipe (input: V_INPUT_STREAM [G])
			-- Copy values from `input' until either `Current' or `input' is `off'.
		note
			explicit: wrapping
		require
			input_wrapped: input.is_wrapped
			input_not_current: input /= Current
			subjects_wrapped: across subjects as s all s.item.is_wrapped end
			modify (Current, subjects)
			modify_model (["box", "closed"], input)
		do
			from
			invariant
				inv
				is_wrapped
				input.is_wrapped
				subjects ~ subjects.old_
				across subjects as s all s.item.is_wrapped end
				decreases ([])
			until
				off or input.off
			loop
				output (input.item)
				input.forth
			end
		ensure
			off_effect: off_ or input.box.is_empty
		end

	pipe_n (input: V_INPUT_STREAM [G]; n: INTEGER)
			-- Copy `n' elements from `input'; stop if either `Current' or `input' is `off'.
		note
			explicit: wrapping
		require
			input_exists: input.is_wrapped
			input_not_current: input /= Current
			n_non_negative: n >= 0
			subjects_wrapped: across subjects as s all s.item.is_wrapped end
			modify_model (["box", "closed"], input)
			modify (Current, subjects)
		local
			i: INTEGER
		do
			from
				i := 1
			invariant
				inv
				is_wrapped
				input.is_wrapped
				subjects ~ subjects.old_
				across subjects as s all s.item.is_wrapped end
			until
				i > n or off or input.off
			loop
				output (input.item)
				input.forth
				i := i + 1
			variant
				n - i
			end
		end

feature -- Specification

	off_: BOOLEAN
		note
			status: ghost
		attribute
		end

invariant
	subjects_contraint: not subjects [Current]
	no_observers: observers = []

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
