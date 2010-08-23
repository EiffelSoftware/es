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

	make (a_translator_input: like translator_input; a_verifier_input: like verifier_input)
			-- Initialize task.
		do
			translator_input := a_translator_input
			verifier_input := a_verifier_input

			create translator.make
			verifier_input.add_boogie_file (translator.background_theory_file_name)

			has_next_step := True
			translator_input.class_list.start
			translator_input.feature_list.start
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
			l_finished: BOOLEAN
			l_class_list: LINKED_LIST [CLASS_C]
			l_feature_list: LINKED_LIST [FEATURE_I]
		do
			l_class_list := translator_input.class_list
			l_feature_list := translator_input.feature_list

			if l_feature_list.after and l_class_list.after then
					-- Translate references
				translator.translate_references
				verifier_input.add_custom_content (translator.last_translation)
				has_next_step := False
			else
					-- Translate features for 100 milliseconds
				from
					l_end_tick := end_tick_for_duration (100)
				until
					clock_ticks > l_end_tick or (l_class_list.after and l_feature_list.after)
				loop
					if l_class_list.after then
						translator.translate_feature (l_feature_list.item)
						l_feature_list.forth
					else
						translator.translate_class (l_class_list.item)
						l_class_list.forth
					end
					verifier_input.add_custom_content (translator.last_translation)
				end
				has_next_step := True
			end
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {E2B_VERIFY_TASK} -- Implementation

	translator_input: E2B_TRANSLATOR_INPUT
			-- Input to translator.

	verifier_input: E2B_VERIFIER_INPUT
			-- Input to verifier.

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
