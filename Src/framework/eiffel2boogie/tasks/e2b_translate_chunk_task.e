note
	description: "Task to translate a chunk of Eiffel to Boogie."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATE_CHUNK_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_translator_input: E2B_TRANSLATOR_INPUT; a_boogie_universe: IV_UNIVERSE)
			-- Initialize task.
		do
			create translator.make (a_boogie_universe)
			translator.add_input (a_translator_input)

			has_next_step := True
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		local
			l_end_tick: NATURAL
		do
				-- Translate features for 100 milliseconds
			from
				l_end_tick := end_tick_for_duration (100)
			until
				clock_ticks > l_end_tick or not translator.has_next_step
			loop
				translator.step
			end
			has_next_step := translator.has_next_step
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {E2B_VERIFY_TASK} -- Implementation

	translator: E2B_TRANSLATOR
			-- Translator to generate Boogie code.

	clock_ticks: NATURAL
			-- Elapsed clock ticks since start of program.
		external "C inline use <time.h>"
		alias
			"return clock();"
		end

	end_tick_for_duration (a_milliseconds: REAL): NATURAL
			-- Tick count for `a_milliseconds' in future.
		external "C inline use <time.h>"
		alias
			"return clock() + ($a_milliseconds * (CLOCKS_PER_SEC / 1000));"
		end

end
