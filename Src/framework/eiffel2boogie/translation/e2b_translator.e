note
	description: "Translates Eiffel to IV AST nodes."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATOR

inherit

	SHARED_WORKBENCH

	E2B_SHARED_CONTEXT

	E2B_SHARED_BOOGIE_UNIVERSE

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE)
			-- Initialize translator.
		do
			boogie_universe_cell.put (a_boogie_universe)

			translation_pool.reset
			translation_pool.add_type (system.any_type)
			translation_pool.mark_translated (translation_pool.next_untranslated_element)
			translation_pool.add_type (system.boolean_class.compiled_class.actual_type)
			translation_pool.mark_translated (translation_pool.next_untranslated_element)
			mark_feature_translated (system.real_64_class, "truncated_to_integer")
			mark_feature_translated (system.real_64_class, "truncated_to_integer_64")
			mark_feature_translated (system.integer_32_class, "to_double")
		end

	mark_feature_translated (a_class: CLASS_I; a_feature: STRING)
			-- Mark feature `a_feature' of class `a_class' as translated.
		do
			check a_class.is_compiled end
			check a_class.compiled_class.feature_named_32 (a_feature) /= Void end
			translation_pool.add_referenced_feature (a_class.compiled_class.feature_named_32 (a_feature), a_class.compiled_class.actual_type)
			translation_pool.mark_translated (translation_pool.next_untranslated_element)
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- Is there another step in the translation?
		do
			Result := translation_pool.has_untranslated_elements
		end

feature -- Element change

	add_input (a_input: E2B_TRANSLATOR_INPUT)
			-- Add all classes and featurse from `a_input' to be translated.
		do
			across a_input.class_list as i loop
				add_class (i.item)
			end
			across a_input.feature_list as i loop
				add_feature (i.item)
			end
		end

	add_class (a_class: CLASS_C)
			-- Add `a_class' to be translated.
		local
			l_feature: FEATURE_I
		do
			if a_class.has_feature_table then
				from
					a_class.feature_table.start
				until
					a_class.feature_table.after
				loop
					l_feature := a_class.feature_table.item_for_iteration
					if l_feature.written_in = a_class.class_id and then l_feature.is_routine then
						add_feature_of_type (l_feature, a_class.actual_type)
					end
					a_class.feature_table.forth
				end
			end
		end

	add_feature (a_feature: FEATURE_I)
			-- Add `a_feature' to be translated.
		require
			a_feature_attached: attached a_feature
		local
			l_class: CLASS_C
			l_context_type: TYPE_A
		do
			l_class := system.class_of_id (a_feature.written_in)
			l_context_type := l_class.actual_type

			add_feature_of_type (a_feature, l_context_type)
		end

	add_feature_of_type (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add `a_feature' in context of type `a_context_type' to be translated.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		local
			l_tuple: TUPLE [FEATURE_I, TYPE_A]
		do
			l_tuple := [a_feature, a_context_type]
			l_tuple.compare_objects

			translation_pool.add_feature (a_feature, a_context_type)
		end

	add_assertion_tag_filter (a_filter: ANY)
			-- Add `a_filter' to assertion tag filters.
		do
			check False end
		end

feature -- Basic operations

	step
			-- Do one step of the translation.
		require
			has_next_step: has_next_step
		local
			l_unit: E2B_TRANSLATION_UNIT
		do
			check translation_pool.has_untranslated_elements end

			l_unit := translation_pool.next_untranslated_element
-- TODO: remove
--			print ("translation unit: " + l_unit.id + "%N")
			l_unit.translate
			translation_pool.mark_translated (l_unit)
		end

end
