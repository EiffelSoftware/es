note
	description : "alias_calculus application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS
	SIZING
	EXAMPLE_PROGRAMS

create
	make

feature {NONE} -- Initialization

	make
			-- Build a program and compute its aliases.
		do
			create aliases.make
			create {COMPOUND} scope.make
			fill_examples
			get_environment_example_number
			from until example_number = 0 loop
				get_next_example_number
				if example_number > 0 then
					execute_example
				end
				known := False
				if automatic then
					known := True
					example_number := previous + 1
					if example_number > example_count then
						example_number := 0
					end
				elseif just_one then
					example_number := 0
				end
			end
		end

feature -- Access

	automatic: BOOLEAN
			-- Is execution being run on all examples?

	example_count: INTEGER
			-- Number of examples.

	examples: ARRAY [TUPLE [prog: PROCEDURE [APPLICATION, TUPLE]; tag: STRING; comment: STRING]]
			-- Example programs for alias computation.
		once
			create Result.make_empty
		end

	example_number: INTEGER
			-- Index of current example.

	previous: INTEGER
			-- Index of previous example if any.

	known: BOOLEAN
			-- Do we know which example to execute next?

	just_one: BOOLEAN
			-- Are we in a mode where we execute one example and stop?

	aliases: ALIAS_RELATION
			-- Alias relation being built.

feature -- Status report

	OK: BOOLEAN
			-- Was a program found and executed?

feature -- Element change

	put_example (prog: PROCEDURE [APPLICATION, TUPLE]; tag: STRING; comment: STRING)
			-- Add example `prog' with `tag' at next available position.
		require
			prog_exists: prog /= Void
			tag_exists: tag /= Void
			comment_exists: comment /= Void
		local
			i: INTEGER
		do
			example_count := example_count + 1
			i := examples.lower + example_count - 1
			examples.force ([prog, tag, comment], i)
		end

			get_environment_example_number
			-- Obtain first example number, if available from
			-- execution arguments, into `example_number'.
			-- Set `known' if successful.
		local
			arg: STRING
		do
			example_number := -1 ; automatic := False
			if argument_count > 0 then
				arg := argument (1)
				if arg.is_integer  then
					example_number := arg.to_integer
					if example_number = 0 then
						automatic := True
						example_number := 1
					end
					known := True
				end
				just_one := (argument_count > 1)
			end
		end


	get_next_example_number
			-- Obtain first example number, interactively if necessary,
			-- into `example_number'. Set `known' if successful.
		local
			s: STRING
			pn: INTEGER
		do
			if not known then
				example_number := -1
				from until example_number >= 0 loop
					display_examples
					pn := previous + 1
					print ("%NNext example%N(enter number, or Return for next (" + pn.out + "), `,' for previous, 0 to exit): ")
					io.read_line
					s := io.last_string
					if s /= Void then
						if s.is_empty or s ~ "." then
							example_number := previous + 1 ; if example_number <= 0 then example_number := 1 end
						elseif s ~ "," then
							example_number := previous - 1 ; if example_number <= 0 then example_number := 1 end
						elseif s.is_integer then
							example_number := s.to_integer
						end
					end
				end
			end
		end

	fill_examples
			-- Add built-in examples.
		do
			put_example (agent ex1_simple_assignments, "Example 1 of the article: assignment", "[
						This is example 1 of the article.
						
						Note that only the last instruction illustrates the example directly;
						The initial instructions, using compound and conditional (introduced
						in later sections of the paper) are there to set the starting
						alias relation for the final assignment.
						]")

			put_example (agent ex2_conditional, "Example 2 of the article: conditional", "[
						This is example 2 of the article.
						
						The initial conditional is there to set up the starting alias relation.
						]")

			put_example (agent ex3_iter0, "Example 3 of the article: iteration (0 time)", "This is example 3 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is zero.")
			put_example (agent ex4_iter1, "Example 4 of the article: iteration (1 times)", "This is example 4 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is one.")
			put_example (agent ex5_iter2, "Example 5 of the article: iteration (2 times)", "This is example 5 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is two.")
			put_example (agent ex6_iter3, "Example 6 of the article: iteration (3 times)", "This is example 6 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is three.")
			put_example (agent ex7_iter4, "Example 7 of the article: iteration (4 times)", "This is example 7 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is four.")
			put_example (agent ex8_iter5, "Example 8 of the article: iteration (5 times)", "This is example 8 of the article.%NThe initial instructions are there to set up the starting alias relation.%NThe number of iterations is five.")

			put_example (agent ex9_loop, "Example 9 of the article: loop", "This is example 9 of the article.")
			put_example (agent ex10_moderately_complex, "Example 10 of the article: combination of all E0 constructs", "This is example 10 of the article.")
			put_example (agent ex11_recursive1, "Example 11 of the article: recursive procedure, first version", "This is example 11 of the article.")
			put_example (agent ex12_recursive2, "Example 12 of the article: recursive procedure, second version", "This is example 12 of the article.")
			put_example (agent ex13_mutually_recursive_1, "Example 13 of the article: mutually recursive procedures", "This is example 13 of the article.")
			put_example (agent ex14_mutually_recursive_2, "Example 14 of the article: mutually recursive procedures", "This is example 14 of the article.")
			put_example (agent ex15_multidot_1, "Example 15 of the article: simple multidot expressions", "This is example 15 of the article.")
			put_example (agent ex16_qualified, "Example 16 of the article: qualified call", "This is example 16 of the article.")
			put_example (agent ex17_qualified, "Example 17 of the article: qualified call, arguments on client side", "This is example 17 of the article.")
			put_example (agent ex18_lists, "Example 18 of the article: lists, no aliasing", "This is example 18 of the article.")
			put_example (agent ex19_lists, "Example 19 of the article: lists, aliasing", "This is example 19 of the article.")
			put_example (agent ex20_deadlock, "Example 20, not in the article: deadlock", "This is example 20, not in the article.")
			put_example (agent ex21_deadlock, "Example 21, not in the article: deadlock variant", "This is example 21, not in the article.")
			put_example (agent ex22_qualified, "Example 22, not in the article: qualified call with argument handling", "This is example 22, not in the article.")
		end


