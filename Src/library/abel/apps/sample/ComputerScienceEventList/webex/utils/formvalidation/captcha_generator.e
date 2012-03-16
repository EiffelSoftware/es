indexing
	description: "Objects that provide captchas and corresponding validation."
	author: "Marco Piccioni"
	date: "17.1.2011"
	revision: "0.1"

class
	CAPTCHA_GENERATOR
create
	make

feature {NONE}-- Creation

	make
			-- Initialize data structure and randomizer.
		local
			t: TIME
		once
			captchas := <<"What is 0 plus 1?",
			"What is 2 times 1?",
			"What is 2 plus 1?",
			"What is 2 times 2?",
			"What is 25 divided by 5?",
			"What is 2 times 3?",
			"What is 4 plus 3?",
			"What is 2 times 4?",
			"What is 15 minus 6?",
			"What is 15 minus 5?",
			"What is the next prime number after 7?",
			"How many months are there in a year?",
			"What is the next prime number after 11?",
			"What is 21 minus 7?",
			"What is 5 times 3?",
			"What is 4 squared?",
			"What is 20 minus 3?",
			"What is 2 plus 16?",
			"What is 21 minus 2?",
			"What is 10 times 2?">>

			create t.make_now
			create randomizer.set_seed (t.milli_second)
			randomizer.start
		end

feature -- Basic operations

--	is_valid_answer (question, answer: STRING): BOOLEAN
--			-- Is `answer' a valid answer to `question'?
--		do
--			Result := captchas [answer.to_integer].is_equal (question)
--		end

	generate_question
			-- Generate a pseudo-random question.
		do
			last_question_id := (Min_table_dim + randomizer.item \\ Max_table_dim).out
			last_question := captchas [last_question_id.to_integer]
			randomizer.forth
		end

feature -- Access

	last_question: STRING
			-- The last pseudo-random generated captcha question.

	last_question_id: STRING
			-- The last generated question id.

feature {NONE} -- Implementation

	Max_table_dim: INTEGER = 20
			-- Maximum number of questions and answers coded in the hash table.

	Min_table_dim: INTEGER = 1
			-- Minimum number of questions and answers coded in the hash table.

	captchas: ARRAY [STRING]
			--  Captchas table.

	randomizer: RANDOM
			-- Random number generator.
invariant
	table_number_of_elements_consistent: captchas.count = Max_table_dim
end
