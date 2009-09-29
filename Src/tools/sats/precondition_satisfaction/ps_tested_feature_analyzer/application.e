indexing
	description : "[
						This application analyzes:
						1. Which features are not tested in or but tested in ps
						2. Which features are still not tested in ps
						3. Which features are tested in or but not in ps
						]"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_tested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_untested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
		do
			if argument_count /= 3 then
				io.put_string ("Usage: ps_tested_feature_analyzer <result_directory> <session_count> <hard_feature_ratio>%N")
				io.put_string ("<result_directory> is the directory storing all result files.%N")
				io.put_string ("<session_count> is the number of test runs for a class group.%N")
				io.put_string ("<hard_feature_ratio> is the ratio to decide hard to test features. Range in [0, 100]%N")
			else
				results_path := argument (1)
				session_count := argument (2).to_integer
				hard_feature_ratio := argument (3).to_integer


				create statistics.make (2)
				statistics.compare_objects

				create l_tested.make (1000)
				l_tested.compare_objects
				create l_untested.make (1000)
				l_untested.compare_objects
				statistics.put ([l_tested, l_untested], or_prefix)

				create l_tested.make (1000)
				l_tested.compare_objects
				create l_untested.make (1000)
				l_untested.compare_objects
				statistics.put ([l_tested, l_untested], ps_prefix)

				find_files
				analyze_result (or_prefix)
				analyze_result (ps_prefix)

				print_result
			end
		end

feature -- Access

	results_path: STRING
			-- Path to the directory storing all result files.

	or_prefix: STRING is "or"
			-- The file name prefix for result files for or-strategy

	ps_prefix: STRING is "ps"
			-- The file name prefix for result files for ps-strategy

	hard_feature_ratio: INTEGER

	session_count: INTEGER

feature{NONE} -- Implementation

	or_files: LINKED_LIST [FILE_NAME]
			-- Files for or-strategy results

	ps_files: LINKED_LIST [FILE_NAME]
			-- Files for ps-strategy results

	statistics: HASH_TABLE [TUPLE [tested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]; untested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]], STRING]
			-- Key is the strategy prefix: "or" or "ps"
			-- Value is a tuple of hash tables, `tested' stored tested features, `untested' stored untested features:
			-- 		Key is the "CLASS.feature" combination
			-- 		Value is a set of integers indicating the test files in which that feature is tested or not tested.


