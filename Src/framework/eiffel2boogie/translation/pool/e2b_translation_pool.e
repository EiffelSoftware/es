note
	description: "Manages lists of translated and untranslated features and types."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATION_POOL

inherit

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty pool.
		do
			create untranslated_elements.make (100)
			create translated_elements.make (100)
			create ids.make (100)
		end

feature -- Access

	untranslated_elements: attached ARRAYED_LIST [attached E2B_TRANSLATION_UNIT]
			-- List of untranslated units.

	translated_elements: attached ARRAYED_LIST [attached E2B_TRANSLATION_UNIT]
			-- List of translated units.

	next_untranslated_element: E2B_TRANSLATION_UNIT
			-- Next untranslated element.
		require
			has_untranslated_elements: has_untranslated_elements
		do
			Result := untranslated_elements.first
		ensure
			result_attached: attached Result
		end

feature -- Status report

	has_untranslated_elements: BOOLEAN
			-- Do some untranslated elements exist?
		do
			Result := not untranslated_elements.is_empty
		end

feature -- Element change

	add_translation_unit (a_unit: E2B_TRANSLATION_UNIT)
			-- Add translation unit `a_unit'.
		require
			a_unit_attached: attached a_unit
		do
			if not ids.has (a_unit.id) then
				untranslated_elements.extend (a_unit)
				ids.put (True, a_unit.id.twin)
			end
		ensure
			ids.has (a_unit.id)
		end

	mark_translated (a_unit: E2B_TRANSLATION_UNIT)
			-- Mark `a_unit' as translated.
		local
			l_found: BOOLEAN
		do
			from
				untranslated_elements.start
			until
				untranslated_elements.after or l_found
			loop
				if untranslated_elements.item.id ~ a_unit.id then
					l_found := True
					translated_elements.extend (untranslated_elements.item)
					untranslated_elements.remove
				else
					untranslated_elements.forth
				end
			end
			check l_found end
		end

	reset
			-- Reset translation pool.
		do
			untranslated_elements.wipe_out
			translated_elements.wipe_out
			ids.wipe_out
		end

feature -- Convenience functions

	add_type (a_type: TYPE_A)
			-- Add type `a_type'.
		do
			if a_type.is_formal then
					-- Ignore formals
			else
				add_translation_unit (create {E2B_TU_TYPE}.make (a_type))
			end
		end

	add_feature (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add signature and implementation of feature `a_feature' of `a_context_type'.
		local
			l_attribute: E2B_TU_ATTRIBUTE
			l_signature: E2B_TU_ROUTINE_SIGNATURE
			l_implementation: E2B_TU_ROUTINE_IMPLEMENTATION
		do
			if a_feature.is_attribute then
				create l_attribute.make (a_feature, a_context_type)
				add_translation_unit (l_attribute)
			elseif a_feature.is_routine then
				if a_context_type.base_class.has_creator_of_name_id (a_feature.feature_name_id) then
					add_creator (a_feature, a_context_type)
				end
				create l_signature.make (a_feature, a_context_type)
				add_translation_unit (l_signature)
				create l_implementation.make (a_feature, a_context_type)
				add_translation_unit (l_implementation)
			else
				check False end
			end
		end

	add_referenced_feature (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add feature `a_feature' in of `a_context_type' as referenced feature.
		local
			l_attribute: E2B_TU_ATTRIBUTE
			l_signature: E2B_TU_ROUTINE_SIGNATURE
		do
			if a_feature.is_attribute then
				create l_attribute.make (a_feature, a_context_type)
				add_translation_unit (l_attribute)
			elseif a_feature.is_routine then
				create l_signature.make (a_feature, a_context_type)
				add_translation_unit (l_signature)
			else
				check False end
			end
		end

	add_creator (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add signature and implementation of creator `a_feature' of `a_context_type'.
		local
			l_creator: E2B_TU_CREATOR_SIGNATURE
			l_creator_impl: E2B_TU_CREATOR_IMPLEMENTATION
		do
			create l_creator.make (a_feature, a_context_type)
			add_translation_unit (l_creator)
			create l_creator_impl.make (a_feature, a_context_type)
			add_translation_unit (l_creator_impl)
		end

	add_referenced_creator (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add signature of creator `a_feature' in of `a_context_type'.
		local
			l_creator: E2B_TU_CREATOR_SIGNATURE
		do
			create l_creator.make (a_feature, a_context_type)
			add_translation_unit (l_creator)
		end

	add_functional_feature (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add functional representation of feature `a_feature' of `a_context_type'.
		local
			l_functional: E2B_TU_ROUTINE_FUNCTIONAL
		do
			create l_functional.make (a_feature, a_context_type)
			add_translation_unit (l_functional)
		end

	add_writes_function (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add writes function of feature `a_feature' of `a_context_type'.
		local
			l_writes: E2B_TU_WRITES_FUNCTION
		do
			create l_writes.make (a_feature, a_context_type)
			add_translation_unit (l_writes)
		end

	add_precondition_predicate (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add precondition predicate of feature `a_feature' of `a_context_type'.
		local
			l_pre_post_predicate: E2B_TU_ROUTINE_PRE_POST_PREDICATE
		do
			create l_pre_post_predicate.make (a_feature, a_context_type)
			add_translation_unit (l_pre_post_predicate)
		end

	add_postcondition_predicate (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Add postcondition predicate of feature `a_feature' of `a_context_type'.
		local
			l_pre_post_predicate: E2B_TU_ROUTINE_PRE_POST_PREDICATE
		do
			create l_pre_post_predicate.make (a_feature, a_context_type)
			add_translation_unit (l_pre_post_predicate)
		end

feature {NONE} -- Implementation

	ids: HASH_TABLE [BOOLEAN, STRING]
			-- Hash map to store translation unit ids.

end
