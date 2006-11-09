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
	EB_SHARED_LOCALE

feature -- Button texts

	b_Abort: STRING is						do	Result := locale.translate("Abort").out 			end
	b_Add: STRING is 						do	Result := locale.translate("Add").out				end
	b_Add_text: STRING is 					do	Result := locale.translate("Add ->").out			end
	b_And: STRING is						do	Result := locale.translate("And").out				end
	b_Apply: STRING is						do	Result := locale.translate("Apply").out				end
	b_Browse: STRING is						do	Result := locale.translate("Browse...").out			end
	b_Cancel: STRING is						do	Result := locale.translate("Cancel").out			end
	b_C_functions: STRING is				do	Result := locale.translate("C Functions").out			end
	b_Close: STRING is						do	Result := locale.translate("Close").out				end
	b_Continue_anyway: STRING is			do	Result := locale.translate("Continue Anyway").out		end
	b_Create: STRING is						do	Result := locale.translate("Create").out			end
	b_Create_folder: STRING is				do	Result := locale.translate("Create Folder...").out		end
	b_Delete_command: STRING is				do	Result := locale.translate("Delete").out			end
	b_Descendant_time: STRING is			do	Result := locale.translate("Descendant Time").out		end
	b_Discard_assertions: STRING is			do	Result := locale.translate("Discard Assertions").out		end
	b_Display_Exception_Trace: STRING is	do	Result := locale.translate("Display Exception Trace").out	end
	b_Down_text: STRING is 					do	Result := locale.translate("Down").out				end
	b_Edit_ace: STRING is					do	Result := locale.translate("Edit").out				end
	b_Edit_command: STRING is				do	Result := locale.translate("Edit...").out			end
	b_Eiffel_features: STRING is 			do	Result := locale.translate("Eiffel Features").out	end
	b_Feature_name: STRING is 				do	Result := locale.translate("Feature Name").out	end
	b_Finish: STRING is 					do	Result := locale.translate("Finish").out	end
	b_Function_time: STRING is 				do	Result := locale.translate("Function Time").out	end
	b_Keep_assertions: STRING is 			do	Result := locale.translate("Keep Assertions").out	end
	b_Load_ace: STRING is 					do	Result := locale.translate("Load From...").out	end
	b_Move_to_folder: STRING is 			do	Result := locale.translate("Move to Folder...").out	end
	b_New_ace: STRING is 					do	Result := locale.translate("Reset").out	end
	b_New_command: STRING is 				do	Result := locale.translate("Add...").out	end
	b_New_favorite_class: STRING is 		do	Result := locale.translate("New Favorite Class...").out	end
	b_New_tab: STRING is 					do	Result := locale.translate("New Tab").out	end
	b_Next: STRING is 						do	Result := locale.translate("Next").out	end
	b_Number_of_calls: STRING is 			do	Result := locale.translate("Number of Calls").out	end
	b_Ok: STRING is 						do	Result := locale.translate("OK").out	end
	b_Open_original: STRING is 				do	Result := locale.translate("Open Original File").out	end
	b_Open_backup: STRING is 				do	Result := locale.translate("Open Backup File").out	end
	b_Or: STRING is 						do	Result := locale.translate("Or").out	end
	b_Percentage: STRING is 				do	Result := locale.translate("Percentage").out	end
	b_Replace: STRING is 					do	Result := locale.translate("Replace").out	end
	b_Replace_all: STRING is 				do	Result := locale.translate("Replace all").out	end
	b_Recursive_functions: STRING is 		do	Result := locale.translate("Recursive Functions").out	end
	b_Reload: STRING is 					do	Result := locale.translate("Reload").out	end
	b_Remove: STRING is 					do	Result := locale.translate("Remove").out	end
	b_Remove_all: STRING is 				do	Result := locale.translate("Remove all").out	end
	b_Remove_text: STRING is 				do	Result := locale.translate("<- Remove").out	end
	b_Retry: STRING is 						do	Result := locale.translate("Retry").out	end
	b_Search: STRING is 					do	Result := locale.translate("Search").out	end
	b_New_search: STRING is 				do	Result := locale.translate("New Search?").out	end
	b_Save: STRING is 						do	Result := locale.translate("Save").out	end
	b_Save_all: STRING is 					do	Result := locale.translate("Save All").out	end
	b_Total_time: STRING is 				do	Result := locale.translate("Total Time").out	end
	b_Up_text: STRING is 					do	Result := locale.translate("Up").out	end
	b_Update: STRING is 					do	Result := locale.translate("Update").out	end
	b_Compile: STRING is 					do	Result := locale.translate("Compile").out	end
	b_Launch: STRING is 					do	Result := locale.translate("Start").out	end
	b_Continue: STRING is 					do	Result := locale.translate("Continue").out	end
	b_Finalize: STRING is 					do	Result := locale.translate("Finalize").out	end
	b_Freeze: STRING is 					do	Result := locale.translate("Freeze").out	end
	b_Precompile: STRING is 				do	Result := locale.translate("Precompile").out	end
	b_override_scan: STRING is 				do	Result := locale.translate("Recompile Overrides").out	end
	b_discover_melt: STRING is 				do	Result := locale.translate("Find Added Classes & Recompile").out	end
	b_Cut: STRING is			 			do	Result := locale.translate("Cut").out	end
	b_Copy: STRING is 						do	Result := locale.translate("Copy").out	end
	b_Paste: STRING is			 			do	Result := locale.translate("Paste").out	end
	b_New_editor: STRING is 				do	Result := locale.translate("New Editor").out	end
	b_New_context: STRING is 				do	Result := locale.translate("New Context").out	end
	b_New_window: STRING is 				do	Result := locale.translate("New Window").out	end
	b_Open: STRING is 						do	Result := locale.translate("Open").out	end
	b_Save_as: STRING is 					do	Result := locale.translate("Save As").out	end
	b_Shell: STRING is 						do	Result := locale.translate("External Editor").out	end
	b_Print: STRING is 						do	Result := locale.translate("Print").out	end
	b_Undo: STRING is 						do	Result := locale.translate("Undo").out	end
	b_Redo: STRING is 						do	Result := locale.translate("Redo").out	end
	b_Create_new_cluster: STRING is 		do	Result := locale.translate("Add Cluster").out	end
	b_Create_new_library: STRING is 		do	Result := locale.translate("Add Library").out	end
	b_Create_new_assembly: STRING is 		do	Result := locale.translate("Add Assembly").out	end
	b_Create_new_precompile: STRING is 		do	Result := locale.translate("Add Precompile").out	end
	b_Create_new_class: STRING is 			do	Result := locale.translate("New Class").out	end
	b_Create_new_feature: STRING is 		do	Result := locale.translate("New Feature").out	end
	b_Send_stone_to_context: STRING is 		do	Result := locale.translate("Synchronize").out	end
	b_Display_error_help: STRING is 		do	Result := locale.translate("Help Tool").out	end
	b_Project_settings: STRING is 			do	Result := locale.translate("Project Settings").out	end
	b_System_info: STRING is 				do	Result := locale.translate("System Info").out	end
	b_Bkpt_info: STRING is 					do	Result := locale.translate("Breakpoint Info").out	end
	b_Bkpt_enable: STRING is 				do	Result := locale.translate("Enable Breakpoints").out	end
	b_Bkpt_disable: STRING is 				do	Result := locale.translate("Disable Breakpoints").out	end
	b_Bkpt_remove: STRING is 				do	Result := locale.translate("Remove Breakpoints").out	end
	b_Bkpt_stop_in_hole: STRING is 			do	Result := locale.translate("Pause").out	end
	b_Exec_kill: STRING is 					do	Result := locale.translate("Stop Application").out	end
	b_Exec_into: STRING is 					do	Result := locale.translate("Step Into").out	end
	b_Exec_no_stop: STRING is 				do	Result := locale.translate("Launch Without Stopping").out	end
	b_Exec_out: STRING is 					do	Result := locale.translate("Step Out").out	end
	b_Exec_step: STRING is 					do	Result := locale.translate("Step").out	end
	b_Exec_stop: STRING is 					do	Result := locale.translate("Pause").out	end
	b_Run_finalized: STRING is 				do	Result := locale.translate("Run Finalized").out	end
	b_Toggle_stone_management: STRING is 	do	Result := locale.translate("Link Context").out	end
	b_Raise_all: STRING is 					do	Result := locale.translate("Raise Windows").out	end
	b_Remove_class_cluster: STRING is 		do	Result := locale.translate("Remove Class/Cluster").out	end
	b_Minimize_all: STRING is 				do	Result := locale.translate("Minimize All").out	end
	b_Terminate_c_compilation: STRING is 	do	Result := locale.translate("Terminate C Compilation").out	end
	b_Expand_all: STRING is 				do	Result := locale.translate("Expand All").out	end
	b_Collapse_all: STRING is 				do	Result := locale.translate("Collapse All").out	end
	b_Dbg_exception_handler: STRING is 		do	Result := locale.translate("Exceptions").out	end
	b_Dbg_assertion_checking_disable: STRING is		do	Result := locale.translate("Disable assertion checking").out	end
	b_Dbg_assertion_checking_restore: STRING is 	do	Result := locale.translate("Restore assertion checking").out	end

feature -- Graphical degree output

	d_Classes_to_go: STRING is 					do	Result := locale.translate("Classes to Go:").out	end
	d_Clusters_to_go: STRING is 				do	Result := locale.translate("Clusters to Go:").out	end
	d_Compilation_class: STRING is 				do	Result := locale.translate("Class:").out	end
	d_Compilation_cluster: STRING is 			do	Result := locale.translate("Cluster:").out	end
	d_Compilation_progress: STRING is 			do	Result := locale.translate("Compilation Progress for ").out	end
	d_Degree: STRING is 						do	Result := locale.translate("Degree:").out	end
	d_Documentation: STRING is 					do	Result := locale.translate("Documentation").out	end
	d_Features_processed: STRING is	 			do	Result := locale.translate("Completed: ").out	end
	d_Features_to_go: STRING is 				do	Result := locale.translate("Remaining: ").out	end
	d_Generating: STRING is 					do	Result := locale.translate("Generating: ").out	end
	d_Resynchronizing_breakpoints: STRING is	do	Result := locale.translate("Resynchronizing Breakpoints").out	end
	d_Resynchronizing_tools: STRING is 			do	Result := locale.translate("Resynchronizing Tools").out	end
	d_Reverse_engineering: STRING is 			do	Result := locale.translate("Reverse Engineering Project").out	end
	d_Finished_removing_dead_code: STRING is 	do	Result := locale.translate("Dead Code Removal Completed").out	end

feature -- Help text

	h_No_help_available: STRING is 				do	Result := locale.translate("No help available for this element").out	end
	h_refactoring_compiled: STRING is 			do	Result := locale.translate("Renames only occurances of the class name in compiled classes.").out	end
	h_refactoring_all_classes: STRING is 		do	Result := locale.translate("Renames occurances of the class name in any class. (Slow)").out	end

feature -- File names

	default_stack_file_name: STRING is 			do	Result := locale.translate("stack").out	end

