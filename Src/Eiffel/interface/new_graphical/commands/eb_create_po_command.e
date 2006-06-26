indexing
	description: "[
				Command that searches all descendants and/or clients of SHARED_TRANSLATOR for calls to i18n() 
				and generates a .po file from the arguments found.
				]"
	author: "leof@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CREATE_PO_COMMAND

inherit
	EB_MENUABLE_COMMAND
	SHARED_EIFFEL_PROJECT
	SHARED_SERVER
	EB_SHARED_PREFERENCES
	EB_FILE_OPENER_CALLBACK
	IMPORTED_UTF8_READER_WRITER

feature --Access
	menu_name:STRING is
		--menu name
		do
			Result := "Generate .po file"
		end

feature --Access
	execute is
	do
		internal_execute
	end

	feature {NONE} --Implementation
		internal_execute is
				--
				local
					translator: CLASS_I
					compiled_translator: CLASS_C
					list: LIST[CLASS_I]
					classes_to_examine: ARRAYED_LIST[CLASS_C]
					annoying_popup: EV_WARNING_DIALOG
					file_dialog: EB_FILE_SAVE_DIALOG
				do
					if not eiffel_project.error_occurred then --should grey out on this
							list :=  eiffel_universe.classes_with_name ("SHARED_I18N_LOCALIZATOR")
							if list.count > 0 then
								translator := list.first
								if translator.compiled then
									--set translation function routine ids
									compiled_translator := translator.compiled_class

									translation_function :=	compiled_translator.feature_named ("i18n").rout_id_set
									plural_form_translation_function := compiled_translator.feature_named ("i18n_pl").rout_id_set
									po_file := build_po_file (find_clients(compiled_translator))
									-- ask where to put it
									create file_dialog.make_with_preference (preferences.dialog_data.last_saved_save_file_as_directory_preference)
									--file_dialog.save_actions.extend (agent write_po (po,file_dialog ))
									file_dialog.show_modal_to_window (window_manager.last_focused_development_window.window)

									write (file_dialog.file_name)
									po_file := Void --garbage collector can do the rest
								else
									--error: translator class is not compiled (so has no ast)	
									create annoying_popup.make_with_text ("The translator class does not seem to be compiled %N%
																			%It is not possible to generate a .po file until it has been compiled%
																			% (We must have an AST)")
									annoying_popup.show_modal_to_window (window_manager.last_focused_development_window.window)

								end
							else
									--error: could not find translator class in universe	
									create annoying_popup.make_with_text ("Could not find translator class in universe!%N%
																			% Are you using the i18n library?")
									annoying_popup.show_modal_to_window (window_manager.last_focused_development_window.window)
							end
					end
				end

		find_clients(a_class:CLASS_C):ARRAYED_LIST[CLASS_C] is
				-- build a list of all clients and descendants of a class
			require
				a_class_not_void: a_class /= Void
			do
				create Result.make (a_class.descendants.count+a_class.clients.count)
				Result.append(a_class.descendants)
				Result.append(a_class.clients)
			end


		build_po_file(clients: ARRAYED_LIST[CLASS_C]):PO_FILE is
				-- go through the list of clients of this class
				-- and extract information into the po_file
			local
				parser: I18N_AST_ITERATOR
				list: LEAF_AS_LIST
			do
				create Result.make_empty
				create parser
				from
					clients.start
				until
					clients.after
				loop
					io.put_string ("client: "+clients.item.name+"%N")
					if clients.item.has_ast then
							list := match_list_server.item (clients.item.class_id)
							parser.set_translator (translation_function)
							parser.set_plural_translator (plural_form_translation_function)
							parser.set_po_file (Result)
							parser.setup (clients.item.ast, list, False, False)
							parser.process_ast_node (clients.item.ast)
					else
						io.put_string("No AST%N")
					end
					clients.forth
				end
			end



		write(location: STRING_GENERAL) is
			-- Writes the po_file to location
			require
				source_not_void: po_file /= Void
				location_not_void: location /= void
			local
				file_name: FILE_NAME
				location_32: STRING_32
				file_opener: EB_FILE_OPENER
			do
						location_32 := location.as_string_32
						--DEbugging
--						io.put_string ("you wanted to write this to: %N")
--						io.put_string (location_32+"%N")
--						io.put_string (po_file.to_string)

						create file_name.make_from_string (location_32)
						if file_name.is_valid then
							create file_opener.make_with_parent (Current, file_name.out, window_manager.last_focused_development_window.window)
						end
			end


		translation_function: ID_SET
		plural_form_translation_function: ID_SET
		po_file: PO_FILE
	feature --Callbacks

	save_file(file:RAW_FILE) is
			-- write to file
		do
			file.create_read_write
			utf8_rw.file_write_string_32 (file, po_file.to_string)
		--	file.put_string (po_file.to_string)
			file.close
		end

end
