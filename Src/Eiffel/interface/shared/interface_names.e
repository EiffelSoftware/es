indexing
	description:
		"Constants for command names, etc."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	conventions:
		"a_: Accelerator key combination; %
		%b_: Button text; %
		%d_: Degree outputter; %
		%f_: Focus label text (tooltips); %
		%h_: Help text; %
		%i_: Icon ids for windows (ignored for motif); %
		%m_: Mnemonic (menu entry); %
		%l_: Label texts; %
		%n_: widget Names; %
		%s_: Stone names; %
		%t_: Title (part); %
		%e_: Short description, explanation; %
		%wt_: Title for wizards step; %
		%wb_: Body for wizards step; %
		%ws_: Subtitle for wizards step"
	date: "$Date$"
	revision: "$Revision$"

class
	INTERFACE_NAMES

inherit
	PRODUCT_NAMES
	SHARED_I18N_LOCALIZATOR

feature -- Button texts

	b_Abort: STRING_32							is do Result := i18n ("Abort") end
	b_Add: STRING_32							is do Result := i18n ("Add") end
	b_Add_text: STRING_32			 			is do Result := i18n("Add ->") end
	b_And: STRING_32							is do Result := i18n("And") end
	b_Apply: STRING_32							is do Result := i18n("Apply") end
	b_Browse: STRING_32							is do Result := i18n("Browse...") end
	b_Cancel: STRING_32							is do Result := i18n("Cancel") end
	b_C_functions: STRING_32					is do Result := i18n("C Functions") end
	b_Close: STRING_32							is do Result := i18n("Close") end
	b_Continue_anyway: STRING_32				is do Result := i18n("Continue Anyway") end
	b_Create: STRING_32							is do Result := i18n("Create") end
	b_Create_folder: STRING_32 					is do Result := i18n("Create Folder...") end
	b_Delete_command: STRING_32 				is do Result := i18n("Delete") end
	b_Descendant_time: STRING_32 				is do Result := i18n("Descendant Time") end
	b_Discard_assertions: STRING_32 			is do Result := i18n("Discard Assertions") end
	b_Display_Exception_Trace: STRING_32		is do Result := i18n("Display Exception Trace") end
	b_Down_text: STRING_32 						is do Result := i18n("Down") end
	b_Edit_ace: STRING_32 						is do Result := i18n("Edit") end
	b_Edit_command: STRING_32 					is do Result := i18n("Edit...") end
	b_Eiffel_features: STRING_32 				is do Result := i18n("Eiffel Features") end
	b_Feature_name: STRING_32 					is do Result := i18n("Feature Name") end
	b_Finish: STRING_32 						is do Result := i18n("Finish") end
	b_Function_time: STRING_32 					is do Result := i18n("Function Time") end
	b_Keep_assertions: STRING_32 				is do Result := i18n("Keep Assertions") end
	b_Load_ace: STRING_32 						is do Result := i18n("Load From...") end
	b_Move_to_folder: STRING_32 				is do Result := i18n("Move to Folder...") end
	b_New_ace: STRING_32 						is do Result := i18n("Reset") end
	b_New_command: STRING_32 					is do Result := i18n("Add...") end
	b_New_favorite_class: STRING_32 			is do Result := i18n("New Favorite Class...") end
	b_Next: STRING_32 							is do Result := i18n("Next") end
	b_Number_of_calls: STRING_32 				is do Result := i18n("Number of Calls") end
	b_Ok: STRING_32 							is do Result := i18n("OK") end
	b_Open_original: STRING_32 					is do Result := i18n("Open Original File") end
	b_Open_backup: STRING_32 					is do Result := i18n("Open Backup File") end
	b_Or: STRING_32 							is do Result := i18n("Or") end
	b_Percentage: STRING_32 					is do Result := i18n("Percentage") end
	b_Replace: STRING_32 						is do Result := i18n("Replace") end
	b_Replace_all: STRING_32 					is do Result := i18n("Replace all") end
	b_Recursive_functions: STRING_32 			is do Result := i18n("Recursive Functions") end
	b_Reload: STRING_32 						is do Result := i18n("Reload") end
	b_Remove: STRING_32 						is do Result := i18n("Remove") end
	b_Remove_all: STRING_32 					is do Result := i18n("Remove all") end
	b_Remove_text: STRING_32 					is do Result := i18n("<- Remove") end
	b_Retry: STRING_32 							is do Result := i18n("Retry") end
	b_Search: STRING_32 						is do Result := i18n("Search") end
	b_New_search: STRING_32 					is do Result := i18n("New Search?") end
	b_Save: STRING_32 							is do Result := i18n("Save") end
	b_Total_time: STRING_32 					is do Result := i18n("Total Time") end
	b_Up_text: STRING_32 						is do Result := i18n("Up") end
	b_Update: STRING_32 						is do Result := i18n("Update") end
	b_Compile: STRING_32 						is do Result := i18n("Compile") end
	b_Launch: STRING_32 						is do Result := i18n("Start") end
	b_Continue: STRING_32 						is do Result := i18n("Continue") end
	b_Finalize: STRING_32 						is do Result := i18n("Finalize") end
	b_Freeze: STRING_32 						is do Result := i18n("Freeze") end
	b_Precompile: STRING_32 					is do Result := i18n("Precompile") end
	b_Quickmelt: STRING_32 						is do Result := i18n("Quick Compile") end
	b_Cut: STRING_32 							is do Result := i18n("Cut") end
	b_Copy: STRING_32 							is do Result := i18n("Copy") end
	b_Paste: STRING_32 							is do Result := i18n("Paste") end
	b_New_editor: STRING_32 					is do Result := i18n("New Editor") end
	b_New_context: STRING_32 					is do Result := i18n("New Context") end
	b_New_window: STRING_32 					is do Result := i18n("New Window") end
	b_Open: STRING_32 							is do Result := i18n("Open") end
	b_Save_as: STRING_32 						is do Result := i18n("Save As") end
	b_Shell: STRING_32 							is do Result := i18n("External Editor") end
	b_Print: STRING_32 							is do Result := i18n("Print") end
	b_Undo: STRING_32 							is do Result := i18n("Undo") end
	b_Redo: STRING_32 							is do Result := i18n("Redo") end
	b_Create_new_cluster: STRING_32 			is do Result := i18n("New Cluster") end
	b_Create_new_class: STRING_32 				is do Result := i18n("New Class") end
	b_Create_new_feature: STRING_32 			is do Result := i18n("New Feature") end
	b_Send_stone_to_context: STRING_32 			is do Result := i18n("Synchronize") end
	b_Display_error_help: STRING_32 			is do Result := i18n("Help Tool") end
	b_Project_settings: STRING_32 				is do Result := i18n("Project Settings") end
	b_System_info: STRING_32 					is do Result := i18n("System Info") end
	b_Bkpt_info: STRING_32 						is do Result := i18n("Breakpoint Info") end
	b_Bkpt_enable: STRING_32 					is do Result := i18n("Enable Breakpoints") end
	b_Bkpt_disable: STRING_32 					is do Result := i18n("Disable Breakpoints") end
	b_Bkpt_remove: STRING_32 					is do Result := i18n("Remove Breakpoints") end
	b_Bkpt_stop_in_hole: STRING_32 				is do Result := i18n("Pause") end
	b_Exec_kill: STRING_32 						is do Result := i18n("Stop Application") end
	b_Exec_into: STRING_32 						is do Result := i18n("Step Into") end
	b_Exec_no_stop: STRING_32 					is do Result := i18n("Launch Without Stopping") end
	b_Exec_out: STRING_32 						is do Result := i18n("Step Out") end
	b_Exec_step: STRING_32 						is do Result := i18n("Step") end
	b_Exec_stop: STRING_32 						is do Result := i18n("Pause") end
	b_Run_finalized: STRING_32 					is do Result := i18n("Run Finalized") end
	b_Toggle_stone_management: STRING_32 		is do Result := i18n("Link Context") end
	b_Raise_all: STRING_32 						is do Result := i18n("Raise Windows") end
	b_Remove_class_cluster: STRING_32 			is do Result := i18n("Remove Class/CLuster") end
	b_Minimize_all: STRING_32 					is do Result := i18n("Minimize All") end
	b_Terminate_c_compilation: STRING_32 		is do Result := i18n("Terminate C compilation") end
	b_Expand_all: STRING_32 					is do Result := i18n("Expand All") end
	b_Collapse_all: STRING_32 					is do Result := i18n("Collapse All") end
	b_Dbg_exception_handler: STRING_32 			is do Result := i18n("Exceptions") end
	b_Dbg_assertion_checking_disable: STRING_32	is do Result := i18n("Disable assertion checking") end
	b_Dbg_assertion_checking_restore: STRING_32 is do Result := i18n("Restore assertion checking") end

	--added by EMU-PROJECT--
	b_emu_upload_class: STRING_32 				is do Result := i18n("Upload") end
	b_emu_download_class: STRING_32 			is do Result := i18n("Download") end
	b_emu_lock_class: STRING_32 				is do Result := i18n("Lock") end
	b_emu_unlock_class: STRING_32 				is do Result := i18n("Unlock") end
	b_emu_new_project_class: STRING_32 			is do Result := i18n("Create Project") end
	b_emu_add_user_class: STRING_32 			is do Result := i18n("Add User") end
	------------------------

feature -- Graphical degree output

	d_Classes_to_go: STRING_32 						is do Result := i18n("Classes to Go:") end
	d_Clusters_to_go: STRING_32 					is do Result := i18n("Clusters to Go:") end
	d_Compilation_class: STRING_32 					is do Result := i18n("Class:") end
	d_Compilation_cluster: STRING_32 				is do Result := i18n("Cluster:") end
	d_Compilation_progress: STRING_32 				is do Result := i18n("Compilation Progress for ") end
	d_Degree: STRING_32 							is do Result := i18n("Degree:") end
	d_Documentation: STRING_32 						is do Result := i18n("Documentation") end
	d_Features_processed: STRING_32 				is do Result := i18n("Completed: ") end
	d_Features_to_go: STRING_32 					is do Result := i18n("Remaining: ") end
	d_Generating: STRING_32 						is do Result := i18n("Generating: ") end
	d_Resynchronizing_breakpoints: STRING_32 		is do Result := i18n("Resynchronizing Breakpoints") end
	d_Resynchronizing_tools: STRING_32 				is do Result := i18n("Resynchronizing Tools") end
	d_Reverse_engineering: STRING_32 				is do Result := i18n("Reverse Engineering Project") end
	d_Finished_removing_dead_code: STRING_32 		is do Result := i18n("Dead Code Removal Completed") end

feature -- Help text

	h_No_help_available: STRING_32 					is do Result := i18n("No help available for this element") end

feature -- File names

	default_stack_file_name: STRING_32 				is do Result := i18n("stack") end