feature -- Accelerator, focus label and menu name

	m_About: STRING is
		once
			Result := locale.format_string (locale.translate("&About $1..."), [Workbench_name])
		end
	m_Advanced: STRING is 						do	Result := locale.translate("Ad&vanced").out	end
	m_Add_to_favorites: STRING is 				do	Result := locale.translate("&Add to Favorites").out	end
	m_Address_toolbar: STRING is 				do	Result := locale.translate("&Address Bar").out	end
	m_Apply: STRING is 							do	Result := locale.translate("&Apply").out	end
	l_all_classes: STRING is 					do	Result := locale.translate("All Classes").out	end
	m_Breakpoints_tool: STRING is 				do	Result := locale.translate("Breakpoints").out	end

	l_class_tree_assemblies: STRING is 			do	Result := locale.translate("Assemblies").out	end
	l_class_tree_clusters: STRING is 			do	Result := locale.translate("Clusters").out	end
	l_class_tree_libraries: STRING is 			do	Result := locale.translate("Libraries").out	end
	l_class_tree_overrides: STRING is 			do	Result := locale.translate("Overrides").out	end

	f_Clear_breakpoints: STRING is 				do	Result := locale.translate("Remove all breakpoints").out	end
	m_Clear_breakpoints: STRING is 				do	Result := locale.translate("Re&move All Breakpoints").out	end
	m_Comment: STRING is 						do	Result := locale.translate("&Comment%TCtrl+K").out	end
	m_Compilation_C_Workbench: STRING is 		do	Result := locale.translate("Compile W&orkbench C Code").out	end
	m_Compilation_C_Final: STRING is 			do	Result := locale.translate("Compile F&inalized C Code").out	end
	m_Contents: STRING is 						do	Result := locale.translate("&Contents").out	end
	m_Customize_general: STRING is 				do	Result := locale.translate("&Customize Standard Toolbar...").out	end
	m_Customize_project: STRING is 				do	Result := locale.translate("Customize P&roject Toolbar...").out	end
	m_Customize_refactoring: STRING is 			do	Result := locale.translate("Customize Re&factoring Toolbar...").out	end
	m_Cut: STRING is 							do	Result := locale.translate("Cu&t%TCtrl+X").out	end
	f_Cut: STRING is 							do	Result := locale.translate("Cut (Ctrl+X)").out	end
	m_Call_stack_tool: STRING is 				do	Result := locale.translate("Call stack").out	end
	m_Cluster_tool: STRING is 					do	Result := locale.translate("&Clusters").out	end
	l_compiled_classes: STRING is 				do	Result := locale.translate("Compiled Classes").out	end
	m_Complete_word: STRING is 					do	Result := locale.translate("Complete &Word").out	end
	m_Complete_class_name: STRING is 			do	Result := locale.translate("Complete Class &Name").out	end
	m_Context_tool: STRING is 					do	Result := locale.translate("Conte&xt").out	end
	m_Copy: STRING is 							do	Result := locale.translate("&Copy%TCtrl+C").out	end
	f_Copy: STRING is				 			do	Result := locale.translate("Copy (Ctrl+C)").out	end
	m_Close: STRING is 							do	Result := locale.translate("&Close Window%TAlt+F4").out	end
	m_Close_short: STRING is 					do	Result := locale.translate("&Close").out	end
	f_Create_new_cluster: STRING is 			do	Result := locale.translate("Add a cluster").out	end
	f_Create_new_library: STRING is 			do	Result := locale.translate("Add a library").out	end
	f_Create_new_assembly: STRING is 			do	Result := locale.translate("Add an assembly").out	end
	f_Create_new_precompile: STRING is 			do	Result := locale.translate("Add a precompile").out	end
	f_Create_new_class: STRING is 				do	Result := locale.translate("Create a new class").out	end
	f_Create_new_feature: STRING is 			do	Result := locale.translate("Create a new feature").out	end

	m_Dbg_assertion_checking_disable: STRING is 	do	Result := locale.translate("Disable Assertion Checking").out	end
	m_Dbg_assertion_checking_restore: STRING is		do	Result := locale.translate("Restore Assertion Checking").out	end
	m_Dbg_exception_handler: STRING is 			do	Result := locale.translate("Exception Handling").out	end
	m_Debug_interrupt_new: STRING is 			do	Result := locale.translate("I&nterrupt Application").out	end
	f_Debug_edit_object: STRING is 				do	Result := locale.translate("Edit Object content").out	end
	m_Debug_edit_object: STRING is 				do	Result := locale.translate("Edit Object Content").out	end
	f_Debug_dynamic_eval: STRING is 			do	Result := locale.translate("Dynamic feature evaluation").out	end
	m_Debug_dynamic_eval: STRING is 			do	Result := locale.translate("Dynamic Feature Evaluation").out	end
	m_Debug_kill: STRING is 					do	Result := locale.translate("&Stop Application").out	end
	f_Debug_run: STRING is 						do	Result := locale.translate("Run").out	end
	m_Debug_run: STRING is 						do	Result := locale.translate("&Run%TCtrl+R").out	end
	m_Debug_run_new: STRING is 					do	Result := locale.translate("St&art").out	end
	m_Launch_With_Arguments: STRING is 			do	Result := locale.translate("Start With Arguments").out	end
	f_diagram_delete: STRING is 				do	Result := locale.translate("Delete").out	end
	l_diagram_delete: STRING is 				do	Result := locale.translate("Delete graphical items, remove code from system").out	end
	f_diagram_crop: STRING is 					do	Result := locale.translate("Crop diagram").out	end
	m_diagram_crop: STRING is		 			do	Result := locale.translate("&Crop Diagram").out	end
	f_diagram_zoom_out: STRING is 				do	Result := locale.translate("Zoom out").out	end
	f_diagram_put_right_angles: STRING is 		do	Result := locale.translate("Force right angles").out	end
	f_diagram_remove_right_angles: STRING is	do	Result := locale.translate("Remove right angles").out	end
	m_diagram_link_tool: STRING is 				do	Result := locale.translate("&Put Right Angles").out	end
	f_diagram_to_png: STRING is 				do	Result := locale.translate("Export diagram to PNG").out	end
	m_diagram_to_png: STRING is 				do	Result := locale.translate("&Export Diagram to PNG").out	end
	f_diagram_context_depth: STRING is 			do	Result := locale.translate("Select depth of relations").out	end
	m_diagram_context_depth: STRING is 			do	Result := locale.translate("&Select Depth of Relations").out	end
	f_diagram_delete_view: STRING is 			do	Result := locale.translate("Delete current view").out	end
	f_diagram_reset_view: STRING is 			do	Result := locale.translate("Reset current view").out	end
	m_diagram_delete_view: STRING is 			do	Result := locale.translate("&Delete Current View").out	end
	m_diagram_reset_view: STRING is 			do	Result := locale.translate("&Reset Current View").out	end
	f_diagram_zoom_in: STRING is 				do	Result := locale.translate("Zoom in").out	end
	f_diagram_fit_to_screen: STRING is 			do	Result := locale.translate("Fit to screen").out	end
	f_diagram_undo: STRING is 					do	Result := locale.translate("Undo last action").out	end
	f_diagram_hide_supplier: STRING is 			do	Result := locale.translate("Hide supplier links").out	end
	f_diagram_show_supplier: STRING is 			do	Result := locale.translate("Show supplier links").out	end

	l_diagram_supplier_visibility: STRING is 	do	Result := locale.translate("Toggle visibility of supplier links").out	end

	l_diagram_add_ancestors: STRING is 			do	Result := locale.translate("Add class ancestors to diagram").out	end
	l_diagram_add_descendents: STRING is 		do	Result := locale.translate("Add class descendants to diagram").out	end
	l_diagram_add_suppliers: STRING is 			do	Result := locale.translate("Add class suppliers to diagram").out	end
	l_diagram_add_clients: STRING is 			do	Result := locale.translate("Add class clients to diagram").out	end

	f_diagram_hide_labels: STRING is 			do	Result := locale.translate("Hide labels").out	end
	f_diagram_show_labels: STRING is 			do	Result := locale.translate("Show labels").out	end
	f_diagram_show_uml: STRING is 				do	Result := locale.translate("Show UML").out	end
	f_diagram_show_bon: STRING is 				do	Result := locale.translate("Show BON").out	end
	f_diagram_hide_clusters: STRING is 			do	Result := locale.translate("Hide clusters").out	end
	f_diagram_show_clusters: STRING is 			do	Result := locale.translate("Show clusters").out	end
	f_diagram_show_legend: STRING is 			do	Result := locale.translate("Show cluster legend").out	end
	f_diagram_hide_legend: STRING is 			do	Result := locale.translate("Hide cluster legend").out	end
	f_diagram_remove_anchor: STRING is 			do	Result := locale.translate("Remove anchor").out	end
	l_diagram_labels_visibility: STRING is 		do	Result := locale.translate("Toggle visibility of client link labels").out	end
	l_diagram_uml_visibility: STRING is 		do	Result := locale.translate("Toggle between UML and BON view").out	end
	l_diagram_clusters_visibility: STRING is 	do	Result := locale.translate("Toggle visibility of clusters").out	end
	l_diagram_legend_visibility: STRING is 		do	Result := locale.translate("Toggle visibility of cluster legend").out	end
	l_diagram_remove_anchor: STRING is 			do	Result := locale.translate("Remove anchor").out	end
	l_diagram_force_directed: STRING is 		do	Result := locale.translate("Turn on/off physics").out	end
	l_diagram_toggle_quality: STRING is 		do	Result := locale.translate("Toggle quality level").out	end
	f_diagram_high_quality: STRING is 			do	Result := locale.translate("Switch to high quality").out	end
	f_diagram_low_quality: STRING is 			do	Result := locale.translate("Switch to low quality").out	end
	f_diagram_hide_inheritance: STRING is 		do	Result := locale.translate("Hide inheritance links").out	end
	f_diagram_show_inheritance: STRING is 		do	Result := locale.translate("Show inheritance links").out	end
	l_diagram_inheritance_visibility: STRING is		do	Result := locale.translate("Toggle visibility of inheritance links").out	end
	f_diagram_redo: STRING is 					do	Result := locale.translate("Redo last action").out	end
	f_diagram_fill_cluster: STRING is 			do	Result := locale.translate("Include all classes of cluster").out	end
	f_diagram_history: STRING is 				do	Result := locale.translate("History tool").out	end
	f_diagram_remove: STRING is 				do	Result := locale.translate("Hide figure").out	end
	l_diagram_remove: STRING is 				do	Result := locale.translate("Delete graphical items").out	end
	f_diagram_create_supplier_links: STRING is 				do	Result := locale.translate("Create new client-supplier links").out	end
	f_diagram_create_aggregate_supplier_links: STRING is 	do	Result := locale.translate("Create new aggregate client-supplier links").out	end
	f_diagram_create_inheritance_links: STRING is 			do	Result := locale.translate("Create new inheritance links").out	end
	l_diagram_create_links: STRING is 			do	Result := locale.translate("Select type of new links").out	end
	f_diagram_new_class: STRING is 				do	Result := locale.translate("Create a new class").out	end
	f_diagram_change_header: STRING is 			do	Result := locale.translate("Change class name and generics").out	end
	f_diagram_change_color: STRING is 			do	Result := locale.translate("Change color").out	end
	f_diagram_force_directed_on: STRING is 		do	Result := locale.translate("Turn on physics").out	end
	f_diagram_force_directed_off: STRING is 	do	Result := locale.translate("Turn off physics").out	end
	f_diagram_force_settings: STRING is 		do	Result := locale.translate("Show physics settings dialog").out	end
	f_Disable_stop_points: STRING is 			do	Result := locale.translate("Disable all breakpoints").out	end
	m_Disable_stop_points: STRING is 			do	Result := locale.translate("&Disable All Breakpoints").out	end
	m_Debug_block: STRING is 					do	Result := locale.translate("E&mbed in %"Debug...%"%TCtrl+D").out	end
	m_Editor: STRING is 						do	Result := locale.translate("&Editor").out	end
	m_Eiffel_introduction: STRING is 			do	Result := locale.translate("&Introduction to Eiffel").out	end
	f_Enable_stop_points: STRING is 			do	Result := locale.translate("Enable all breakpoints").out	end
	m_Enable_stop_points: STRING is 			do	Result := locale.translate("&Enable All Breakpoints").out	end
	m_Exec_last: STRING is 						do	Result := locale.translate("&Out of Routine").out	end
	m_Exec_nostop: STRING is 					do	Result := locale.translate("&Ignore Breakpoints").out	end
	m_Exec_step: STRING is 						do	Result := locale.translate("&Step-by-Step").out	end
	m_Exec_into: STRING is 						do	Result := locale.translate("Step In&to").out	end
	m_Exit_project: STRING is 					do	Result := locale.translate("E&xit").out	end
	m_Explorer_bar: STRING is 			do	Result := locale.translate("&Tools").out	end
	m_Export_to: STRING is 			do	Result := locale.translate("Save Cop&y As...").out	end
	m_Export_XMI: STRING is 			do	Result := locale.translate("E&xport XMI...").out	end
	m_Expression_evaluation: STRING is 			do	Result := locale.translate("Expression Evaluation").out	end
	m_External_editor: STRING is 			do	Result := locale.translate("External E&ditor").out	end
	m_Favorites_tool: STRING is 			do	Result := locale.translate("F&avorites").out	end
	m_Features_tool: STRING is 			do	Result := locale.translate("&Features").out	end
	f_Finalize: STRING is 			do	Result := locale.translate("Finalize...").out	end
	m_Finalize_new: STRING is 			do	Result := locale.translate("Finali&ze...").out	end
	m_Find: STRING is 			do	Result := locale.translate("&Search").out	end
	m_Find_next: STRING is 			do	Result := locale.translate("Find &Next").out	end
	m_Find_previous: STRING is 			do	Result := locale.translate("Find &Previous").out	end
	m_Find_next_selection: STRING is 			do	Result := locale.translate("Find Next &Selection").out	end
	m_Find_previous_selection: STRING is 			do	Result := locale.translate("Find P&revious Selection").out	end
	f_Freeze: STRING is 			do	Result := locale.translate("Freeze...").out	end
	m_Freeze_new: STRING is 			do	Result := locale.translate("&Freeze...").out	end
	m_General_toolbar: STRING is 			do	Result := locale.translate("&Standard Buttons").out	end
	m_Generate_documentation: STRING is 			do	Result := locale.translate("Generate &Documentation...").out	end
	m_Go_to: STRING is 			do	Result := locale.translate("&Go to...").out	end
	m_Guided_tour: STRING is 			do	Result := locale.translate("&Guided Tour").out	end
	m_Help: STRING is 			do	Result := locale.translate("&Help").out	end
	m_Hide_favorites: STRING is 			do	Result := locale.translate("&Hide Favorites").out	end
	m_Hide_formatting_marks: STRING is 			do	Result := locale.translate("&Hide Formatting Marks").out	end
	m_History_forth: STRING is 			do	Result := locale.translate("&Forward").out	end
	m_History_back: STRING is 			do	Result := locale.translate("&Back").out	end
	f_History_forth: STRING is 			do	Result := locale.translate("Go forth").out	end
	f_History_back: STRING is 			do	Result := locale.translate("Go back").out	end
	m_How_to_s: STRING is 			do	Result := locale.translate("&How to's").out	end
	m_If_block: STRING is 			do	Result := locale.translate("&Embed in %"if...%"%TCtrl+I").out	end
	m_Indent: STRING is 			do	Result := locale.translate("&Indent Selection%TTab").out	end
	m_Line_numbers: STRING is 			do	Result := locale.translate("Toggle &Line Numbers").out	end
	f_Melt: STRING is 			do	Result := locale.translate("Compile current project").out	end
	m_Melt_new: STRING is 			do	Result := locale.translate("&Compile").out	end
	m_New: STRING is 			do	Result := locale.translate("&New").out	end
	l_new_name: STRING is 			do	Result := locale.translate("New Name:").out	end
	f_New_window: STRING is 			do	Result := locale.translate("Create a new window").out	end
	m_New_window: STRING is 			do	Result := locale.translate("New &Window").out	end
	m_New_dynamic_lib: STRING is 			do	Result := locale.translate("&Dynamic Library Builder...").out	end
	m_New_project: STRING is 			do	Result := locale.translate("&New Project...").out	end
	m_Ok: STRING is 			do	Result := locale.translate("&OK").out	end
	m_Open: STRING is 			do	Result := locale.translate("&Open...%TCtrl+O").out	end
	m_Open_new: STRING is 			do	Result := locale.translate("Op&en...").out	end
	m_Open_project: STRING is 			do	Result := locale.translate("&Open Project...").out	end
	m_Organize_favorites: STRING is 			do	Result := locale.translate("&Organize Favorites...").out	end
	m_Output: STRING is 			do	Result := locale.translate("&Output").out	end
	f_Paste: STRING is 			do	Result := locale.translate("Paste (Ctrl+V)").out	end
	m_Paste: STRING is 			do	Result := locale.translate("&Paste%TCtrl+V").out	end
	m_Precompile_new: STRING is 			do	Result := locale.translate("&Precompile").out	end
	f_Print: STRING is 			do	Result := locale.translate("Print").out	end
	m_Print: STRING is 			do	Result := locale.translate("&Print").out	end
	f_preferences: STRING is 			do	Result := locale.translate("Preferences").out	end
	m_Preferences: STRING is 			do	Result := locale.translate("&Preferences...").out	end
	m_Properties_tool: STRING is 			do	Result := locale.translate("Pr&operties").out	end
	m_Profile_tool: STRING is 			do	Result := locale.translate("Pro&filer...").out	end
	m_Project_toolbar: STRING is 			do	Result := locale.translate("&Project Bar").out	end
	m_Refactoring_toolbar: STRING is 			do	Result := locale.translate("Re&factoring Bar").out	end
	f_refactoring_pull: STRING is 			do	Result := locale.translate("Pull up Feature").out	end
	f_refactoring_rename: STRING is 			do	Result := locale.translate("Rename Feature/Class").out	end
	f_refactoring_undo: STRING is 			do	Result := locale.translate("Undo Last Refactoring (only works as long as no file that was refactored has been changed by hand)").out	end
	f_refactoring_redo: STRING is 			do	Result := locale.translate("Redo Last Refactoring (only works as long as no file that was refactored has been changed by hand)").out	end
	b_refactoring_pull: STRING is 			do	Result := locale.translate("Pull Up").out	end
	b_refactoring_rename: STRING is 			do	Result := locale.translate("Rename").out	end
	b_refactoring_undo: STRING is 			do	Result := locale.translate("Undo Refactoring").out	end
	b_refactoring_redo: STRING is 			do	Result := locale.translate("Redo Refactoring").out	end
	l_rename_file: STRING is 			do	Result := locale.translate("Rename File").out	end
	l_replace_comments: STRING is 			do	Result := locale.translate("Replace Name in Comments").out	end
	l_replace_strings: STRING is 			do	Result := locale.translate("Replace Name in Strings").out	end
	m_Recent_project: STRING is 			do	Result := locale.translate("&Recent Projects").out	end
	m_Redo: STRING is 			do	Result := locale.translate("Re&do%TCtrl+Y").out	end
	f_Redo: STRING is 			do	Result := locale.translate("Redo (Ctrl+Y)").out	end
	m_Replace: STRING is 			do	Result := locale.translate("&Replace...").out	end
	f_Retarget_diagram: STRING is 			do	Result := locale.translate("Target to cluster or class").out	end
	f_Run_finalized: STRING is 			do	Result := locale.translate("Run finalized system").out	end
	m_Run_finalized: STRING is 			do	Result := locale.translate("&Run Finalized System").out	end
	f_Save: STRING is 			do	Result := locale.translate("Save").out	end
	m_Save_new: STRING is 			do	Result := locale.translate("&Save").out	end
	m_Save_As: STRING is 			do	Result := locale.translate("S&ave As...").out	end
	f_Save_all: STRING is 			do	Result := locale.translate("Save All").out	end
	m_Save_All: STRING is 			do	Result := locale.translate("Save &All").out	end
	m_Search: STRING is 			do	Result := locale.translate("&Find...").out	end
	m_Search_tool: STRING is 			do	Result := locale.translate("&Search").out	end
	m_Select_all: STRING is 			do	Result := locale.translate("Select &All%TCtrl+A").out	end
	m_Send_to: STRING is 			do	Result := locale.translate("Sen&d to").out	end
	m_show_assigners: STRING is 			do	Result := locale.translate("A&ssigners").out	end
	m_Show_class_cluster: STRING is 			do	Result := locale.translate("Find in Cluster Tree").out	end
	m_show_creators: STRING is 			do	Result := locale.translate("C&reators").out	end
	m_Show_favorites: STRING is 			do	Result := locale.translate("&Show Favorites").out	end
	m_Show_formatting_marks: STRING is 			do	Result := locale.translate("&Show Formatting Marks").out	end
	m_Showancestors: STRING is 			do	Result := locale.translate("&Ancestors").out	end
	m_Showattributes: STRING is 			do	Result := locale.translate("A&ttributes").out	end
	m_Showcallers: STRING is 			do	Result := locale.translate("&Callers").out	end
	m_Showcallees: STRING is 			do	Result := locale.translate("Call&ees").out	end
	m_Show_creation: STRING is 			do	Result := locale.translate("Creat&ions").out	end
	m_Show_assignees: STRING is 			do	Result := locale.translate("&Assignees").out	end
	m_Showclick: STRING is 			do	Result := locale.translate("C&lickable").out	end
	m_Showclients: STRING is 			do	Result := locale.translate("Cli&ents").out	end
	m_showcreators: STRING is 			do	Result := locale.translate("&Creators").out	end
	m_Showdeferreds: STRING is 			do	Result := locale.translate("&Deferred").out	end
	m_Showdescendants: STRING is 			do	Result := locale.translate("De&scendants").out	end
	m_Showexported: STRING is 			do	Result := locale.translate("Ex&ported").out	end
	m_Showexternals: STRING is 			do	Result := locale.translate("E&xternals").out	end
	m_Showflat: STRING is 			do	Result := locale.translate("&Flat").out	end
	m_Showfs: STRING is 			do	Result := locale.translate("&Interface").out	end
	m_Showfuture: STRING is 			do	Result := locale.translate("&Descendant Versions").out	end
	m_Showhistory: STRING is 			do	Result := locale.translate("&Implementers").out	end
	m_Showindexing: STRING is 			do	Result := locale.translate("&Indexing clauses").out	end
	m_show_invariants: STRING is 			do	Result := locale.translate("In&variants").out	end
	m_Showonces: STRING is 			do	Result := locale.translate("O&nce/Constants").out	end
	m_Showpast: STRING is 			do	Result := locale.translate("&Ancestor Versions").out	end
	m_Showroutines: STRING is 			do	Result := locale.translate("&Routines").out	end
	m_Showshort: STRING is 			do	Result := locale.translate("C&ontract").out	end
	m_Showhomonyms: STRING is 			do	Result := locale.translate("&Homonyms").out	end
	m_Showsuppliers: STRING is 			do	Result := locale.translate("S&uppliers").out	end
	m_Showtext_new: STRING is 			do	Result := locale.translate("Te&xt").out	end
	m_System_new: STRING is 			do	Result := locale.translate("Project &Settings...").out	end
	m_Toolbars: STRING is 			do	Result := locale.translate("Tool&bars").out	end
	m_To_lower: STRING is 			do	Result := locale.translate("Set to &Lowercase%TCtrl+Shift+U").out	end
	m_To_upper: STRING is 			do	Result := locale.translate("Set to U&ppercase%TCtrl+U").out	end
	m_Uncomment: STRING is 			do	Result := locale.translate("U&ncomment%TCtrl+Shift+K").out	end
	f_Uncomment: STRING is 			do	Result := locale.translate("Uncomment selected lines").out	end
	m_Undo: STRING is 			do	Result := locale.translate("&Undo%TCtrl+Z").out	end
	f_Undo: STRING is 			do	Result := locale.translate("Undo (Ctrl+Z)").out	end
	m_Unindent: STRING is 			do	Result := locale.translate("&Unindent Selection%TShift+Tab").out	end
	m_Windows_tool: STRING is 			do	Result := locale.translate("&Windows").out	end
	m_Watch_tool: STRING is 			do	Result := locale.translate("Watch Tool").out	end
	m_Wizard_precompile: STRING is 			do	Result := locale.translate("Precompilation &Wizard...").out	end
	f_Wizard_precompile: STRING is 			do	Result := locale.translate("Wizard to precompile libraries").out	end
	f_go_to_first_occurrence: STRING is 			do	Result := locale.translate("Double click to go to first occurrence").out	end

