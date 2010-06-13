note
	description: "[
			Given a list of basic classes, collect the list of classes that are used in the interface
			of the basic classes.
			Usage: -autotest -a --collect-interface [--data-output output_dir] class_name_1 class_name_2 
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_INTERFACE_RELATED_CLASS_COLLECTOR

inherit

	EPA_UTILITY

	SHARED_TYPES

	KL_SHARED_STRING_EQUALITY_TESTER

	EXCEPTIONS

create
	make

feature -- Initialization

	make (a_names: attached DS_HASH_SET [STRING])
			-- Initialization
		require
			a_names_attached: a_names /= Void
		do
			create class_names.make (a_names.count)
			a_names.do_all (agent class_names.force_new)
		end

feature -- Access

	class_names: attached DS_HASH_SET [STRING]
			-- Names of basic classes to be processed.

	last_interface_related_classes: attached DS_HASH_TABLE[DS_HASH_SET[STRING], STRING]
			-- Result of last collection.
			-- The keys are names of the basic classes, and the values are names of the interface-related classes.
			-- The basic class names could also appear in the related hash sets.
		do
			if last_interface_related_classes_cache = Void then
				create last_interface_related_classes_cache.make_default
				last_interface_related_classes_cache.set_key_equality_tester (case_insensitive_string_equality_tester)
			end

			Result := last_interface_related_classes_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Operation

	collect
			-- Collect interface related classes for a set of basic classes.
			-- For each basic class from `class_names', all the classes referred to in its interface would be collected.
			-- The result is available in `last_interface_related_classes'.
		local
			l_basics: like class_names
			l_basic: STRING
		do
			l_basics := class_names
			from l_basics.start
			until l_basics.after
			loop
				l_basic := l_basics.item_for_iteration

				-- Collect from each class.
				collect_from_single_class (l_basic)
				check class_in_result: last_interface_related_classes.has (l_basic) end

				l_basics.forth
			end
		end

	save_names (a_file_name: STRING)
			-- Save the result into a file with the name 'a_file_name'.
			-- Line format: basic_class,related_class1,related_class2,...,related_classn
		local
			l_file: KL_TEXT_OUTPUT_FILE
			l_err_msg: STRING
		do
			create l_file.make (a_file_name)
			l_file.recursive_open_write
			if not l_file.is_open_write then
				l_err_msg := once "Error opening file to write: "
				l_err_msg.append (a_file_name)
				raise (l_err_msg)
			end

			write_to_file (l_file)
			l_file.close
		end

feature{NONE} -- Implementation

	collect_from_single_class (a_class: STRING)
			-- Collect interface-related classes for a single class 'a_class',
			-- and put the result into `last_interface_related_classes'.
		local
			l_related_classes: DS_HASH_SET [STRING]
			l_feature_table: FEATURE_TABLE
			l_feature: FEATURE_I
		do
			-- Add an empty set to the result.
			create l_related_classes.make_default
			l_related_classes.set_equality_tester (case_insensitive_string_equality_tester)
			last_interface_related_classes.force_new (l_related_classes, a_class)

			if attached {CLASS_C}first_class_starts_with_name (a_class) as lt_class then
				l_feature_table := lt_class.feature_table
				from l_feature_table.start
				until l_feature_table.after
				loop
					l_feature := l_feature_table.item_for_iteration

					if is_interface_routine (l_feature) then
						collect_from_single_routine (lt_class, l_feature, l_related_classes)
					end

					l_feature_table.forth
				end
			end
		end

	collect_from_single_routine (a_class: attached CLASS_C; a_feature: attached FEATURE_I; a_classes: attached DS_HASH_SET[STRING])
			-- Collect related classes from routine 'a_feature', and put the names into 'a_classes'.
		require
			feature_is_routine: a_feature.is_routine
		local
			l_arguments: FEAT_ARG
			l_type: TYPE_A
			l_basic_name: STRING
			l_class_name: STRING
		do
			l_basic_name := a_class.name

			-- Classes from arguments.
			if a_feature.argument_count /= 0 then
				l_arguments := a_feature.arguments
				check arguments_attached: l_arguments /= Void end
				from l_arguments.start
				until l_arguments.after
				loop
					l_type := l_arguments.item_for_iteration
					l_type := l_type.actual_type.instantiation_in (a_class.actual_type, a_class.class_id)
					if is_interesting_type (l_type) then
						l_class_name := l_type.associated_class.name
						if not a_classes.has (l_class_name) and then l_basic_name /~ l_class_name then
							a_classes.force_new (l_class_name)
						end
					end
					l_arguments.forth
				end
			end

			-- Class from return type.
			l_type := a_feature.type.actual_type.instantiation_in (a_class.actual_type, a_class.class_id)
			if l_type /= Void_type and then is_interesting_type (l_type) then
				l_class_name := l_type.associated_class.name
				if not a_classes.has (l_class_name) and then l_basic_name /~ l_class_name then
					a_classes.force_new (l_class_name)
				end
			end
		end

	is_interface_routine (a_feature: attached FEATURE_I): BOOLEAN
			-- Is 'a_feature' denoting an interface routine?
		local
		do
			if a_feature.written_class.class_id /= system.any_class.compiled_representation.class_id
					and then a_feature.is_routine
					and then a_feature.is_exported_for (system.any_class.compiled_representation)
			then
				Result := True
			end
		end

	is_interesting_type (a_type: TYPE_A): BOOLEAN
			-- Is 'a_type' interesting w.r.t. related-class collection?
		do
			if not a_type.is_formal
					and then not a_type.is_integer
					and then not a_type.is_real_32
					and then not a_type.is_boolean
			then
				Result := True
			end
		end

	write_to_file (a_file: KL_TEXT_OUTPUT_FILE)
			-- Write the class names from `class_names' to 'a_file'.
		local
			l_names: like class_names
			l_basic_name, l_name: STRING
			l_related: DS_HASH_SET [STRING]
			l_line: STRING
		do
			l_names := class_names
			from l_names.start
			until l_names.after
			loop
				l_basic_name := l_names.item_for_iteration

				-- Related classes from interface routines.
				check last_interface_related_classes.has (l_basic_name) end
				l_related := last_interface_related_classes.item (l_basic_name)

				-- A class should always be related with itself.
				l_line := l_basic_name.twin

				from l_related.start
				until l_related.after
				loop
					l_name := l_related.item_for_iteration

					-- Name of the basic class should not appear in the list of related_classes.
					check l_name /~ l_basic_name end

					l_line.append (separator)
					l_line.append (l_name)

					l_related.forth
				end

				a_file.put_string (l_line)
				a_file.put_new_line

				l_names.forth
			end

		end

	separator: STRING = " "
			-- String used to separate consecutive class names.

feature{NONE} -- Implementation

	last_interface_related_classes_cache: detachable like last_interface_related_classes
			-- Cache for `last_interface_related_classes'.


;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