feature -- Accelerator, focus label and menu name

	m_About: STRING_32 is
		once
			Result := formatter.solve_template (i18n ("&About $1..."), [Workbench_name])
		end
	m_Advanced: STRING_32 								is do Result := i18n("Ad&vanced") end
	m_Add_to_favorites: STRING_32 						is do Result := i18n("&Add to Favorites") end
	m_Address_toolbar: STRING_32 						is do Result := i18n("&Address Bar") end
	m_Apply: STRING_32 									is do Result := i18n("&Apply") end
	m_Breakpoints_tool: STRING_32 						is do Result := i18n("Breakpoints") end

	l_class_tree_assemblies: STRING_32 					is do Result := i18n("Assemblies") end
	l_class_tree_clusters: STRING_32 					is do Result := i18n("Clusters") end
	l_class_tree_libraries: STRING_32 					is do Result := i18n("Libraries") end
	l_class_tree_overrides: STRING_32 					is do Result := i18n("Overrides") end

	f_Clear_breakpoints: STRING_32 						is do Result := i18n("Remove all breakpoints") end
	m_Clear_breakpoints: STRING_32 						is do Result := i18n("Re&move All Breakpoints") end
	m_Comment: STRING_32 								is do Result := i18n("&Comment%TCtrl+K") end
	m_Compilation_C_Workbench: STRING_32 				is do Result := i18n("Compile W&orkbench C Code") end
	m_Compilation_C_Final: STRING_32 					is do Result := i18n("Compile F&inalized C Code") end
	m_Contents: STRING_32 								is do Result := i18n("&Contents") end
	m_Customize_general: STRING_32 						is do Result := i18n("&Customize Standard Toolbar...") end
	m_Customize_project: STRING_32 						is do Result := i18n("Customize P&roject Toolbar...") end
	m_Customize_refactoring: STRING_32 					is do Result := i18n("Customize Re&factoring Toolbar...") end
	m_Cut: STRING_32 									is do Result := i18n("Cu&t%TCtrl+X") end
	f_Cut: STRING_32 									is do Result := i18n("Cut (Ctrl+X)") end
	m_Call_stack_tool: STRING_32 						is do Result := i18n("Call stack") end
	m_Cluster_tool: STRING_32 							is do Result := i18n("&Clusters") end
	m_Complete_word: STRING_32 							is do Result := i18n("Complete &Word") end
	m_Complete_class_name: STRING_32 					is do Result := i18n("Complete Class &Name") end
	m_Context_tool: STRING_32 							is do Result := i18n("Conte&xt") end
	m_Copy: STRING_32 									is do Result := i18n("&Copy%TCtrl+C") end
	f_Copy: STRING_32 									is do Result := i18n("Copy (Ctrl+C)") end
	m_Close: STRING_32 									is do Result := i18n("&Close Window%TAlt+F4") end
	m_Close_short: STRING_32 							is do Result := i18n("&Close") end
	f_Create_new_cluster: STRING_32 					is do Result := i18n("Create a new cluster") end
	f_Create_new_class: STRING_32 						is do Result := i18n("Create a new class") end
	f_Create_new_feature: STRING_32 					is do Result := i18n("Create a new feature") end

	m_Dbg_assertion_checking_disable: STRING_32 		is do Result := i18n("Disable Assertion Checking") end
	m_Dbg_assertion_checking_restore: STRING_32 		is do Result := i18n("Restore Assertion Checking") end
	m_Dbg_exception_handler: STRING_32 					is do Result := i18n("Exceptions Handling") end
	m_Debug_interrupt_new: STRING_32 					is do Result := i18n("I&nterrupt Application") end
	f_Debug_edit_object: STRING_32 						is do Result := i18n("Edit Object content") end
	m_Debug_edit_object: STRING_32 						is do Result := i18n("Edit Object Content") end
	f_Debug_dynamic_eval: STRING_32 					is do Result := i18n("Dynamic feature evaluation") end
	m_Debug_dynamic_eval: STRING_32 					is do Result := i18n("Dynamic Feature Evaluation") end
	m_Debug_kill: STRING_32 							is do Result := i18n("&Stop Application") end
	f_Debug_run: STRING_32 								is do Result := i18n("Run") end
	m_Debug_run: STRING_32 								is do Result := i18n("&Run%TCtrl+R") end
	m_Debug_run_new: STRING_32 							is do Result := i18n("St&art") end
	f_diagram_delete: STRING_32 						is do Result := i18n("Delete") end
	l_diagram_delete: STRING_32 						is do Result := i18n("Delete graphical items, remove code from system") end
	f_diagram_crop: STRING_32 							is do Result := i18n("Crop diagram") end
	m_diagram_crop: STRING_32 							is do Result := i18n("&Crop Diagram") end
	f_diagram_zoom_out: STRING_32 						is do Result := i18n("Zoom out") end
	f_diagram_put_right_angles: STRING_32 				is do Result := i18n("Force right angles") end
	f_diagram_remove_right_angles: STRING_32 			is do Result := i18n("Remove right angles") end
	m_diagram_link_tool: STRING_32 						is do Result := i18n("&Put Right Angles") end
	f_diagram_to_png: STRING_32 						is do Result := i18n("Export diagram to PNG") end
	m_diagram_to_png: STRING_32 						is do Result := i18n("&Export Diagram to PNG") end
	f_diagram_context_depth: STRING_32 					is do Result := i18n("Select depth of relations") end
	m_diagram_context_depth: STRING_32 					is do Result := i18n("&Select Depth of Relations") end
	f_diagram_delete_view: STRING_32 					is do Result := i18n("Delete current view") end
	f_diagram_reset_view: STRING_32 					is do Result := i18n("Reset current view") end
	m_diagram_delete_view: STRING_32 					is do Result := i18n("&Delete Current View") end
	m_diagram_reset_view: STRING_32 					is do Result := i18n("&Reset Current View") end
	f_diagram_zoom_in: STRING_32 						is do Result := i18n("Zoom in") end
	f_diagram_fit_to_screen: STRING_32 					is do Result := i18n("Fit to screen") end
	f_diagram_undo: STRING_32 							is do Result := i18n("Undo last action") end
	f_diagram_hide_supplier: STRING_32 					is do Result := i18n("Hide supplier links") end
	f_diagram_show_supplier: STRING_32 					is do Result := i18n("Show supplier links") end

	l_diagram_supplier_visibility: STRING_32 			is do Result := i18n("Toggle visibility of supplier links") end

	l_diagram_add_ancestors: STRING_32 					is do Result := i18n("Add class ancestors to diagram") end
	l_diagram_add_descendents: STRING_32 				is do Result := i18n("Add class descendents to diagram") end
	l_diagram_add_suppliers: STRING_32 					is do Result := i18n("Add class suppliers to diagram") end
	l_diagram_add_clients: STRING_32 					is do Result := i18n("Add class clients to diagram") end

	f_diagram_hide_labels: STRING_32 					is do Result := i18n("Hide labels") end
	f_diagram_show_labels: STRING_32 					is do Result := i18n("Show labels") end
	f_diagram_show_uml: STRING_32 						is do Result := i18n("Show UML") end
	f_diagram_show_bon: STRING_32 						is do Result := i18n("Show BON") end
	f_diagram_hide_clusters: STRING_32 					is do Result := i18n("Hide clusters") end
	f_diagram_show_clusters: STRING_32 					is do Result := i18n("Show clusters") end
	f_diagram_show_legend: STRING_32 					is do Result := i18n("Show cluster legend") end
	f_diagram_hide_legend: STRING_32 					is do Result := i18n("Hide cluster legend") end
	f_diagram_remove_anchor: STRING_32 					is do Result := i18n("Remove anchor") end
	l_diagram_labels_visibility: STRING_32 				is do Result := i18n("Toggle visibility of client link labels") end
	l_diagram_uml_visibility: STRING_32 				is do Result := i18n("Toggle between UML and BON view") end
	l_diagram_clusters_visibility: STRING_32 			is do Result := i18n("Toggle visibility of clusters") end
	l_diagram_legend_visibility: STRING_32 				is do Result := i18n("Toggle visibility of cluster legend") end
	l_diagram_remove_anchor: STRING_32 					is do Result := i18n("Remove anchor") end
	l_diagram_force_directed: STRING_32 				is do Result := i18n("Turn on/off physics") end
	l_diagram_toggle_quality: STRING_32 				is do Result := i18n("Toggle quality level") end
	f_diagram_high_quality: STRING_32 					is do Result := i18n("Switch to high quality") end
	f_diagram_low_quality: STRING_32 					is do Result := i18n("Switch to low quality") end
	f_diagram_hide_inheritance: STRING_32 				is do Result := i18n("Hide inheritance links") end
	f_diagram_show_inheritance: STRING_32 				is do Result := i18n("Show inheritance links") end
	l_diagram_inheritance_visibility: STRING_32 		is do Result := i18n("Toggle visibility of inheritance links") end
	f_diagram_redo: STRING_32 							is do Result := i18n("Redo last action") end
	f_diagram_fill_cluster: STRING_32 					is do Result := i18n("Include all classes of cluster") end
	f_diagram_history: STRING_32 						is do Result := i18n("History tool") end
	f_diagram_remove: STRING_32 						is do Result := i18n("Remove figure") end
	l_diagram_remove: STRING_32 						is do Result := i18n("Delete graphical items") end
	f_diagram_create_supplier_links: STRING_32 			is do Result := i18n("Create new client-supplier links") end
	f_diagram_create_aggregate_supplier_links: STRING_32 is do Result := i18n ("Create new aggregate client-supplier links") end
	f_diagram_create_inheritance_links: STRING_32 		is do Result := i18n("Create new inheritance links") end
	l_diagram_create_links: STRING_32 					is do Result := i18n("Select type of new links") end
	f_diagram_new_class: STRING_32 						is do Result := i18n("Create a new class") end
	f_diagram_change_header: STRING_32 					is do Result := i18n("Change class name and generics") end
	f_diagram_change_color: STRING_32 					is do Result := i18n("Change color") end
	f_diagram_force_directed_on: STRING_32 				is do Result := i18n("Turn on physics") end
	f_diagram_force_directed_off: STRING_32 			is do Result := i18n("Turn off physics") end
	f_diagram_force_settings: STRING_32 				is do Result := i18n("Show physics settings dialog") end
	f_Disable_stop_points: STRING_32 					is do Result := i18n("Disable all breakpoints") end
	m_Disable_stop_points: STRING_32 					is do Result := i18n("&Disable All Breakpoints") end
	m_Debug_block: STRING_32 							is do Result := i18n("E&mbed in %"Debug...%"%TCtrl+D") end
	m_Editor: STRING_32 								is do Result := i18n("&Editor") end
	m_Eiffel_introduction: STRING_32 					is do Result := i18n("&Introduction to Eiffel") end
	f_Enable_stop_points: STRING_32 					is do Result := i18n("Enable all breakpoints") end
	m_Enable_stop_points: STRING_32 					is do Result := i18n("&Enable All breakpoints") end
	m_Exec_last: STRING_32 								is do Result := i18n("&Out of Routine") end
	m_Exec_nostop: STRING_32 							is do Result := i18n("&Ignore Breakpoints") end
	m_Exec_step: STRING_32 								is do Result := i18n("&Step-by-Step") end
	m_Exec_into: STRING_32 								is do Result := i18n("Step In&to") end
	m_Exit_project: STRING_32 							is do Result := i18n("E&xit") end
	m_Explorer_bar: STRING_32 							is do Result := i18n("&Tools") end
	m_Export_to: STRING_32 								is do Result := i18n("Save Cop&y As...") end
	m_Export_XMI: STRING_32 							is do Result := i18n("E&xport XMI...") end
	m_Expression_evaluation: STRING_32 					is do Result := i18n("Expression Evaluation") end
	m_External_editor: STRING_32 						is do Result := i18n("&External Editor") end
	m_Favorites_tool: STRING_32 						is do Result := i18n("F&avorites") end
	m_Features_tool: STRING_32 							is do Result := i18n("&Features") end
	f_Finalize: STRING_32 								is do Result := i18n("Finalize...") end
	m_Finalize_new: STRING_32 							is do Result := i18n("Finali&ze...") end
	m_Find: STRING_32 									is do Result := i18n("&Search") end
	m_Find_next: STRING_32 								is do Result := i18n("Find &Next") end
	m_Find_previous: STRING_32 							is do Result := i18n("Find &Previous") end
	m_Find_selection: STRING_32 						is do Result := i18n("Find &Selection") end
	f_Freeze: STRING_32 								is do Result := i18n("Freeze...") end
	m_Freeze_new: STRING_32 							is do Result := i18n("&Freeze...") end
	m_General_toolbar: STRING_32 						is do Result := i18n("&Standard Buttons") end
	m_Generate_documentation: STRING_32					is do Result := i18n("Generate &Documentation...") end
	m_Go_to: STRING_32 									is do Result := i18n("&Go to...") end
	m_Guided_tour: STRING_32 							is do Result := i18n("&Guided Tour") end
	m_Help: STRING_32 									is do Result := i18n("&Help") end
	m_Hide_favorites: STRING_32 						is do Result := i18n("&Hide Favorites") end
	m_Hide_formatting_marks: STRING_32 					is do Result := i18n("&Hide Formatting Marks") end
	m_History_forth: STRING_32 							is do Result := i18n("&Forward") end
	m_History_back: STRING_32 							is do Result := i18n("&Back") end
	f_History_forth: STRING_32 							is do Result := i18n("Go forth") end
	f_History_back: STRING_32 							is do Result := i18n("Go back") end
	m_How_to_s: STRING_32 								is do Result := i18n("&How to's") end
	m_If_block: STRING_32 								is do Result := i18n("&Embed in %"if...%"%TCtrl+I") end
	m_Indent: STRING_32 								is do Result := i18n("&Indent selection%TTab") end
	m_Line_numbers: STRING_32 							is do Result := i18n("Toggle &Line numbers") end
	m_Folding_points: STRING_32							is do Result := i18n("Toggle Folding &points") end

	f_Melt: STRING_32 									is do Result := i18n("Compile current project") end
	m_Melt_new: STRING_32 								is do Result := i18n("&Compile") end
	m_New: STRING_32 									is do Result := i18n("&New") end
	f_New_window: STRING_32 							is do Result := i18n("Create a new window") end
	m_New_window: STRING_32 							is do Result := i18n("New &Window") end
	m_New_dynamic_lib: STRING_32 						is do Result := i18n("&Dynamic Library Builder...") end
	m_New_project: STRING_32 							is do Result := i18n("&New Project...") end
	m_Ok: STRING_32 									is do Result := i18n("&OK") end
	m_Open: STRING_32 									is do Result := i18n("&Open...%TCtrl+O") end
	m_Open_new: STRING_32 								is do Result := i18n("Op&en...") end
	m_Open_project: STRING_32 							is do Result := i18n("&Open Project...") end
	m_Organize_favorites: STRING_32 					is do Result := i18n("&Organize Favorites...") end
	m_Output: STRING_32 								is do Result := i18n("&Output") end
	f_Paste: STRING_32 									is do Result := i18n("Paste (Ctrl+V)") end
	m_Paste: STRING_32 									is do Result := i18n("&Paste%TCtrl+V") end
	m_Precompile_new: STRING_32 						is do Result := i18n("&Precompile") end
	f_Print: STRING_32 									is do Result := i18n("Print") end
	m_Print: STRING_32 									is do Result := i18n("&Print") end
	f_preferences: STRING_32 							is do Result := i18n("Preferences") end
	m_Preferences: STRING_32 							is do Result := i18n("&Preferences...") end
	m_Profile_tool: STRING_32 							is do Result := i18n("Pro&filer...") end
	m_Project_toolbar: STRING_32 						is do Result := i18n("&Project Bar") end
	m_Refactoring_toolbar: STRING_32 					is do Result := i18n("Re&factoring Bar") end
	f_refactoring_pull: STRING_32 						is do Result := i18n("Pull up feature") end
	f_refactoring_rename: STRING_32 					is do Result := i18n("Rename feature/class") end
	f_refactoring_undo: STRING_32 						is do Result := i18n("Undo last refactoring (only works as long as no file that was refactored has been changed by hand)") end
	f_refactoring_redo: STRING_32 						is do Result := i18n("Redo last refactoring (only works as long as no file that was refactored has been changed by hand)") end
	b_refactoring_pull: STRING_32 						is do Result := i18n("Pull up") end
	b_refactoring_push: STRING_32 						is do Result := i18n("Push down") end
	b_refactoring_rename: STRING_32 					is do Result := i18n("Rename") end
	b_refactoring_undo: STRING_32 						is do Result := i18n("Undo refactoring") end
	b_refactoring_redo: STRING_32 						is do Result := i18n("Redo refactoring") end
	m_Recent_project: STRING_32 						is do Result := i18n("&Recent Projects") end
	m_Redo: STRING_32 									is do Result := i18n("Re&do%TCtrl+Y") end
	f_Redo: STRING_32 									is do Result := i18n("Redo (Ctrl+Y)") end
	m_Replace: STRING_32 								is do Result := i18n("&Replace...") end
	f_Retarget_diagram: STRING_32 						is do Result := i18n("Target to cluster or class") end
	f_Run_finalized: STRING_32 							is do Result := i18n("Run finalized system") end
	m_Run_finalized: STRING_32 							is do Result := i18n("&Run Finalized System") end
	f_Save: STRING_32 									is do Result := i18n("Save") end
	m_Save_new: STRING_32 								is do Result := i18n("&Save") end
	m_Save_As: STRING_32 								is do Result := i18n("S&ave As...") end
	m_Search: STRING_32 								is do Result := i18n("&Find...") end
	m_Search_tool: STRING_32 							is do Result := i18n("&Search") end
	m_Select_all: STRING_32 							is do Result := i18n("Select &All%TCtrl+A") end
	m_Send_to: STRING_32 								is do Result := i18n("Sen&d to") end
	m_show_assigners: STRING_32 						is do Result := i18n("A&ssigners") end
	m_Show_class_cluster: STRING_32 					is do Result := i18n("Find in Cluster Tree") end
	m_show_creators: STRING_32 							is do Result := i18n("C&reators") end
	m_Show_favorites: STRING_32 						is do Result := i18n("&Show Favorites") end
	m_Show_formatting_marks: STRING_32 					is do Result := i18n("&Show Formatting Marks") end
	m_Showancestors: STRING_32 							is do Result := i18n("&Ancestors") end
	m_Showattributes: STRING_32 						is do Result := i18n("A&ttributes") end
	m_Showcallers: STRING_32 							is do Result := i18n("&Callers") end
	m_Showcallees: STRING_32 							is do Result := i18n("Call&ees") end
	m_Show_creation: STRING_32 							is do Result := i18n("&Creators") end
	m_Show_assignees: STRING_32 						is do Result := i18n("&Assignees") end
	m_Showclick: STRING_32 								is do Result := i18n("C&lickable") end
	m_Showclients: STRING_32 							is do Result := i18n("Cli&ents") end
	m_showcreators: STRING_32 							is do Result := i18n("&Creators") end
	m_Showdeferreds: STRING_32 							is do Result := i18n("&Deferred") end
	m_Showdescendants: STRING_32 						is do Result := i18n("De&scendants") end
	m_Showexported: STRING_32 							is do Result := i18n("Ex&ported") end
	m_Showexternals: STRING_32 							is do Result := i18n("E&xternals") end
	m_Showflat: STRING_32 								is do Result := i18n("&Flat") end
	m_Showfs: STRING_32 								is do Result := i18n("&Interface") end
	m_Showfuture: STRING_32 							is do Result := i18n("&Descendant Versions") end
	m_Showhistory: STRING_32 							is do Result := i18n("&Implementers") end
	m_Showindexing: STRING_32 							is do Result := i18n("&Indexing clauses") end
	m_show_invariants: STRING_32 						is do Result := i18n("In&variants") end
	m_Showonces: STRING_32 								is do Result := i18n("O&nce/Constants") end
	m_Showpast: STRING_32 								is do Result := i18n("&Ancestor Versions") end
	m_Showroutines: STRING_32 							is do Result := i18n("&Routines") end
	m_Showshort: STRING_32 								is do Result := i18n("C&ontract") end
	m_Showhomonyms: STRING_32 							is do Result := i18n("&Homonyms") end
	m_Showsuppliers: STRING_32 							is do Result := i18n("S&uppliers") end
	m_Showtext_new: STRING_32 							is do Result := i18n("Te&xt") end
	m_System_new: STRING_32 							is do Result := i18n("Project &Settings...") end
	m_Toolbars: STRING_32 								is do Result := i18n("Tool&bars") end
	m_To_lower: STRING_32 								is do Result := i18n("Set to &Lowercase%TCtrl+Shift+U") end
	m_To_upper: STRING_32 								is do Result := i18n("Set to U&ppercase%TCtrl+U") end
	m_Uncomment: STRING_32 								is do Result := i18n("U&ncomment%TCtrl+Shift+K") end
	f_Uncomment: STRING_32 								is do Result := i18n("Uncomment selected lines") end
	m_Undo: STRING_32 									is do Result := i18n("&Undo%TCtrl+Z") end
	f_Undo: STRING_32 									is do Result := i18n("Undo (Ctrl+Z)") end
	m_Unindent: STRING_32 								is do Result := i18n("&Unindent Selection%TShift+Tab") end
	m_Windows_tool: STRING_32 							is do Result := i18n("&Windows") end
	m_Watch_tool: STRING_32 							is do Result := i18n("Watch Tool") end
	m_Wizard_precompile: STRING_32 						is do Result := i18n("Precompilation &Wizard...") end
	f_Wizard_precompile: STRING_32 						is do Result := i18n("Wizard to precompile libraries") end
	f_go_to_first_occurrence: STRING_32 				is do Result := i18n("Double click to go to first occurrence") end

