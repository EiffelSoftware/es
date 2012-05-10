note
	description: "Result of a single procedure."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_PROCEDURE_RESULT

inherit

	E2B_SHARED_CONTEXT

feature -- Access

	procedure_name: STRING
			-- Name of procedure.

	time: REAL
			-- Time used for verification in seconds.

	eiffel_feature: FEATURE_I
			-- Feature of procedure (if any).

	eiffel_class: CLASS_C
			-- Class of procedure (if any).
		do
			if eiffel_feature /= Void then
				Result := eiffel_feature.written_class
			end
		end

feature {E2B_OUTPUT_PARSER} -- Element change

	set_procedure_name (a_name: like procedure_name)
			-- Set `procedure_name' to `a_name'.
		do
			procedure_name := a_name
			eiffel_feature := name_translator.feature_for_boogie_name (procedure_name)
		ensure
			procedure_name_set: procedure_name = a_name
		end

	set_time (a_time: like time)
			-- Set `time' to `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

end
