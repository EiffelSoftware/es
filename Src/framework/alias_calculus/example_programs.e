note
	description: "Sample programs."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXAMPLE_PROGRAMS

inherit
	BUILDER
	APPLICATION_CONSTANTS

feature -- Examples from the paper

	ex1_simple_assignments
			-- Build a program consisting of some assignments.
			-- Initial instructions are there just to set a starting
			-- alias relations for the final assignment.
			-- Example 1 of the paper.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, z)
				start_then
					set (c, b)
					set (x, b)
				start_else
					set (gg, ff)
					set (x, ff)
				end_if
				set (z, ff)
				snap ("END")
				printsnap ("END")
			end_procedure
		end

	ex2_conditional
			-- Build a program.
			-- Example 2 of the article.
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (c, b)
				start_else
					set (ff, gg)
				end_if
				start_then
					set (x, b)
				start_else
					set (x, ff)
					set (z, y)
				end_if
			end_procedure
		end

	ex3_iter0
			-- Build a repetition (0 iteration).
			-- Example 3 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (0)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex4_iter1
			-- Build a repetition (1 iteration).
			-- Example 4 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (1)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex5_iter2
			-- Build a repetition (2 iterations).
			-- Example 5 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (2)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex6_iter3
			-- Build a repetition (3 iteration).
			-- Example 6 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (3)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex7_iter4
			-- Build a repetition (4 iterations).
			-- Example 7 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (4)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex8_iter5
			-- Build a repetition (5 iterations).
			-- Example 8 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_iter (5)
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_iter
			end_procedure
		end

	ex9_loop
			-- Build a loop.
			-- Example 9 of the program.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (y, c)
				set (z, d)
				start_loop
					-- The part to be repeated
					set (x, y)
					set (y, z)
					set (z, x)
				end_loop
			end_procedure
		end

	ex10_moderately_complex
			-- Build an E0 program without procedures..
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					set (x, a)
				end_if
				start_then
					cut (x, y)
					set (z, x)
				start_else
				end_if
				set (gg, hh)
				set (x, y)
				set (z, a)
				set (b, x)
				start_loop
					set (ee, ff)
					set (a, ee)
				end_loop
				start_loop
					start_then
						set (c, b)
						set (a, ff)
						set (gg, x)
					start_else
						set (c, a)
						set (a, gg)
					end_if
					set (ff, x)
				end_loop

				set (b, z)
				forget (b)
				set (a, ee)
				creator (z)
				set (a, hh)
				cut (a, gg)
				creator (x)
			end_procedure
		end

	ex11_recursive1
			-- Build a program, using a recursive procedure.
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					set (x, a)
					call ("Main")
				end_if
			end_procedure
		end

	ex12_recursive2
			-- Build a program, using a recursive procedure.
			-- Slight modification of the previous one.
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					call ("Main")
					set (x, a)
				end_if
			end_procedure

		end

	ex13_mutually_recursive_1
			-- Build a program, using two simple mutually recursive procedures.
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					set (x, a)
					call ("q")
				end_if
			end_procedure
			start_procedure ("q")
				set (x, b)
				start_then
					call ("Main")
				start_else
					set (a, c)
				end_if
			end_procedure
		end

	ex14_mutually_recursive_2
			-- Build a program, using two mutually recursive procedures.
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					set (x, a)
				end_if
				start_then
					cut (x, y)
					set (z, x)
				start_else
				end_if
				start_then
					call ("q")
				start_else
					set (gg, hh)
				end_if
				set (x, y)
				set (z, a)
				set (b, x)
				start_loop
					set (ee, ff)
					start_then
						set (a, ee)
					start_else
					end_if
				end_loop
				start_then
					set (c, b)
					set (a, ff)
					set (gg, x)
				start_else
					start_loop
						set (c, a)
						set (a, gg)
					end_loop