feature -- Toggles

	f_hide_alias: STRING_32 							is do Result := i18n("Hide Alias Name") end
	f_hide_assigner: STRING_32 							is do Result := i18n("Hide Assigner Command Name") end
	f_hide_signature: STRING_32 						is do Result := i18n("Hide Signature") end
	f_show_alias: STRING_32 							is do Result := i18n("Show Alias Name") end
	f_show_assigner: STRING_32 							is do Result := i18n("Show Assigner Command Name") end
	f_show_signature: STRING_32 						is do Result := i18n("Show Signature") end
	l_toggle_alias: STRING_32 							is do Result := i18n("Toggle visibility of feature alias name") end
	l_toggle_assigner: STRING_32 						is do Result := i18n("Toggle visibility of assigner command name") end
	l_toggle_signature: STRING_32 						is do Result := i18n("Toggle visibility of feature signature") end

feature -- Menu mnenomics

	m_Add_exported_feature: STRING_32 					is do Result := i18n("&Add...") end
	m_Bkpt_info: STRING_32 								is do Result := i18n("Brea&kpoint Information") end
	m_Class_info: STRING_32 							is do Result := i18n("Cla&ss Views") end
	m_Check_exports: STRING_32 							is do Result := i18n("Chec&k Export Clauses") end
	m_Create_new_cluster: STRING_32 					is do Result := i18n("New C&luster...") end
	m_Create_new_class: STRING_32 						is do Result := i18n("&New Class...") end
	m_Create_new_feature: STRING_32 					is do Result := i18n("New Fea&ture...") end
	m_Debug: STRING_32 									is do Result := i18n("&Debug") end
	m_Debugging_tool: STRING_32 						is do Result := i18n("&Debugging Tools") end
	m_Disable_this_bkpt: STRING_32 						is do Result := i18n("&Disable This Breakpoint") end
	m_Display_error_help: STRING_32 					is do Result := i18n("Compilation Error &Wizard...") end
	m_Display_system_info: STRING_32 					is do Result := i18n("S&ystem Info") end
	m_Edit: STRING_32 									is do Result := i18n("&Edit") end
	m_Edit_condition: STRING_32 						is do Result := i18n("E&dit Condition") end
	m_Edit_exported_feature: STRING_32 					is do Result := i18n("&Edit...") end
	m_Edit_external_commands: STRING_32 				is do Result := i18n("&External Commands...") end
	m_Enable_this_bkpt: STRING_32 						is do Result := i18n("&Enable This Breakpoint") end
	m_Favorites: STRING_32 								is do Result := i18n("Fav&orites") end
	m_Feature_info: STRING_32 							is do Result := i18n("Feat&ure Views") end
	m_File: STRING_32 									is do Result := i18n("&File") end
	m_Formats: STRING_32 								is do Result := i18n("F&ormat") end
	m_Formatter_separators: ARRAY [STRING_32] is
		once
			Result := <<i18n("Text Generators"), i18n("Class Relations"), i18n("Restrictors"), i18n("Main Editor Views")>>
		end
	m_History: STRING_32 								is do Result := i18n("&Go to") end
	m_Maximize: STRING_32 								is do Result := i18n("Ma&ximize") end
	m_Minimize: STRING_32 								is do Result := i18n("Mi&nimize") end
	m_Minimize_all: STRING_32 							is do Result := i18n("&Minimize All") end
	m_New_editor: STRING_32 							is do Result := i18n("New Ed&itor Window") end
	m_New_context_tool: STRING_32 						is do Result := i18n("New Con&text Window") end
	m_Object: STRING_32 								is do Result := i18n("&Object") end
	m_Object_tools: STRING_32 							is do Result := i18n("&Object Tools") end
	m_Open_eac_browser: STRING_32 						is do Result := i18n("EAC Browser") end
	m_Pretty_print: STRING_32 							is do Result := i18n("Expand an Object") end
	m_Project: STRING_32 								is do Result := i18n("&Project") end
	m_Quick_compile: STRING_32 							is do Result := i18n("&Quick Compile") end
	m_Raise: STRING_32 									is do Result := i18n("&Raise") end
	m_Raise_all: STRING_32 								is do Result := i18n("&Raise All") end
	m_Raise_all_unsaved: STRING_32 						is do Result := i18n("Raise &Unsaved Windows") end
	m_Remove_class_cluster: STRING_32 					is do Result := i18n("&Remove Current Item") end
	m_Remove_exported_feature: STRING_32 				is do Result := i18n("&Remove") end
	m_Remove_condition: STRING_32 						is do Result := i18n("Remove Condition") end
	m_Remove_this_bkpt: STRING_32 						is do Result := i18n("&Remove This Breakpoint") end
	m_Run_to_this_point: STRING_32 						is do Result := i18n("&Run to This Point") end
	m_Send_stone_to_context: STRING_32 					is do Result := i18n("S&ynchronize Context Tool") end
	m_Set_conditional_breakpoint: STRING_32 			is do Result := i18n("Set &Conditional Breakpoint") end
	m_Set_critical_stack_depth: STRING_32 				is do Result := i18n("Overflow &Prevention...") end
	m_Set_slice_size: STRING_32 						is do Result := i18n("&Alter size") end
	m_Special: STRING_32 								is do Result := i18n("&Special") end
	m_Separate_stone: STRING_32 						is do Result := i18n("Unlin&k Context Tool") end
	m_teachmode: STRING_32								is do Result := i18n("Teachmode") end
	m_Tools: STRING_32 									is do Result := i18n("&Tools") end
	m_Unify_stone: STRING_32 							is do Result := i18n("Lin&k Context Tool") end
	m_View: STRING_32 									is do Result := i18n("&View") end
	m_Window: STRING_32 								is do Result := i18n("&Window") end

	--added by EMU-PROJECT--
	m_emu_upload_class: STRING_32 						is do Result := i18n("Emu &upload ...") end
	m_emu_download_class: STRING_32 					is do Result := i18n("Emu &download...") end
	m_emu_lock_class: STRING_32 						is do Result := i18n("Emu &lock...") end
	m_emu_unlock_class: STRING_32 						is do Result := i18n("Emu u&nlock...") end
	m_emu_new_project_class: STRING_32 					is do Result := i18n("Emu create &Project...") end
	m_emu_add_user_class: STRING_32 					is do Result := i18n("Emu &add user...") end
	------------------------

