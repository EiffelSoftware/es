note
	description: "Summary description for {EPA_DEPENDENT_EXPRESSION_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DEPENDENT_EXPRESSION_FINDER

inherit
	AST_ITERATOR
		redefine
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as,
			process_body_as,
			process_binary_as,
			process_assign_as
		end

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature -- Creation Procedure

	make
			-- Create a new relevancy detector
		do
			create dependency_set.make (1)
		ensure
			dependency_set_not_void: dependency_set /= Void
		end

feature -- Element Change

	set_written_class (a_written_class: CLASS_C)
			-- Sets `written_class' to `a_written_class'
		require
			a_written_class_not_void: a_written_class /= Void
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

	set_context_class (a_context_class: CLASS_C)
			-- Sets `context_class' to `a_context_class'
		require
			a_context_class_not_void: a_context_class /= Void
		do
			context_class := a_context_class
		ensure
			context_class_set: context_class = a_context_class
		end

	set_context_feature (a_context_feature: FEATURE_I)
			-- Sets `context_feature' to `a_context_feature'
		require
			a_context_feature_not_void: a_context_feature /= Void
		do
			context_feature := a_context_feature
		ensure
			context_feature_set: context_feature = a_context_feature
		end

feature -- Visit operations

	process_assign_as (l_as: ASSIGN_AS)
		local
			l_target: EPA_AST_EXPRESSION
		do
			create l_target.make_with_text (context_class, context_feature, text_from_ast (l_as.target), written_class)
			target := l_target
			l_as.target.process (Current)
			l_as.source.process (Current)
			target := Void
		end

	process_body_as (l_as: BODY_AS)
		local
			feature_string: STRING
		do
			feature_string := text_from_ast (l_as)
			if
				not feature_string.has_substring ("attached")
			then
				safe_process (l_as.arguments)
				safe_process (l_as.type)
				safe_process (l_as.assigner)
				safe_process (l_as.content)
			end
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			-- Nothing to be done
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			-- Nothing to be done
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			-- Nothing to be done
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			-- Nothing to be done
		end

	process_binary_as (l_as: BINARY_AS)
		local
			l_related_set: EPA_HASH_SET[EPA_EXPRESSION]
			l_pair: PAIR[EPA_EXPRESSION,EPA_HASH_SET[EPA_EXPRESSION]]
			l_left_epa: EPA_AST_EXPRESSION
			l_right_epa: EPA_AST_EXPRESSION
		do
			if
				target /= Void
			then
				create l_left_epa.make_with_text (context_class, context_feature, text_from_ast (l_as.left), written_class)
				create l_right_epa.make_with_text (context_class, context_feature, text_from_ast (l_as.right), written_class)
				create l_related_set.make_default
				l_related_set.set_equality_tester (expression_equality_tester)
				l_related_set.force_last (l_left_epa)
				l_related_set.force_last (l_right_epa)

				create l_pair.make (target, l_related_set)
				dependency_set.extend (l_pair)
			end

			l_as.left.process (Current)
			l_as.right.process (Current)
		end

feature -- Dumping

	dump_file (a_file_path: STRING)
			-- Dumps the sets of related expressions into a text file into the folder specified by `a_file_path'
		require
			a_file_path_not_void: a_file_path /= Void
		local
			l_text_file: PLAIN_TEXT_FILE
			l_set_counter: INTEGER
			i: INTEGER
			l_file_path: STRING
		do
			l_file_path := a_file_path
			create l_text_file.make_create_read_write (l_file_path + "dependent_expressions.txt")
			l_text_file.flush

			from
				l_set_counter := 1
				i := 1
			until
				i > dependency_set.count
			loop
				l_text_file.put_string ("---Beginning of Set " + l_set_counter.out + ": " + dependency_set.i_th (i).first.text + "---")
				l_text_file.put_new_line
				l_text_file.flush
				from
					dependency_set.i_th (i).second.start
				until
					dependency_set.i_th (i).second.after
				loop
					l_text_file.put_string (dependency_set.i_th (i).second.item_for_iteration.text)
					l_text_file.put_string (": ")
					l_text_file.put_string (dependency_set.i_th (i).second.item_for_iteration.type.name)
					l_text_file.put_new_line
					l_text_file.flush
					dependency_set.i_th (i).second.forth
				end
				l_text_file.put_string ("---End of Set " + l_set_counter.out + ": " + dependency_set.i_th (i).first.text + "---")
				l_set_counter := l_set_counter + 1
				l_text_file.put_new_line
				l_text_file.put_new_line
				l_text_file.flush
				i := i + 1
			end
			l_text_file.close
		end

--	dump_console
--			-- Dumps the sets of related expressions into the console
--		local
--			counter: INTEGER
--			i: INTEGER
--		do
--			counter := 1

--			from
--				i := 1
--			until
--				i > related_set.count
--			loop
--				if
--					related_set.i_th (i) /= Void
--				then
--					io.put_string ("---Beginning of Set " + counter.out + "---")
--					io.put_new_line
--					from
--						related_set.i_th (i).start
--					until
--						related_set.i_th (i).after
--					loop
--						io.put_string (related_set.i_th (i).item_for_iteration.text)
--						io.put_string (": ")
--						io.put_string (related_set.i_th (i).item_for_iteration.type.name)
--						io.put_new_line
--						related_set.i_th (i).forth
--					end
--					io.put_string ("---End of Set " + counter.out + "---")
--					counter := counter + 1
--					io.put_new_line
--					io.put_new_line
--				end
--				i := i + 1
--			end
--		end

feature -- Merging

--	merge
--			-- Merges the sets of related expressions if two different sets contain the same expression
--		local
--			m,n: INTEGER
--		do
--			from
--				m := 1
--			until
--				m > related_set.count
--			loop
--				from
--					n := 1
--				until
--					n > related_set.count
--				loop
--					if
--						m /= n and related_set.i_th (m) /= Void and related_set.i_th (n) /= Void
--					then
--						if
--							not related_set.i_th (m).is_disjoint (related_set.i_th (n))
--						then
--							related_set.i_th (m).merge (related_set.i_th (n))
--							related_set.put_i_th (Void, n)
--							m := 1
--							n := 1
--						else
--							n := n + 1
--						end
--					else
--						n := n + 1
--					end
--				end
--				m := m + 1
--			end
--		end

feature -- Return sets

	return_set (a_expr: EPA_EXPRESSION): EPA_HASH_SET[EPA_EXPRESSION]
			-- Returns a set containing `a_expr'. An empty set is returned when no set containing `a_expr' is found.
		require
			a_expr_not_void: a_expr /= Void
		local
			i: INTEGER
			l_empty_set: EPA_HASH_SET[EPA_EXPRESSION]
		do
			create l_empty_set.make_default
			Result := l_empty_set
			from
				i := 1
			until
				i > dependency_set.count
			loop
				if
					expression_equality_tester.test (dependency_set.i_th (i).first, a_expr)
				then
					Result := dependency_set.i_th (i).second
				end
				i := i + 1
			end
		ensure
			Result_set: Result /= Void
		end

feature{NONE} -- Implementation

	target: EPA_EXPRESSION

	dependency_set: ARRAYED_LIST[PAIR[EPA_EXPRESSION,EPA_HASH_SET[EPA_EXPRESSION]]]

	context_class: CLASS_C
			-- Context class for the visited AST

	written_class: CLASS_C
			-- Written class for the visited AST

	context_feature: detachable FEATURE_I
			-- Feature for the visited AST

end