--					The following line used to cause a postcondition violation in is_deep_equal!
					call ("Main")
				end_if

				set (ff, x)

				set (b, z)
				forget (b)
				set (a, ee)
				creator (z)
				set (a, hh)
				cut (a, gg)
				creator (x)
			end_procedure
			start_procedure ("q")
				start_then
					set (mm, nn)
				start_else
					set (mm, hh)
					call ("Main")
				end_if
			end_procedure

		end

	ex15_multidot_1
			-- Build a program consisting of some assignments.
			-- Some of them are multidot, e.g. x := x.a.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (x, y)
				set (a, b)
				set (z, x_a)
				set (x, x_a)
			end_procedure
		end

	ex16_qualified
			-- Build a program, using qualified calls.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (ff, x_a)
				qualified (x, "q")
			end_procedure
			start_procedure ("q")
				set (b, xprime)
				set (c, xprime_f)
				set (d, b)
			end_procedure
		end

	ex17_qualified
			-- Build a program, using qualified calls and argument passing on client side.
		do
			start_program ("Main")
			start_procedure ("Main")
				set (ff, x_a)
				set (q_client, x)
				qualified (q_client, "q")
			end_procedure
			start_procedure ("q")
				set (b, q_client_prime)
				set (c, q_client_prime_f)
				set (d, b)
			end_procedure
		end

	ex18_lists
			-- Build a program, showing non-aliasing of list elements.
		do
			start_program ("Main")

			start_procedure ("Main")
				call ("build")
				set (ff, x_first)
				set (gg, y_first)
				start_loop
					start_then
						set (ff, f_right)
					start_else
						set (gg, g_right)
					end_if
				end_loop
			end_procedure

			start_procedure ("build")
				set (extend_client, x)
				start_loop
					creator (el)
					qualified (x, "extend")
				end_loop
				set (extend_client, y)
				start_loop
					creator (el)
					qualified (y, "extend")
				end_loop
			end_procedure

			start_procedure ("extend")
				set (a, extend_client_prime_el)
				start_then
					creator (first1)
					set (last1, first1)
				start_else
					set (last1, first1)
				end_if
				start_loop
					set (last1, last_right)
				end_loop
				creator (new)
				qualified (new, "set")
				qualified  (last1, "set_right")
			end_procedure

			start_procedure ("set")
				set (item1, new_prime_a)
			end_procedure

			start_procedure ("set_right")
				set (right1, last_prime_new)
			end_procedure


		end

	ex19_lists
			-- Build a program, showing aliasing of list elements.			
		do
			start_program ("Main")

			start_procedure ("Main")
				set (x, y)
				call ("build")
				set (ff, x_first)
				set (gg, y_first)
				start_loop
					start_then
						set (ff, f_right)
					start_else
						set (gg, g_right)
					end_if
				end_loop
			end_procedure

			start_procedure ("build")
				set (extend_client, x)
				start_loop
					creator (el)
					qualified (x, "extend")
				end_loop
				set (extend_client, y)
				start_loop
					creator (el)
					qualified (y, "extend")
				end_loop
			end_procedure

			start_procedure ("extend")
				set (a, extend_client_prime_el)
				start_then
					creator (first1)
					set (last1, first1)
				start_else
					set (last1, first1)
				end_if
				start_loop
					set (last1, last_right)
				end_loop
				creator (new)
				qualified (new, "set")
				qualified  (last1, "set_right")
			end_procedure

			start_procedure ("set")
				set (item1, new_prime_a)
			end_procedure

			start_procedure ("set_right")
				set (right1, last_prime_new)
			end_procedure
		end

	ex20_deadlock
			-- Build a program, with a routine causing deadlock and the other not.
		do
			start_program ("Main") -- Procedure `make' of MEAL
			start_procedure ("Main")
				creator (f1) ; creator (f2)
				creator (p2)

				-- Creation call create p1.make (f1, f2)
				creator (p1)
				set (pmc, p1)
				set (pma1, f1) ; set (pma2, f2)
				qualified (p1, "philosopher_make_1")

				-- Creation call create p2.make (f2, f1)
				creator (p2)
				set (pmc, p2)
				set (pma1, f2) ; set (pma2, f1)
				qualified (p2, "philosopher_make_2")
			end_procedure

			start_procedure ("philosopher_make_1")
				set (pmx, p1_prime_actual1); set (pmy, p1_prime_actual2);
				set (left, pmx)
				set (right, pmy)
			end_procedure

			start_procedure ("philosopher_make_2")
				set (pmx, p2_prime_actual1); set (pmy, p2_prime_actual2);
				set (left, pmx)
				set (right, pmy)
			end_procedure

		end

	ex21_deadlock
			-- Build a program, with a routine causing deadlock and the other not.
			-- Version with better argument handling
		do
			start_program ("Main") -- Procedure `make' of MEAL
			start_procedure ("Main")
				creator (f1) ; creator (f2)
				creator (p2)

				-- Creation call create p1.make (f1, f2)
				creator (p1)
				set (pmc, p1)
				set (pma1, f1) ; set (pma2, f2)
				qualified (pmc, "philosopher_make")

				-- Creation call create p2.make (f2, f1)
--				creator (p2)
--				set (pmc, p2)
--				set (pma1, f2) ; set (pma2, f1)
--				qualified (pmc, "philosopher_make")
			end_procedure

			start_procedure ("philosopher_make")
--				set (pmx, pmc_prime_actual1); set (pmy, pmc_prime_actual2);
				set (left, pmc_prime_actual1)
				set (right, pmc_prime_actual2)
			end_procedure

		end

	ex22_qualified
			-- Build a program with argument passing to a qualified call.
		do
			start_program ("Main")
			start_procedure ("Main")
--				set (ff, a)
				set (target, x)
				printout ("before first call")
				qualified (target, "p")
--				set (target, y)
--				set (ff, b)
--				printout ("before second call")
--				qualified (target, "p")
			end_procedure

			start_procedure ("p")
				printout ("procedure entry")
				set (v, target_prime_f)
				printout ("after argument passing")
--				set (z, v)
				printout ("procedure exit")
			end_procedure

		end

	ex23_gerasimov
			-- Gerasimov's recursion example ("Program 1")).
		do
			start_program ("Main")
			start_procedure ("Main")
				start_then
					set (x, y)
				start_else
					set (x, a)
					call ("q")
				end_if
			end_procedure

			start_procedure ("q")
				set (x, b)
				start_then
					call ("Main")
				start_else
					set (a, c)
				end_if
			end_procedure

		end


feature -- Other examples

	build_iter_simulated
			-- Build a repetition, not using the iteration construct.
			-- Should no longer be useful, was a kludge before ITER
			-- construct was implemented.
		do
			start_program ("p")
			start_procedure ("p")
				set (y, c)
				set (z, d)

					-- The part to be repeated (here I am copy-pasting it manually!)
					set (x, y)
					set (y, z)
					set (z, x)

					set (x, y)
					set (y, z)
					set (z, x)

					set (x, y)
					set (y, z)
					set (z, x)
			end_procedure
		end

end
