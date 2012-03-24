note
	description: "Indefinite loop instruction."
	terminology: "Called LOOP1 because `loop' is an Eiffel keyword"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOOP1

inherit
	REPETITION

feature -- Initialization

feature -- Input and output

	out: STRING
			-- Printable representation of conditional.
		do
			Result :=
					tabs + "loop" + New_line +
					body.out +
					tabs + "end"+ New_line
		end

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by loop.
		local
			other, next: ALIAS_RELATION
			original: ALIAS_RELATION
			next_power, accumulated_powers: ALIAS_RELATION
			is_fixpoint: BOOLEAN
			i: INTEGER
		do
			debug ("LOOP")
				a.printout ("before iterations")
			end

			from
				original := a.deep_twin
				accumulated_powers := a.deep_twin
				next := a -- Make sure this variable is set as it is used after a loop.
			until is_fixpoint loop
				other := a.deep_twin
				next := a.deep_twin
				i := i + 1
				iterate (next, i)
				a.add (next)
				is_fixpoint := (a ~ other)
				next_power := power (original, i)
				accumulated_powers := all_powers (original, i)
				debug ("LOOP")
					next_power.printout ("p [" + i.out + "]")
					accumulated_powers.printout ("s [" + i.out + "]")
					a.printout ("t [" + i.out + "]")
				end
				if a /~ accumulated_powers then
					io.put_string ("== Not identical: " + a.difference (accumulated_powers) + " ==%N" )
				end
			end
			debug ("LOOP")
				io.put_string ("Iterating once more to check fixpoint reached:%N")
				i := i + 1
				iterate (next, i)
				a.add (next)
				a.printout ("t [" + i.out + "]")
			end

		end

	power (a: ALIAS_RELATION; i: INTEGER): ALIAS_RELATION
				-- Result of `i' iterations of the body, starting from `a'.
				-- Not cumulated.
			require
				relation_exists: a /= Void
				non_negative: i >= 0
			local
				it: ITER
			do
				create it.make (i)
				it.body := body
				Result := a.deep_twin
				Result.update (it)
			ensure
				created: Result /= Void
			end

	all_powers (a: ALIAS_RELATION; i: INTEGER): ALIAS_RELATION
				-- Cumulated result of 0, 1, ...  `i' iterations
				-- of the body, starting from `a'.
			require
				relation_exists: a /= Void
				non_negative: i >= 0
			do
				Result := a.deep_twin
				across 1 |..| i as aa loop
					Result.add (power (a, aa.target_index))
				end
			ensure
				created: Result /= Void
			end


end