feature -- Basic operations

	build_program
				-- Build the example program for the example at index `example_number'.
		require
			big_enough: example_number >= examples.lower
			small_enough: example_number <= examples.upper
			meaningful: examples [example_number] /= Void
			ok: OK
		local
			prog: PROCEDURE [APPLICATION, TUPLE]
			example_tuple: TUPLE [prog: PROCEDURE [APPLICATION, TUPLE]; tag: STRING; comment: STRING]
			tag, comment: STRING
		do
			example_tuple := examples [example_number]
			check example_tuple /= Void end
			prog := example_tuple.prog; tag := example_tuple.tag; comment := example_tuple.comment
			check tag /= Void end
			print ("%N--- Example " + example_number.out + ": " + tag + " ---%N%N")
			if not comment.is_empty then
				print ("%N" + comment + "%N%N")
			end
			prog.call ([])
		end

	compute_aliases
			-- Compute aliases.
		require
			attached {PROGRAM} scope
		do
			if attached {PROGRAM} scope as pr then
				pr.update (aliases)
			end
		end

	execute_example
			-- Execute example of index `example_number', if meaningful.
			-- If so, set `OK'; if not, make `OK' false.
		local
			example_tuple: TUPLE [prog: PROCEDURE [APPLICATION, TUPLE]; comment: STRING]
		do
			create aliases.make
			create {PROGRAM} scope.make ("p")
			OK := False
			if example_number < examples.lower or example_number > examples.upper then
				print ("No example at index " + example_number.out + "; program number must be between " + examples.lower.out + " and " + examples.upper.out + "%N")
			else
				example_tuple := examples [example_number]
				if example_tuple = Void then
					if not automatic then print ("No example at index " + example_number.out + "%N") end
				else
					OK := True
					build_program
					if not automatic then
						scope.display
					end
					compute_aliases
					if not automatic then
						print ("%NPress Return to compute the alias relation ")
						io.read_line
					end
					print_aliases
					previous := example_number
				end
			end
		end


feature -- Input and output

	print_aliases
			-- Print a list of aliases computed.
		do
			aliases.printout ("%NComputed alias relation")
		end

	display_examples
			-- Present a list of available programs.
		local
			example_tuple: TUPLE [prog: PROCEDURE [APPLICATION, TUPLE]; tag: STRING]
			tag, blank: STRING
			i: INTEGER
		do
			from
				i := examples.lower
				print ("%N________________________________________________________%NAvailable example programs: %N%N")
			until
				i > examples.upper
			loop
				example_tuple := examples [i]
				if example_tuple /= Void then
					blank := ": " ; if i < 10 then blank := ":  " end
					tag := example_tuple.tag
					print (i.out + blank + tag + "%N")
				end
				i := i + 1
			end
		end

invariant
	scope_exists: scope /= Void
	aliases_exist: aliases /= Void
	examples_fit: example_count <= examples.count
end