feature{NONE} -- Implementation

	find_files is
			-- Find all result files in `results_path'.
		local
			l_dir: DIRECTORY
			l_file_name: FILE_NAME
			l_files: like or_files
		do
			create or_files.make
			create ps_files.make

				-- Iterate `results_path' to find result files.
			create l_dir.make_open_read (results_path)
			from
				l_dir.readentry
			until
				l_dir.lastentry = Void
			loop
				if
					not (l_dir.lastentry.is_equal (".") or l_dir.lastentry.is_equal ("..")) and
					l_dir.lastentry.substring (l_dir.lastentry.count - 3, l_dir.lastentry.count).is_equal (".txt")
				then
					create l_file_name.make_from_string (results_path)
					l_file_name.set_file_name (l_dir.lastentry)
					if l_dir.lastentry.substring (1, 2).is_equal (or_prefix) then
						l_files := or_files
					elseif l_dir.lastentry.substring (1, 2).is_equal (ps_prefix) then
						l_files := ps_files
					end
					l_files.extend (l_file_name)
				end
				l_dir.readentry
			end
		end

	analyze_result (a_strategy: STRING) is
			-- Analyze result for `a_strategy'.
			-- `a_strategy' is the startegy prefix, can be either `or_prefix' or `ps_prefix'.
		local
			l_tested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_untested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_files: like or_files
		do
			l_tested := statistics.item (a_strategy).tested
			l_untested := statistics.item (a_strategy).untested

			if a_strategy.is_equal (or_prefix) then
				l_files := or_files
			else
				l_files := ps_files
			end

			from
				l_files.start
			until
				l_files.after
			loop
				analyze_one_file (l_files.item_for_iteration, l_tested, l_untested)
				l_files.forth
			end
		end


	analyze_one_file (a_file: STRING; a_tested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]; a_untested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]) is
			-- Analyze `a_file' and store result in `a_tested' and `a_untested'.
		local
			l_mirror: STRING
			l_file: PLAIN_TEXT_FILE
			l_session_index: INTEGER
			l_parts: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_pass_tc: INTEGER
			l_fail_tc: INTEGER
			l_bad_tc: INTEGER
			l_invalid_tc: INTEGER
			l_classes: HASH_TABLE [INTEGER, STRING]
			l_full_name: STRING
			l_index_set: DS_HASH_SET [INTEGER]
			l_leader: STRING
		do
				-- Get session index.
			l_mirror := a_file.twin
			l_mirror.mirror
			l_mirror := l_mirror.substring (5, l_mirror.count)
			l_mirror := l_mirror.substring (1, l_mirror.index_of ('_', 1) - 1)
			l_mirror.mirror
			l_session_index := l_mirror.to_integer

			io.error.put_string (a_file + " " + l_session_index.out + "%N")
			create l_file.make_open_read (a_file)

				-- Get classes under test.
			go_to_line (l_file, "--[Class under test]")
			create l_classes.make (10)
			l_classes.compare_objects
			from
				l_file.read_line
			until
				l_file.last_string.is_empty
			loop
				if l_leader = Void then
					l_leader := l_file.last_string.twin
				end
				l_classes.force (5, l_file.last_string.twin)
				l_file.read_line
			end

			go_to_line (l_file, "--[Feature statistics]")
			l_file.read_line

			from
				l_file.read_line
			until
				l_file.last_string.is_empty
			loop
				l_parts := l_file.last_string.split ('%T')
				l_class_name := l_parts.i_th (1)

				if l_classes.has (l_class_name) then
					l_feature_name := l_parts.i_th (2) + "." + l_parts.i_th (3)
					l_pass_tc := l_parts.i_th (4).to_integer
					l_fail_tc := l_parts.i_th (5).to_integer
					l_bad_tc := l_parts.i_th (6).to_integer
					l_invalid_tc := l_parts.i_th (7).to_integer
					create l_full_name.make (64)
					l_full_name.append (l_leader + "@")
					l_full_name.append (l_class_name)
					l_full_name.append (".")
					l_full_name.append (l_feature_name)

					if l_pass_tc > 0 or l_fail_tc > 0 then
							-- Found a tested feature.
						if not a_tested.has (l_full_name) then
							create l_index_set.make (30)
							l_index_set.force_last (l_session_index)
							a_tested.force (l_index_set, l_full_name)
						else
							l_index_set := a_tested.item (l_full_name)
							l_index_set.force_last (l_session_index)
						end
						if a_untested.has (l_full_name) then
							a_untested.remove (l_full_name)
						end

					elseif l_invalid_tc > 0 then
							-- Found a untested feature.
						if a_tested.has (l_full_name) then
						else
							if not a_untested.has (l_full_name) then
								a_untested.force (Void, l_full_name)
							end
						end
					end
				end

				l_file.read_line
			end

			l_file.close
		end

	go_to_line (a_file: PLAIN_TEXT_FILE; a_line: STRING) is
			-- Goto the first line containing `a_line' in `a_file'.
		do
			from
				a_file.read_line
			until
				a_file.after or else a_file.last_string.has_substring (a_line)
			loop
				a_file.read_line
			end
		end


	print_result is
			-- Print result into console.
		local
			l_ps_tested: DS_HASH_SET [STRING]
			l_ps_untested: DS_HASH_SET [STRING]
			l_or_tested: DS_HASH_SET [STRING]
			l_or_untested: DS_HASH_SET [STRING]
			b: AGENT_BASED_EQUALITY_TESTER [STRING]
			l_tested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_untested: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_sets: DS_HASH_SET [STRING]
			l_hard_features: HASH_TABLE [TUPLE [or_rate: DOUBLE; ps_rate: DOUBLE], STRING]
			l_ratio: DOUBLE
			l_count: INTEGER
			ps_count: INTEGER
			l_ps_ratio: DOUBLE
			l_flist: SORTED_TWO_WAY_LIST [STRING]
			l_parts: LIST [STRING]
			l_fd: FORMAT_DOUBLE
		do
			create l_ps_tested.make (10000)
			l_ps_tested.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

			create l_or_tested.make (10000)
			l_or_tested.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

			create l_or_untested.make (10000)
			l_or_untested.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

			create l_ps_untested.make (10000)
			l_ps_untested.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

			create l_hard_features.make (10000)
			l_hard_features.compare_objects

				-- Get or-strategy statistics.
			l_tested := statistics.item (or_prefix).tested
			l_untested := statistics.item (or_prefix).untested
			from
				l_tested.start
			until
				l_tested.after
			loop
				l_or_tested.force_last (l_tested.key_for_iteration)
				l_tested.forth
			end

			from
				l_untested.start
			until
				l_untested.after
			loop
				l_or_untested.force_last (l_untested.key_for_iteration)
				l_untested.forth
			end

				-- Get ps-strategy statistics.
			l_tested := statistics.item (ps_prefix).tested
			l_untested := statistics.item (ps_prefix).untested
			from
				l_tested.start
			until
				l_tested.after
			loop
				l_ps_tested.force_last (l_tested.key_for_iteration)
				l_tested.forth
			end

			from
				l_untested.start
			until
				l_untested.after
			loop
				l_ps_untested.force_last (l_untested.key_for_iteration)
				l_untested.forth
			end

			io.put_string ("--[Feature not tested in or-strategy but tested in ps-strategy]%N")
			io.put_string ("Class%TFeature%TSessions%N")
			l_sets := l_ps_tested.intersection (l_or_untested)
			print_set (l_sets, statistics.item (ps_prefix).tested, False)
			io.put_string ("%N%N")

			io.put_string ("--[Feature tested in or-strategy but not in ps-strategy]%N")
			io.put_string ("Class%TFeature%TSessions%N")
			l_sets := l_or_tested.intersection (l_ps_untested)
			print_set (l_sets, statistics.item (or_prefix).tested, False)
			io.put_string ("%N%N")

			io.put_string ("--[Feature still not tested in ps-strategy]%N")
			io.put_string ("Class%TFeature%N")
			l_sets := l_ps_untested
			print_set (l_sets, statistics.item (ps_prefix).untested, False)
			io.put_string ("%N%N")

				-- Print hard features.
			from
				l_or_tested.start
			until
				l_or_tested.after
			loop
				l_count := statistics.item (or_prefix).tested.item (l_or_tested.item_for_iteration).count
				l_ratio := l_count.to_double / session_count.to_double
				if l_ratio <= hard_feature_ratio.to_double / 100.0 then
					if l_ps_tested.has (l_or_tested.item_for_iteration) then
						ps_count := statistics.item (ps_prefix).tested.item (l_or_tested.item_for_iteration).count
						l_ps_ratio := ps_count.to_double / session_count.to_double
					else
						l_ps_ratio := 0
					end
					l_hard_features.force ([l_ratio, l_ps_ratio], l_or_tested.item_for_iteration)
				end
				l_or_tested.forth
			end

			from
				l_or_untested.start
			until
				l_or_untested.after
			loop
				if l_ps_tested.has (l_or_untested.item_for_iteration) then
					ps_count := statistics.item (ps_prefix).tested.item (l_or_untested.item_for_iteration).count
					l_ps_ratio := ps_count.to_double / session_count.to_double
				else
					l_ps_ratio := 0
				end
				l_hard_features.force ([0.0, l_ps_ratio],  l_or_untested.item_for_iteration)
				l_or_untested.forth
			end

			create l_flist.make
			from
				l_hard_features.start
			until
				l_hard_features.after
			loop
				l_flist.extend (l_hard_features.key_for_iteration)
				l_hard_features.forth
			end
			l_flist.sort

			io.put_string ("-- [Feature testabilities]%N")
			io.put_string ("Class%TFeature%T%Has_precondition%Tor-strategy%Tps-strategy%N")
			from
				l_flist.start
			until
				l_flist.after
			loop
				l_parts := l_flist.item_for_iteration.split ('.')
				io.put_string (l_parts.i_th (1) + "%T" + l_parts.i_th (2) + "%T" + l_parts.i_th (3) + "%T")
				l_ratio := l_hard_features.item (l_flist.item_for_iteration).or_rate * 100.0
				l_ps_ratio := l_hard_features.item (l_flist.item_for_iteration).ps_rate * 100.0
				io.put_string (floor (l_ratio).out + "%T" + floor (l_ps_ratio).out + "%N")
				l_flist.forth
			end
			io.put_string ("%N%N")

			io.put_string ("--[Feature tested in ps-strategy]%N")
			io.put_string ("Class%TFeature%TSessions%N")
			l_sets := l_or_tested
			print_set (l_sets, statistics.item (ps_prefix).tested, False)
			io.put_string ("%N%N")


			io.put_string ("--[Feature tested in or-strategy]%N")
			io.put_string ("Class%TFeature%TSessions%N")
			l_sets := l_or_tested
			print_set (l_sets, statistics.item (or_prefix).tested, False)
			io.put_string ("%N%N")

			io.put_string ("--[Feature not tested in or-strategy]%N")
			io.put_string ("Class%TFeature%N")
			l_sets := l_or_untested
			print_set (l_sets, statistics.item (or_prefix).untested, False)
			io.put_string ("%N%N")

		end



	print_set (a_set: DS_HASH_SET [STRING]; a_reference: HASH_TABLE [DS_HASH_SET [INTEGER], STRING]; a_precondition: BOOLEAN) is
			--
		local
			l_parts: LIST [STRING]
			l_index: DS_HASH_SET [INTEGER]

			l_list: SORTED_TWO_WAY_LIST [STRING]
		do
			create l_list.make
			from
				a_set.start
			until
				a_set.after
			loop
				l_list.extend (a_set.item_for_iteration)
				a_set.forth
			end
			l_list.sort

			from
				l_list.start
			until
				l_list.after
			loop
				l_parts := l_list.item_for_iteration.split ('.')
				io.put_string (l_parts.i_th (1))
				io.put_string ("%T")
				io.put_string (l_parts.i_th (2))
				io.put_string ("%T")
				if a_precondition then
					io.put_string (l_parts.i_th (3))
					io.put_string ("%T")
				end
				l_index := a_reference.item (l_list.item_for_iteration)
				if l_index /= Void then
					from
						l_index.start
					until
						l_index.after
					loop
						io.put_string (l_index.item_for_iteration.out)
						io.put_string (" ")
						l_index.forth
					end
				end
				io.put_string ("%N")
				l_list.forth
			end
		end

end
