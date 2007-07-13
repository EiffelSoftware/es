indexing

	description:
		"Warning for potential cat-calls."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision $"

class INTERVAL_CONFORMANCE_WARNING

inherit
	EIFFEL_WARNING
		redefine
			build_explain
		end

	SHARED_NAMES_HEAP

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I) is
			-- Initialize warning
		require
			a_class_not_void: a_class /= Void
		do
			set_class (a_class)
			set_feature (a_feature)
		ensure
			associated_class_set: associated_class = a_class
		end

feature -- Access

	original_result: BOOLEAN
			-- Result of non-interval conformance check

	interval_result: BOOLEAN
			-- Result of interval conformance check

	associated_feature: E_FEATURE
			-- Feature where cat-call happens

	source_type: TYPE_A
			-- Source type

	target_type: TYPE_A
			-- Target type

	code: STRING is
			-- Error code
		do
			Result := "interval-conformance";
		end

feature -- Element change

	set_class (a_class: CLASS_C) is
			-- Set `associated_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			associated_class := a_class
		ensure
			associated_class_set: associated_class = a_class
		end

	set_feature (a_feature: FEATURE_I) is
			-- Set `associated_feature' to `a_feature'.
		do
			if a_feature /= Void then
				associated_feature := a_feature.api_feature (a_feature.written_in)
			end
		end

	set_result (a_original_result, a_interval_result: BOOLEAN)
			-- Set orignal result and interval result.
		do
			original_result := a_original_result
			interval_result := a_interval_result
		ensure
			original_result_set: original_result = a_original_result
			interval_result_set: interval_result = a_interval_result
		end

	set_types (a_source_type, a_target_type: TYPE_A)
			-- Set source type and target type
		require
			a_source_type_not_void: a_source_type /= Void
			a_target_type_not_void: a_target_type /= Void
		do
			source_type := a_source_type
			target_type := a_target_type
		ensure
			source_type_set: source_type = a_source_type
			target_type_set: target_type = a_target_type
		end

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER) is
		do
				-- Print context
			a_text_formatter.add ("Class: ")
			associated_class.append_name (a_text_formatter)
			a_text_formatter.add_new_line
			if associated_feature = Void then
				a_text_formatter.add ("Invariant")
			else
				a_text_formatter.add ("Feature: ")
				associated_feature.append_name (a_text_formatter)
			end
			a_text_formatter.add_new_line
			a_text_formatter.add_new_line

			a_text_formatter.add ("Source type: ")
			source_type.append_to (a_text_formatter)

			a_text_formatter.add_new_line
			a_text_formatter.add ("Target type: ")
			target_type.append_to (a_text_formatter)

			a_text_formatter.add_new_line
			a_text_formatter.add_new_line

			if original_result then
				a_text_formatter.add ("Conformance without interval types: True")
			else
				a_text_formatter.add ("Conformance without interval types: False")
			end
			a_text_formatter.add_new_line
			if interval_result then
				a_text_formatter.add ("Conformance with interval types:    True")
			else
				a_text_formatter.add ("Conformance with interval types:    False")
			end
			a_text_formatter.add_new_line
			a_text_formatter.add_new_line

			print_statistics (a_text_formatter)
		end

feature

	update_statistics is
			-- Update statistics with catcall of current warning
		local
			l_gen_type: GEN_TYPE_A
			l_tuple_type: TUPLE_TYPE_A
		do
			system.statistics.conformance_total := system.statistics.conformance_total + 1
			if source_type.is_formal or target_type.is_formal then
				system.statistics.conformance_formal_generic := system.statistics.conformance_formal_generic + 1
			end
			if source_type.is_like or target_type.is_like then
				system.statistics.conformance_anchored := system.statistics.conformance_anchored + 1
			end
			if source_type.is_like_current or target_type.is_like_current then
				system.statistics.conformance_like_current := system.statistics.conformance_like_current + 1
			end
			if source_type.is_monomorph or target_type.is_monomorph then
				system.statistics.conformance_monomorph := system.statistics.conformance_monomorph + 1
			end
			l_gen_type ?= source_type
			if
				l_gen_type /= Void and then
				l_gen_type.has_associated_class and then
				(
					l_gen_type.associated_class.name_in_upper.is_equal ("PROCEDURE") or else
					l_gen_type.associated_class.name_in_upper.is_equal ("FUNCTION") or else
					l_gen_type.associated_class.name_in_upper.is_equal ("ROUTINE") or else
					l_gen_type.associated_class.name_in_upper.is_equal ("PREDICATE")
				)
			then
				system.statistics.conformance_agents := system.statistics.conformance_agents + 1
			else
				l_gen_type ?= target_type
				if
					l_gen_type /= Void and then
					l_gen_type.has_associated_class and then
					(
						l_gen_type.associated_class.name_in_upper.is_equal ("PROCEDURE") or else
						l_gen_type.associated_class.name_in_upper.is_equal ("FUNCTION") or else
						l_gen_type.associated_class.name_in_upper.is_equal ("ROUTINE") or else
						l_gen_type.associated_class.name_in_upper.is_equal ("PREDICATE")
					)
				then
					system.statistics.conformance_agents := system.statistics.conformance_agents + 1
				end
			end

			l_tuple_type ?= source_type
			if l_tuple_type /= Void then
				system.statistics.conformance_tuple := system.statistics.conformance_tuple + 1
			else
				l_tuple_type ?= target_type
				system.statistics.conformance_tuple := system.statistics.conformance_tuple + 1
			end
		end

	print_statistics (a_text_formatter: TEXT_FORMATTER) is
			--
		do
			a_text_formatter.add ("STAT (")
			a_text_formatter.add ("total: " + system.statistics.conformance_total.out + "%T")
			a_text_formatter.add ("formal: " + system.statistics.conformance_formal_generic.out + "%T")
			a_text_formatter.add ("anchored: " + system.statistics.conformance_anchored.out + "%T")
			a_text_formatter.add ("like current: " + system.statistics.conformance_like_current.out + "%T")
			a_text_formatter.add ("monomorph: " + system.statistics.conformance_monomorph.out + "%T")
			a_text_formatter.add (")")
			a_text_formatter.add_new_line
		end

invariant

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