feature -- Label texts

	l_Ace_file_for_frame: STRING_32 					is do Result := i18n("Ace file") end
	l_action_colon: STRING_32 							is do Result := i18n("Action:") end
	l_Active_query: STRING_32 							is do Result := i18n("Active query") end
	l_Address: STRING_32 								is do Result := i18n("Address:") end
	l_add_project_config_file: STRING_32 				is do Result := i18n("Add Project...") end
	l_All: STRING_32 									is do Result := i18n("recursive") end
	l_Alias_name: STRING_32 							is do Result := i18n("Alias:") end
	l_Ancestors: STRING_32 								is do Result := i18n("ancestors") end
	l_Arguments: STRING_32 								is do Result := i18n("Arguments") end
	l_assigners: STRING_32 								is do Result := i18n("assigners") end
	l_Attributes: STRING_32 							is do Result := i18n("attributes") end
	l_Available_buttons_text: STRING_32 				is do Result := i18n("Available buttons") end
	l_Basic_application: STRING_32 						is do Result := i18n("Basic application (no graphics library included)") end
	l_Basic_text: STRING_32 							is do Result := i18n("basic text view") end
	l_Callers: STRING_32 								is do Result := i18n("callers") end
	l_Calling_convention: STRING_32 					is do Result := i18n("Calling convention:") end
	l_Choose_folder: STRING_32 							is do Result := i18n("Select the destination folder ") end
	l_Class: STRING_32 									is do Result := i18n("Class:") end
	l_Class_name: STRING_32 							is do Result := i18n("Class name:") end
	l_clean: STRING_32 									is do Result := i18n("Clean") end
	l_clean_user_file: STRING_32 						is do Result := i18n("Reset user settings") end
	l_Clients: STRING_32 								is do Result := i18n("clients") end
	l_Clickable: STRING_32 								is do Result := i18n("clickable view") end
	l_Cluster: STRING_32 								is do Result := i18n("Cluster:") end
	l_Cluster_name: STRING_32 							is do Result := i18n("Cluster name ") end
	l_Cluster_options: STRING_32 						is do Result := i18n("Cluster options ") end
	l_Command_error_output: STRING_32 					is do Result := i18n("Command error output:%N") end
	l_Command_line: STRING_32 							is do Result := i18n("Command line:") end
	l_Command_normal_output: STRING_32 					is do Result := i18n("Command output:%N") end
	l_Compiled_class: STRING_32 						is do Result := i18n("Only compiled classes") end
	l_compile: STRING_32 								is do Result := i18n("Compile") end
	l_Compile_first: STRING_32 							is do Result := i18n("Compile to have information") end
	l_Compile_project: STRING_32 						is do Result := i18n("Compile project") end
	l_Condition: STRING_32 								is do Result := i18n("Condition") end
	l_Confirm_kill: STRING_32 							is do Result := i18n("Stop the application?") end
	l_Context: STRING_32 								is do Result := i18n("Context") end
	l_Creation: STRING_32 								is do Result := i18n("Creation procedure:") end
	l_creators: STRING_32 								is do Result := i18n("creators") end
	l_Current_context: STRING_32 						is do Result := i18n("Current feature") end
	l_Current_editor: STRING_32 						is do Result := i18n("Current editor") end
	l_Current_object: STRING_32 						is do Result := i18n("Current object") end
	l_Custom: STRING_32 								is do Result := i18n("Custom") end
	l_Deferred: STRING_32 								is do Result := i18n("deferred") end
	l_Deferreds: STRING_32 								is do Result := i18n("deferred features") end
	l_Deleting_dialog_default: STRING_32 				is do Result := i18n("Creating new project, please wait...") end
	l_Descendants: STRING_32 							is do Result := i18n("descendants") end
	l_Diagram_delete_view_cmd: STRING_32	 			is do Result := i18n("Do you really want to delete current view?") end
	l_Diagram_reset_view_cmd: STRING_32 				is do Result := i18n("Do you really want to reset current view?") end
	l_Discard_convert_project_dialog: STRING_32 		is do Result := i18n("Do not ask again, and always convert old projects") end
	l_Discard_finalize_assertions: STRING_32 			is do Result := i18n("Do not ask again, and always discard assertions when finalizing") end
	l_Discard_finalize_precompile_dialog: STRING_32 	is do Result := i18n("Dont ask me again and always finalize.") end
	l_Discard_freeze_dialog: STRING_32 					is do Result := i18n("Do not ask again, and always compile C code") end
	l_Discard_save_before_compile_dialog: STRING_32 	is do Result := i18n("Do not ask again, and always save files before compiling") end
	l_Discard_starting_dialog: STRING_32 				is do Result := i18n("Don't show this dialog at startup") end
	l_Discard_replace_all_warning_dialog: STRING_32 	is do Result := i18n("Dont ask me again and always replace all") end
	l_Discard_terminate_freezing: STRING_32 			is do Result := i18n("Do not ask again, and always terminate freezing when needed.") end
	l_Discard_terminate_external_command: STRING_32 	is do Result := i18n("Do not ask again, and always terminate running external command.") end
	l_Discard_terminate_finalizing: STRING_32 			is do Result := i18n("Do not ask again, and always terminate finalizing when needed.") end
	l_Display_call_stack_warning: STRING_32 			is do Result := i18n("Display a warning when the call stack depth reaches:") end
	l_Displayed_buttons_text: STRING_32 				is do Result := i18n("Displayed buttons") end
	l_Dont_ask_me_again: STRING_32 						is do Result := i18n("Do not ask me again") end
	l_Do_not_detect_stack_overflows: STRING_32 			is do Result := i18n("Do not detect stack overflows") end
	l_Do_not_show_again: STRING_32 						is do Result := i18n("Do not show again") end
	l_Dropped_references: STRING_32 					is do Result := i18n("Dropped references") end
	l_Dummy: STRING_32 									is do Result := i18n("Should not be read") end
	l_Not_empty: STRING_32 								is do Result := i18n("Generate default feature clauses") end
	l_Elements: STRING_32 								is do Result := i18n("elements.") end
	l_Enter_folder_name: STRING_32 						is do Result := i18n("Enter the name of the new folder: ") end
	l_error: STRING_32 									is do Result := i18n("Error") end
	l_Executing_command: STRING_32 						is do Result := i18n("Command is currently executing.%NPress OK to ignore the output.") end
	l_Execution_interrupted: STRING_32 					is do Result := i18n("Execution interrupted") end
	l_Exit_application: STRING_32 is
		once
			Result :=formatter.solve_template ("Are you sure you want to quit $1?", [Workbench_name])
		end
	l_Exit_warning: STRING_32 							is do Result := i18n("Some files have not been saved.%NDo you want to save them before exiting?") end
	l_Expanded: STRING_32 								is do Result := i18n("expanded") end
	l_Explicit_exception_pending: STRING_32				is do Result := i18n("Explicit exception pending") end
	l_Exported: STRING_32 								is do Result := i18n("exported features") end
	l_Expression: STRING_32 							is do Result := i18n("Expression") end
	l_External: STRING_32 								is do Result := i18n("external features") end
	l_Feature: STRING_32 								is do Result := i18n("Feature:") end
	l_Feature_properties: STRING_32 					is do Result := i18n("Feature properties") end
	l_File_name: STRING_32 								is do Result := i18n("File name:") end
	l_finalize: STRING_32 								is do Result := i18n("Finalize") end
	l_Finalized_mode: STRING_32							is do Result := i18n("Finalized mode") end
	l_Flat: STRING_32 									is do Result := i18n("flat view") end
	l_Flatshort: STRING_32 								is do Result := i18n("interface view") end
	l_freeze: STRING_32 								is do Result := i18n("Freeze") end
	l_fresh_compilation: STRING_32 						is do Result := i18n("Recompile project") end
	l_general: STRING_32 								is do Result := i18n("General") end
	l_Generate_profile_from_rtir: STRING_32				is do Result := i18n("Generate profile from Run-time information record") end
	l_Generate_creation: STRING_32 						is do Result := i18n("Generate creation procedure") end
	l_Homonyms: STRING_32 								is do Result := i18n("homonyms") end
	l_Homonym_confirmation: STRING_32 					is do Result := i18n("Extracting the homonyms%Nmay take a long time.") end
	l_Identification: STRING_32 						is do Result := i18n("Identification") end
	l_Implicit_exception_pending: STRING_32				is do Result := i18n("Implicit exception pending") end
	l_Implementers: STRING_32 							is do Result := i18n("implementers") end
	l_Inactive_subqueries: STRING_32 					is do Result := i18n("Inactive subqueries") end
	l_Index: STRING_32 									is do Result := i18n("Index:") end
	l_invariants: STRING_32 							is do Result := i18n("invariants") end
	l_Language_type: STRING_32 							is do Result := i18n("Language type") end
	l_Library: STRING_32 								is do Result := i18n("library") end
	l_Literal_value: STRING_32 							is do Result := i18n("Literal Value") end
	l_Loaded_project: STRING_32 						is do Result := i18n("Loaded project: ") end
	l_Located_in: STRING_32 							is do Result := i18n(" located in ") end
	l_Location_colon: STRING_32							is do Result := i18n("Location: ") end
	l_Locals: STRING_32 								is do Result := i18n("Locals") end
	l_Min_index: STRING_32 								is do Result := i18n("Minimum index displayed") end
	l_Match_case: STRING_32 							is do Result := i18n("Match case") end
	l_Max_index: STRING_32 								is do Result := i18n("Maximum index displayed") end
	l_Max_displayed_string_size: STRING_32				is do Result := i18n("Maximum displayed string size") end
	l_More_items: STRING_32 							is do Result := i18n("Display limit reached") end
	l_Name: STRING_32 									is do Result := i18n("Name") end
	l_Name_colon: STRING_32 							is do Result := i18n("Name:") end
	l_New_breakpoint: STRING_32 						is do Result := i18n("New breakpoint(s) to commit") end
	l_No_feature: STRING_32 							is do Result := i18n("Select a fully compiled feature to have information about it.") end
	l_No_feature_group_clause: STRING_32				is do Result := i18n("[Unnamed feature clause]") end
	l_No_text_text: STRING_32							is do Result := i18n("No text labels") end
	l_Not_in_system_no_info: STRING_32 					is do Result := i18n("Select a class which is fully compiled to have information about it.") end
	l_Not_yet_called: STRING_32 						is do Result := i18n("Not yet called") end
	l_Object_attributes: STRING_32 						is do Result := i18n("Attributes") end
	l_On_object: STRING_32 								is do Result := i18n("On object") end
	l_As_object: STRING_32 								is do Result := i18n("As object") end
	l_Of_class: STRING_32 								is do Result := i18n(" of class ") end
	l_Of_feature: STRING_32 							is do Result := i18n(" of feature ") end
	l_Onces: STRING_32 									is do Result := i18n("once routines and constants") end
	l_Once_functions: STRING_32 						is do Result := i18n("Once routines") end
	l_open: STRING_32 									is do Result := i18n("Open") end
	l_Open_a_project: STRING_32 						is do Result := i18n("Open a project") end
	l_Open_project: STRING_32							is do Result := i18n("Open project") end
	l_Options: STRING_32								is do Result := i18n("Options") end
	l_Output_switches: STRING_32 						is do Result := i18n("Output switches") end
	l_Parent_cluster: STRING_32 						is do Result := i18n("Parent cluster") end
	l_parents: STRING_32 								is do Result := i18n("Parents:") end
	l_Path: STRING_32 									is do Result := i18n("Path") end
	l_Possible_overflow: STRING_32 						is do Result := i18n("Possible stack overflow") end
	l_precompile: STRING_32 							is do Result := i18n("Precompile") end
	l_Profiler_used: STRING_32 							is do Result := i18n("Profiler used to produce the above record: ") end
	l_Project_location: STRING_32 						is do Result := i18n("The project location is the place where compilation%Nfiles will be generated by the compiler") end
	l_Put_text_right_text: STRING_32					is do Result := i18n("Show selective text on the right of buttons") end
	l_Show_all_text: STRING_32 							is do Result := i18n("Show text labels") end
	l_Query: STRING_32 									is do Result := i18n("Query") end
	l_remove_project: STRING_32 						is do Result := i18n("Remove Project") end
	l_Remove_object: STRING_32 							is do Result := i18n("Remove") end
	l_Remove_object_desc:STRING_32 						is do Result := i18n("Remove an object from the tree") end
	l_Replace_with: STRING_32 							is do Result := i18n("Replace with:") end
	l_Replace_with_ellipsis: STRING_32 					is do Result := i18n("Replace with...") end
	l_Replace_all: STRING_32 							is do Result := i18n("Replace all") end
	l_Result: STRING_32 								is do Result := i18n("Result") end
	l_Root_class: STRING_32 							is do Result := i18n("Root class name: ") end
	l_Root_class_name: STRING_32 						is do Result := i18n("Root class: ") end
	l_Root_cluster_name: STRING_32 						is do Result := i18n("Root cluster: ") end
	l_Root_feature_name: STRING_32 						is do Result := i18n("Root feature: ") end
	l_Routine_ancestors: STRING_32 						is do Result := i18n("ancestor versions") end
	l_Routine_descendants: STRING_32 					is do Result := i18n("descendant versions") end
	l_Routine_flat: STRING_32 							is do Result := i18n("flat view") end
	l_Routines: STRING_32 								is do Result := i18n("routines") end
	l_Runtime_information_record: STRING_32				is do Result := i18n("Run-time information record") end
	l_Same_class_name: STRING_32 						is do Result := i18n("---") end
	l_Scope: STRING_32									is do Result := i18n("Scope") end
	l_Search_backward: STRING_32 						is do Result := i18n("Search backwards") end
	l_Search_for: STRING_32 							is do Result := i18n("Search for:") end
	l_Search_options_show: STRING_32 					is do Result := i18n("Scope >>") end
	l_Search_options_hide: STRING_32 					is do Result := i18n("Scope <<") end
	l_Search_report_show: STRING_32 					is do Result := i18n("Report >>") end
	l_Search_report_hide: STRING_32						is do Result := i18n("Report <<") end
	l_Set_as_default: STRING_32 						is do Result := i18n("Set as default") end
	l_Set_slice_limits: STRING_32 						is do Result := i18n("Slice limits") end
	l_Set_slice_limits_desc: STRING_32 					is do Result := i18n("Set which values a) endre shown in special objects") end
	l_Short: STRING_32 									is do Result := i18n("contract view") end
	l_Short_name: STRING_32 							is do Result := i18n("Short Name") end
	l_Show_all_call_stack: STRING_32 					is do Result := i18n("Show all stack elements") end
	l_Show_only_n_elements: STRING_32 					is do Result := i18n("Show only:") end
	l_Showallcallers: STRING_32 						is do Result := i18n("Show all callers") end
	l_Showcallers: STRING_32 							is do Result := i18n("Show static callers") end
	l_Showstops: STRING_32 								is do Result := i18n("Show stop points") end
	l_Slice_taken_into_account1: STRING_32				is do Result := i18n("Warning: Modifications will be taken into account") end
	l_Slice_taken_into_account2: STRING_32				is do Result := i18n("for the next objects you will add in the object tree.") end
	l_Specify_arguments: STRING_32 						is do Result := i18n("Specify arguments") end
	l_Stack_information: STRING_32 						is do Result := i18n("Stack information") end
	l_Stepped: STRING_32 								is do Result := i18n("Step completed") end
	l_Stop_point_reached: STRING_32 					is do Result := i18n("Breakpoint reached") end
	l_Sub_cluster: STRING_32 							is do Result := i18n("Subcluster") end
	l_Sub_clusters: STRING_32 							is do Result := i18n("Recusive") end
	l_Subquery: STRING_32 								is do Result := i18n("Define new subquery") end
	l_Suppliers: STRING_32 								is do Result := i18n("suppliers") end
	l_Switch_num_format: STRING_32						is do Result := i18n("Switch numerical formating") end
	l_Switch_num_format_desc: STRING_32					is do Result := i18n("Display numerical value as Hexadecimal or Decimal formating") end
	l_Syntax_error: STRING_32 							is do Result := i18n("Class text has syntax error") end
	l_System_name: STRING_32 							is do Result := i18n("System name: ") end
	l_System_properties: STRING_32 						is do Result := i18n("System properties") end
	l_System_running: STRING_32 						is do Result := i18n("System running") end
	l_System_launched: STRING_32 						is do Result := i18n("System launched") end
	l_System_not_running: STRING_32 					is do Result := i18n("System not running") end
	l_Tab_output: STRING_32								is do Result := i18n("Output") end
	l_Tab_class_info: STRING_32							is do Result := i18n("Class") end
	l_Tab_feature_info: STRING_32						is do Result := i18n("Feature") end
	l_Tab_diagram: STRING_32							is do Result := i18n("Diagram") end
	l_Tab_metrics: STRING_32							is do Result := i18n("Metrics") end
	l_target: STRING_32 								is do Result := i18n("Target") end
	l_teachmode: STRING_32								is do Result := i18n("teaching mode") end
	l_Text_loaded: STRING_32 							is do Result := i18n("Text finished loading") end
	l_Text_saved: STRING_32 							is do Result := i18n("Text was saved") end
	l_Three_dots: STRING_32 							is do Result := i18n("...") end
	l_Text_loading: STRING_32 							is do Result := i18n("Current text is being loaded. It is therefore%Nnot editable nor pickable.") end
	l_Toolbar_select_text_position: STRING_32			is do Result := i18n("Text option: ") end
	l_Toolbar_select_has_gray_icons: STRING_32			is do Result := i18n("Icon option: ") end
	l_Top_level: STRING_32 								is do Result := i18n("Top-level") end
	l_Type: STRING_32 									is do Result := i18n("Type") end
	l_Unknown_status: STRING_32 						is do Result := i18n("Unknown application status") end
	l_Unknown_class_name: STRING_32 					is do Result := i18n("Unknown class name") end
	l_Use_existing_ace: STRING_32 						is do Result := i18n("Open existing Ace (control file)") end
	l_Use_existing_profile: STRING_32 					is do Result := i18n("Use existing profile: ") end
	l_Use_regular_expression: STRING_32					is do Result := i18n("Use regular expression") end
	l_Use_wildcards: STRING_32 							is do Result := i18n("Use wildcards") end
	l_Use_wizard: STRING_32								is do Result := i18n("Create project") end
	l_Value: STRING_32 									is do Result := i18n("Value") end
	l_Whole_project: STRING_32 							is do Result := i18n("Whole project") end
	l_Whole_word: STRING_32 							is do Result := i18n("Whole word") end
	l_Windows_only: STRING_32 							is do Result := i18n("(Windows only)") end
	l_Workbench_mode: STRING_32							is do Result := i18n("Workbench mode") end
	l_Working_formatter: STRING_32 						is do Result := i18n("Extracting ") end
	l_Tab_external_output: STRING_32					is do Result := i18n("External Output") end
	l_Tab_C_output: STRING_32							is do Result := i18n("C Output") end
	l_Tab_warning_output: STRING_32						is do Result := i18n("Warnings") end
	l_Tab_error_output: STRING_32						is do Result := i18n("Errors") end
	l_show_feature_from_any: STRING_32					is do Result := i18n("Features from ANY") end
	l_show_tooltip: STRING_32							is do Result := i18n("Tooltip") end
	h_show_feature_from_any: STRING_32					is do Result := i18n("Show unchanged features from class ANY?") end
	h_show_tooltip: STRING_32							is do Result := i18n("Show tooltips?") end
	l_class_browser_classes: STRING_32					is do Result := i18n("Class") end
	l_class_browser_features: STRING_32					is do Result := i18n("Feature") end
	l_version_from: STRING_32							is do Result := i18n("Declared in class") end
	l_branch: STRING_32									is do Result := i18n("Branch #") end
	l_version_from_message: STRING_32					is do Result := i18n(" (version from)") end
	l_expand_layer: STRING_32							is do Result := i18n("Expand selected level(s)") end
	l_collapse_layer: STRING_32							is do Result := i18n("Collapse selected level(s)") end
	l_collapse_all_layers: STRING_32					is do Result := i18n("Collapse all selected level(s)") end
	l_searching_selected_file: STRING_32				is do Result := i18n("Searching selected file...") end
	l_selected_file_not_found: STRING_32				is do Result := i18n("Selected text is not a valid file name or the file can not be found.") end
	l_manage_external_commands: STRING_32				is do Result := i18n("Add, remove or edit external commands") end
	l_add_scope: STRING_32 								is do Result := i18n("Add scope") end
	l_remove_scope: STRING_32							is do Result := i18n("Remove selected scope(s)") end
	l_remove_all_scopes: STRING_32						is do Result := i18n("Remove all scopes") end
	l_callees: STRING_32								is do Result := i18n("callees") end
	l_assignees: STRING_32								is do Result := i18n("assignees") end
	l_created: STRING_32								is do Result := i18n("creators") end
	l_filter: STRING_32									is do Result := i18n("Filter") end


