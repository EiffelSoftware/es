note
	description: "Summary description for {CA_MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	CA_MESSAGES

inherit {NONE}
	SHARED_LOCALE

feature -- Utility functions

--	wrapped_string (a_input: READABLE_STRING_GENERAL; a_max_count: INTEGER; a_force_wrap: BOOLEAN): READABLE_STRING_GENERAL
--			--
--		require
--			a_max_count >= 5
--		local
--			l_words: LIST[READABLE_STRING_GENERAL]
--			l_word: READABLE_STRING_GENERAL
--			l_output: STRING_32
--			l_current_line_char_count, j: INTEGER
--		do
--			if a_input.count <= a_max_count then
--				-- The trivial case.
--				Result := a_input
--			else
--				from
--					l_current_line_char_count := 0
--					l_output.make_empty
--					l_words := a_input.split (' ')
--					l_words.start
--				until
--					l_words.after
--				loop
--					l_word := l_words.item
--					if l_word.count > a_max_count and then a_force_wrap then -- A very long word.
--						if l_current_line_char_count /= 0 then
--							l_output.append_character ('%N')
--						end
--						from
--							j := 1
--						until
--							j + a_max_count > l_word.count
--						loop
--							l_output.append (l_word.substring (j, j + a_max_count - 1))
--							l_output.append_character ('%N')
--							j := j + a_max_count
--						end
--						l_output.append (l_word.substring (j, l_word.count))
--					else
--						if l_current_line_char_count + l_word.count > a_max_count then
--							if l_current_line_char_count /= 0 then
--								l_output.append_character ('%N')
--							end
--							current_line_char_count := l_word.count
--						else
--							l_output.append_character (' ')
--							current_line_char_count := current_line_char_count + 1 + l_word.count
--						end
--						l_output.append (l_word)
--					end

--					l_words.forth
--				end

--				Result := l_output
--			end
--		ensure
--			length_preserved: (not a_force_wrap) implies (a_input.count = Result.count) -- Make sure 'LF CR' new lines count as 1.
--		end

feature -- Code Analyzer

	analyzing_class (a_class_name: READABLE_STRING_GENERAL): STRING_32
		do Result := locale.formatted_string (locale.translation ("Analyzing class $1 ...%N"), [a_class_name]) end


	self_assignment_violation_1: STRING_32
		do Result := locale.translation ("Variable '") end

	self_assignment_violation_2: STRING_32
		do Result := locale.translation ("' is assigned to itself. Assigning a variable to %
			                        %itself is%Na meaningless statement due to a typing%
			                        % error. Most probably, one of the two%Nvariable %
			                        %names was misspelled.") end

	unused_argument_violation_1: STRING_32
		do Result := locale.translation ("Arguments ") end

	unused_argument_violation_2: STRING_32
		do Result := locale.translation (" from routine '") end

	unused_argument_violation_3: STRING_32
		do Result := locale.translation ("' are not used.") end

	npath_violation_1: STRING_32
		do Result := locale.translation ("Routine '") end

	npath_violation_2: STRING_32
		do Result := locale.translation ("' has an NPATH measure of ") end

	npath_violation_3: STRING_32
		do Result := locale.translation (", which is greater than the defined%Nmaximum of ") end

	feature_never_called_violation_1: STRING_32
		do Result := locale.translation ("Feature '") end

	feature_never_called_violation_2: STRING_32
		do Result := locale.translation ("' is never called by any class.") end

	cq_separation_violation_1 : STRING_32
		do Result := locale.translation ("Function '") end

	cq_separation_violation_2: STRING_32
		do Result := locale.translation ("' contains a procedure call, assigns to an%
			% attribute, or%Ncreates an attribute. This indicates that the function%
			% changes the state of the%Nobject, which is a violation of the %
			%command-query separation principle.") end

	unneeded_ot_local_violation_1: STRING_32
		do Result := locale.translation ("' is either a local variable, a feature%
			% argument, or an%Nobject test local. Thus the object test is not in %
			%need of the object test%Nlocal '") end

	empty_if_violation_1: STRING_32
		do Result := locale.translation ("An empty if statement is useless and should be removed.") end

	nested_complexity_violation_1: STRING_32
		do Result := locale.translation ("In routine '") end

	nested_complexity_violation_2: STRING_32
		do Result := locale.translation ("' there are ") end

	nested_complexity_violation_3: STRING_32
		do Result := locale.translation (" nested branches%Nor loops, which is %
			%greater than or equal the defined threshold of ") end

feature -- Command Line

	cmd_class: STRING_32
		do Result := locale.translation ("%NIn class '") end

	cmd_help_message: STRING_32
		do Result := locale.translation ("Code Analysis performs static analyses on the source code and %
			           %outputs a list of issues found according to a set of rules.") end

	cmd_class_not_found_1: STRING_32
		do Result := locale.translation ("Warning: class '") end

	cmd_class_not_found_2: STRING_32
		do Result := locale.translation ("' was not found and will be skipped. Check the spelling %
			%and make sure the class has been compiled.%N") end

end