feature -- Toggles

	f_hide_alias: STRING is 				do	Result := locale.translate("Hide Alias Name").out	end
	f_hide_assigner: STRING is 				do	Result := locale.translate("Hide Assigner Command Name").out	end
	f_hide_signature: STRING is 			do	Result := locale.translate("Hide Signature").out	end
	f_show_alias: STRING is 				do	Result := locale.translate("Show Alias Name").out	end
	f_show_assigner: STRING is 				do	Result := locale.translate("Show Assigner Command Name").out	end
	f_show_signature: STRING is 			do	Result := locale.translate("Show Signature").out	end
	l_toggle_alias: STRING is 				do	Result := locale.translate("Toggle visibility of feature alias name").out	end
	l_toggle_assigner: STRING is 			do	Result := locale.translate("Toggle visibility of assigner command name").out	end
	l_toggle_signature: STRING is 			do	Result := locale.translate("Toggle visibility of feature signature").out	end

feature -- Menu mnenomics

	m_Add_exported_feature: STRING is 			do	Result := locale.translate("&Add...").out	end
	m_Bkpt_info: STRING is 			do	Result := locale.translate("Brea&kpoint Information").out	end
	m_Class_info: STRING is 			do	Result := locale.translate("Cla&ss Views").out	end
	m_Check_exports: STRING is 			do	Result := locale.translate("Chec&k Export Clauses").out	end
	m_Create_new_cluster: STRING is 			do	Result := locale.translate("Add C&luster...").out	end
	m_Create_new_library: STRING is 			do	Result := locale.translate("Add L&ibrary...").out	end
	m_Create_new_precompile: STRING is 			do	Result := locale.translate("Add &Precompile").out	end
	m_Create_new_assembly: STRING is 			do	Result := locale.translate("Add &Assembly...").out	end
	m_Create_new_class: STRING is 			do	Result := locale.translate("&New Class...").out	end
	m_Create_new_feature: STRING is 			do	Result := locale.translate("New Fea&ture...").out	end
	m_Debug: STRING is 			do	Result := locale.translate("&Debug").out	end
	m_Debugging_tool: STRING is 			do	Result := locale.translate("&Debugging Tools").out	end
	m_Disable_this_bkpt: STRING is 			do	Result := locale.translate("&Disable This Breakpoint").out	end
	m_Display_error_help: STRING is 			do	Result := locale.translate("Compilation Error &Wizard...").out	end
	m_Display_system_info: STRING is 			do	Result := locale.translate("S&ystem Info").out	end
	m_Edit: STRING is 			do	Result := locale.translate("&Edit").out	end
	m_Edit_condition: STRING is 			do	Result := locale.translate("E&dit Condition").out	end
	m_Edit_exported_feature: STRING is 			do	Result := locale.translate("&Edit...").out	end
	m_Edit_external_commands: STRING is 			do	Result := locale.translate("&External Commands...").out	end
	m_Enable_this_bkpt: STRING is 			do	Result := locale.translate("&Enable This Breakpoint").out	end
	m_Favorites: STRING is 			do	Result := locale.translate("Fav&orites").out	end
	m_Feature_info: STRING is 			do	Result := locale.translate("Feat&ure Views").out	end
	m_File: STRING is 			do	Result := locale.translate("&File").out	end
	m_Formats: STRING is 			do	Result := locale.translate("F&ormat").out	end
	m_Formatter_separators: ARRAY [STRING] is
		once
			Result := << locale.translate("Text Generators"), locale.translate("Class Relations"),
				     locale.translate("Restrictors"), locale.translate("Main Editor Views")>>
		end
	m_History: STRING is 			do	Result := locale.translate("&Go to").out	end
	m_Maximize: STRING is 			do	Result := locale.translate("Ma&ximize").out	end
	m_Minimize: STRING is 			do	Result := locale.translate("Mi&nimize").out	end
	m_Minimize_all: STRING is 			do	Result := locale.translate("&Minimize All").out	end
	f_New_tab: STRING is 			do	Result := locale.translate("New Tab").out	end
	m_New_tab: STRING is 			do	Result := locale.translate("New Ta&b").out	end
	m_New_editor: STRING is 			do	Result := locale.translate("New Ed&itor Window").out	end
	m_New_context_tool: STRING is 			do	Result := locale.translate("New Con&text Window").out	end
	m_Object: STRING is 			do	Result := locale.translate("&Object").out	end
	m_Object_tools: STRING is 			do	Result := locale.translate("&Object Tools").out	end
	m_Open_eac_browser: STRING is 			do	Result := locale.translate("EAC Browser").out	end
	m_Pretty_print: STRING is 			do	Result := locale.translate("Expand an Object").out	end
	m_Project: STRING is 			do	Result := locale.translate("&Project").out	end
	m_Override_scan: STRING is 			do	Result := locale.translate("Recompile &Overrides").out	end
	m_Discover_melt: STRING is 			do	Result := locale.translate("Find &Added Classes && Recompile").out	end
	m_Raise: STRING is 			do	Result := locale.translate("&Raise").out	end
	m_Raise_all: STRING is 			do	Result := locale.translate("&Raise All").out	end
	m_Raise_all_unsaved: STRING is 			do	Result := locale.translate("Raise &Unsaved Windows").out	end
	m_Remove_class_cluster: STRING is 			do	Result := locale.translate("&Remove Current Item").out	end
	m_Remove_exported_feature: STRING is 			do	Result := locale.translate("&Remove").out	end
	m_Remove_condition: STRING is 			do	Result := locale.translate("Remove Condition").out	end
	m_Remove_this_bkpt: STRING is 			do	Result := locale.translate("&Remove This Breakpoint").out	end
	m_Run_to_this_point: STRING is 			do	Result := locale.translate("&Run to This Point").out	end
	m_Send_stone_to_context: STRING is 			do	Result := locale.translate("S&ynchronize Context Tool").out	end
	m_Set_conditional_breakpoint: STRING is 			do	Result := locale.translate("Set &Conditional Breakpoint").out	end
	m_Set_critical_stack_depth: STRING is 			do	Result := locale.translate("Overflow &Prevention...").out	end
	m_Set_slice_size: STRING is 			do	Result := locale.translate("&Alter size").out	end
	m_Special: STRING is 			do	Result := locale.translate("&Special").out	end
	m_Separate_stone: STRING is 			do	Result := locale.translate("Unlin&k Context Tool").out	end
	m_Tools: STRING is 			do	Result := locale.translate("&Tools").out	end
	m_Unify_stone: STRING is 			do	Result := locale.translate("Lin&k Context Tool").out	end
	m_View: STRING is 			do	Result := locale.translate("&View").out	end
	m_Window: STRING is 			do	Result := locale.translate("&Window").out	end
	m_Refactoring: STRING is 			do	Result := locale.translate("&Refactoring").out	end

