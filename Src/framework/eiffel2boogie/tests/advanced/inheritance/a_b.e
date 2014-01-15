class
	A_B

inherit
	A_A
		redefine
			prev,
			break
		end

feature
	prev: A_B
		-- Redefined.

	-- set_x: fails

	-- set_to_next: fails since inv_without is bound statically, so new invariant is not available

	-- set_to_next_public succeeds, as the new invariant holds at the start

	-- set_to_prev_public succeeds, since the type of prev has been redefined

	use_break (other: A_A)
		note
			explicit: wrapping
		require
			other_wrapped: other.is_wrapped
			modify (Current, other)
		do
			break
			check x > 0 end
			prev := Current
			wrap

			other.break
			check almost_holds: other.inv_without ("prev_exists") end
			check new_property: other.x > 0 end -- Fail
			other.set_prev
			other.wrap -- Fail: dynamic type unknown
		end

feature {A_A}

	break
		do
			check new_property: prev.x > 0 end -- Fail
			unwrap
			prev := Void
		ensure then
			still_almost_holds: inv_without ("prev_exists")
		end

invariant
	next_is_b: attached {A_B} next
	x_positive: x > 0
end
