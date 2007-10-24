indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ROOT_PRINTER

inherit

	CDD_PRINTER

	CDD_CONSTANTS

feature {NONE} -- Class text output

	append_class_header (a_class_name: STRING) is
			-- Append class header to output file
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
			output_file_not_void: output_file /= Void
		do
			append_text ("indexing%N")
			append_text ("%Tdescription: %"Automatic generated root class for cdd testing%"%N")
			append_text ("%Tauthor: %"CDD_TESTER_PRINTER%"%N")
			append_text ("%Tdate: %"$Date$%"%N")
			append_text ("%Trevision: %"$Revision$%"%N%N")
			append_text ("class%N%T " + a_class_name + " %N%N")
			append_text ("inherit%N%TCDD_INTERPRETER_SUPPORT%N%N")
			append_text ("create%N%Tmake%N%N")
			append_text ("feature {NONE} -- Initialization%N%N")
		end

	append_class_footer (a_class_name: STRING) is
			-- Append class footer to output file
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
			output_file_not_void: output_file /= Void
		do
			append_text ("%N%Nend -- " + a_class_name + "%N%N")
		end

end
