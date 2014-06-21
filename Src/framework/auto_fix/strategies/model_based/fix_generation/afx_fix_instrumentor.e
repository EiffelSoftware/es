note
	description: "Summary description for {AFX_FIX_INSTRUMENTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_INSTRUMENTOR

inherit
	AFX_SHARED_SESSION

	SHARED_SERVER

	SHARED_WORKBENCH

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature{NONE} -- Initialization

	make (a_fixes: like fixes)
			--
		do
			fixes := a_fixes.twin
		end

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Fix candidates to validate

feature{NONE} -- Path to overriding class

	override_class_path: PATH

feature -- Basic operation

	instrument
			-- Instrument `fixes' into the project.
			--
			-- Generate a new (overriding) class which contains the faulty feature and all its fixes.
			-- The class executes a different version of the faulty feature, depending on `AFX_INTERPRETER.active_fix_id'.
		require
			fixes /= Void and then not fixes.is_empty
		local
			l_feature_to_fix: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_feature_as: FEATURE_AS
			l_body_compound_ast: EIFFEL_LIST [INSTRUCTION_AS]
			l_new_features: STRING
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_new_class_text: STRING

			l_body_ast: BODY_AS
			l_feature_name_for_fix: STRING
		do
			l_feature_to_fix := feature_to_fix
			l_written_class := l_feature_to_fix.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)

				-- All new features from different fixes.
			l_new_features := "%N" + new_feature_with_original_body + "%N"
			from
				l_fix_cursor := fixes.new_cursor
				l_fix_cursor.start
			until
				l_fix_cursor.after
			loop
				l_new_features := l_new_features + "%N" + new_feature_with_fix (l_fix_cursor.item) + "%N"
				l_fix_cursor.forth
			end

				-- Modify the feature under fix into a dispatcher.
			l_body_compound_ast := l_feature_to_fix.body_compound_ast
			l_body_compound_ast.replace_text (inspect_instruction_for_fix_selection, l_match_list)
				-- Insert the new features after `feature_to_fix'.
			l_feature_to_fix.feature_as_ast.last_token (l_match_list).append_text (l_new_features, l_match_list)
				-- Modified class text.
			l_new_class_text := l_written_class.ast.text_32 (l_match_list).twin
			l_match_list.remove_modifications
				-- Store the new class into 'override'.
			store_override_class (l_written_class.name, l_new_class_text)
		end

	uninstrument
			-- Undo the instrumentation.
		local
			l_file: PLAIN_TEXT_FILE
		do
			if override_class_path /= Void then
				create l_file.make_with_path (override_class_path)
				if l_file.exists then
					l_file.delete
				end
				override_class_path := Void
			end
		end

feature{NONE} -- Implementation

	feature_to_fix: EPA_FEATURE_WITH_CONTEXT_CLASS
			--
		require
			fixes /= Void and then not fixes.is_empty
		do
			Result := fixes.first.context_feature
		end

	new_feature_with_original_body: STRING
			-- New feature with the original body, but under the new name.
		local
			l_feature_to_fix: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_feature_as: FEATURE_AS
			l_body_ast: BODY_AS
			l_feature_name_for_fix: STRING
		do
			l_feature_to_fix := feature_to_fix
			l_feature_name_for_fix := feature_name_with_fix_id (0)
			l_written_class := l_feature_to_fix.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)
			l_feature_to_fix.feature_as_ast.feature_names.replace_text (l_feature_name_for_fix, l_match_list)

			Result := l_feature_to_fix.feature_as_ast.text_32 (l_match_list).twin
			l_match_list.remove_modifications
		end

	new_feature_with_fix (a_fix: AFX_CODE_FIX_TO_FAULT): STRING
			-- New feature with the original body fixed by `a_fix'.
		local
			l_feature_to_fix: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_feature_as: FEATURE_AS
			l_body_ast: BODY_AS
			l_feature_name_for_fix: STRING
		do
			l_feature_to_fix := feature_to_fix
			l_feature_name_for_fix := feature_name_with_fix_id (a_fix.id)
			l_written_class := l_feature_to_fix.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)
			l_feature_to_fix.feature_as_ast.feature_names.replace_text (l_feature_name_for_fix, l_match_list)
			l_feature_to_fix.body_ast.replace_text (a_fix.fixed_body_text, l_match_list)

			Result := l_feature_to_fix.feature_as_ast.text_32 (l_match_list).twin
			l_match_list.remove_modifications
		end

	inspect_instruction_for_fix_selection: STRING
			--
		local
			l_argument_sequence, l_return_sequence: STRING
			l_feat_arg: FEAT_ARG
			l_argument_count, l_argument_index: INTEGER
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_fix: AFX_CODE_FIX_TO_FAULT
		do
				-- Arguments to be used to call the fixed features.
			l_argument_sequence := ""
			l_feat_arg := feature_to_fix.feature_.arguments
			if l_feat_arg /= Void then
				l_argument_count := l_feat_arg.count
				from
					l_argument_index := 1
				until
					l_argument_index > l_argument_count
				loop
					if not l_argument_sequence.is_empty then
						l_argument_sequence.append (", ")
					end
					l_argument_sequence.append (l_feat_arg.item_name (l_argument_index))

					l_argument_index := l_argument_index + 1
				end
				if not l_argument_sequence.is_empty then
					l_argument_sequence.prepend ("(")
					l_argument_sequence.append (")")
				end
			else
				l_argument_sequence := ""
			end


				-- Assignment to "Return" to be used.
			if feature_to_fix.feature_.type /= Void and then not feature_to_fix.feature_.type.is_void then
				l_return_sequence := "Result :="
			else
				l_return_sequence := ""
			end

			create Result.make (100 * fixes.count)
			Result.append ("inspect (create {AFX_FIX_SELECTOR}).selected_fix_id%N"
						+ "%Twhen 0 then " + l_return_sequence + " " + feature_name_with_fix_id (0) + " " + l_argument_sequence + "%N")
			from
				l_fix_cursor := fixes.new_cursor
				l_fix_cursor.start
			until
				l_fix_cursor.after
			loop
				l_fix := l_fix_cursor.item
				Result.append ("%Twhen " + l_fix.id.out + " then " + l_return_sequence + " " + feature_name_with_fix_id (l_fix.id) + " " + l_argument_sequence + "%N")

				l_fix_cursor.forth
			end
			Result.append ("%Telse (create {DEVELOPER_EXCEPTION}).raise%Nend%N")
		end

	feature_name_with_fix_id (a_id: INTEGER): STRING
			--
		do
			Result := feature_to_fix.feature_.feature_name_32 + "_ID_" + a_id.out
		end

	store_override_class (a_name, a_text: STRING)
			--
		local
			l_path_to_overriding_class: PATH
			l_file: PLAIN_TEXT_FILE
		do
			l_path_to_overriding_class := session.override_directory.extended (a_name.as_lower + ".e")
			override_class_path := l_path_to_overriding_class.twin

			create l_file.make_with_path (l_path_to_overriding_class)
			l_file.open_write

			if l_file.is_open_write then
				l_file.put_string (a_text)
				l_file.close
			end
		end

end