feature -- Label texts

	l_Ace_file_for_frame: STRING is 			do	Result := locale.translate("Ace file").out	end
	l_action_colon: STRING is 			do	Result := locale.translate("Action:").out	end
	l_Active_query: STRING is 			do	Result := locale.translate("Active query").out	end
	l_Address: STRING is 			do	Result := locale.translate("Address:").out	end
	l_add_project_config_file: STRING is 			do	Result := locale.translate("Add Project...").out	end
	l_All: STRING is 			do	Result := locale.translate("recursive").out	end
	l_Alias_name: STRING is 			do	Result := locale.translate("Alias:").out	end
	l_Ancestors: STRING is 			do	Result := locale.translate("ancestors").out	end
	l_Arguments: STRING is 			do	Result := locale.translate("Arguments").out	end
	l_assigners: STRING is 			do	Result := locale.translate("assigners").out	end
	l_Attributes: STRING is 			do	Result := locale.translate("attributes").out	end
	l_Available_buttons_text: STRING is 			do	Result := locale.translate("Available buttons").out	end
	l_Basic_application: STRING is 			do	Result := locale.translate("Basic application (no graphics library included)").out	end
	l_Basic_text: STRING is 			do	Result := locale.translate("basic text view").out	end
	l_Callers: STRING is 			do	Result := locale.translate("callers").out	end
	l_Calling_convention: STRING is 			do	Result := locale.translate("Calling convention:").out	end
	l_Choose_folder: STRING is 			do	Result := locale.translate("Select the destination folder ").out	end
	l_Class: STRING is 			do	Result := locale.translate("Class:").out	end
	l_class_name: STRING is 			do	Result := locale.translate("Class name:").out	end
	l_clean: STRING is 			do	Result := locale.translate("Clean").out	end
	l_clean_user_file: STRING is 			do	Result := locale.translate("Reset user settings").out	end
	l_Clients: STRING is 			do	Result := locale.translate("clients").out	end
	l_Clickable: STRING is 			do	Result := locale.translate("clickable view").out	end
	l_Cluster: STRING is 			do	Result := locale.translate("Cluster:").out	end
	l_Cluster_name: STRING is 			do	Result := locale.translate("Cluster name ").out	end
	l_Cluster_options: STRING is 			do	Result := locale.translate("Cluster options ").out	end
	l_Command_error_output: STRING is		do		Result := locale.translate("Command error output:%N").out end
	l_Command_line: STRING is 			do	Result := locale.translate("Command line:").out	end
	l_Command_normal_output: STRING is 			do	Result := locale.translate("Command output:%N").out	end
	l_Compiled_class: STRING is 			do	Result := locale.translate("Only compiled classes").out	end
	l_compile: STRING is 			do	Result := locale.translate("Compile").out	end
	l_Compile_first: STRING is 			do	Result := locale.translate("Compile to have information").out	end
	l_Compile_project: STRING is 			do	Result := locale.translate("Compile project").out	end
	l_Condition: STRING is 			do	Result := locale.translate("Condition").out	end
	l_Confirm_kill: STRING is 			do	Result := locale.translate("Stop the application?").out	end
	l_Context: STRING is 			do	Result := locale.translate("Context").out	end
	l_Creation: STRING is 			do	Result := locale.translate("Creation procedure:").out	end
	l_creators: STRING is 			do	Result := locale.translate("creators").out	end
	l_Current_context: STRING is 			do	Result := locale.translate("Current feature").out	end
	l_Current_editor: STRING is 			do	Result := locale.translate("Current editor").out	end
	l_Current_object: STRING is 			do	Result := locale.translate("Current object").out	end
	l_Custom: STRING is 			do	Result := locale.translate("Custom").out	end
	l_Deferred: STRING is 			do	Result := locale.translate("deferred").out	end
	l_Deferreds: STRING is 			do	Result := locale.translate("deferred features").out	end
	l_Deleting_dialog_default: STRING is 			do	Result := locale.translate("Creating new project, please wait...").out	end
	l_Descendants: STRING is 			do	Result := locale.translate("descendants").out	end
	l_Diagram_delete_view_cmd: STRING is 			do	Result := locale.translate("Do you really want to delete current view?").out	end
	l_Diagram_reset_view_cmd: STRING is 			do	Result := locale.translate("Do you really want to reset current view?").out	end
	l_Discard_convert_project_dialog: STRING is 			do	Result := locale.translate("Do not ask again, and always convert old projects").out	end
	l_Discard_build_precompile_dialog: STRING is 			do	Result := locale.translate("Do not ask again, and always build precompile").out	end
	l_Discard_finalize_assertions: STRING is 			do	Result := locale.translate("Do not ask again, and always discard assertions when finalizing").out	end
	l_Discard_finalize_precompile_dialog: STRING is 			do	Result := locale.translate("Don't ask me again and always finalize.").out	end
	l_Discard_freeze_dialog: STRING is 			do	Result := locale.translate("Do not ask again, and always compile C code").out	end
	l_Discard_save_before_compile_dialog: STRING is 			do	Result := locale.translate("Do not ask again, and always save files before compiling").out	end
	l_Discard_starting_dialog: STRING is 			do	Result := locale.translate("Don't show this dialog at startup").out	end
	l_Discard_replace_all_warning_dialog: STRING is 			do	Result := locale.translate("Don't ask me again and always replace all").out	end
	l_Discard_terminate_freezing: STRING is 			do	Result := locale.translate("Do not ask again, and always terminate freezing when needed.").out	end
	l_Discard_terminate_external_command: STRING is 			do	Result := locale.translate("Do not ask again, and always terminate running external command.").out	end
	l_Discard_terminate_finalizing: STRING is 			do	Result := locale.translate("Do not ask again, and always terminate finalizing when needed.").out	end
	l_Display_call_stack_warning: STRING is 			do	Result := locale.translate("Display a warning when the call stack depth reaches:").out	end
	l_Displayed_buttons_text: STRING is 			do	Result := locale.translate("Displayed buttons").out	end
	l_Dont_ask_me_again: STRING is 			do	Result := locale.translate("Do not ask me again").out	end
	l_Do_not_detect_stack_overflows: STRING is 			do	Result := locale.translate("Do not detect stack overflows").out	end
	l_Do_not_show_again: STRING is 			do	Result := locale.translate("Do not show again").out	end
	l_Dropped_references: STRING is 			do	Result := locale.translate("Dropped references").out	end
	l_Dummy: STRING is 			do	Result := locale.translate("Should not be read").out	end
	l_Not_empty: STRING is 			do	Result := locale.translate("Generate default feature clauses").out	end
	l_edit_project: STRING is 			do	Result := locale.translate("Edit Project").out	end
	l_Elements: STRING is 			do	Result := locale.translate("elements.").out	end
	l_Enter_folder_name: STRING is 			do	Result := locale.translate("Enter the name of the new folder: ").out	end
	l_error: STRING is 			do	Result := locale.translate("Error").out	end
	l_Executing_command: STRING is 			do	Result := locale.translate("Command is currently executing.%NPress OK to ignore the output.").out	end
	l_Execution_interrupted: STRING is 			do	Result := locale.translate("Execution interrupted").out	end
	l_Exit_application: STRING is
		once
			Result := locale.format_string(locale.translate("Are you sure you want to quit $1?"), [Workbench_name])
		end
	l_Exit_warning: STRING is 			do	Result := locale.translate("Some files have not been saved.%NDo you want to save them before exiting?").out	end
	l_Expanded: STRING is 			do	Result := locale.translate("expanded").out	end
	l_Explicit_exception_pending: STRING is 			do	Result := locale.translate("Explicit exception pending").out	end
	l_Exported: STRING is 			do	Result := locale.translate("exported features").out	end
	l_Expression: STRING is 			do	Result := locale.translate("Expression").out	end
	l_External: STRING is 			do	Result := locale.translate("external features").out	end
	l_Feature: STRING is 			do	Result := locale.translate("Feature:").out	end
	l_Feature_properties: STRING is 			do	Result := locale.translate("Feature properties").out	end
	l_File_name: STRING is 			do	Result := locale.translate("File name:").out	end
	l_finalize: STRING is 			do	Result := locale.translate("Finalize").out	end
	l_Finalized_mode: STRING is 			do	Result := locale.translate("Finalized mode").out	end
	l_Flat: STRING is 			do	Result := locale.translate("flat view").out	end
	l_Flatshort: STRING is 			do	Result := locale.translate("interface view").out	end
	l_freeze: STRING is 			do	Result := locale.translate("Freeze").out	end
	l_fresh_compilation: STRING is 			do	Result := locale.translate("Recompile project").out	end
	l_general: STRING is 			do	Result := locale.translate("General").out	end
	l_Generate_profile_from_rtir: STRING is 			do	Result := locale.translate("Generate profile from Run-time information record").out	end
	l_Generate_creation: STRING is 			do	Result := locale.translate("Generate creation procedure").out	end
	l_Homonyms: STRING is 			do	Result := locale.translate("homonyms").out	end
	l_Homonym_confirmation: STRING is 			do	Result := locale.translate("Extracting the homonyms%Nmay take a long time.").out	end
	l_Identification: STRING is 			do	Result := locale.translate("Identification").out	end
	l_Implicit_exception_pending: STRING is 			do	Result := locale.translate("Implicit exception pending").out	end
	l_Implementers: STRING is 			do	Result := locale.translate("implementers").out	end
	l_Inactive_subqueries: STRING is 			do	Result := locale.translate("Inactive subqueries").out	end
	l_Index: STRING is 			do	Result := locale.translate("Index:").out	end
	l_invariants: STRING is 			do	Result := locale.translate("invariants").out	end
	l_Language_type: STRING is 			do	Result := locale.translate("Language type").out	end
	l_Library: STRING is 			do	Result := locale.translate("library").out	end
	l_Literal_value: STRING is 			do	Result := locale.translate("Literal Value").out	end
	l_Loaded_project: STRING is 			do	Result := locale.translate("Loaded project: ").out	end
	l_Located_in: STRING is 			do	Result := locale.translate(" located in ").out	end
	l_Location_colon: STRING is 			do	Result := locale.translate("Location: ").out	end
	l_Locals: STRING is 			do	Result := locale.translate("Locals").out	end
	l_Min_index: STRING is 			do	Result := locale.translate("Minimum index displayed").out	end
	l_Match_case: STRING is 			do	Result := locale.translate("Match case").out	end
	l_Max_index: STRING is 			do	Result := locale.translate("Maximum index displayed").out	end
	l_Max_displayed_string_size: STRING is 			do	Result := locale.translate("Maximum displayed string size").out	end
	l_More_items: STRING is 			do	Result := locale.translate("Display limit reached").out	end
	l_Name: STRING is 			do	Result := locale.translate("Name").out	end
	l_Name_colon: STRING is 			do	Result := locale.translate("Name:").out	end
	l_New_breakpoint: STRING is 			do	Result := locale.translate("New breakpoint(s) to commit").out	end
	l_No_feature: STRING is 			do	Result := locale.translate("Select a fully compiled feature to have information about it.").out	end
	l_No_feature_group_clause: STRING is 			do	Result := locale.translate("[Unnamed feature clause]").out	end
	l_No_text_text: STRING is 			do	Result := locale.translate("No text labels").out	end
	l_Not_in_system_no_info: STRING is 			do	Result := locale.translate("Select a class which is fully compiled to have information about it.").out	end
	l_Not_yet_called: STRING is 			do	Result := locale.translate("Not yet called").out	end
	l_Object_attributes: STRING is 			do	Result := locale.translate("Attributes").out	end
	l_On_object: STRING is 			do	Result := locale.translate("On object").out	end
	l_As_object: STRING is 			do	Result := locale.translate("As object").out	end
	l_Of_class: STRING is 			do	Result := locale.translate(" of class ").out	end
	l_Of_feature: STRING is 			do	Result := locale.translate(" of feature ").out	end
	l_Onces: STRING is 			do	Result := locale.translate("once routines and constants").out	end
	l_Once_functions: STRING is 			do	Result := locale.translate("Once routines").out	end
	l_open: STRING is 			do	Result := locale.translate("Open").out	end
	l_Open_a_project: STRING is 			do	Result := locale.translate("Open a project").out	end
	l_Open_project: STRING is 			do	Result := locale.translate("Open project").out	end
	l_Options: STRING is 			do	Result := locale.translate("Options").out	end
	l_Output_switches: STRING is 			do	Result := locale.translate("Output switches").out	end
	l_Parent_cluster: STRING is 			do	Result := locale.translate("Parent cluster").out	end
	l_parents: STRING is 			do	Result := locale.translate("Parents:").out	end
	l_Path: STRING is 			do	Result := locale.translate("Path").out	end
	l_Possible_overflow: STRING is 			do	Result := locale.translate("Possible stack overflow").out	end
	l_precompile: STRING is 			do	Result := locale.translate("Precompile").out	end
	l_Profiler_used: STRING is 			do	Result := locale.translate("Profiler used to produce the above record: ").out	end
	l_Project_location: STRING is 			do	Result := locale.translate("The project location is the place where compilation%Nfiles will be generated by the compiler").out	end
	l_Put_text_right_text: STRING is 			do	Result := locale.translate("Show selective text on the right of buttons").out	end
	l_Show_all_text: STRING is 			do	Result := locale.translate("Show text labels").out	end
	l_Query: STRING is 			do	Result := locale.translate("Query").out	end
	l_remove_project: STRING is 			do	Result := locale.translate("Remove Project").out	end
	l_Remove_object: STRING is 			do	Result := locale.translate("Remove").out	end
	l_Remove_object_desc:STRING is 			do	Result := locale.translate("Remove an object from the tree").out	end
	l_Replace_with: STRING is 			do	Result := locale.translate("Replace with:").out	end
	l_Replace_with_ellipsis: STRING is 			do	Result := locale.translate("Replace with...").out	end
	l_Replace_all: STRING is 			do	Result := locale.translate("Replace all").out	end
	l_Result: STRING is 			do	Result := locale.translate("Result").out	end
	l_Root_class: STRING is 			do	Result := locale.translate("Root class name: ").out	end
	l_Root_class_name: STRING is 			do	Result := locale.translate("Root class: ").out	end
	l_Root_cluster_name: STRING is 			do	Result := locale.translate("Root cluster: ").out	end
	l_Root_feature_name: STRING is 			do	Result := locale.translate("Root feature: ").out	end
	l_Routine_ancestors: STRING is 			do	Result := locale.translate("ancestor versions").out	end
	l_Routine_descendants: STRING is 			do	Result := locale.translate("descendant versions").out	end
	l_Routine_flat: STRING is 			do	Result := locale.translate("flat view").out	end
	l_Routines: STRING is 			do	Result := locale.translate("routines").out	end
	l_Runtime_information_record: STRING is 			do	Result := locale.translate("Run-time information record").out	end
	l_Same_class_name: STRING is 			do	Result := locale.translate("---").out	end
	l_Scope: STRING is 			do	Result := locale.translate("Scope").out	end
	l_Search_backward: STRING is 			do	Result := locale.translate("Search backwards").out	end
	l_Search_for: STRING is 			do	Result := locale.translate("Search for:").out	end
	l_Search_options_show: STRING is 			do	Result := locale.translate("Scope >>").out	end
	l_Search_options_hide: STRING is 			do	Result := locale.translate("Scope <<").out	end
	l_Search_report_show: STRING is 			do	Result := locale.translate("Report >>").out	end
	l_Search_report_hide: STRING is 			do	Result := locale.translate("Report <<").out	end
	l_Set_as_default: STRING is 			do	Result := locale.translate("Set as default").out	end
	l_Set_slice_limits: STRING is 			do	Result := locale.translate("Slice limits").out	end
	l_Set_slice_limits_desc: STRING is 			do	Result := locale.translate("Set which values are shown in special objects").out	end
	l_Short: STRING is 			do	Result := locale.translate("contract view").out	end
	l_Short_name: STRING is 			do	Result := locale.translate("Short Name").out	end
	l_Show_all_call_stack: STRING is 			do	Result := locale.translate("Show all stack elements").out	end
	l_Show_only_n_elements: STRING is 			do	Result := locale.translate("Show only:").out	end
	l_Showallcallers: STRING is 			do	Result := locale.translate("Show all callers").out	end
	l_Showcallers: STRING is 			do	Result := locale.translate("Show static callers").out	end
	l_Showstops: STRING is 			do	Result := locale.translate("Show stop points").out	end
	l_Slice_taken_into_account1: STRING is 			do	Result := locale.translate("Warning: Modifications will be taken into account").out	end
	l_Slice_taken_into_account2: STRING is 			do	Result := locale.translate("for the next objects you will add in the object tree.").out	end
	l_Specify_arguments: STRING is 			do	Result := locale.translate("Specify arguments").out	end
	l_Stack_information: STRING is 			do	Result := locale.translate("Stack information").out	end
	l_Stepped: STRING is 			do	Result := locale.translate("Step completed").out	end
	l_Stop_point_reached: STRING is 			do	Result := locale.translate("Breakpoint reached").out	end
	l_Sub_cluster: STRING is 			do	Result := locale.translate("Subcluster").out	end
	l_Sub_clusters: STRING is 			do	Result := locale.translate("Recursive").out	end
	l_Subquery: STRING is 			do	Result := locale.translate("Define new subquery").out	end
	l_Suppliers: STRING is 			do	Result := locale.translate("suppliers").out	end
	l_Switch_num_format: STRING is 			do	Result := locale.translate("Switch numerical formating").out	end
	l_Switch_num_format_desc: STRING is 			do	Result := locale.translate("Display numerical value as Hexadecimal or Decimal formating").out	end
	l_Syntax_error: STRING is 			do	Result := locale.translate("Class text has syntax error").out	end
	l_System_name: STRING is 			do	Result := locale.translate("System name: ").out	end
	l_System_properties: STRING is 			do	Result := locale.translate("System properties").out	end
	l_System_running: STRING is 			do	Result := locale.translate("System running").out	end
	l_System_launched: STRING is 			do	Result := locale.translate("System launched").out	end
	l_System_not_running: STRING is 			do	Result := locale.translate("System not running").out	end
	l_Tab_output: STRING is 			do	Result := locale.translate("Output").out	end
	l_Tab_class_info: STRING is 			do	Result := locale.translate("Class").out	end
	l_Tab_feature_info: STRING is 			do	Result := locale.translate("Feature").out	end
	l_Tab_diagram: STRING is 			do	Result := locale.translate("Diagram").out	end
	l_target: STRING is 			do	Result := locale.translate("Target").out	end
	l_Text_loaded: STRING is 			do	Result := locale.translate("Text finished loading").out	end
	l_Text_saved: STRING is 			do	Result := locale.translate("Text was saved").out	end
	l_Three_dots: STRING is 			do	Result := locale.translate("...").out	end
	l_Text_loading: STRING is 			do	Result := locale.translate("Current text is being loaded. It is therefore%Nnot editable nor pickable.").out	end
	l_Toolbar_select_text_position: STRING is 			do	Result := locale.translate("Text option: ").out	end
	l_Toolbar_select_has_gray_icons: STRING is 			do	Result := locale.translate("Icon option: ").out	end
	l_Top_level: STRING is 			do	Result := locale.translate("Top-level").out	end
	l_Type: STRING is 			do	Result := locale.translate("Type").out	end
	l_Unknown_status: STRING is 			do	Result := locale.translate("Unknown application status").out	end
	l_Unknown_class_name: STRING is 			do	Result := locale.translate("Unknown class name").out	end
	l_Use_existing_ace: STRING is 			do	Result := locale.translate("Open existing Ace (control file)").out	end
	l_Use_existing_profile: STRING is 			do	Result := locale.translate("Use existing profile: ").out	end
	l_Use_regular_expression: STRING is 			do	Result := locale.translate("Use regular expression").out	end
	l_Use_wildcards: STRING is 			do	Result := locale.translate("Use wildcards").out	end
	l_Use_wizard: STRING is 			do	Result := locale.translate("Create project").out	end
	l_Value: STRING is 			do	Result := locale.translate("Value").out	end
	l_Whole_project: STRING is 			do	Result := locale.translate("Whole project").out	end
	l_Whole_word: STRING is 			do	Result := locale.translate("Whole word").out	end
	l_Windows_only: STRING is 			do	Result := locale.translate("(Windows only)").out	end
	l_Workbench_mode: STRING is 			do	Result := locale.translate("Workbench mode").out	end
	l_Working_formatter: STRING is 			do	Result := locale.translate("Extracting ").out	end
	l_Tab_external_output: STRING is 			do	Result := locale.translate("External Output").out	end
	l_Tab_C_output: STRING is 			do	Result := locale.translate("C Output").out	end
	l_Tab_warning_output: STRING is 			do	Result := locale.translate("Warnings").out	end
	l_Tab_error_output: STRING is 			do	Result := locale.translate("Errors").out	end
	l_show_feature_from_any: STRING is 			do	Result := locale.translate("Features from ANY").out	end
	l_show_tooltip: STRING is 			do	Result := locale.translate("Tooltip").out	end
	h_show_feature_from_any: STRING is 			do	Result := locale.translate("Show unchanged features from class ANY?").out	end
	h_show_tooltip: STRING is 			do	Result := locale.translate("Show tooltips?").out	end
	l_class_browser_classes: STRING is 			do	Result := locale.translate("Class").out	end
	l_class_browser_features: STRING is 			do	Result := locale.translate("Feature").out	end
	l_version_from: STRING is 			do	Result := locale.translate("Declared in class").out	end
	l_version_in: STRING is 			do	Result := locale.translate("Version from class").out	end
	l_branch: STRING is 			do	Result := locale.translate("Branch #").out	end
	l_version_from_message: STRING is 			do	Result := locale.translate(" (version from)").out	end
	l_expand_layer: STRING is 			do	Result := locale.translate("Expand selected level(s)").out	end
	l_collapse_layer: STRING is 			do	Result := locale.translate("Collapse selected level(s)").out	end
	l_collapse_all_layers: STRING is 			do	Result := locale.translate("Collapse all selected level(s)").out	end
	l_searching_selected_file: STRING is 			do	Result := locale.translate("Searching selected file...").out	end
	l_selected_file_not_found: STRING is 			do	Result := locale.translate("Selected text is not a valid file name or the file cannot be found").out	end
	l_manage_external_commands: STRING is 			do	Result := locale.translate("Add, remove or edit external commands").out	end
	l_callees: STRING is 			do	Result := locale.translate("callees").out	end
	l_assignees: STRING is 			do	Result := locale.translate("assignees").out	end
	l_created: STRING is 			do	Result := locale.translate("creations").out	end
	l_filter: STRING is 			do	Result := locale.translate("Filter: ").out	end
	l_viewpoints: STRING is 			do	Result := locale.translate("Viewpoints: ").out	end
	l_Tab_metrics: STRING is 			do	Result := locale.translate("Metric").out	end

