note
	description: "Translates Eiffel to Boogie code."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize translator.
		do
			create eve_proofs.make
			eve_proofs.reset
			eve_proofs.set_up_environment

			create last_translation.make_empty
		end

feature -- Access

	last_translation: attached STRING
			-- Boogie code of last translation.

	background_theory_file_name: attached STRING
			-- File name of background theory file.
		do
			Result := eve_proofs.background_theory_file_name
		end

feature -- Basic operations

	translate_class (a_class: CLASS_C)
			-- Translate class `a_class' to Boogie code.
		do
			eve_proofs.generate_boogie_code (a_class)

			create last_translation.make_empty
		ensure
			last_translation_set: attached last_translation and last_translation /= old last_translation
		end

	translate_feature (a_feature: FEATURE_I)
			-- Translate feature `a_feature' to Boogie code.
		do
			eve_proofs.boogie_generator.process_feature (a_feature)

			create last_translation.make_empty
		ensure
			last_translation_set: attached last_translation and last_translation /= old last_translation
		end

	translate_references
			-- Translate all referenced classes and features.
		do
			eve_proofs.generate_code_for_referenced_features
			eve_proofs.generate_code_for_referenced_types

			from
				create last_translation.make (1024)
				eve_proofs.verifier.verification_content.start
			until
				eve_proofs.verifier.verification_content.after
			loop
				last_translation.append ("%N//" + eve_proofs.verifier.verification_content.item.name + "%N")
				last_translation.append (eve_proofs.verifier.verification_content.item.content)
				last_translation.append ("%N%N")
				eve_proofs.verifier.verification_content.forth
			end
		ensure
			last_translation_set: attached last_translation and last_translation /= old last_translation
		end

feature {NONE} -- Implementation

	eve_proofs: EVE_PROOFS
			-- Instance of eve proofs used to translate the code.

end
