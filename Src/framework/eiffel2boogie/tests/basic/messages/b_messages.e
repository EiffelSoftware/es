class B_MESSAGES

feature -- Successful verification

	verification_successful (a, b, c: INTEGER)
		require
			tag1: a > 0
			b > 0
			tag2: c > 0
		do
		end

feature -- Check violation

	check_fails (a: INTEGER)
		do
			check a > 0 end
		end

	tagged_check_fails (a: INTEGER)
		do
			check tag1: a > 0 end
		end

	multi_check_fails (a, b, c: INTEGER)
		do
			check
				tag1: a > 0
				b > 0
				tag2: c > 0
			end
		end

feature -- Postcondition violation

	postcondition_fails: INTEGER
		do
		ensure
			Result > 0
		end

	tagged_postcondition_fails: INTEGER
		do
		ensure
			tag1: Result > 0
		end

	multi_postcondition_fails (a: INTEGER): INTEGER
		do
			Result := a
		ensure
			tag1: Result > 0
			Result < 0
		end

feature -- Precondition violation

	precondition_fails: INTEGER
		do
			verification_successful (1, 0, 1)
		end

	tagged_precondition_fails: INTEGER
		do
			verification_successful (0, 1, 1)
		end

	multi_precondition_fails (a: INTEGER): INTEGER
		do
				-- ONLY ONE ERROR REPORTED
			verification_successful (0, 0, 0)
		end

feature -- Loop invariant violation

	loop_invariant_fails_on_entry
		local
			a: INTEGER
		do
			from
			invariant
				a < 0
			until
				a > 10
			loop
				a := a + 1
			end
		end

	tagged_loop_invariant_fails_on_entry
		local
			a: INTEGER
		do
			from
			invariant
				tag1: a < 0
			until
				a > 10
			loop
				a := a + 1
			end
		end

	multi_loop_invariant_fails_on_entry
		local
			a, b, c: INTEGER
		do
			from
			invariant
					-- ONLY ONE ERROR REPORTED
				tag1: a < 0
				b < 0
				tag2: c < 0
			until
				a > 10
			loop
				a := a + 1
			end
		end

	loop_invariant_not_maintained
		local
			a: INTEGER
		do
			from
			invariant
				a <= 0
			until
				a > 10
			loop
				a := a + 1
			end
		end

	tagged_loop_invariant_not_maintained
		local
			a: INTEGER
		do
			from
			invariant
				tag1: a <= 0
			until
				a > 10
			loop
				a := a + 1
			end
		end

	multi_loop_invariant_not_maintained
		local
			a, b, c: INTEGER
		do
			from
			invariant
					-- ONLY ONE ERROR REPORTED
				tag1: a <= 0
				b <= 0
				tag2: c <= 0
			until
				a > 10
			loop
				a := a + 1
				b := b + 1
				c := c + 1
			end
		end

feature -- Loop variant violation

	loop_variant_negative
		local
			a: INTEGER
		do
			from
			until
				a > 10
			loop
				a := a + 1
			variant
				a - 1
			end
		end

	tagged_loop_variant_negative
		local
			a: INTEGER
		do
			from
			until
				a > 10
			loop
				a := a + 1
			variant
				tag1: a - 1
			end
		end

	loop_variant_not_reduced
		local
			a: INTEGER
		do
			from
			until
				a > 10
			loop
			variant
				10 - a
			end
		end

	tagged_loop_variant_not_reduced
		local
			a: INTEGER
		do
			from
			until
				a > 10
			loop
			variant
				tag1: 10 - a
			end
		end

feature -- Class invariant
feature -- Frame violation
feature -- Void-call

	void_call_on_local: ANY
		local
			x: ANY
		do
			x.do_nothing
		end

	any_attribute: ANY

	void_call_on_attribute: ANY
		do
			any_attribute.do_nothing
		end

	void_call_on_function
		do
			void_call_on_local.do_nothing
		end

feature -- Overflow


end