feature -- Stone names

	s_Class_stone: STRING_32 							is do Result := i18n("Class ") end
	s_Cluster_stone: STRING_32 							is do Result := i18n("Cluster ") end
	s_Feature_stone: STRING_32 							is do Result := i18n("Feature ") end

feature -- Title part

	t_About: STRING_32 is
		do
			Result := i18n ("About")-- "About " + Workbench_name
		end

	t_Add_search_scope: STRING_32 						is do Result := i18n("Add Search Scope") end
	t_Alias: STRING_32 									is do Result := i18n("Alias") end
	t_Breakpoints_tool: STRING_32 						is do Result := i18n("Breakpoints") end
	t_Call_stack_tool: STRING_32 						is do Result := i18n("Call Stack") end
	t_Calling_convention: STRING_32 					is do Result := i18n("Calling Convention") end
	t_Choose_ace_file: STRING_32 						is do Result := i18n("Choose an Ace File") end
	t_Choose_ace_and_directory: STRING_32 				is do Result := i18n("Choose Your Ace File and Directory") end
	t_Choose_class: STRING_32 							is do Result := i18n("Choose a Class") end
	t_Choose_directory: STRING_32 						is do Result := i18n("Choose Your Directory") end
	t_Choose_folder_name: STRING_32 					is do Result := i18n("Choose a Folder Name") end
	t_Choose_project_and_directory: STRING_32 			is do Result := i18n("Choose Your Project Name and Directory") end
	t_Class: STRING_32 									is do Result := i18n("Class") end
	t_Clients_of: STRING_32 							is do Result := i18n("Clients of Class ") end
	t_Cluster_tool: STRING_32 							is do Result := i18n("Clusters") end
	t_Context_tool: STRING_32 							is do Result := i18n("Context") end
	t_Creation_routine: STRING_32 						is do Result := i18n("Creation Procedure") end
	t_Customize_toolbar_text: STRING_32 				is do Result := i18n("Customize Toolbar") end
	t_Debugging_tool: STRING_32 						is do Result := i18n("Debugging") end
	t_Default_print_job_name: STRING_32 is
		once
			Result := "From " + Workbench_name
		end
	t_Deleting_files: STRING_32 						is do Result := i18n("Deleting Files") end
	t_Dummy: STRING_32 									is do Result := i18n("Dummy") end
	t_Dynamic_lib_window: STRING_32 					is do Result := i18n("Dynamic Library Builder") end
	t_Dynamic_type: STRING_32 							is do Result := i18n("In Class") end
	t_Editor: STRING_32 								is do Result := i18n("Editor") end
	t_Enter_condition: STRING_32 						is do Result := i18n("Enter Condition") end
	t_Exported_feature: STRING_32 						is do Result := i18n("Feature") end
	t_Expression_evaluation: STRING_32 					is do Result := i18n("Evaluation") end
	t_Extended_explanation: STRING_32 					is do Result := i18n("Compilation Error Wizard") end
	t_external_command: STRING_32 						is do Result := i18n("External Command") end
	t_external_commands: STRING_32 						is do Result := i18n("External Commands") end
	t_External_edition: STRING_32 						is do Result := i18n("External Edition") end
	t_Favorites_tool: STRING_32 						is do Result := i18n("Favorites") end
	t_Feature: STRING_32 								is do Result := i18n("In Feature") end
	t_Feature_properties: STRING_32 					is do Result := i18n("Feature Properties") end
	t_File_selection: STRING_32 						is do Result := i18n("File Selection") end
	t_Find: STRING_32 									is do Result := i18n("Find") end
	t_Index: STRING_32 									is do Result := i18n("Index") end
	t_New_class: STRING_32 								is do Result := i18n("New Class") end
	t_New_cluster: STRING_32 							is do Result := i18n("New Cluster") end
	t_New_expression: STRING_32 						is do Result := i18n("New Expression") end
	t_New_project: STRING_32 							is do Result := i18n("New Project") end
	t_Object_tool: STRING_32 							is do Result := i18n("Objects") end
	t_Open_backup: STRING_32 							is do Result := i18n("Backup Found") end
	t_Organize_favorites: STRING_32 					is do Result := i18n("Organize Favorites") end
	t_Profile_query_window: STRING_32 					is do Result := i18n("Profile Query Window") end
	t_Profiler_wizard: STRING_32 						is do Result := i18n("Profiler Wizard") end
	t_Project: STRING_32 is
		once
			Result := Workbench_name
		end
	t_Preference_window: STRING_32 						is do Result := i18n("Preferences") end
	t_Select_class: STRING_32 							is do Result := i18n("Select Class") end
	t_Select_cluster: STRING_32 						is do Result := i18n("Select Cluster") end
	t_Select_feature: STRING_32 						is do Result := i18n("Select Feature") end
	t_Search_tool: STRING_32 							is do Result := i18n("Search") end
	t_Select_a_file: STRING_32 							is do Result := i18n("Select a File") end
	t_Select_a_directory: STRING_32 					is do Result := i18n("Select a Directory") end
	t_Set_stack_depth: STRING_32 						is do Result := i18n("Maximum Call Stack Depth") end
	t_Set_critical_stack_depth: STRING_32 				is do Result := i18n("Overflow Prevention") end
	t_Static_type: STRING_32 							is do Result := i18n("From Class") end
	t_Starting_dialog: STRING_32 is
		once
			Result := Workbench_name
		end
	t_Slice_limits: STRING_32 							is do Result := i18n("Choose New Slice Limits for Special Objects") end
	t_System: STRING_32 								is do Result := i18n("Project Settings") end
	t_Windows_tool: STRING_32 							is do Result := i18n("Windows") end
	t_Watch_tool: STRING_32 							is do Result := i18n("Watch") end
	t_Features_tool: STRING_32 							is do Result := i18n("Features") end
	t_Empty_development_window: STRING_32 				is do Result := i18n("Empty Development Tool") end
	t_Autocomplete_window: STRING_32 					is do Result := i18n("Auto-Complete") end
	t_Diagram_class_header: STRING_32 					is do Result := i18n("Class Header") end
	t_Diagram_set_center_class: STRING_32 				is do Result := i18n("Set Center Class") end
	t_Diagram_context_depth: STRING_32 					is do Result := i18n("Select Depths") end
	t_Diagram_link_tool: STRING_32 						is do Result := i18n("Link Tool") end
	t_Diagram_delete_client_link: STRING_32 			is do Result := i18n("Choose Feature(s) to Delete") end
	t_Diagram_history_tool: STRING_32 					is do Result := i18n("History Tool") end

	t_Diagram_move_class_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result :=formatter.solve_template ("Move Class '$1'",[a_name])
		end

	t_Diagram_move_cluster_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Move Cluster '$1'",[a_name])
		end

	t_Diagram_move_midpoint_cmd: STRING_32 					is do Result := i18n("Move Midpoint") end

	t_Diagram_add_cs_link_cmd (client_name, supplier_name: STRING_32): STRING_32 is
		require
			exists: client_name /= Void	and supplier_name /= Void
		do
			Result := formatter.solve_template ("Add Client-Supplier Relation Between '$1' and '$2'", [client_name,supplier_name])
		end

	t_Diagram_add_inh_link_cmd (ancestor_name, descendant_name: STRING_32): STRING_32 is
		require
			exists: ancestor_name /= Void and descendant_name /= Void
		do
			Result := formatter.solve_template ("Add Inheritance Relation Between '$1' and '$2'", [ancestor_name,descendant_name])
		end

	t_Diagram_include_class_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Include Class '$1'", [a_name])
		end

	t_Diagram_include_cluster_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Include Cluster '$1'",[a_name])
		end

	t_Diagram_include_library_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Include Library '$1'",[a_name])
		end

	t_Diagram_insert_midpoint_cmd: STRING_32 					is do Result := i18n("Insert Midpoint") end
	t_Diagram_change_color_cmd: STRING_32 						is do Result := i18n("Change Class Color") end

	t_Diagram_rename_class_locally_cmd (old_name, new_name: STRING_32): STRING_32 is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := formatter.solve_template ("Rename Class '$1' Locally to '$2'",[old_name,new_name])
		end

	t_Diagram_rename_class_globally_cmd (old_name, new_name: STRING_32): STRING_32 is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := formatter.solve_template ("Rename Class '$1' Globally to '$2'",[old_name,new_name])
		end

	t_Diagram_delete_client_link_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Delete Client Link '$1'",[a_name])
		end

	t_Diagram_delete_inheritance_link_cmd (an_ancestor, a_descendant: STRING_32): STRING_32 is
		require
			exists: an_ancestor /= Void and a_descendant /= Void
		do
			Result := formatter.solve_template ("Delete Inheritance Link Between '$1' and '$2'",[an_ancestor,a_descendant])
		end

	t_Diagram_erase_cluster_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Erase Cluster '$1'",[a_name])
		end

	t_Diagram_delete_midpoint_cmd: STRING_32 					is do Result := i18n("Erase Midpoint") end

	t_Diagram_erase_class_cmd (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Erase Class '$1'",[a_name])
		end

	t_Diagram_erase_classes_cmd: STRING_32 							is do Result := i18n(	"Erase Classes") end
	t_Diagram_put_right_angles_cmd: STRING_32 						is do Result := i18n("Put Right Angles") end
	t_Diagram_remove_right_angles_cmd: STRING_32 					is do Result := i18n("Remove Right Angles") end
	t_Diagram_put_one_handle_left_cmd: STRING_32 					is do Result := i18n("Put Handle Left") end
	t_Diagram_put_one_handle_right_cmd: STRING_32 					is do Result := i18n("Put Handle Right") end
	t_Diagram_put_two_handles_left_cmd: STRING_32 					is do Result := i18n("Put Two Handles Left") end
	t_Diagram_put_two_handles_right_cmd: STRING_32 					is do Result := i18n("Put Two Handles Right") end
	t_Diagram_remove_handles_cmd: STRING_32 						is do Result := i18n("Remove Handles") end
	t_Diagram_zoom_in_cmd: STRING_32 								is do Result := i18n("Zoom In") end
	t_Diagram_zoom_out_cmd: STRING_32			 					is do Result := i18n("Zoom Out") end
	t_Diagram_zoom_cmd: STRING_32 									is do Result := i18n("Zoom") end

	t_Diagram_cluster_expand (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Expand cluster '$1'",[a_name])
		end

	t_Diagram_cluster_collapse (a_name: STRING_32): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := formatter.solve_template ("Collapse Cluster '$1'",[a_name])
		end

	t_Diagram_disable_high_quality: STRING_32 					is do Result := i18n("Disable High Quality") end
	t_Diagram_enable_high_quality: STRING_32 					is do Result := i18n("Enable High Quality") end

	t_first_match_reached: STRING_32 							is do Result := i18n("The first match touched.") end
	t_bottom_reached: STRING_32		 							is do Result := i18n("Bottom touched.") end

feature -- Description texts

	e_Add_exported_feature: STRING_32		 					is do Result := i18n("Add a new feature to this dynamic library definition") end
	e_Bkpt_info: STRING_32 										is do Result := i18n("Show/Hide information about breakpoints") end
	e_Check_exports: STRING_32 									is do Result := i18n("Check the validity of the library definition") end
	e_Compilation_failed: STRING_32 							is do Result := i18n("Eiffel compilation failed") end
	e_Compilation_succeeded: STRING_32 							is do Result := i18n("Eiffel compilation succeeded") end
	e_freezing_failed: STRING_32	 							is do Result := i18n("Background workbench C compilation failed") end
	e_finalizing_failed: STRING_32 								is do Result := i18n("Background finalized C compilation failed") end
	e_freezing_launch_failed: STRING_32 						is do Result := i18n("Background workbench C compilation launch failed") end
	e_finalizing_launch_failed: STRING_32 						is do Result := i18n("Background finalized C compilation launch failed") end
	e_freezing_launched: STRING_32 								is do Result := i18n("Background workbench C compilation launched") end
	e_finalizing_launched: STRING_32 							is do Result := i18n("Background finalized C compilation launched") end
	e_freezing_succeeded: STRING_32 							is do Result := i18n("Background workbench C compilation succeeded") end
	e_finalizing_succeeded: STRING_32 							is do Result := i18n("Background finalized C compilation succeeded") end
	e_freezing_terminated: STRING_32 							is do Result := i18n("Background workbench C compilation terminated") end
	e_finalizing_terminated: STRING_32 							is do Result := i18n("Background finalized C compilation terminated") end
	e_C_compilation_failed: STRING_32 							is do Result := i18n("Background C compilation failed") end
	e_C_compilation_launch_failed: STRING_32 					is do Result := i18n("Background C compilation launch failed") end
	e_C_compilation_terminated: STRING_32 						is do Result := i18n("Background C compilation terminated") end
	e_C_compilication_launched: STRING_32 						is do Result := i18n("Background C compilation launched") end
	e_C_compilation_succeeded: STRING_32 						is do Result := i18n("Background C compilation succeeded") end
	e_C_compilation_running: STRING_32 							is do Result := i18n("Background C compilation in progress") end
	e_Compiling: STRING_32 										is do Result := i18n("System is being compiled") end
	e_Copy_call_stack_to_clipboard: STRING_32					is do Result := i18n("Copy call stack to clipboard") end
	e_Cursor_position: STRING_32 								is do Result := i18n("Cursor position (line:column)") end
	e_Diagram_hole: STRING_32 									is do Result := i18n("Please drop a class or a cluster on this button %N%	%to view its diagram.%N %%Use right click for both pick and drop actions.") end


	e_Diagram_class_header: STRING_32 is do Result := i18n("Please drop a class on this button.%NUse right click for both%N%
															%pick and drop actions.") end


	e_Diagram_remove_anchor: STRING_32 is do Result := i18n("Please drop a class or a cluster with an%Nanchor on this button.%NUse right click for both%N%
															%pick and drop actions.") end

	e_Diagram_create_class: STRING_32 is do Result := i18n("Please drop this button on the diagram.%N%
															%Use right click for both%Npick and drop actions.") end


	--added by EMU-PROJECT--
	e_emu_upload_class: STRING_32 			is do Result := i18n("Upload class to Emu Server") end
	e_emu_download_class: STRING_32 		is do Result := i18n("Download class from Emu Server") end
	e_emu_lock_class: STRING_32 			is do Result := i18n("Lock class on Emu Server") end
	e_emu_unlock_class: STRING_32 			is do Result := i18n("Unlock class for me on Emu Server") end
	e_emu_new_project_class: STRING_32 		is do Result := i18n("Create emu project") end
	e_emu_add_user_class: STRING_32 		is do Result := i18n("Add user to emu-project") end
	------------------------

	e_Diagram_delete_figure: STRING_32 is do Result := i18n("Please drop a class, a cluster or a midpoint%N%
															%on this button. Use right click for both%Npick and drop actions.") end

	e_Diagram_add_class_figure_relations: STRING_32 is do Result := i18n("A class figure(s) must either be selected%N%
																		%or dropped on this button via right clicking.") end

	e_Diagram_delete_item: STRING_32 is do Result := i18n("Please drop a class, a cluster or a link%N%
															%on this button. Use right click for both%Npick and drop actions.") end

	e_Display_error_help: STRING_32 							is do Result := i18n("Give help on compilation errors") end
	e_Display_system_info: STRING_32 							is do Result := i18n("Display information concerning current system") end
	e_Drop_an_error_stone: STRING_32 							is do Result := i18n("Pick the code of a compilation error (such as VEEN, VTCT,...)%N%
																						%and drop it here to have extended information about it.") end
	e_Edit_exported_feature: STRING_32 							is do Result := i18n("Edit the properties of the selected feature") end
	e_Edit_expression: STRING_32 								is do Result := i18n("Edit an expression") end
	e_Edited: STRING_32 										is do Result := i18n("Some classes were edited since last compilation") end
	e_Exec_debug: STRING_32 									is do Result := i18n("Start application and stop at breakpoints") end
	e_Exec_kill: STRING_32 										is do Result := i18n("Stop application") end
	e_Exec_into: STRING_32 										is do Result := i18n("Step into a routine") end
	e_Exec_no_stop: STRING_32 									is do Result := i18n("Start application without stopping at breakpoints") end
	e_Exec_out: STRING_32 										is do Result := i18n("Step out of a routine") end
	e_Exec_step: STRING_32 										is do Result := i18n("Execute the application one line at a time") end
	e_Exec_stop: STRING_32 										is do Result := i18n("Pause application at current point") end
	e_History_back: STRING_32 									is do Result := i18n("Back") end
	e_History_forth: STRING_32 									is do Result := i18n("Forward") end
	e_Minimize_all: STRING_32 									is do Result := i18n("Minimize all windows") end
	e_New_context_tool: STRING_32 								is do Result := i18n("Open a new context window") end
	e_New_dynamic_lib_definition: STRING_32 					is do Result := i18n("Create a new dynamic library definition") end
	e_New_editor: STRING_32 									is do Result := i18n("Open a new editor window") end
	e_New_expression: STRING_32 								is do Result := i18n("Create a new expression") end
	e_Not_running: STRING_32 									is do Result := i18n("Application is not running") end
	e_Open_dynamic_lib_definition: STRING_32					is do Result := i18n("Open a dynamic library definition") end
	e_Open_file: STRING_32 										is do Result := i18n("Open a file") end
	e_Open_eac_browser: STRING_32 								is do Result := i18n("Open the Eiffel Assembly Cache browser tool") end
	e_Paste: STRING_32 											is do Result := i18n("Paste") end
	e_Paused: STRING_32 										is do Result := i18n("Application is paused") end
	e_Pretty_print: STRING_32 									is do Result := i18n("Display an expanded view of objects") end
	e_Print: STRING_32 											is do Result := i18n("Print the currently edited text") end
	e_Project_name: STRING_32 									is do Result := i18n("Name of the current project") end
	e_Project_settings: STRING_32 								is do Result := i18n("Change project settings") end
	e_Quick_compile: STRING_32 									is do Result := i18n("Recompile classes that were edited in EiffelStudio") end
	e_Raise_all: STRING_32 										is do Result := i18n("Raise all windows") end
	e_Raise_all_unsaved: STRING_32								is do Result := i18n("Raise all unsaved windows") end
	e_Redo: STRING_32 											is do Result := i18n("Redo") end
	e_Remove_class_cluster: STRING_32 							is do Result := i18n("Remove a class or a cluster from the system") end
	e_Remove_exported_feature: STRING_32 						is do Result := i18n("Remove the selected feature from this dynamic library definition") end
	e_Remove_expressions: STRING_32 							is do Result := i18n("Remove selected expressions") end
	e_Remove_object: STRING_32 									is do Result := i18n("Remove currently selected object") end
	e_Running: STRING_32 										is do Result := i18n("Application is running") end
	e_Running_no_stop_points: STRING_32 						is do Result := i18n("Application is running (ignoring breakpoints)") end
	e_Save_call_stack: STRING_32 								is do Result := i18n("Save call stack to a text file") end
	e_Save_dynamic_lib_definition: STRING_32					is do Result := i18n("Save this dynamic library definition") end
	e_Show_class_cluster: STRING_32 							is do Result := i18n("Locate currently edited class or cluster") end
	e_Send_stone_to_context: STRING_32 							is do Result := i18n("Synchronize context") end
	e_Separate_stone: STRING_32 								is do Result := i18n("Unlink the context tool from the other components") end
	e_Set_stack_depth: STRING_32 								is do Result := i18n("Set maximum call stack depth") end
	e_Shell: STRING_32 											is do Result := i18n("Send to external editor") end
	e_Switch_num_format_to_hex: STRING_32						is do Result := i18n("Switch to hexadecimal format") end
	e_Switch_num_format_to_dec: STRING_32						is do Result := i18n("Switch to decimal format") end
	e_Switch_num_formating: STRING_32							is do Result := i18n("Hexadecimal/Decimal formating") end
	e_Toggle_state_of_expressions: STRING_32 					is do Result := i18n("Enable/Disable expressions") end
	e_Toggle_stone_management: STRING_32						is do Result := i18n("Link or not the context tool to other components") end
	e_Undo: STRING_32 											is do Result := i18n("Undo") end
	e_Up_to_date: STRING_32 									is do Result := i18n("Executable is up-to-date") end
	e_Unify_stone: STRING_32 									is do Result := i18n("Link the context tool to the other components") end
	e_Terminate_c_compilation: STRING_32						is do Result := i18n("Terminate current C compilation in progress") end

	e_Dbg_exception_handler: STRING_32							is do Result := i18n("Exceptions handling") end
	e_Dbg_assertion_checking: STRING_32							is do Result := i18n("Disable or restore Assertion checking handling during debugging") end

	e_open_selection_in_editor: STRING_32						is do Result := i18n("Open selected file name in specified external editor") end
	e_save_c_compilation_output: STRING_32						is do Result := i18n("Save c compilation output to file") end
	e_go_to_w_code_dir: STRING_32								is do Result := i18n("Go to W_code directory of this system") end
	e_go_to_f_code_dir: STRING_32								is do Result := i18n("Go to F_code directory of this system") end
	e_f_code: STRING_32											is do Result := i18n("F_code") end
	e_w_code: STRING_32											is do Result := i18n("W_code") end
	e_no_text_is_selected: STRING_32							is do Result := i18n("No file name is selected.") end
	e_selected_text_is_not_file: STRING_32 						is do Result := i18n("Selected text is not a correct file name.") end
	e_external_editor_not_defined: STRING_32 					is do Result := i18n("External editor not defined") end
	e_external_command_is_running: STRING_32 					is do Result := i18n("An external command is running now. %NPlease wait until it exits.") end
	e_external_command_list_full: STRING_32 					is do Result := i18n("Your external command list is full.%NUse Tools->External Command... to delete one.") end

feature -- Wizard texts

	wt_Profiler_welcome: STRING_32 								is do Result := i18n("Welcome to the Profiler Wizard") end
	wb_Profiler_welcome: STRING_32
			is do Result := i18n(
				"Using this wizard you can analyze the result of a profiling.%N%
				%%N%
				%Profiling a system is used to analyze its run-time properties%N%
				%and in particular the cost of each routine: number of calls,%N%
				%time spent, etc. The profiler is a precious tool to understand%N%
				%and optimize a system.%N%
				%%N%
				%To continue you need to have already executed your system%N%
				%with the profiler activated. If this is not the case, please%N%
				%refer to the documentation on how to profile a system.%N%
				%%N%
				%%N%
				%To continue, click Next.") end

	wt_Compilation_mode: STRING_32 									is do Result := i18n("Compilation mode") end
	ws_Compilation_mode: STRING_32 									is do Result := i18n("Select the Compilation mode.") end

	wt_Execution_Profile: STRING_32 								is do Result := i18n("Execution Profile") end
	ws_Execution_Profile: STRING_32 								is do Result := i18n("Reuse or Generate an Execution Profile.") end
	wb_Execution_Profile: STRING_32
		is do Result := i18n(
			"You can generate the Execution Profile from a Run-time Information Record%N%
			%created by a profiler, or you can reuse an existing Execution Profile if you%N%
			%have already generated one for this system.") end

	wt_Execution_Profile_Generation: STRING_32 						is do Result := i18n("Execution Profile Generation") end
	ws_Execution_Profile_Generation: STRING_32 						is do Result := i18n("Select a Run-time information record to generate the Execution profile") end
	wb_Execution_Profile_Generation: STRING_32
			is do Result := i18n(
				"Once an execution of an instrumented system has generated the proper file,%N%
				%you must process it through a profile converter to produce the Execution%N%
				%Profile. The need for the converter comes from the various formats that%N%
				%profilers use to record run-time information during an execution.%N%
				%%N%
				%Provide the Run-time information record produced by the profiler and%N%
				%select the profiler used to create this record.%
				%%N%
				%The Execution Profile will be generated under the file %"profinfo.pfi%".") end

	wt_Switches_and_query: STRING_32 									is do Result := i18n("Switches and Query") end
	ws_Switches_and_query: STRING_32 									is do Result := i18n("Select the information you need and formulate your query.") end

	wt_Generation_error: STRING_32 										is do Result := i18n("Generation Error") end
	wb_Click_back_and_correct_error: STRING_32 							is do Result := i18n("Click Back if you can correct the problem or Click Abort.") end

	wt_Runtime_information_record_error: STRING_32 						is do Result := i18n("Runtime Information Record Error") end
	wb_Runtime_information_record_error (generation_path: STRING_32): STRING_32 is
		do
			Result := formatter.solve_template ("The file you have supplied as Runtime Information Record%N%
				%does not exist or is not valid.%N%
				%Do not forget that the Runtime Information Record has to%N%
				%be located in the project directory:%N%
				% $1 %
				%N%N%
				%Please provide a valid file or execute your profiler again to%N%
				%generate a valid Runtime Information Record.%N%
				%%N%
				%Click Back and select a valid file or Click Abort.",[generation_path])
		end

	wt_Execution_profile_error: STRING_32 							is do Result := i18n("Execution Profile Error") end
	wb_Execution_profile_error: STRING_32
		is do Result := i18n(
				"The file you have supplied as existring Execution Provide does%N%
				%not exist or is not valid. Please provide a valid file or generate%N%
				%a new one.%N%
				%Click Back and select a valid file or choose the generate option.") end

feature -- Metric constants (tooltips)

	metric_metrics: STRING_32 						is do Result := i18n("&Metrics") end

	metric_this_archive: STRING_32 					is do Result := i18n("Archive...") end
	metric_this_system: STRING_32 					is do Result := i18n("System") end
	metric_this_cluster: STRING_32 					is do Result := i18n("Cluster") end
	metric_this_class: STRING_32 					is do Result := i18n("Class") end
	metric_this_feature: STRING_32 					is do Result := i18n("Feature") end
	metric_this_delayed: STRING_32 					is do Result := i18n("Delayed") end

	metric_ignore: STRING_32 						is do Result := i18n("Ignore") end

	metric_all: STRING_32 							is do Result := i18n("All") end
	metric_classes: STRING_32 						is do Result := i18n("Classes") end
	metric_deferred_class: STRING_32 				is do Result := i18n("Deferred classes") end
	metric_effective_class: STRING_32 				is do Result := i18n("Effective") end
	metric_invariant_equipped: STRING_32			is do Result := i18n("Invariant equipped") end
	metric_obsolete: STRING_32 						is do Result := i18n("Obsolete") end
	metric_no_invariant: STRING_32 					is do Result := i18n("No invariant") end
	metric_no_obsolete: STRING_32 					is do Result := i18n("Not obsolete") end

	metric_clusters: STRING_32 						is do Result := i18n("Clusters") end

	metric_compilations: STRING_32 					is do Result := i18n("Compilations") end

	metric_dependents: STRING_32 					is do Result := i18n("Dependents") end
	metric_clients: STRING_32 						is do Result := i18n("Clients") end
	metric_indirect_clients: STRING_32 				is do Result := i18n("Indirect clients") end
	metric_heirs: STRING_32 						is do Result := i18n("Heirs") end
	metric_indirect_heirs: STRING_32 				is do Result := i18n("Indirect heirs") end
	metric_parents: STRING_32 						is do Result := i18n("Parents") end
	metric_indirect_parents: STRING_32 				is do Result := i18n("Indirect parents") end
	metric_suppliers: STRING_32 					is do Result := i18n("Suppliers") end
	metric_indirect_suppliers: STRING_32			is do Result := i18n("Indirect suppliers") end
	metric_self: STRING_32 							is do Result := i18n("Self") end

	metric_features: STRING_32 						is do Result := i18n("Features") end
	metric_attributes: STRING_32 					is do Result := i18n("Attributes") end
	metric_commands: STRING_32 						is do Result := i18n("Commands") end
	metric_deferred_feature: STRING_32 				is do Result := i18n("Deferred features") end
	metric_exported: STRING_32 						is do Result := i18n("Exported") end
	metric_inherited: STRING_32 					is do Result := i18n("Inherited") end
	metric_functions: STRING_32 					is do Result := i18n("Functions") end
	metric_postcondition_equipped: STRING_32		is do Result := i18n("Postcondition equipped") end
	metric_precondition_equipped: STRING_32 		is do Result := i18n("Precondition equipped") end
	metric_queries: STRING_32 						is do Result := i18n("Queries") end
	metric_routines: STRING_32 						is do Result := i18n("Routines") end

	metric_imm_features: STRING_32 					is do Result := i18n("Features: immediate") end
	metric_imm_attributes: STRING_32 				is do Result := i18n("Imm. attributes") end
	metric_imm_commands: STRING_32 					is do Result := i18n("Imm. commands") end
	metric_imm_deferred_feature: STRING_32 			is do Result := i18n("Imm. deferred features") end
	metric_imm_effective_feature: STRING_32 		is do Result := i18n("Imm. effective features") end
	metric_imm_exported: STRING_32 					is do Result := i18n("Imm. exported") end
	metric_imm_functions: STRING_32 				is do Result := i18n("Imm. functions") end
	metric_imm_postcondition_equipped: STRING_32 	is do Result := i18n("Imm. post equipped") end
	metric_imm_precondition_equipped: STRING_32 	is do Result := i18n("Imm. pre equipped") end
	metric_imm_queries: STRING_32 					is do Result := i18n("Imm. queries") end
	metric_imm_routines: STRING_32 					is do Result := i18n("Imm. routines") end

	metric_all_features: STRING_32 					is do Result := i18n("Features: all") end
	metric_all_attributes: STRING_32 				is do Result := i18n("All attributes") end
	metric_all_commands: STRING_32 					is do Result := i18n("All commands") end
	metric_all_deferred_feature: STRING_32 			is do Result := i18n("All deferred features") end
	metric_all_effective_feature: STRING_32 		is do Result := i18n("All effective features") end
	metric_all_exported: STRING_32 					is do Result := i18n("All exported") end
	metric_all_functions: STRING_32 				is do Result := i18n("All functions") end
	metric_all_postcondition_equipped: STRING_32 	is do Result := i18n("All post equipped") end
	metric_all_precondition_equipped: STRING_32 	is do Result := i18n("All pre equipped") end
	metric_all_queries: STRING_32 					is do Result := i18n("All queries") end
	metric_all_routines: STRING_32 					is do Result := i18n("All routines") end

	metric_imm_feature_assertions: STRING_32 		is do Result := i18n("Feature assertions: immediate") end
	metric_imm_precondition_clauses: STRING_32 		is do Result := i18n("Imm pre. clauses") end
	metric_imm_postcondition_clauses: STRING_32 	is do Result := i18n("Imm. post. clauses") end

	metric_all_feature_assertions: STRING_32 		is do Result := i18n("Feature assertions: all") end
	metric_all_precondition_clauses: STRING_32 		is do Result := i18n("All pre. clauses") end
	metric_all_postcondition_clauses: STRING_32 	is do Result := i18n("All post. clauses") end

	metric_formal_generics: STRING_32 				is do Result := i18n("Formal generics") end
	metric_formal_generics_constrained: STRING_32	is do Result := i18n("Constrained") end

	metric_formals: STRING_32 						is do Result := i18n("Formals") end
	metric_imm_formals: STRING_32 					is do Result := i18n("Imm. formals") end

	metric_invariant_clauses: STRING_32 			is do Result := i18n("Invariant clauses") end
	metric_imm_invariant_clauses: STRING_32 		is do Result := i18n("Imm. invariant clauses") end

	metric_lines: STRING_32 						is do Result := i18n("Lines") end

	metric_locals: STRING_32 						is do Result := i18n("Locals") end
	metric_imm_locals: STRING_32 					is do Result := i18n("Imm. locals") end

--	metric_ancestors: STRING_32 					is do Result := i18n("Ancestors") end
--	metric_descendants: STRING_32 					is do Result := i18n("Descendents") end
--	metric_comment_lines: STRING_32 					is do Result := i18n("Comment lines") end

	metric_class_unit: STRING_32 					is do Result := i18n("Class") end
	metric_feature_unit: STRING_32 					is do Result := i18n("Feature") end
	metric_cluster_unit: STRING_32 					is do Result := i18n("Cluster") end
	metric_line_unit: STRING_32 					is do Result := i18n("Line") end
	metric_contract_unit: STRING_32 				is do Result := i18n("Contract") end
	metric_contract_clause_unit: STRING_32 			is do Result := i18n("Contract clause") end
	metric_ratio_unit: STRING_32 					is do Result := i18n("Ratio") end
	metric_compilation_unit: STRING_32 				is do Result := i18n("Compilation") end
	metric_local_unit: STRING_32 					is do Result := i18n("Local") end

	metric_calculate: STRING_32 					is do Result := i18n("&Calculate") end
	metric_add: STRING_32 							is do Result := i18n("&Add") end
	metric_delete: STRING_32 						is do Result := i18n("&Delete") end
	metric_details: STRING_32 						is do Result := i18n("&Show/hide details") end
	metric_new_metrics: STRING_32 					is do Result := i18n("&New metrics") end
	metric_management: STRING_32 					is do Result := i18n("&Metric management") end
	metric_archive: STRING_32 						is do Result := i18n("A&rchive") end

feature {NONE} -- Template formatter

	formatter: I18N_TEMPLATE_FORMATTER is
		once
			create Result.make
		end

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

end -- class INTERFACE_NAMES

