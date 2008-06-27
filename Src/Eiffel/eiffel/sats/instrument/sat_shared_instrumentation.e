indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_SHARED_INSTRUMENTATION

feature -- Access

	included_instrument_classes: DS_HASH_SET [STRING] is
			-- Classes to be instrumented
		once
			create Result.make (20)
			Result.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (s1, s2: STRING): BOOLEAN do Result := s1.is_equal (s2) end))
		ensure
			result_attached: Result /= Void
		end

	excluded_instrument_classes: DS_HASH_SET [STRING] is
			-- Classes to be excluded for instrumentation
			-- Only have effects if `included_instrument_classes' is empty.
		once
			create Result.make (20)
			Result.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (s1, s2: STRING): BOOLEAN do Result := s1.is_equal (s2) end))
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_decision_coverage_enabled: BOOLEAN is
			-- Is decision coverage recording enabled?
		do
			Result := decision_coverage_enabled.item
		ensure
			good_result:  Result = decision_coverage_enabled.item
		end

	instrument_config_file_name: STRING is
			-- File containing config information for decision coverage
		once
			create Result.make (256)
		end

feature -- Setting

	set_is_decision_coverage_enabled (b: BOOLEAN) is
			-- Set `is_decision_coverage_enabled' with `b'.
		do
			decision_coverage_enabled.put (b)
		ensure
			is_decision_coverage_enabled_set: is_decision_coverage_enabled = b
		end

	set_instrument_config_file_name (a_name: like instrument_config_file_name) is
			-- Set `instrument_config_file_name' with `a_name'.
		require
			a_name_attached: a_name /= Void
		do
			instrument_config_file_name.wipe_out
			instrument_config_file_name.append (a_name)
		ensure
			instrument_config_file_name_set: instrument_config_file_name.is_equal (a_name)
		end

	analyze_classes_for_instrumentation (a_config_file: STRING; a_universe: UNIVERSE_I) is
			--
		local
			l_classes: DS_HASH_SET [STRING]
			l_new_classes: DS_LINKED_LIST [CLASS_C]
			l_class: CLASS_C
			l_classes_i: LIST [CLASS_I]
			l_cursor: DS_LINKED_LIST_CURSOR [CLASS_C]
			l_included: like included_instrument_classes
			l_excluded: like excluded_instrument_classes
			l_config_reader: SAT_INSTRUMENT_CONFIG_READER
			l_config: LIST [SAT_INSTRUMENT_CLASS_CONFIG]
			l_class_config: SAT_INSTRUMENT_CLASS_CONFIG
		do
			l_included := included_instrument_classes
			l_excluded := excluded_instrument_classes
			l_included.wipe_out
			l_excluded.wipe_out
			if a_config_file /= Void and then not a_config_file.is_empty then
				create l_config_reader
				l_config_reader.read_config (a_config_file)
				l_config := l_config_reader.last_config
				if not l_config.is_empty then
					from
						l_config.start
					until
						l_config.after
					loop
						l_class_config := l_config.item
						if l_class_config.is_excluded then
							l_classes := l_excluded
						else
							l_classes := l_included
						end
						l_classes_i := a_universe.classes_with_name (l_class_config.class_name)
						if not l_classes_i.is_empty then
							l_classes.force_last (l_classes_i.first.name)
								-- Read ancestors of current class.
							if l_class_config.is_proper_ancestor_included then
								create l_new_classes.make
								calculate_parents (l_classes_i.first, l_new_classes)

								l_cursor := l_new_classes.new_cursor
								from
									l_cursor.start
								until
									l_cursor.after
								loop
									l_classes.force_last (l_cursor.item.name_in_upper)
									l_cursor.forth
								end
							end
						end
						l_config.forth
					end
				end
			end
		end

	calculate_parents (a_class: CLASS_I; a_list: DS_LIST [CLASS_C])
			-- <Precursor>
		local
			l_class_i: CLASS_I
			l_class_C: CLASS_C
			l_list: LIST [CLASS_C]
			l_cursor: CURSOR
		do
			if a_class.is_compiled then
				l_list := a_class.compiled_class.parents_classes
				if l_list /= Void and then not l_list.is_empty then
					l_cursor := l_list.cursor
					from l_list.start until l_list.after loop
						l_class_c ?=  l_list.item
						if not a_list.has (l_class_c) then
							a_list.force_last (l_class_c)
							l_class_i ?= l_class_c.lace_class
							calculate_parents (l_class_i, a_list)
						end
						l_list.forth
					end
					l_list.go_to (l_cursor)
				end
			end
		end

feature{NONE} -- Implementation

	decision_coverage_enabled: CELL [BOOLEAN] is
			--
		once
			create Result.put (False)
		end

end