feature -- Stone names

	s_Class_stone: STRING is 			do	Result := locale.translate("Class ").out	end
	s_Cluster_stone: STRING is 			do	Result := locale.translate("Cluster ").out	end
	s_Feature_stone: STRING is 			do	Result := locale.translate("Feature ").out	end

feature -- Title part

	t_About: STRING is
		once
			Result := locale.format_string(locale.translate("About $1"), [ Workbench_name])
		end
	t_Add_search_scope: STRING is 			do	Result := locale.translate("Add Search Scope").out	end
	t_Alias: STRING is 			do	Result := locale.translate("Alias").out	end
	t_Breakpoints_tool: STRING is 			do	Result := locale.translate("Breakpoints").out	end
	t_Call_stack_tool: STRING is 			do	Result := locale.translate("Call Stack").out	end
	t_Calling_convention: STRING is 			do	Result := locale.translate("Calling Convention").out	end
	t_Choose_ace_file: STRING is 			do	Result := locale.translate("Choose an Ace File").out	end
	t_Choose_ace_and_directory: STRING is 			do	Result := locale.translate("Choose Your Ace File and Directory").out	end
	t_Choose_class: STRING is 			do	Result := locale.translate("Choose a Class").out	end
	t_Choose_directory: STRING is 			do	Result := locale.translate("Choose Your Directory").out	end
	t_Choose_folder_name: STRING is 			do	Result := locale.translate("Choose a Folder Name").out	end
	t_Choose_project_and_directory: STRING is 			do	Result := locale.translate("Choose Your Project Name and Directory").out	end
	t_Class: STRING is 			do	Result := locale.translate("Class").out	end
	t_Clients_of: STRING is 			do	Result := locale.translate("Clients of Class ").out	end
	t_Cluster_tool: STRING is 			do	Result := locale.translate("Clusters").out	end
	t_Context_tool: STRING is 			do	Result := locale.translate("Context").out	end
	t_Creation_routine: STRING is 			do	Result := locale.translate("Creation Procedure").out	end
	t_Customize_toolbar_text: STRING is 			do	Result := locale.translate("Customize Toolbar").out	end
	t_Debugging_tool: STRING is 			do	Result := locale.translate("Debugging").out	end
	t_Default_print_job_name: STRING is
		once
			Result := locale.format_string(locale.translate("From $1"), [Workbench_name])
		end
	t_Deleting_files: STRING is 			do	Result := locale.translate("Deleting Files").out	end
	t_Dummy: STRING is 			do	Result := locale.translate("Dummy").out	end
	t_Dynamic_lib_window: STRING is 			do	Result := locale.translate("Dynamic Library Builder").out	end
	t_Dynamic_type: STRING is 			do	Result := locale.translate("In Class").out	end
	t_Editor: STRING is 			do	Result := locale.translate("Editor").out	end
	t_Enter_condition: STRING is 			do	Result := locale.translate("Enter Condition").out	end
	t_Exported_feature: STRING is 			do	Result := locale.translate("Feature").out	end
	t_Expression_evaluation: STRING is 			do	Result := locale.translate("Evaluation").out	end
	t_Extended_explanation: STRING is 			do	Result := locale.translate("Compilation Error Wizard").out	end
	t_external_command: STRING is 			do	Result := locale.translate("External Command").out	end
	t_external_commands: STRING is 			do	Result := locale.translate("External Commands").out	end
	t_External_edition: STRING is 			do	Result := locale.translate("External Edition").out	end
	t_Favorites_tool: STRING is 			do	Result := locale.translate("Favorites").out	end
	t_metric_tool: STRING is 			do	Result := locale.translate("Metrics").out	end
	t_Feature: STRING is 			do	Result := locale.translate("In Feature").out	end
	t_Feature_properties: STRING is 			do	Result := locale.translate("Feature Properties").out	end
	t_File_selection: STRING is 			do	Result := locale.translate("File Selection").out	end
	t_Find: STRING is 			do	Result := locale.translate("Find").out	end
	t_Index: STRING is 			do	Result := locale.translate("Index").out	end
	t_New_class: STRING is 			do	Result := locale.translate("New Class").out	end
	t_New_cluster: STRING is 			do	Result := locale.translate("Add Cluster").out	end
	t_New_expression: STRING is 			do	Result := locale.translate("New Expression").out	end
	t_New_project: STRING is 			do	Result := locale.translate("New Project").out	end
	t_Object_tool: STRING is 			do	Result := locale.translate("Objects").out	end
	t_Open_backup: STRING is 			do	Result := locale.translate("Backup Found").out	end
	t_Organize_favorites: STRING is 			do	Result := locale.translate("Organize Favorites").out	end
	t_Properties_tool: STRING is 			do	Result := locale.translate("Properties").out	end
	t_Profile_query_window: STRING is 			do	Result := locale.translate("Profile Query Window").out	end
	t_Profiler_wizard: STRING is 			do	Result := locale.translate("Profiler Wizard").out	end
	t_Project: STRING is
		once
			Result := Workbench_name
		end
	t_Preference_window: STRING is 			do	Result := locale.translate("Preferences").out	end
	t_Select_class: STRING is 			do	Result := locale.translate("Select Class").out	end
	t_Select_cluster: STRING is 			do	Result := locale.translate("Select Cluster").out	end
	t_Select_feature: STRING is 			do	Result := locale.translate("Select Feature").out	end
	t_Search_tool: STRING is 			do	Result := locale.translate("Search").out	end
	t_Select_a_file: STRING is 			do	Result := locale.translate("Select a File").out	end
	t_Select_a_directory: STRING is 			do	Result := locale.translate("Select a Directory").out	end
	t_Set_stack_depth: STRING is 			do	Result := locale.translate("Maximum Call Stack Depth").out	end
	t_Set_critical_stack_depth: STRING is 			do	Result := locale.translate("Overflow Prevention").out	end
	t_Static_type: STRING is 			do	Result := locale.translate("From Class").out	end
	t_Starting_dialog: STRING is
		once
			Result := Workbench_name
		end
	t_Slice_limits: STRING is 			do	Result := locale.translate("Choose New Slice Limits for Special Objects").out	end
	t_System: STRING is 			do	Result := locale.translate("Project Settings").out	end
	t_Windows_tool: STRING is 			do	Result := locale.translate("Windows").out	end
	t_Watch_tool: STRING is 			do	Result := locale.translate("Watch").out	end
	t_Features_tool: STRING is 			do	Result := locale.translate("Features").out	end
	t_Empty_development_window: STRING is 			do	Result := locale.translate("Empty Development Tool").out	end
	t_Autocomplete_window: STRING is 			do	Result := locale.translate("Auto-Complete").out	end
	t_Diagram_class_header: STRING is 			do	Result := locale.translate("Class Header").out	end
	t_Diagram_set_center_class: STRING is 			do	Result := locale.translate("Set Center Class").out	end
	t_Diagram_context_depth: STRING is 			do	Result := locale.translate("Select Depths").out	end
	t_Diagram_link_tool: STRING is 			do	Result := locale.translate("Link Tool").out	end
	t_Diagram_delete_client_link: STRING is 			do	Result := locale.translate("Choose Feature(s) to Delete").out	end
	t_Diagram_history_tool: STRING is 			do	Result := locale.translate("History Tool").out	end

	t_Diagram_move_class_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Move Class '$1'"), [a_name])
		end

	t_Diagram_move_cluster_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Move Cluster '$1'"),[a_name])
		end

	t_Diagram_move_midpoint_cmd: STRING is 			do	Result := locale.translate("Move Midpoint").out	end

	t_Diagram_add_cs_link_cmd (client_name, supplier_name: STRING): STRING is
		require
			exists: client_name /= Void	and supplier_name /= Void
		do
			Result := locale.format_string(locale.translate("Add Client-Supplier Relation Between '$1' and '$2'"), [client_name, supplier_name])
		end

	t_Diagram_add_inh_link_cmd (ancestor_name, descendant_name: STRING): STRING is
		require
			exists: ancestor_name /= Void and descendant_name /= Void
		do
			Result := locale.format_string(locale.translate("Add Inheritance Relation Between '$1' and '$2'"), [ancestor_name, descendant_name])
		end

	t_Diagram_include_class_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Include Class '$1'"), [a_name])
		end

	t_Diagram_include_cluster_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Include Cluster '$1'"), [a_name])
		end

	t_Diagram_include_library_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Include Library '$1'"),[a_name])
		end

	t_Diagram_insert_midpoint_cmd: STRING is 			do	Result := locale.translate("Insert Midpoint").out	end
	t_Diagram_change_color_cmd: STRING is 			do	Result := locale.translate("Change Class Color").out	end

	t_Diagram_rename_class_locally_cmd (old_name, new_name: STRING): STRING is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := locale.format_string(locale.translate("Rename Class '$1' Locally to '$2'"), [old_name,new_name])
		end

	t_Diagram_rename_class_globally_cmd (old_name, new_name: STRING): STRING is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := locale.format_string(locale.translate("Rename Class '$1' Globally to '$2'"), [old_name, new_name])
		end

	t_Diagram_delete_client_link_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Delete Client Link '$1'") , [a_name])
		end

	t_Diagram_delete_inheritance_link_cmd (an_ancestor, a_descendant: STRING): STRING is
		require
			exists: an_ancestor /= Void and a_descendant /= Void
		do
			Result := locale.format_string(locale.translate("Delete Inheritance Link Between '$1' and '$2'"), [an_ancestor,a_descendant])
		end

	t_Diagram_erase_cluster_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Erase Cluster '$1'"), [a_name])
		end

	t_Diagram_delete_midpoint_cmd: STRING is 			do	Result := locale.translate("Erase Midpoint").out	end

	t_Diagram_erase_class_cmd (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Erase Class '$1'"), [a_name])
		end

	t_Diagram_erase_classes_cmd: STRING is 			do	Result := locale.translate("Erase Classes").out	end
	t_Diagram_put_right_angles_cmd: STRING is 			do	Result := locale.translate("Put Right Angles").out	end
	t_Diagram_remove_right_angles_cmd: STRING is 			do	Result := locale.translate("Remove Right Angles").out	end
	t_Diagram_put_one_handle_left_cmd: STRING is 			do	Result := locale.translate("Put Handle Left").out	end
	t_Diagram_put_one_handle_right_cmd: STRING is 			do	Result := locale.translate("Put Handle Right").out	end
	t_Diagram_put_two_handles_left_cmd: STRING is 			do	Result := locale.translate("Put Two Handles Left").out	end
	t_Diagram_put_two_handles_right_cmd: STRING is 			do	Result := locale.translate("Put Two Handles Right").out	end
	t_Diagram_remove_handles_cmd: STRING is 			do	Result := locale.translate("Remove Handles").out	end
	t_Diagram_zoom_in_cmd: STRING is 			do	Result := locale.translate("Zoom In").out	end
	t_Diagram_zoom_out_cmd: STRING is 			do	Result := locale.translate("Zoom Out").out	end
	t_Diagram_zoom_cmd: STRING is 			do	Result := locale.translate("Zoom").out	end

	t_Diagram_cluster_expand (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Expand cluster '$1'"), [ a_name])
		end

	t_Diagram_cluster_collapse (a_name: STRING): STRING is
		require
			exists: a_name /= Void
		do
			Result := locale.format_string(locale.translate("Collapse Cluster '$1'"), [a_name])
		end

	t_Diagram_disable_high_quality: STRING is 			do	Result := locale.translate("Disable High Quality").out	end
	t_Diagram_enable_high_quality: STRING is 			do	Result := locale.translate("Enable High Quality").out	end

	t_first_match_reached: STRING is 			do	Result := locale.translate("Initial match reached.").out	end
	t_bottom_reached: STRING is 			do	Result := locale.translate("Bottom reached.").out	end
	t_refactoring_feature_rename: STRING is 			do	Result := locale.translate("Refactoring: Feature Rename (Compiled Classes)").out	end
	t_refactoring_class_select: STRING is 			do	Result := locale.translate("Select Class").out	end
	t_refactoring_class_rename: STRING is 			do	Result := locale.translate("Refactoring: Class Rename").out	end

feature -- Description texts

	e_Add_exported_feature: STRING is 			do	Result := locale.translate("Add a new feature to this dynamic library definition").out	end
	e_Bkpt_info: STRING is 			do	Result := locale.translate("Show/Hide information about breakpoints").out	end
	e_Check_exports: STRING is 			do	Result := locale.translate("Check the validity of the library definition").out	end
	e_Compilation_failed: STRING is 			do	Result := locale.translate("Eiffel Compilation Failed").out	end
	e_Compilation_succeeded: STRING is 			do	Result := locale.translate("Eiffel Compilation Succeeded").out	end
	e_freezing_failed: STRING is 			do	Result := locale.translate("Background Workbench C Compilation Failed").out	end
	e_finalizing_failed: STRING is 			do	Result := locale.translate("Background Finalized C compilation Failed").out	end
	e_freezing_launch_failed: STRING is 			do	Result := locale.translate("Background Workbench C Compilation Launch Failed").out	end
	e_finalizing_launch_failed: STRING is 			do	Result := locale.translate("Background Finalized C Compilation Launch Failed").out	end
	e_freezing_launched: STRING is 			do	Result := locale.translate("Background Workbench C Compilation Launched").out	end
	e_finalizing_launched: STRING is 			do	Result := locale.translate("Background Finalized C Compilation Launched").out	end
	e_freezing_succeeded: STRING is 			do	Result := locale.translate("Background Workbench C Compilation Succeeded").out	end
	e_finalizing_succeeded: STRING is 			do	Result := locale.translate("Background Finalized C Compilation Succeeded").out	end
	e_freezing_terminated: STRING is 			do	Result := locale.translate("Background Workbench C Compilation Terminated").out	end
	e_finalizing_terminated: STRING is 			do	Result := locale.translate("Background Finalized C Compilation Terminated").out	end
	e_C_compilation_failed: STRING is 			do	Result := locale.translate("Background C Compilation Failed").out	end
	e_C_compilation_launch_failed: STRING is 			do	Result := locale.translate("Background C Compilation Launch Failed").out	end
	e_C_compilation_terminated: STRING is 			do	Result := locale.translate("Background C Compilation Terminated").out	end
	e_C_compilication_launched: STRING is 			do	Result := locale.translate("Background C Compilation Launched").out	end
	e_C_compilation_succeeded: STRING is 			do	Result := locale.translate("Background C Compilation Succeeded").out	end
	e_C_compilation_running: STRING is 			do	Result := locale.translate("Background C Compilation in Progress").out	end
	e_Compiling: STRING is 			do	Result := locale.translate("System is being compiled").out	end
	e_Copy_call_stack_to_clipboard: STRING is 			do	Result := locale.translate("Copy call stack to clipboard").out	end
	e_Cursor_position: STRING is 			do	Result := locale.translate("Cursor position (line:column)").out	end
	e_Diagram_hole: STRING is	
		do 
			Result := locale.translate ("Please drop a class or a cluster on this button %N%
							%to view its diagram.%N%
							%Use right click for both pick and drop actions.") 
		end
	e_Diagram_class_header: STRING is 
		do 
			Result := locale.translate("Please drop a class on this button.%NUse right click for both%N%
						%pick and drop actions.")
		end
	e_Diagram_remove_anchor: STRING is 
		do
			Result := locale.translate("Please drop a class or a cluster with an%Nanchor on this button.%NUse right click for both%N%
						 %pick and drop actions.")
		end
	e_Diagram_create_class: STRING is 
		do 
			Result := locale.translate("Please drop this button on the diagram.%N%
						%Use right click for both%Npick and drop actions.")
		end
	e_Diagram_delete_figure: STRING is 
		do 
			Result := locale.translate("Please drop a class, a cluster or a midpoint%N%
						%on this button. Use right click for both%Npick and drop actions.")

		end
	e_Diagram_add_class_figure_relations: STRING is
		do 
			Result := locale.translate("A class figure(s) must either be selected%N%
						%or dropped on this button via right clicking.")
		end
	e_Diagram_delete_item: STRING is
		do 
			Result := locale.translate("Please drop a class, a cluster or a link%N%
						%on this button. Use right click for both%Npick and drop actions.")
		end
	e_Display_error_help: STRING is 			do	Result := locale.translate("Give help on compilation errors").out	end
	e_Display_system_info: STRING is 			do	Result := locale.translate("Display information concerning current system").out	end
	e_Drop_an_error_stone: STRING is 
		do
			Result := locale.translate("Pick the code of a compilation error (such as VEEN, VTCT,...)%N%
						%and drop it here to have extended information about it.")
		end
	e_Edit_exported_feature: STRING is 			do	Result := locale.translate("Edit the properties of the selected feature").out	end
	e_Edit_expression: STRING is 			do	Result := locale.translate("Edit an expression").out	end
	e_Edited: STRING is 			do	Result := locale.translate("Some classes were edited since last compilation").out	end
	e_Exec_debug: STRING is 			do	Result := locale.translate("Start application and stop at breakpoints").out	end
	e_Exec_kill: STRING is 			do	Result := locale.translate("Stop application").out	end
	e_Exec_into: STRING is 			do	Result := locale.translate("Step into a routine").out	end
	e_Exec_no_stop: STRING is 			do	Result := locale.translate("Start application without stopping at breakpoints").out	end
	e_Exec_out: STRING is 			do	Result := locale.translate("Step out of a routine").out	end
	e_Exec_step: STRING is 			do	Result := locale.translate("Execute the application one line at a time").out	end
	e_Exec_stop: STRING is 			do	Result := locale.translate("Pause application at current point").out	end
	e_History_back: STRING is 			do	Result := locale.translate("Back").out	end
	e_History_forth: STRING is 			do	Result := locale.translate("Forward").out	end
	e_Minimize_all: STRING is 			do	Result := locale.translate("Minimize all windows").out	end
	e_New_context_tool: STRING is 			do	Result := locale.translate("Open a new context window").out	end
	e_New_dynamic_lib_definition: STRING is 			do	Result := locale.translate("Create a new dynamic library definition").out	end
	e_New_editor: STRING is 			do	Result := locale.translate("Open a new editor window").out	end
	e_New_expression: STRING is 			do	Result := locale.translate("Create a new expression").out	end
	e_Not_running: STRING is 			do	Result := locale.translate("Application is not running").out	end
	e_Open_dynamic_lib_definition: STRING is 			do	Result := locale.translate("Open a dynamic library definition").out	end
	e_Open_file: STRING is 			do	Result := locale.translate("Open a file").out	end
	e_Open_eac_browser: STRING is 			do	Result := locale.translate("Open the Eiffel Assembly Cache browser tool").out	end
	e_Paste: STRING is 			do	Result := locale.translate("Paste").out	end
	e_Paused: STRING is 			do	Result := locale.translate("Application is paused").out	end
	e_Pretty_print: STRING is 			do	Result := locale.translate("Display an expanded view of objects").out	end
	e_Print: STRING is 			do	Result := locale.translate("Print the currently edited text").out	end
	e_Project_name: STRING is 			do	Result := locale.translate("Name of the current project").out	end
	e_Project_settings: STRING is 			do	Result := locale.translate("Change project settings, right click to open external editor").out	end
	e_override_scan: STRING is 			do	Result := locale.translate("Recompile override clusters").out	end
	e_discover_melt: STRING is 			do	Result := locale.translate("Discover unreferenced externally added classes and recompile.").out	end
	e_Raise_all: STRING is 			do	Result := locale.translate("Raise all windows").out	end
	e_Raise_all_unsaved: STRING is 			do	Result := locale.translate("Raise all unsaved windows").out	end
	e_Redo: STRING is 			do	Result := locale.translate("Redo").out	end
	e_Remove_class_cluster: STRING is 			do	Result := locale.translate("Remove a class or a cluster from the system").out	end
	e_Remove_exported_feature: STRING is 			do	Result := locale.translate("Remove the selected feature from this dynamic library definition").out	end
	e_Remove_expressions: STRING is 			do	Result := locale.translate("Remove selected expressions").out	end
	e_Remove_object: STRING is 			do	Result := locale.translate("Remove currently selected object").out	end
	e_Running: STRING is 			do	Result := locale.translate("Application is running").out	end
	e_Running_no_stop_points: STRING is 			do	Result := locale.translate("Application is running (ignoring breakpoints)").out	end
	e_Save_call_stack: STRING is 			do	Result := locale.translate("Save call stack to a text file").out	end
	e_Save_dynamic_lib_definition: STRING is 			do	Result := locale.translate("Save this dynamic library definition").out	end
	e_Show_class_cluster: STRING is 			do	Result := locale.translate("Locate currently edited class or cluster").out	end
	e_Send_stone_to_context: STRING is 			do	Result := locale.translate("Synchronize context").out	end
	e_Separate_stone: STRING is 			do	Result := locale.translate("Unlink the context tool from the other components").out	end
	e_Set_stack_depth: STRING is 			do	Result := locale.translate("Set maximum call stack depth").out	end
	e_Shell: STRING is 			do	Result := locale.translate("Send to external editor").out	end
	e_Switch_num_format_to_hex: STRING is 			do	Result := locale.translate("Switch to hexadecimal format").out	end
	e_Switch_num_format_to_dec: STRING is 			do	Result := locale.translate("Switch to decimal format").out	end
	e_Switch_num_formating: STRING is 			do	Result := locale.translate("Hexadecimal/Decimal formating").out	end
	e_Toggle_state_of_expressions: STRING is 			do	Result := locale.translate("Enable/Disable expressions").out	end
	e_Toggle_stone_management: STRING is 			do	Result := locale.translate("Link or not the context tool to other components").out	end
	e_Undo: STRING is 			do	Result := locale.translate("Undo").out	end
	e_Up_to_date: STRING is 			do	Result := locale.translate("Executable is up-to-date").out	end
	e_Unify_stone: STRING is 			do	Result := locale.translate("Link the context tool to the other components").out	end
	e_Terminate_c_compilation: STRING is 			do	Result := locale.translate("Terminate current C compilation in progress").out	end

	e_Dbg_exception_handler: STRING is 			do	Result := locale.translate("Exception handling").out	end
	e_Dbg_assertion_checking: STRING is 			do	Result := locale.translate("Disable or restore Assertion checking handling during debugging").out	end

	e_open_selection_in_editor: STRING is 			do	Result := locale.translate("Open selected file name in specified external editor").out	end
	e_save_c_compilation_output: STRING is 			do	Result := locale.translate("Save C Compilation output to file").out	end
	e_go_to_w_code_dir: STRING is 			do	Result := locale.translate("Go to W_code directory of this system, or right click to open W_code in specified file browser").out	end
	e_go_to_f_code_dir: STRING is 			do	Result := locale.translate("Go to F_code directory of this system, or right click to open F_code in specified file browser").out	end
	e_f_code: STRING is 			do	Result := locale.translate("F_code").out	end
	e_w_code: STRING is 			do	Result := locale.translate("W_code").out	end
	e_no_text_is_selected: STRING is 			do	Result := locale.translate("No file name is selected.").out	end
	e_selected_text_is_not_file: STRING is 			do	Result := locale.translate("Selected text is not a correct file name.").out	end
	e_external_editor_not_defined: STRING is 			do	Result := locale.translate("External editor not defined").out	end
	e_external_command_is_running: STRING is 			do	Result := locale.translate("An external command is running now. %NPlease wait until it exits.").out	end
	e_external_command_list_full: STRING is 			do	Result := locale.translate("Your external command list is full.%NUse Tools->External Command... to delete one.").out	end
	e_working_directory_invalid: STRING is 			do	Result := locale.translate("Cannot change to directory ").out	end
	e_external_command_not_launched: STRING is 			do	Result := locale.translate("External command not launched.").out	end
	e_refactoring_undo_sure: STRING is 			do	Result := locale.translate("Are you sure you want to undo the refactoring?%N If classes have been modified since the refactoring this can lead to corrupt classes and lost information!").out	end
	e_refactoring_redo_sure: STRING is 			do	Result := locale.translate("Are you sure you want to redo the refactoring?%N If classes have been modified since the undo of the refactoring this can lead to corrupt classes and lost information!").out	end
feature -- Wizard texts

	wt_Profiler_welcome: STRING is 			do	Result := locale.translate("Welcome to the Profiler Wizard").out	end
	wb_Profiler_welcome: STRING is 
			do
				Result := locale.translate( "Using this wizard you can analyze the result of a profiling.%N%
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
								%To continue, click Next.") 
			end

	wt_Compilation_mode: STRING is 			do	Result := locale.translate("Compilation mode").out	end
	ws_Compilation_mode: STRING is 			do	Result := locale.translate("Select the Compilation mode.").out	end

	wt_Execution_Profile: STRING is 			do	Result := locale.translate("Execution Profile").out	end
	ws_Execution_Profile: STRING is 			do	Result := locale.translate("Reuse or Generate an Execution Profile.").out	end
	wb_Execution_Profile: STRING is
		do
			Result := locale.translate("You can generate the Execution Profile from a Run-time Information Record%N%
						%created by a profiler, or you can reuse an existing Execution Profile if you%N%
						%have already generated one for this system.")
		end

	wt_Execution_Profile_Generation: STRING is 			do	Result := locale.translate("Execution Profile Generation").out	end
	ws_Execution_Profile_Generation: STRING is 			do	Result := locale.translate("Select a Run-time information record to generate the Execution profile").out	end
	wb_Execution_Profile_Generation: STRING is
		do
			Result := locale.translate("Once an execution of an instrumented system has generated the proper file,%N%
					%you must process it through a profile converter to produce the Execution%N%
					%Profile. The need for the converter comes from the various formats that%N%
					%profilers use to record run-time information during an execution.%N%
					%%N%
					%Provide the Run-time information record produced by the profiler and%N%
					%select the profiler used to create this record.%
					%%N%
					%The Execution Profile will be generated under the file %"profinfo.pfi%".")
		end

	wt_Switches_and_query: STRING is 			do	Result := locale.translate("Switches and Query").out	end
	ws_Switches_and_query: STRING is 			do	Result := locale.translate("Select the information you need and formulate your query.").out	end

	wt_Generation_error: STRING is 			do	Result := locale.translate("Generation Error").out	end
	wb_Click_back_and_correct_error: STRING is 			do	Result := locale.translate("Click Back if you can correct the problem or Click Abort.").out	end

	wt_Runtime_information_record_error: STRING is 			do	Result := locale.translate("Runtime Information Record Error").out	end
	wb_Runtime_information_record_error (generation_path: STRING): STRING is
		do
			Result := locale.format_string( 
					locale.translate("The file you have supplied as Runtime Information Record%N%
							%does not exist or is not valid.%N%
							%Do not forget that the Runtime Information Record has to%N%
							%be located in the project directory:%N$1%
							%%N%N%
							%Please provide a valid file or execute your profiler again to%N%
							%generate a valid Runtime Information Record.%N%
							%%N%
							%Click Back and select a valid file or Click Abort."), [generation_path])
		end

	wt_Execution_profile_error: STRING is 			do	Result := locale.translate("Execution Profile Error").out	end
	wb_Execution_profile_error: STRING is
		do
			Result := locale.translate("The file you have supplied as existring Execution Provide does%N%
					%not exist or is not valid. Please provide a valid file or generate%N%
					%a new one.%N%
					%Click Back and select a valid file or choose the generate option.");
		end

feature -- String escape

	escaped_string_for_menu_item (a_str: STRING): STRING is
			-- Escaped string for menu item.
			-- "&" is escaped by "&&" because in menu item, "&" is used as accelerator indicator.
		require
			a_str_attached: a_str /= Void
		do
			Result := a_str.twin
			Result.replace_substring_all ("&", "&&")
		ensure
			result_attached: Result /= Void
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



