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
--i18n
	SHARED_I18N_LOCALIZATOR

feature -- Button texts

	b_Abort: STRING_32 is do Result := i18n("Abort")
	b_Add: STRING_32 is do Result := i18n("Add")
	b_Add_text: STRING_32 is do Result := i18n("Add ->")
	b_And: STRING_32 is do Result := i18n("And")
	b_Apply: STRING_32 is do Result := i18n("Apply")
	b_Browse: STRING_32 is do Result := i18n("Browse...")
	b_Cancel: STRING_32 is do Result := i18n("Cancel")
	b_C_functions: STRING_32 is do Result := i18n("C Functions")
	b_Close: STRING_32 is do Result := i18n("Close")
	b_Continue_anyway: STRING_32 is do Result := i18n("Continue Anyway")
	b_Create: STRING_32 is do Result := i18n("Create")
	b_Create_folder: STRING_32 is do Result := i18n("Create Folder...")
	b_Delete_command: STRING_32 is do Result := i18n("Delete")
	b_Descendant_time: STRING_32 is do Result := i18n("Descendant Time")
	b_Discard_assertions: STRING_32 is do Result := i18n("Discard Assertions")
	b_Display_Exception_Trace: STRING_32 is do Result := i18n("Display Exception Trace")
	b_Down_text: STRING_32 is do Result := i18n("Down")
	b_Edit_ace: STRING_32 is do Result := i18n("Edit")
	b_Edit_command: STRING_32 is do Result := i18n("Edit...")
	b_Eiffel_features: STRING_32 is do Result := i18n("Eiffel Features")
	b_Feature_name: STRING_32 is do Result := i18n("Feature Name")
	b_Finish: STRING_32 is do Result := i18n("Finish")
	b_Function_time: STRING_32 is do Result := i18n("Function Time")
	b_Keep_assertions: STRING_32 is do Result := i18n("Keep Assertions")
	b_Load_ace: STRING_32 is do Result := i18n("Load From...")
	b_Move_to_folder: STRING_32 is do Result := i18n("Move to Folder...")
	b_New_ace: STRING_32 is do Result := i18n("Reset")
	b_New_command: STRING_32 is do Result := i18n("Add...")
	b_New_favorite_class: STRING_32 is do Result := i18n("New Favorite Class...")
	b_New_tab: STRING_32 is do Result := i18n("New Tab")
	b_Next: STRING_32 is do Result := i18n("Next")
	b_Number_of_calls: STRING_32 is do Result := i18n("Number of Calls")
	b_Ok: STRING_32 is do Result := i18n("OK")
	b_Open_original: STRING_32 is do Result := i18n("Open Original File")
	b_Open_backup: STRING_32 is do Result := i18n("Open Backup File")
	b_Or: STRING_32 is do Result := i18n("Or")
	b_Percentage: STRING_32 is do Result := i18n("Percentage")
	b_Replace: STRING_32 is do Result := i18n("Replace")
	b_Replace_all: STRING_32 is do Result := i18n("Replace all")
	b_Recursive_functions: STRING_32 is do Result := i18n("Recursive Functions")
	b_Reload: STRING_32 is do Result := i18n("Reload")
	b_Remove: STRING_32 is do Result := i18n("Remove")
	b_Remove_all: STRING_32 is do Result := i18n("Remove all")
	b_Remove_text: STRING_32 is do Result := i18n("<- Remove")
	b_Retry: STRING_32 is do Result := i18n("Retry")
	b_Search: STRING_32 is do Result := i18n("Search")
	b_New_search: STRING_32 is do Result := i18n("New Search?")
	b_Save: STRING_32 is do Result := i18n("Save")
	b_Save_all: STRING_32 is do Result := i18n("Save All")
	b_Total_time: STRING_32 is do Result := i18n("Total Time")
	b_Up_text: STRING_32 is do Result := i18n("Up")
	b_Update: STRING_32 is do Result := i18n("Update")
	b_Compile: STRING_32 is do Result := i18n("Compile")
	b_Launch: STRING_32 is do Result := i18n("Start")
	b_Continue: STRING_32 is do Result := i18n("Continue")
	b_Finalize: STRING_32 is do Result := i18n("Finalize")
	b_Freeze: STRING_32 is do Result := i18n("Freeze")
	b_Precompile: STRING_32 is do Result := i18n("Precompile")
	b_override_scan: STRING_32 is do Result := i18n("Recompile Overrides")
	b_Cut: STRING_32 is do Result := i18n("Cut")
	b_Copy: STRING_32 is do Result := i18n("Copy")
	b_Paste: STRING_32 is do Result := i18n("Paste")
	b_New_editor: STRING_32 is do Result := i18n("New Editor")
	b_New_context: STRING_32 is do Result := i18n("New Context")
	b_New_window: STRING_32 is do Result := i18n("New Window")
	b_Open: STRING_32 is do Result := i18n("Open")
	b_Save_as: STRING_32 is do Result := i18n("Save As")
	b_Shell: STRING_32 is do Result := i18n("External Editor")
	b_Print: STRING_32 is do Result := i18n("Print")
	b_Undo: STRING_32 is do Result := i18n("Undo")
	b_Redo: STRING_32 is do Result := i18n("Redo")
	b_Create_new_cluster: STRING_32 is do Result := i18n("Add Cluster")
	b_Create_new_library: STRING_32 is do Result := i18n("Add Library")
	b_Create_new_assembly: STRING_32 is do Result := i18n("Add Assembly")
	b_Create_new_precompile: STRING_32 is do Result := i18n("Add Precompile")
	b_Create_new_class: STRING_32 is do Result := i18n("New Class")
	b_Create_new_feature: STRING_32 is do Result := i18n("New Feature")
	b_Send_stone_to_context: STRING_32 is do Result := i18n("Synchronize")
	b_Display_error_help: STRING_32 is do Result := i18n("Help Tool")
	b_Project_settings: STRING_32 is do Result := i18n("Project Settings")
	b_System_info: STRING_32 is do Result := i18n("System Info")
	b_Bkpt_info: STRING_32 is do Result := i18n("Breakpoint Info")
	b_Bkpt_enable: STRING_32 is do Result := i18n("Enable Breakpoints")
	b_Bkpt_disable: STRING_32 is do Result := i18n("Disable Breakpoints")
	b_Bkpt_remove: STRING_32 is do Result := i18n("Remove Breakpoints")
	b_Bkpt_stop_in_hole: STRING_32 is do Result := i18n("Pause")
	b_Exec_kill: STRING_32 is do Result := i18n("Stop Application")
	b_Exec_into: STRING_32 is do Result := i18n("Step Into")
	b_Exec_no_stop: STRING_32 is do Result := i18n("Launch Without Stopping")
	b_Exec_out: STRING_32 is do Result := i18n("Step Out")
	b_Exec_step: STRING_32 is do Result := i18n("Step")
	b_Exec_stop: STRING_32 is do Result := i18n("Pause")
	b_Run_finalized: STRING_32 is do Result := i18n("Run Finalized")
	b_Toggle_stone_management: STRING_32 is do Result := i18n("Link Context")
	b_Raise_all: STRING_32 is do Result := i18n("Raise Windows")
	b_Remove_class_cluster: STRING_32 is do Result := i18n("Remove Class/Cluster")
	b_Minimize_all: STRING_32 is do Result := i18n("Minimize All")
	b_Terminate_c_compilation: STRING_32 is do Result := i18n("Terminate C Compilation")
	b_Expand_all: STRING_32 is do Result := i18n("Expand All")
	b_Collapse_all: STRING_32 is do Result := i18n("Collapse All")
	b_Dbg_exception_handler: STRING_32 is do Result := i18n("Exceptions")
	b_Dbg_assertion_checking_disable: STRING_32 is do Result := i18n("Disable assertion checking")
	b_Dbg_assertion_checking_restore: STRING_32 is do Result := i18n("Restore assertion checking")

feature -- Graphical degree output

	d_Classes_to_go: STRING_32 is do Result := i18n("Classes to Go:")
	d_Clusters_to_go: STRING_32 is do Result := i18n("Clusters to Go:")
	d_Compilation_class: STRING_32 is do Result := i18n("Class:")
	d_Compilation_cluster: STRING_32 is do Result := i18n("Cluster:")
	d_Compilation_progress: STRING_32 is do Result := i18n("Compilation Progress for ")
	d_Degree: STRING_32 is do Result := i18n("Degree:")
	d_Documentation: STRING_32 is do Result := i18n("Documentation")
	d_Features_processed: STRING_32 is do Result := i18n("Completed: ")
	d_Features_to_go: STRING_32 is do Result := i18n("Remaining: ")
	d_Generating: STRING_32 is do Result := i18n("Generating: ")
	d_Resynchronizing_breakpoints: STRING_32 is do Result := i18n("Resynchronizing Breakpoints")
	d_Resynchronizing_tools: STRING_32 is do Result := i18n("Resynchronizing Tools")
	d_Reverse_engineering: STRING_32 is do Result := i18n("Reverse Engineering Project")
	d_Finished_removing_dead_code: STRING_32 is do Result := i18n("Dead Code Removal Completed")

feature -- Help text

	h_No_help_available: STRING_32 is do Result := i18n("No help available for this element")
	h_refactoring_compiled: STRING_32 is do Result := i18n("Renames only occurances of the class name in compiled classes.")
	h_refactoring_all_classes: STRING_32 is do Result := i18n("Renames occurances of the class name in any class. (Slow)")

feature -- File names

	default_stack_file_name: STRING_32 is do Result := i18n("stack")

feature -- Accelerator, focus label and menu name

	m_About: STRING_32 is
		once
			Result := i18n("&About ") + Workbench_name + i18n("...")
		end
	m_Advanced: STRING_32 is do Result := i18n("Ad&vanced")
	m_Add_to_favorites: STRING_32 is do Result := i18n("&Add to Favorites")
	m_Address_toolbar: STRING_32 is do Result := i18n("&Address Bar")
	m_Apply: STRING_32 is do Result := i18n("&Apply")
	l_all_classes: STRING_32 is do Result := i18n("All Classes")
	m_Breakpoints_tool: STRING_32 is do Result := i18n("Breakpoints")

	l_class_tree_assemblies: STRING_32 is do Result := i18n("Assemblies")
	l_class_tree_clusters: STRING_32 is do Result := i18n("Clusters")
	l_class_tree_libraries: STRING_32 is do Result := i18n("Libraries")
	l_class_tree_overrides: STRING_32 is do Result := i18n("Overrides")

	f_Clear_breakpoints: STRING_32 is do Result := i18n("Remove all breakpoints")
	m_Clear_breakpoints: STRING_32 is do Result := i18n("Re&move All Breakpoints")
	m_Comment: STRING_32 is do Result := i18n("&Comment%TCtrl+K")
	m_Compilation_C_Workbench: STRING_32 is do Result := i18n("Compile W&orkbench C Code")
	m_Compilation_C_Final: STRING_32 is do Result := i18n("Compile F&inalized C Code")
	m_Contents: STRING_32 is do Result := i18n("&Contents")
	m_Customize_general: STRING_32 is do Result := i18n("&Customize Standard Toolbar...")
	m_Customize_project: STRING_32 is do Result := i18n("Customize P&roject Toolbar...")
	m_Customize_refactoring: STRING_32 is do Result := i18n("Customize Re&factoring Toolbar...")
	m_Cut: STRING_32 is do Result := i18n("Cu&t%TCtrl+X")
	f_Cut: STRING_32 is do Result := i18n("Cut (Ctrl+X)")
	m_Call_stack_tool: STRING_32 is do Result := i18n("Call stack")
	m_Cluster_tool: STRING_32 is do Result := i18n("&Clusters")
	l_compiled_classes: STRING_32 is do Result := i18n("Compiled Classes")
	m_Complete_word: STRING_32 is do Result := i18n("Complete &Word")
	m_Complete_class_name: STRING_32 is do Result := i18n("Complete Class &Name")
	m_Context_tool: STRING_32 is do Result := i18n("Conte&xt")
	m_Copy: STRING_32 is do Result := i18n("&Copy%TCtrl+C")
	f_Copy: STRING_32 is do Result := i18n("Copy (Ctrl+C)")
	m_Close: STRING_32 is do Result := i18n("&Close Window%TAlt+F4")
	m_Close_short: STRING_32 is do Result := i18n("&Close")
	f_Create_new_cluster: STRING_32 is do Result := i18n("Add a cluster")
	f_Create_new_library: STRING_32 is do Result := i18n("Add a library")
	f_Create_new_assembly: STRING_32 is do Result := i18n("Add an assembly")
	f_Create_new_precompile: STRING_32 is do Result := i18n("Add a precompile")
	f_Create_new_class: STRING_32 is do Result := i18n("Create a new class")
	f_Create_new_feature: STRING_32 is do Result := i18n("Create a new feature")

	m_Dbg_assertion_checking_disable: STRING_32 is do Result := i18n("Disable Assertion Checking")
	m_Dbg_assertion_checking_restore: STRING_32 is do Result := i18n("Restore Assertion Checking")
	m_Dbg_exception_handler: STRING_32 is do Result := i18n("Exception Handling")
	m_Debug_interrupt_new: STRING_32 is do Result := i18n("I&nterrupt Application")
	f_Debug_edit_object: STRING_32 is do Result := i18n("Edit Object content")
	m_Debug_edit_object: STRING_32 is do Result := i18n("Edit Object Content")
	f_Debug_dynamic_eval: STRING_32 is do Result := i18n("Dynamic feature evaluation")
	m_Debug_dynamic_eval: STRING_32 is do Result := i18n("Dynamic Feature Evaluation")
	m_Debug_kill: STRING_32 is do Result := i18n("&Stop Application")
	f_Debug_run: STRING_32 is do Result := i18n("Run")
	m_Debug_run: STRING_32 is do Result := i18n("&Run%TCtrl+R")
	m_Debug_run_new: STRING_32 is do Result := i18n("St&art")
	m_Launch_With_Arguments: STRING_32 is do Result := i18n("Start With Arguments")
	f_diagram_delete: STRING_32 is do Result := i18n("Delete")
	l_diagram_delete: STRING_32 is do Result := i18n("Delete graphical items, remove code from system")
	f_diagram_crop: STRING_32 is do Result := i18n("Crop diagram")
	m_diagram_crop: STRING_32 is do Result := i18n("&Crop Diagram")
	f_diagram_zoom_out: STRING_32 is do Result := i18n("Zoom out")
	f_diagram_put_right_angles: STRING_32 is do Result := i18n("Force right angles")
	f_diagram_remove_right_angles: STRING_32 is do Result := i18n("Remove right angles")
	m_diagram_link_tool: STRING_32 is do Result := i18n("&Put Right Angles")
	f_diagram_to_png: STRING_32 is do Result := i18n("Export diagram to PNG")
	m_diagram_to_png: STRING_32 is do Result := i18n("&Export Diagram to PNG")
	f_diagram_context_depth: STRING_32 is do Result := i18n("Select depth of relations")
	m_diagram_context_depth: STRING_32 is do Result := i18n("&Select Depth of Relations")
	f_diagram_delete_view: STRING_32 is do Result := i18n("Delete current view")
	f_diagram_reset_view: STRING_32 is do Result := i18n("Reset current view")
	m_diagram_delete_view: STRING_32 is do Result := i18n("&Delete Current View")
	m_diagram_reset_view: STRING_32 is do Result := i18n("&Reset Current View")
	f_diagram_zoom_in: STRING_32 is do Result := i18n("Zoom in")
	f_diagram_fit_to_screen: STRING_32 is do Result := i18n("Fit to screen")
	f_diagram_undo: STRING_32 is do Result := i18n("Undo last action")
	f_diagram_hide_supplier: STRING_32 is do Result := i18n("Hide supplier links")
	f_diagram_show_supplier: STRING_32 is do Result := i18n("Show supplier links")

	l_diagram_supplier_visibility: STRING_32 is do Result := i18n("Toggle visibility of supplier links")

	l_diagram_add_ancestors: STRING_32 is do Result := i18n("Add class ancestors to diagram")
	l_diagram_add_descendents: STRING_32 is do Result := i18n("Add class descendants to diagram")
	l_diagram_add_suppliers: STRING_32 is do Result := i18n("Add class suppliers to diagram")
	l_diagram_add_clients: STRING_32 is do Result := i18n("Add class clients to diagram")

	f_diagram_hide_labels: STRING_32 is do Result := i18n("Hide labels")
	f_diagram_show_labels: STRING_32 is do Result := i18n("Show labels")
	f_diagram_show_uml: STRING_32 is do Result := i18n("Show UML")
	f_diagram_show_bon: STRING_32 is do Result := i18n("Show BON")
	f_diagram_hide_clusters: STRING_32 is do Result := i18n("Hide clusters")
	f_diagram_show_clusters: STRING_32 is do Result := i18n("Show clusters")
	f_diagram_show_legend: STRING_32 is do Result := i18n("Show cluster legend")
	f_diagram_hide_legend: STRING_32 is do Result := i18n("Hide cluster legend")
	f_diagram_remove_anchor: STRING_32 is do Result := i18n("Remove anchor")
	l_diagram_labels_visibility: STRING_32 is do Result := i18n("Toggle visibility of client link labels")
	l_diagram_uml_visibility: STRING_32 is do Result := i18n("Toggle between UML and BON view")
	l_diagram_clusters_visibility: STRING_32 is do Result := i18n("Toggle visibility of clusters")
	l_diagram_legend_visibility: STRING_32 is do Result := i18n("Toggle visibility of cluster legend")
	l_diagram_remove_anchor: STRING_32 is do Result := i18n("Remove anchor")
	l_diagram_force_directed: STRING_32 is do Result := i18n("Turn on/off physics")
	l_diagram_toggle_quality: STRING_32 is do Result := i18n("Toggle quality level")
	f_diagram_high_quality: STRING_32 is do Result := i18n("Switch to high quality")
	f_diagram_low_quality: STRING_32 is do Result := i18n("Switch to low quality")
	f_diagram_hide_inheritance: STRING_32 is do Result := i18n("Hide inheritance links")
	f_diagram_show_inheritance: STRING_32 is do Result := i18n("Show inheritance links")
	l_diagram_inheritance_visibility: STRING_32 is do Result := i18n("Toggle visibility of inheritance links")
	f_diagram_redo: STRING_32 is do Result := i18n("Redo last action")
	f_diagram_fill_cluster: STRING_32 is do Result := i18n("Include all classes of cluster")
	f_diagram_history: STRING_32 is do Result := i18n("History tool")
	f_diagram_remove: STRING_32 is do Result := i18n("Hide figure")
	l_diagram_remove: STRING_32 is do Result := i18n("Delete graphical items")
	f_diagram_create_supplier_links: STRING_32 is do Result := i18n("Create new client-supplier links")
	f_diagram_create_aggregate_supplier_links: STRING_32 is do Result := i18n("Create new aggregate client-supplier links")
	f_diagram_create_inheritance_links: STRING_32 is do Result := i18n("Create new inheritance links")
	l_diagram_create_links: STRING_32 is do Result := i18n("Select type of new links")
	f_diagram_new_class: STRING_32 is do Result := i18n("Create a new class")
	f_diagram_change_header: STRING_32 is do Result := i18n("Change class name and generics")
	f_diagram_change_color: STRING_32 is do Result := i18n("Change color")
	f_diagram_force_directed_on: STRING_32 is do Result := i18n("Turn on physics")
	f_diagram_force_directed_off: STRING_32 is do Result := i18n("Turn off physics")
	f_diagram_force_settings: STRING_32 is do Result := i18n("Show physics settings dialog")
	f_Disable_stop_points: STRING_32 is do Result := i18n("Disable all breakpoints")
	m_Disable_stop_points: STRING_32 is do Result := i18n("&Disable All Breakpoints")
	m_Debug_block: STRING_32 is do Result := i18n("E&mbed in %"Debug...%"%TCtrl+D")
	m_Editor: STRING_32 is do Result := i18n("&Editor")
	m_Eiffel_introduction: STRING_32 is do Result := i18n("&Introduction to Eiffel")
	f_Enable_stop_points: STRING_32 is do Result := i18n("Enable all breakpoints")
	m_Enable_stop_points: STRING_32 is do Result := i18n("&Enable All Breakpoints")
	m_Exec_last: STRING_32 is do Result := i18n("&Out of Routine")
	m_Exec_nostop: STRING_32 is do Result := i18n("&Ignore Breakpoints")
	m_Exec_step: STRING_32 is do Result := i18n("&Step-by-Step")
	m_Exec_into: STRING_32 is do Result := i18n("Step In&to")
	m_Exit_project: STRING_32 is do Result := i18n("E&xit")
	m_Explorer_bar: STRING_32 is do Result := i18n("&Tools")
	m_Export_to: STRING_32 is do Result := i18n("Save Cop&y As...")
	m_Export_XMI: STRING_32 is do Result := i18n("E&xport XMI...")
	m_Expression_evaluation: STRING_32 is do Result := i18n("Expression Evaluation")
	m_External_editor: STRING_32 is do Result := i18n("External E&ditor")
	m_Favorites_tool: STRING_32 is do Result := i18n("F&avorites")
	m_Features_tool: STRING_32 is do Result := i18n("&Features")
	f_Finalize: STRING_32 is do Result := i18n("Finalize...")
	m_Finalize_new: STRING_32 is do Result := i18n("Finali&ze...")
	m_Find: STRING_32 is do Result := i18n("&Search")
	m_Find_next: STRING_32 is do Result := i18n("Find &Next")
	m_Find_previous: STRING_32 is do Result := i18n("Find &Previous")
	m_Find_next_selection: STRING_32 is do Result := i18n("Find Next &Selection")
	m_Find_previous_selection: STRING_32 is do Result := i18n("Find P&revious Selection")
	f_Freeze: STRING_32 is do Result := i18n("Freeze...")
	m_Freeze_new: STRING_32 is do Result := i18n("&Freeze...")
	m_General_toolbar: STRING_32 is do Result := i18n("&Standard Buttons")
	m_Generate_documentation: STRING_32 is do Result := i18n("Generate &Documentation...")
	m_Go_to: STRING_32 is do Result := i18n("&Go to...")
	m_Guided_tour: STRING_32 is do Result := i18n("&Guided Tour")
	m_Help: STRING_32 is do Result := i18n("&Help")
	m_Hide_favorites: STRING_32 is do Result := i18n("&Hide Favorites")
	m_Hide_formatting_marks: STRING_32 is do Result := i18n("&Hide Formatting Marks")
	m_History_forth: STRING_32 is do Result := i18n("&Forward")
	m_History_back: STRING_32 is do Result := i18n("&Back")
	f_History_forth: STRING_32 is do Result := i18n("Go forth")
	f_History_back: STRING_32 is do Result := i18n("Go back")
	m_How_to_s: STRING_32 is do Result := i18n("&How to's")
	m_If_block: STRING_32 is do Result := i18n("&Embed in %"if...%"%TCtrl+I")
	m_Indent: STRING_32 is do Result := i18n("&Indent Selection%TTab")
	m_Line_numbers: STRING_32 is do Result := i18n("Toggle &Line Numbers")
	f_Melt: STRING_32 is do Result := i18n("Compile current project")
	m_Melt_new: STRING_32 is do Result := i18n("&Compile")
	m_New: STRING_32 is do Result := i18n("&New")
	l_new_name: STRING_32 is do Result := i18n("New Name:")
	f_New_window: STRING_32 is do Result := i18n("Create a new window")
	m_New_window: STRING_32 is do Result := i18n("New &Window")
	m_New_dynamic_lib: STRING_32 is do Result := i18n("&Dynamic Library Builder...")
	m_New_project: STRING_32 is do Result := i18n("&New Project...")
	m_Ok: STRING_32 is do Result := i18n("&OK")
	m_Open: STRING_32 is do Result := i18n("&Open...%TCtrl+O")
	m_Open_new: STRING_32 is do Result := i18n("Op&en...")
	m_Open_project: STRING_32 is do Result := i18n("&Open Project...")
	m_Organize_favorites: STRING_32 is do Result := i18n("&Organize Favorites...")
	m_Output: STRING_32 is do Result := i18n("&Output")
	f_Paste: STRING_32 is do Result := i18n("Paste (Ctrl+V)")
	m_Paste: STRING_32 is do Result := i18n("&Paste%TCtrl+V")
	m_Precompile_new: STRING_32 is do Result := i18n("&Precompile")
	f_Print: STRING_32 is do Result := i18n("Print")
	m_Print: STRING_32 is do Result := i18n("&Print")
	f_preferences: STRING_32 is do Result := i18n("Preferences")
	m_Preferences: STRING_32 is do Result := i18n("&Preferences...")
	m_Properties_tool: STRING_32 is do Result := i18n("Pr&operties")
	m_Profile_tool: STRING_32 is do Result := i18n("Pro&filer...")
	m_Project_toolbar: STRING_32 is do Result := i18n("&Project Bar")
	m_Refactoring_toolbar: STRING_32 is do Result := i18n("Re&factoring Bar")
	f_refactoring_pull: STRING_32 is do Result := i18n("Pull up Feature")
	f_refactoring_rename: STRING_32 is do Result := i18n("Rename Feature/Class")
	f_refactoring_undo: STRING_32 is do Result := i18n("Undo Last Refactoring (only works as long as no file that was refactored has been changed by hand)")
	f_refactoring_redo: STRING_32 is do Result := i18n("Redo Last Refactoring (only works as long as no file that was refactored has been changed by hand)")
	b_refactoring_pull: STRING_32 is do Result := i18n("Pull Up")
	b_refactoring_rename: STRING_32 is do Result := i18n("Rename")
	b_refactoring_undo: STRING_32 is do Result := i18n("Undo Refactoring")
	b_refactoring_redo: STRING_32 is do Result := i18n("Redo Refactoring")
	l_rename_file: STRING_32 is do Result := i18n("Rename File")
	l_replace_comments: STRING_32 is do Result := i18n("Replace Name in Comments")
	l_replace_strings: STRING_32 is do Result := i18n("Replace Name in Strings")
	m_Recent_project: STRING_32 is do Result := i18n("&Recent Projects")
	m_Redo: STRING_32 is do Result := i18n("Re&do%TCtrl+Y")
	f_Redo: STRING_32 is do Result := i18n("Redo (Ctrl+Y)")
	m_Replace: STRING_32 is do Result := i18n("&Replace...")
	f_Retarget_diagram: STRING_32 is do Result := i18n("Target to cluster or class")
	f_Run_finalized: STRING_32 is do Result := i18n("Run finalized system")
	m_Run_finalized: STRING_32 is do Result := i18n("&Run Finalized System")
	f_Save: STRING_32 is do Result := i18n("Save")
	m_Save_new: STRING_32 is do Result := i18n("&Save")
	m_Save_As: STRING_32 is do Result := i18n("S&ave As...")
	f_Save_all: STRING_32 is do Result := i18n("Save All")
	m_Save_All: STRING_32 is do Result := i18n("Save &All")
	m_Search: STRING_32 is do Result := i18n("&Find...")
	m_Search_tool: STRING_32 is do Result := i18n("&Search")
	m_Select_all: STRING_32 is do Result := i18n("Select &All%TCtrl+A")
	m_Send_to: STRING_32 is do Result := i18n("Sen&d to")
	m_show_assigners: STRING_32 is do Result := i18n("A&ssigners")
	m_Show_class_cluster: STRING_32 is do Result := i18n("Find in Cluster Tree")
	m_show_creators: STRING_32 is do Result := i18n("C&reators")
	m_Show_favorites: STRING_32 is do Result := i18n("&Show Favorites")
	m_Show_formatting_marks: STRING_32 is do Result := i18n("&Show Formatting Marks")
	m_Showancestors: STRING_32 is do Result := i18n("&Ancestors")
	m_Showattributes: STRING_32 is do Result := i18n("A&ttributes")
	m_Showcallers: STRING_32 is do Result := i18n("&Callers")
	m_Showcallees: STRING_32 is do Result := i18n("Call&ees")
	m_Show_creation: STRING_32 is do Result := i18n("Creat&ions")
	m_Show_assignees: STRING_32 is do Result := i18n("&Assignees")
	m_Showclick: STRING_32 is do Result := i18n("C&lickable")
	m_Showclients: STRING_32 is do Result := i18n("Cli&ents")
	m_showcreators: STRING_32 is do Result := i18n("&Creators")
	m_Showdeferreds: STRING_32 is do Result := i18n("&Deferred")
	m_Showdescendants: STRING_32 is do Result := i18n("De&scendants")
	m_Showexported: STRING_32 is do Result := i18n("Ex&ported")
	m_Showexternals: STRING_32 is do Result := i18n("E&xternals")
	m_Showflat: STRING_32 is do Result := i18n("&Flat")
	m_Showfs: STRING_32 is do Result := i18n("&Interface")
	m_Showfuture: STRING_32 is do Result := i18n("&Descendant Versions")
	m_Showhistory: STRING_32 is do Result := i18n("&Implementers")
	m_Showindexing: STRING_32 is do Result := i18n("&Indexing clauses")
	m_show_invariants: STRING_32 is do Result := i18n("In&variants")
	m_Showonces: STRING_32 is do Result := i18n("O&nce/Constants")
	m_Showpast: STRING_32 is do Result := i18n("&Ancestor Versions")
	m_Showroutines: STRING_32 is do Result := i18n("&Routines")
	m_Showshort: STRING_32 is do Result := i18n("C&ontract")
	m_Showhomonyms: STRING_32 is do Result := i18n("&Homonyms")
	m_Showsuppliers: STRING_32 is do Result := i18n("S&uppliers")
	m_Showtext_new: STRING_32 is do Result := i18n("Te&xt")
	m_System_new: STRING_32 is do Result := i18n("Project &Settings...")
	m_Toolbars: STRING_32 is do Result := i18n("Tool&bars")
	m_To_lower: STRING_32 is do Result := i18n("Set to &Lowercase%TCtrl+Shift+U")
	m_To_upper: STRING_32 is do Result := i18n("Set to U&ppercase%TCtrl+U")
	m_Uncomment: STRING_32 is do Result := i18n("U&ncomment%TCtrl+Shift+K")
	f_Uncomment: STRING_32 is do Result := i18n("Uncomment selected lines")
	m_Undo: STRING_32 is do Result := i18n("&Undo%TCtrl+Z")
	f_Undo: STRING_32 is do Result := i18n("Undo (Ctrl+Z)")
	m_Unindent: STRING_32 is do Result := i18n("&Unindent Selection%TShift+Tab")
	m_Windows_tool: STRING_32 is do Result := i18n("&Windows")
	m_Watch_tool: STRING_32 is do Result := i18n("Watch Tool")
	m_Wizard_precompile: STRING_32 is do Result := i18n("Precompilation &Wizard...")
	f_Wizard_precompile: STRING_32 is do Result := i18n("Wizard to precompile libraries")
	f_go_to_first_occurrence: STRING_32 is do Result := i18n("Double click to go to first occurrence")

feature -- Toggles

	f_hide_alias: STRING_32 is do Result := i18n("Hide Alias Name")
	f_hide_assigner: STRING_32 is do Result := i18n("Hide Assigner Command Name")
	f_hide_signature: STRING_32 is do Result := i18n("Hide Signature")
	f_show_alias: STRING_32 is do Result := i18n("Show Alias Name")
	f_show_assigner: STRING_32 is do Result := i18n("Show Assigner Command Name")
	f_show_signature: STRING_32 is do Result := i18n("Show Signature")
	l_toggle_alias: STRING_32 is do Result := i18n("Toggle visibility of feature alias name")
	l_toggle_assigner: STRING_32 is do Result := i18n("Toggle visibility of assigner command name")
	l_toggle_signature: STRING_32 is do Result := i18n("Toggle visibility of feature signature")

feature -- Menu mnenomics

	m_Add_exported_feature: STRING_32 is do Result := i18n("&Add...")
	m_Bkpt_info: STRING_32 is do Result := i18n("Brea&kpoint Information")
	m_Class_info: STRING_32 is do Result := i18n("Cla&ss Views")
	m_Check_exports: STRING_32 is do Result := i18n("Chec&k Export Clauses")
	m_Create_new_cluster: STRING_32 is do Result := i18n("Add C&luster...")
	m_Create_new_library: STRING_32 is do Result := i18n("Add L&ibrary...")
	m_Create_new_precompile: STRING_32 is do Result := i18n("Add &Precompile")
	m_Create_new_assembly: STRING_32 is do Result := i18n("Add &Assembly...")
	m_Create_new_class: STRING_32 is do Result := i18n("&New Class...")
	m_Create_new_feature: STRING_32 is do Result := i18n("New Fea&ture...")
	m_Debug: STRING_32 is do Result := i18n("&Debug")
	m_Debugging_tool: STRING_32 is do Result := i18n("&Debugging Tools")
	m_Disable_this_bkpt: STRING_32 is do Result := i18n("&Disable This Breakpoint")
	m_Display_error_help: STRING_32 is do Result := i18n("Compilation Error &Wizard...")
	m_Display_system_info: STRING_32 is do Result := i18n("S&ystem Info")
	m_Edit: STRING_32 is do Result := i18n("&Edit")
	m_Edit_condition: STRING_32 is do Result := i18n("E&dit Condition")
	m_Edit_exported_feature: STRING_32 is do Result := i18n("&Edit...")
	m_Edit_external_commands: STRING_32 is do Result := i18n("&External Commands...")
	m_Enable_this_bkpt: STRING_32 is do Result := i18n("&Enable This Breakpoint")
	m_Favorites: STRING_32 is do Result := i18n("Fav&orites")
	m_Feature_info: STRING_32 is do Result := i18n("Feat&ure Views")
	m_File: STRING_32 is do Result := i18n("&File")
	m_Formats: STRING_32 is do Result := i18n("F&ormat")
	m_Formatter_separators: ARRAY [STRING_32] is
		once
			Result := <<"Text Generators", "Class Relations", "Restrictors", "Main Editor Views">>
		end
	m_History: STRING_32 is do Result := i18n("&Go to")
	m_Maximize: STRING_32 is do Result := i18n("Ma&ximize")
	m_Minimize: STRING_32 is do Result := i18n("Mi&nimize")
	m_Minimize_all: STRING_32 is do Result := i18n("&Minimize All")
	f_New_tab: STRING_32 is do Result := i18n("New Tab")
	m_New_tab: STRING_32 is do Result := i18n("New Ta&b")
	m_New_editor: STRING_32 is do Result := i18n("New Ed&itor Window")
	m_New_context_tool: STRING_32 is do Result := i18n("New Con&text Window")
	m_Object: STRING_32 is do Result := i18n("&Object")
	m_Object_tools: STRING_32 is do Result := i18n("&Object Tools")
	m_Open_eac_browser: STRING_32 is do Result := i18n("EAC Browser")
	m_Pretty_print: STRING_32 is do Result := i18n("Expand an Object")
	m_Project: STRING_32 is do Result := i18n("&Project")
	m_Override_scan: STRING_32 is do Result := i18n("Recompile &Overrides")
	m_Raise: STRING_32 is do Result := i18n("&Raise")
	m_Raise_all: STRING_32 is do Result := i18n("&Raise All")
	m_Raise_all_unsaved: STRING_32 is do Result := i18n("Raise &Unsaved Windows")
	m_Remove_class_cluster: STRING_32 is do Result := i18n("&Remove Current Item")
	m_Remove_exported_feature: STRING_32 is do Result := i18n("&Remove")
	m_Remove_condition: STRING_32 is do Result := i18n("Remove Condition")
	m_Remove_this_bkpt: STRING_32 is do Result := i18n("&Remove This Breakpoint")
	m_Run_to_this_point: STRING_32 is do Result := i18n("&Run to This Point")
	m_Send_stone_to_context: STRING_32 is do Result := i18n("S&ynchronize Context Tool")
	m_Set_conditional_breakpoint: STRING_32 is do Result := i18n("Set &Conditional Breakpoint")
	m_Set_critical_stack_depth: STRING_32 is do Result := i18n("Overflow &Prevention...")
	m_Set_slice_size: STRING_32 is do Result := i18n("&Alter size")
	m_Special: STRING_32 is do Result := i18n("&Special")
	m_Separate_stone: STRING_32 is do Result := i18n("Unlin&k Context Tool")
	m_Tools: STRING_32 is do Result := i18n("&Tools")
	m_Unify_stone: STRING_32 is do Result := i18n("Lin&k Context Tool")
	m_View: STRING_32 is do Result := i18n("&View")
	m_Window: STRING_32 is do Result := i18n("&Window")
	m_Refactoring: STRING_32 is do Result := i18n("&Refactoring")

feature -- Label texts

	l_Ace_file_for_frame: STRING_32 is do Result := i18n("Ace file")
	l_action_colon: STRING_32 is do Result := i18n("Action:")
	l_Active_query: STRING_32 is do Result := i18n("Active query")
	l_Address: STRING_32 is do Result := i18n("Address:")
	l_add_project_config_file: STRING_32 is do Result := i18n("Add Project...")
	l_All: STRING_32 is do Result := i18n("recursive")
	l_Alias_name: STRING_32 is do Result := i18n("Alias:")
	l_Ancestors: STRING_32 is do Result := i18n("ancestors")
	l_Arguments: STRING_32 is do Result := i18n("Arguments")
	l_assigners: STRING_32 is do Result := i18n("assigners")
	l_Attributes: STRING_32 is do Result := i18n("attributes")
	l_Available_buttons_text: STRING_32 is do Result := i18n("Available buttons")
	l_Basic_application: STRING_32 is do Result := i18n("Basic application (no graphics library included)")
	l_Basic_text: STRING_32 is do Result := i18n("basic text view")
	l_Callers: STRING_32 is do Result := i18n("callers")
	l_Calling_convention: STRING_32 is do Result := i18n("Calling convention:")
	l_Choose_folder: STRING_32 is do Result := i18n("Select the destination folder ")
	l_Class: STRING_32 is do Result := i18n("Class:")
	l_class_name: STRING_32 is do Result := i18n("Class name:")
	l_clean: STRING_32 is do Result := i18n("Clean")
	l_clean_user_file: STRING_32 is do Result := i18n("Reset user settings")
	l_Clients: STRING_32 is do Result := i18n("clients")
	l_Clickable: STRING_32 is do Result := i18n("clickable view")
	l_Cluster: STRING_32 is do Result := i18n("Cluster:")
	l_Cluster_name: STRING_32 is do Result := i18n("Cluster name ")
	l_Cluster_options: STRING_32 is do Result := i18n("Cluster options ")
	l_Command_error_output: STRING_32 is do Result := i18n("Command error output:%N")
	l_Command_line: STRING_32 is do Result := i18n("Command line:")
	l_Command_normal_output: STRING_32 is do Result := i18n("Command output:%N")
	l_Compiled_class: STRING_32 is do Result := i18n("Only compiled classes")
	l_compile: STRING_32 is do Result := i18n("Compile")
	l_Compile_first: STRING_32 is do Result := i18n("Compile to have information")
	l_Compile_project: STRING_32 is do Result := i18n("Compile project")
	l_Condition: STRING_32 is do Result := i18n("Condition")
	l_Confirm_kill: STRING_32 is do Result := i18n("Stop the application?")
	l_Context: STRING_32 is do Result := i18n("Context")
	l_Creation: STRING_32 is do Result := i18n("Creation procedure:")
	l_creators: STRING_32 is do Result := i18n("creators")
	l_Current_context: STRING_32 is do Result := i18n("Current feature")
	l_Current_editor: STRING_32 is do Result := i18n("Current editor")
	l_Current_object: STRING_32 is do Result := i18n("Current object")
	l_Custom: STRING_32 is do Result := i18n("Custom")
	l_Deferred: STRING_32 is do Result := i18n("deferred")
	l_Deferreds: STRING_32 is do Result := i18n("deferred features")
	l_Deleting_dialog_default: STRING_32 is do Result := i18n("Creating new project, please wait...")
	l_Descendants: STRING_32 is do Result := i18n("descendants")
	l_Diagram_delete_view_cmd: STRING_32 is do Result := i18n("Do you really want to delete current view?")
	l_Diagram_reset_view_cmd: STRING_32 is do Result := i18n("Do you really want to reset current view?")
	l_Discard_convert_project_dialog: STRING_32 is do Result := i18n("Do not ask again, and always convert old projects")
	l_Discard_build_precompile_dialog: STRING_32 is do Result := i18n("Do not ask again, and always build precompile")
	l_Discard_finalize_assertions: STRING_32 is do Result := i18n("Do not ask again, and always discard assertions when finalizing")
	l_Discard_finalize_precompile_dialog: STRING_32 is do Result := i18n("Don't ask me again and always finalize.")
	l_Discard_freeze_dialog: STRING_32 is do Result := i18n("Do not ask again, and always compile C code")
	l_Discard_save_before_compile_dialog: STRING_32 is do Result := i18n("Do not ask again, and always save files before compiling")
	l_Discard_starting_dialog: STRING_32 is do Result := i18n("Don't show this dialog at startup")
	l_Discard_replace_all_warning_dialog: STRING_32 is do Result := i18n("Don't ask me again and always replace all")
	l_Discard_terminate_freezing: STRING_32 is do Result := i18n("Do not ask again, and always terminate freezing when needed.")
	l_Discard_terminate_external_command: STRING_32 is do Result := i18n("Do not ask again, and always terminate running external command.")
	l_Discard_terminate_finalizing: STRING_32 is do Result := i18n("Do not ask again, and always terminate finalizing when needed.")
	l_Display_call_stack_warning: STRING_32 is do Result := i18n("Display a warning when the call stack depth reaches:")
	l_Displayed_buttons_text: STRING_32 is do Result := i18n("Displayed buttons")
	l_Dont_ask_me_again: STRING_32 is do Result := i18n("Do not ask me again")
	l_Do_not_detect_stack_overflows: STRING_32 is do Result := i18n("Do not detect stack overflows")
	l_Do_not_show_again: STRING_32 is do Result := i18n("Do not show again")
	l_Dropped_references: STRING_32 is do Result := i18n("Dropped references")
	l_Dummy: STRING_32 is do Result := i18n("Should not be read")
	l_Not_empty: STRING_32 is do Result := i18n("Generate default feature clauses")
	l_Elements: STRING_32 is do Result := i18n("elements.")
	l_Enter_folder_name: STRING_32 is do Result := i18n("Enter the name of the new folder: ")
	l_error: STRING_32 is do Result := i18n("Error")
	l_Executing_command: STRING_32 is do Result := i18n("Command is currently executing.%NPress OK to ignore the output.")
	l_Execution_interrupted: STRING_32 is do Result := i18n("Execution interrupted")
	l_Exit_application: STRING_32 is
		once
			Result := i18n_comp("Are you sure you want to quit $1?", [Workbench_name])
		end
	l_Exit_warning: STRING_32 is do Result := i18n("Some files have not been saved.%NDo you want to save them before exiting?")
	l_Expanded: STRING_32 is do Result := i18n("expanded")
	l_Explicit_exception_pending: STRING_32 is do Result := i18n("Explicit exception pending")
	l_Exported: STRING_32 is do Result := i18n("exported features")
	l_Expression: STRING_32 is do Result := i18n("Expression")
	l_External: STRING_32 is do Result := i18n("external features")
	l_Feature: STRING_32 is do Result := i18n("Feature:")
	l_Feature_properties: STRING_32 is do Result := i18n("Feature properties")
	l_File_name: STRING_32 is do Result := i18n("File name:")
	l_finalize: STRING_32 is do Result := i18n("Finalize")
	l_Finalized_mode: STRING_32 is do Result := i18n("Finalized mode")
	l_Flat: STRING_32 is do Result := i18n("flat view")
	l_Flatshort: STRING_32 is do Result := i18n("interface view")
	l_freeze: STRING_32 is do Result := i18n("Freeze")
	l_fresh_compilation: STRING_32 is do Result := i18n("Recompile project")
	l_general: STRING_32 is do Result := i18n("General")
	l_Generate_profile_from_rtir: STRING_32 is do Result := i18n("Generate profile from Run-time information record")
	l_Generate_creation: STRING_32 is do Result := i18n("Generate creation procedure")
	l_Homonyms: STRING_32 is do Result := i18n("homonyms")
	l_Homonym_confirmation: STRING_32 is do Result := i18n("Extracting the homonyms%Nmay take a long time.")
	l_Identification: STRING_32 is do Result := i18n("Identification")
	l_Implicit_exception_pending: STRING_32 is do Result := i18n("Implicit exception pending")
	l_Implementers: STRING_32 is do Result := i18n("implementers")
	l_Inactive_subqueries: STRING_32 is do Result := i18n("Inactive subqueries")
	l_Index: STRING_32 is do Result := i18n("Index:")
	l_invariants: STRING_32 is do Result := i18n("invariants")
	l_Language_type: STRING_32 is do Result := i18n("Language type")
	l_Library: STRING_32 is do Result := i18n("library")
	l_Literal_value: STRING_32 is do Result := i18n("Literal Value")
	l_Loaded_project: STRING_32 is do Result := i18n("Loaded project: ")
	l_Located_in: STRING_32 is do Result := i18n(" located in ")
	l_Location_colon: STRING_32 is do Result := i18n("Location: ")
	l_Locals: STRING_32 is do Result := i18n("Locals")
	l_Min_index: STRING_32 is do Result := i18n("Minimum index displayed")
	l_Match_case: STRING_32 is do Result := i18n("Match case")
	l_Max_index: STRING_32 is do Result := i18n("Maximum index displayed")
	l_Max_displayed_string_size: STRING_32 is do Result := i18n("Maximum displayed string size")
	l_More_items: STRING_32 is do Result := i18n("Display limit reached")
	l_Name: STRING_32 is do Result := i18n("Name")
	l_Name_colon: STRING_32 is do Result := i18n("Name:")
	l_New_breakpoint: STRING_32 is do Result := i18n("New breakpoint(s) to commit")
	l_No_feature: STRING_32 is do Result := i18n("Select a fully compiled feature to have information about it.")
	l_No_feature_group_clause: STRING_32 is do Result := i18n("[Unnamed feature clause]")
	l_No_text_text: STRING_32 is do Result := i18n("No text labels")
	l_Not_in_system_no_info: STRING_32 is do Result := i18n("Select a class which is fully compiled to have information about it.")
	l_Not_yet_called: STRING_32 is do Result := i18n("Not yet called")
	l_Object_attributes: STRING_32 is do Result := i18n("Attributes")
	l_On_object: STRING_32 is do Result := i18n("On object")
	l_As_object: STRING_32 is do Result := i18n("As object")
	l_Of_class: STRING_32 is do Result := i18n(" of class ")
	l_Of_feature: STRING_32 is do Result := i18n(" of feature ")
	l_Onces: STRING_32 is do Result := i18n("once routines and constants")
	l_Once_functions: STRING_32 is do Result := i18n("Once routines")
	l_open: STRING_32 is do Result := i18n("Open")
	l_Open_a_project: STRING_32 is do Result := i18n("Open a project")
	l_Open_project: STRING_32 is do Result := i18n("Open project")
	l_Options: STRING_32 is do Result := i18n("Options")
	l_Output_switches: STRING_32 is do Result := i18n("Output switches")
	l_Parent_cluster: STRING_32 is do Result := i18n("Parent cluster")
	l_parents: STRING_32 is do Result := i18n("Parents:")
	l_Path: STRING_32 is do Result := i18n("Path")
	l_Possible_overflow: STRING_32 is do Result := i18n("Possible stack overflow")
	l_precompile: STRING_32 is do Result := i18n("Precompile")
	l_Profiler_used: STRING_32 is do Result := i18n("Profiler used to produce the above record: ")
	l_Project_location: STRING_32 is do Result := i18n("The project location is the place where compilation%Nfiles will be generated by the compiler")
	l_Put_text_right_text: STRING_32 is do Result := i18n("Show selective text on the right of buttons")
	l_Show_all_text: STRING_32 is do Result := i18n("Show text labels")
	l_Query: STRING_32 is do Result := i18n("Query")
	l_remove_project: STRING_32 is do Result := i18n("Remove Project")
	l_Remove_object: STRING_32 is do Result := i18n("Remove")
	l_Remove_object_desc: STRING_32 is do Result := i18n("Remove an object from the tree")
	l_Replace_with: STRING_32 is do Result := i18n("Replace with:")
	l_Replace_with_ellipsis: STRING_32 is do Result := i18n("Replace with...")
	l_Replace_all: STRING_32 is do Result := i18n("Replace all")
	l_Result: STRING_32 is do Result := i18n("Result")
	l_Root_class: STRING_32 is do Result := i18n("Root class name: ")
	l_Root_class_name: STRING_32 is do Result := i18n("Root class: ")
	l_Root_cluster_name: STRING_32 is do Result := i18n("Root cluster: ")
	l_Root_feature_name: STRING_32 is do Result := i18n("Root feature: ")
	l_Routine_ancestors: STRING_32 is do Result := i18n("ancestor versions")
	l_Routine_descendants: STRING_32 is do Result := i18n("descendant versions")
	l_Routine_flat: STRING_32 is do Result := i18n("flat view")
	l_Routines: STRING_32 is do Result := i18n("routines")
	l_Runtime_information_record: STRING_32 is do Result := i18n("Run-time information record")
	l_Same_class_name: STRING_32 is do Result := i18n("---")
	l_Scope: STRING_32 is do Result := i18n("Scope")
	l_Search_backward: STRING_32 is do Result := i18n("Search backwards")
	l_Search_for: STRING_32 is do Result := i18n("Search for:")
	l_Search_options_show: STRING_32 is do Result := i18n("Scope >>")
	l_Search_options_hide: STRING_32 is do Result := i18n("Scope <<")
	l_Search_report_show: STRING_32 is do Result := i18n("Report >>")
	l_Search_report_hide: STRING_32 is do Result := i18n("Report <<")
	l_Set_as_default: STRING_32 is do Result := i18n("Set as default")
	l_Set_slice_limits: STRING_32 is do Result := i18n("Slice limits")
	l_Set_slice_limits_desc: STRING_32 is do Result := i18n("Set which values are shown in special objects")
	l_Short: STRING_32 is do Result := i18n("contract view")
	l_Short_name: STRING_32 is do Result := i18n("Short Name")
	l_Show_all_call_stack: STRING_32 is do Result := i18n("Show all stack elements")
	l_Show_only_n_elements: STRING_32 is do Result := i18n("Show only:")
	l_Showallcallers: STRING_32 is do Result := i18n("Show all callers")
	l_Showcallers: STRING_32 is do Result := i18n("Show static callers")
	l_Showstops: STRING_32 is do Result := i18n("Show stop points")
	l_Slice_taken_into_account1: STRING_32 is do Result := i18n("Warning: Modifications will be taken into account")
	l_Slice_taken_into_account2: STRING_32 is do Result := i18n("for the next objects you will add in the object tree.")
	l_Specify_arguments: STRING_32 is do Result := i18n("Specify arguments")
	l_Stack_information: STRING_32 is do Result := i18n("Stack information")
	l_Stepped: STRING_32 is do Result := i18n("Step completed")
	l_Stop_point_reached: STRING_32 is do Result := i18n("Breakpoint reached")
	l_Sub_cluster: STRING_32 is do Result := i18n("Subcluster")
	l_Sub_clusters: STRING_32 is do Result := i18n("Recursive")
	l_Subquery: STRING_32 is do Result := i18n("Define new subquery")
	l_Suppliers: STRING_32 is do Result := i18n("suppliers")
	l_Switch_num_format: STRING_32 is do Result := i18n("Switch numerical formating")
	l_Switch_num_format_desc: STRING_32 is do Result := i18n("Display numerical value as Hexadecimal or Decimal formating")
	l_Syntax_error: STRING_32 is do Result := i18n("Class text has syntax error")
	l_System_name: STRING_32 is do Result := i18n("System name: ")
	l_System_properties: STRING_32 is do Result := i18n("System properties")
	l_System_running: STRING_32 is do Result := i18n("System running")
	l_System_launched: STRING_32 is do Result := i18n("System launched")
	l_System_not_running: STRING_32 is do Result := i18n("System not running")
	l_Tab_output: STRING_32 is do Result := i18n("Output")
	l_Tab_class_info: STRING_32 is do Result := i18n("Class")
	l_Tab_feature_info: STRING_32 is do Result := i18n("Feature")
	l_Tab_diagram: STRING_32 is do Result := i18n("Diagram")
	l_target: STRING_32 is do Result := i18n("Target")
	l_Text_loaded: STRING_32 is do Result := i18n("Text finished loading")
	l_Text_saved: STRING_32 is do Result := i18n("Text was saved")
	l_Three_dots: STRING_32 is do Result := i18n("...")
	l_Text_loading: STRING_32 is do Result := i18n("Current text is being loaded. It is therefore%Nnot editable nor pickable.")
	l_Toolbar_select_text_position: STRING_32 is do Result := i18n("Text option: ")
	l_Toolbar_select_has_gray_icons: STRING_32 is do Result := i18n("Icon option: ")
	l_Top_level: STRING_32 is do Result := i18n("Top-level")
	l_Type: STRING_32 is do Result := i18n("Type")
	l_Unknown_status: STRING_32 is do Result := i18n("Unknown application status")
	l_Unknown_class_name: STRING_32 is do Result := i18n("Unknown class name")
	l_Use_existing_ace: STRING_32 is do Result := i18n("Open existing Ace (control file)")
	l_Use_existing_profile: STRING_32 is do Result := i18n("Use existing profile: ")
	l_Use_regular_expression: STRING_32 is do Result := i18n("Use regular expression")
	l_Use_wildcards: STRING_32 is do Result := i18n("Use wildcards")
	l_Use_wizard: STRING_32 is do Result := i18n("Create project")
	l_Value: STRING_32 is do Result := i18n("Value")
	l_Whole_project: STRING_32 is do Result := i18n("Whole project")
	l_Whole_word: STRING_32 is do Result := i18n("Whole word")
	l_Windows_only: STRING_32 is do Result := i18n("(Windows only)")
	l_Workbench_mode: STRING_32 is do Result := i18n("Workbench mode")
	l_Working_formatter: STRING_32 is do Result := i18n("Extracting ")
	l_Tab_external_output: STRING_32 is do Result := i18n("External Output")
	l_Tab_C_output: STRING_32 is do Result := i18n("C Output")
	l_Tab_warning_output: STRING_32 is do Result := i18n("Warnings")
	l_Tab_error_output: STRING_32 is do Result := i18n("Errors")
	l_show_feature_from_any: STRING_32 is do Result := i18n("Features from ANY")
	l_show_tooltip: STRING_32 is do Result := i18n("Tooltip")
	h_show_feature_from_any: STRING_32 is do Result := i18n("Show unchanged features from class ANY?")
	h_show_tooltip: STRING_32 is do Result := i18n("Show tooltips?")
	l_class_browser_classes: STRING_32 is do Result := i18n("Class")
	l_class_browser_features: STRING_32 is do Result := i18n("Feature")
	l_version_from: STRING_32 is do Result := i18n("Declared in class")
	l_version_in: STRING_32 is do Result := i18n("Version from class")
	l_branch: STRING_32 is do Result := i18n("Branch #")
	l_version_from_message: STRING_32 is do Result := i18n(" (version from)")
	l_expand_layer: STRING_32 is do Result := i18n("Expand selected level(s)")
	l_collapse_layer: STRING_32 is do Result := i18n("Collapse selected level(s)")
	l_collapse_all_layers: STRING_32 is do Result := i18n("Collapse all selected level(s)")
	l_searching_selected_file: STRING_32 is do Result := i18n("Searching selected file...")
	l_selected_file_not_found: STRING_32 is do Result := i18n("Selected text is not a valid file name or the file cannot be found")
	l_manage_external_commands: STRING_32 is do Result := i18n("Add, remove or edit external commands")
	l_callees: STRING_32 is do Result := i18n("callees")
	l_assignees: STRING_32 is do Result := i18n("assignees")
	l_created: STRING_32 is do Result := i18n("creations")
	l_filter: STRING_32 is do Result := i18n("Filter: ")
	l_viewpoints: STRING_32 is do Result := i18n("Viewpoints: ")
	l_Tab_metrics: STRING_32 is do Result := i18n("Metric")

feature -- Stone names

	s_Class_stone: STRING_32 is do Result := i18n("Class ")
	s_Cluster_stone: STRING_32 is do Result := i18n("Cluster ")
	s_Feature_stone: STRING_32 is do Result := i18n("Feature ")

feature -- Title part

	t_About: STRING_32 is
		once
			Result := i18n_comp("About $1", [Workbench_name])
		end
	t_Add_search_scope: STRING_32 is do Result := i18n("Add Search Scope")
	t_Alias: STRING_32 is do Result := i18n("Alias")
	t_Breakpoints_tool: STRING_32 is do Result := i18n("Breakpoints")
	t_Call_stack_tool: STRING_32 is do Result := i18n("Call Stack")
	t_Calling_convention: STRING_32 is do Result := i18n("Calling Convention")
	t_Choose_ace_file: STRING_32 is do Result := i18n("Choose an Ace File")
	t_Choose_ace_and_directory: STRING_32 is do Result := i18n("Choose Your Ace File and Directory")
	t_Choose_class: STRING_32 is do Result := i18n("Choose a Class")
	t_Choose_directory: STRING_32 is do Result := i18n("Choose Your Directory")
	t_Choose_folder_name: STRING_32 is do Result := i18n("Choose a Folder Name")
	t_Choose_project_and_directory: STRING_32 is do Result := i18n("Choose Your Project Name and Directory")
	t_Class: STRING_32 is do Result := i18n("Class")
	t_Clients_of: STRING_32 is do Result := i18n("Clients of Class ")
	t_Cluster_tool: STRING_32 is do Result := i18n("Clusters")
	t_Context_tool: STRING_32 is do Result := i18n("Context")
	t_Creation_routine: STRING_32 is do Result := i18n("Creation Procedure")
	t_Customize_toolbar_text: STRING_32 is do Result := i18n("Customize Toolbar")
	t_Debugging_tool: STRING_32 is do Result := i18n("Debugging")
	t_Default_print_job_name: STRING_32 is
		once
			Result := i18n_comp("From $1", [Workbench_name])
		end
	t_Deleting_files: STRING_32 is do Result := i18n("Deleting Files")
	t_Dummy: STRING_32 is do Result := i18n("Dummy")
	t_Dynamic_lib_window: STRING_32 is do Result := i18n("Dynamic Library Builder")
	t_Dynamic_type: STRING_32 is do Result := i18n("In Class")
	t_Editor: STRING_32 is do Result := i18n("Editor")
	t_Enter_condition: STRING_32 is do Result := i18n("Enter Condition")
	t_Exported_feature: STRING_32 is do Result := i18n("Feature")
	t_Expression_evaluation: STRING_32 is do Result := i18n("Evaluation")
	t_Extended_explanation: STRING_32 is do Result := i18n("Compilation Error Wizard")
	t_external_command: STRING_32 is do Result := i18n("External Command")
	t_external_commands: STRING_32 is do Result := i18n("External Commands")
	t_External_edition: STRING_32 is do Result := i18n("External Edition")
	t_Favorites_tool: STRING_32 is do Result := i18n("Favorites")
	t_metric_tool: STRING_32 is do Result := i18n("Metrics")
	t_Feature: STRING_32 is do Result := i18n("In Feature")
	t_Feature_properties: STRING_32 is do Result := i18n("Feature Properties")
	t_File_selection: STRING_32 is do Result := i18n("File Selection")
	t_Find: STRING_32 is do Result := i18n("Find")
	t_Index: STRING_32 is do Result := i18n("Index")
	t_New_class: STRING_32 is do Result := i18n("New Class")
	t_New_cluster: STRING_32 is do Result := i18n("Add Cluster")
	t_New_expression: STRING_32 is do Result := i18n("New Expression")
	t_New_project: STRING_32 is do Result := i18n("New Project")
	t_Object_tool: STRING_32 is do Result := i18n("Objects")
	t_Open_backup: STRING_32 is do Result := i18n("Backup Found")
	t_Organize_favorites: STRING_32 is do Result := i18n("Organize Favorites")
	t_Properties_tool: STRING_32 is do Result := i18n("Properties")
	t_Profile_query_window: STRING_32 is do Result := i18n("Profile Query Window")
	t_Profiler_wizard: STRING_32 is do Result := i18n("Profiler Wizard")
	t_Project: STRING_32 is
		once
			Result := Workbench_name
		end
	t_Preference_window: STRING_32 is do Result := i18n("Preferences")
	t_Select_class: STRING_32 is do Result := i18n("Select Class")
	t_Select_cluster: STRING_32 is do Result := i18n("Select Cluster")
	t_Select_feature: STRING_32 is do Result := i18n("Select Feature")
	t_Search_tool: STRING_32 is do Result := i18n("Search")
	t_Select_a_file: STRING_32 is do Result := i18n("Select a File")
	t_Select_a_directory: STRING_32 is do Result := i18n("Select a Directory")
	t_Set_stack_depth: STRING_32 is do Result := i18n("Maximum Call Stack Depth")
	t_Set_critical_stack_depth: STRING_32 is do Result := i18n("Overflow Prevention")
	t_Static_type: STRING_32 is do Result := i18n("From Class")
	t_Starting_dialog: STRING_32 is
		once
			Result := Workbench_name
		end
	t_Slice_limits: STRING_32 is do Result := i18n("Choose New Slice Limits for Special Objects")
	t_System: STRING_32 is do Result := i18n("Project Settings")
	t_Windows_tool: STRING_32 is do Result := i18n("Windows")
	t_Watch_tool: STRING_32 is do Result := i18n("Watch")
	t_Features_tool: STRING_32 is do Result := i18n("Features")
	t_Empty_development_window: STRING_32 is do Result := i18n("Empty Development Tool")
	t_Autocomplete_window: STRING_32 is do Result := i18n("Auto-Complete")
	t_Diagram_class_header: STRING_32 is do Result := i18n("Class Header")
	t_Diagram_set_center_class: STRING_32 is do Result := i18n("Set Center Class")
	t_Diagram_context_depth: STRING_32 is do Result := i18n("Select Depths")
	t_Diagram_link_tool: STRING_32 is do Result := i18n("Link Tool")
	t_Diagram_delete_client_link: STRING_32 is do Result := i18n("Choose Feature(s) to Delete")
	t_Diagram_history_tool: STRING_32 is do Result := i18n("History Tool")

	t_Diagram_move_class_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Move Class '$1'", [a_name])
		end

	t_Diagram_move_cluster_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Move Cluster '$1'", [a_name])
		end

	t_Diagram_move_midpoint_cmd: STRING_32 is do Result := i18n("Move Midpoint")

	t_Diagram_add_cs_link_cmd (client_name, supplier_name: STRING_GENERAL): STRING_32 is
		require
			exists: client_name /= Void	and supplier_name /= Void
		do
			Result := i18n_comp("Add Client-Supplier Relation Between '$1' and '$2'", [client_name, supplier_name])
		end

	t_Diagram_add_inh_link_cmd (ancestor_name, descendant_name: STRING_GENERAL): STRING_32 is
		require
			exists: ancestor_name /= Void and descendant_name /= Void
		do
			Result := i18n_comp("Add Inheritance Relation Between '$1' and '$2'", [ancestor_name, descendant_name])
		end

	t_Diagram_include_class_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Include Class '$1'", [a_name])
		end

	t_Diagram_include_cluster_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Include Cluster '$1'", [a_name])
		end

	t_Diagram_include_library_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Include Library '$1'", [a_name])
		end

	t_Diagram_insert_midpoint_cmd: STRING_32 is do Result := i18n("Insert Midpoint")
	t_Diagram_change_color_cmd: STRING_32 is do Result := i18n("Change Class Color")

	t_Diagram_rename_class_locally_cmd (old_name, new_name: STRING_GENERAL): STRING_32 is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := i18n_comp("Rename Class '$1' Locally to '$2'", [old_name, new_name])
		end

	t_Diagram_rename_class_globally_cmd (old_name, new_name: STRING_GENERAL): STRING_32 is
		require
			exists: old_name /= Void and new_name /= Void
		do
			Result := i18n_comp("Rename Class '$1' Globally to '$2'", [old_name, new_name])
		end

	t_Diagram_delete_client_link_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Delete Client Link '$1'", [a_name])
		end

	t_Diagram_delete_inheritance_link_cmd (an_ancestor, a_descendant: STRING_GENERAL): STRING_32 is
		require
			exists: an_ancestor /= Void and a_descendant /= Void
		do
			Result := i18n_comp("Delete Inheritance Link Between '$1' and '$2'", [an_ancestor, a_descendant])
		end

	t_Diagram_erase_cluster_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Erase Cluster '$1'", [a_name])
		end

	t_Diagram_delete_midpoint_cmd: STRING_32 is do Result := i18n("Erase Midpoint")

	t_Diagram_erase_class_cmd (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Erase Class '$1'", [a_name])
		end

	t_Diagram_erase_classes_cmd: STRING_32 is do Result := i18n("Erase Classes")
	t_Diagram_put_right_angles_cmd: STRING_32 is do Result := i18n("Put Right Angles")
	t_Diagram_remove_right_angles_cmd: STRING_32 is do Result := i18n("Remove Right Angles")
	t_Diagram_put_one_handle_left_cmd: STRING_32 is do Result := i18n("Put Handle Left")
	t_Diagram_put_one_handle_right_cmd: STRING_32 is do Result := i18n("Put Handle Right")
	t_Diagram_put_two_handles_left_cmd: STRING_32 is do Result := i18n("Put Two Handles Left")
	t_Diagram_put_two_handles_right_cmd: STRING_32 is do Result := i18n("Put Two Handles Right")
	t_Diagram_remove_handles_cmd: STRING_32 is do Result := i18n("Remove Handles")
	t_Diagram_zoom_in_cmd: STRING_32 is do Result := i18n("Zoom In")
	t_Diagram_zoom_out_cmd: STRING_32 is do Result := i18n("Zoom Out")
	t_Diagram_zoom_cmd: STRING_32 is do Result := i18n("Zoom")

	t_Diagram_cluster_expand (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Expand cluster '$1'", [a_name])
		end

	t_Diagram_cluster_collapse (a_name: STRING_GENERAL): STRING_32 is
		require
			exists: a_name /= Void
		do
			Result := i18n_comp("Collapse Cluster '$1'", [a_name])
		end

	t_Diagram_disable_high_quality: STRING_32 is do Result := i18n("Disable High Quality")
	t_Diagram_enable_high_quality: STRING_32 is do Result := i18n("Enable High Quality")

	t_first_match_reached: STRING_32 is do Result := i18n("Initial match reached.")
	t_bottom_reached: STRING_32 is do Result := i18n("Bottom reached.")
	t_refactoring_feature_rename: STRING_32 is do Result := i18n("Refactoring: Feature Rename (Compiled Classes)")
	t_refactoring_class_select: STRING_32 is do Result := i18n("Select Class")
	t_refactoring_class_rename: STRING_32 is do Result := i18n("Refactoring: Class Rename")

feature -- Description texts

	e_Add_exported_feature: STRING_32 is do Result := i18n("Add a new feature to this dynamic library definition")
	e_Bkpt_info: STRING_32 is do Result := i18n("Show/Hide information about breakpoints")
	e_Check_exports: STRING_32 is do Result := i18n("Check the validity of the library definition")
	e_Compilation_failed: STRING_32 is do Result := i18n("Eiffel Compilation Failed")
	e_Compilation_succeeded: STRING_32 is do Result := i18n("Eiffel Compilation Succeeded")
	e_freezing_failed: STRING_32 is do Result := i18n("Background Workbench C Compilation Failed")
	e_finalizing_failed: STRING_32 is do Result := i18n("Background Finalized C compilation Failed")
	e_freezing_launch_failed: STRING_32 is do Result := i18n("Background Workbench C Compilation Launch Failed")
	e_finalizing_launch_failed: STRING_32 is do Result := i18n("Background Finalized C Compilation Launch Failed")
	e_freezing_launched: STRING_32 is do Result := i18n("Background Workbench C Compilation Launched")
	e_finalizing_launched: STRING_32 is do Result := i18n("Background Finalized C Compilation Launched")
	e_freezing_succeeded: STRING_32 is do Result := i18n("Background Workbench C Compilation Succeeded")
	e_finalizing_succeeded: STRING_32 is do Result := i18n("Background Finalized C Compilation Succeeded")
	e_freezing_terminated: STRING_32 is do Result := i18n("Background Workbench C Compilation Terminated")
	e_finalizing_terminated: STRING_32 is do Result := i18n("Background Finalized C Compilation Terminated")
	e_C_compilation_failed: STRING_32 is do Result := i18n("Background C Compilation Failed")
	e_C_compilation_launch_failed: STRING_32 is do Result := i18n("Background C Compilation Launch Failed")
	e_C_compilation_terminated: STRING_32 is do Result := i18n("Background C Compilation Terminated")
	e_C_compilication_launched: STRING_32 is do Result := i18n("Background C Compilation Launched")
	e_C_compilation_succeeded: STRING_32 is do Result := i18n("Background C Compilation Succeeded")
	e_C_compilation_running: STRING_32 is do Result := i18n("Background C Compilation in Progress")
	e_Compiling: STRING_32 is do Result := i18n("System is being compiled")
	e_Copy_call_stack_to_clipboard: STRING_32 is do Result := i18n("Copy call stack to clipboard")
	e_Cursor_position: STRING_32 is do Result := i18n("Cursor position (line:column)")
	e_Diagram_hole: STRING is			"Please drop a class or a cluster on this button %N%
										%to view its diagram.%N%
										%Use right click for both pick and drop actions."
	e_Diagram_class_header: STRING is 	"Please drop a class on this button.%NUse right click for both%N%
										%pick and drop actions."
	e_Diagram_remove_anchor: STRING is	"Please drop a class or a cluster with an%Nanchor on this button.%NUse right click for both%N%
										%pick and drop actions."
	e_Diagram_create_class: STRING is	"Please drop this button on the diagram.%N%
										%Use right click for both%Npick and drop actions."
	e_Diagram_delete_figure: STRING is	"Please drop a class, a cluster or a midpoint%N%
										%on this button. Use right click for both%Npick and drop actions."
	e_Diagram_add_class_figure_relations: STRING is "A class figure(s) must either be selected%N%
										%or dropped on this button via right clicking."
	e_Diagram_delete_item: STRING is	"Please drop a class, a cluster or a link%N%
										%on this button. Use right click for both%Npick and drop actions."
	e_Display_error_help: STRING_32 is do Result := i18n("Give help on compilation errors")
	e_Display_system_info: STRING_32 is do Result := i18n("Display information concerning current system")
	e_Drop_an_error_stone: STRING is	"Pick the code of a compilation error (such as VEEN, VTCT,...)%N%
										%and drop it here to have extended information about it."
	e_Edit_exported_feature: STRING_32 is do Result := i18n("Edit the properties of the selected feature")
	e_Edit_expression: STRING_32 is do Result := i18n("Edit an expression")
	e_Edited: STRING_32 is do Result := i18n("Some classes were edited since last compilation")
	e_Exec_debug: STRING_32 is do Result := i18n("Start application and stop at breakpoints")
	e_Exec_kill: STRING_32 is do Result := i18n("Stop application")
	e_Exec_into: STRING_32 is do Result := i18n("Step into a routine")
	e_Exec_no_stop: STRING_32 is do Result := i18n("Start application without stopping at breakpoints")
	e_Exec_out: STRING_32 is do Result := i18n("Step out of a routine")
	e_Exec_step: STRING_32 is do Result := i18n("Execute the application one line at a time")
	e_Exec_stop: STRING_32 is do Result := i18n("Pause application at current point")
	e_History_back: STRING_32 is do Result := i18n("Back")
	e_History_forth: STRING_32 is do Result := i18n("Forward")
	e_Minimize_all: STRING_32 is do Result := i18n("Minimize all windows")
	e_New_context_tool: STRING_32 is do Result := i18n("Open a new context window")
	e_New_dynamic_lib_definition: STRING_32 is do Result := i18n("Create a new dynamic library definition")
	e_New_editor: STRING_32 is do Result := i18n("Open a new editor window")
	e_New_expression: STRING_32 is do Result := i18n("Create a new expression")
	e_Not_running: STRING_32 is do Result := i18n("Application is not running")
	e_Open_dynamic_lib_definition: STRING_32 is do Result := i18n("Open a dynamic library definition")
	e_Open_file: STRING_32 is do Result := i18n("Open a file")
	e_Open_eac_browser: STRING_32 is do Result := i18n("Open the Eiffel Assembly Cache browser tool")
	e_Paste: STRING_32 is do Result := i18n("Paste")
	e_Paused: STRING_32 is do Result := i18n("Application is paused")
	e_Pretty_print: STRING_32 is do Result := i18n("Display an expanded view of objects")
	e_Print: STRING_32 is do Result := i18n("Print the currently edited text")
	e_Project_name: STRING_32 is do Result := i18n("Name of the current project")
	e_Project_settings: STRING_32 is do Result := i18n("Change project settings, right click to open external editor")
	e_override_scan: STRING_32 is do Result := i18n("Recompile override clusters")
	e_Raise_all: STRING_32 is do Result := i18n("Raise all windows")
	e_Raise_all_unsaved: STRING_32 is do Result := i18n("Raise all unsaved windows")
	e_Redo: STRING_32 is do Result := i18n("Redo")
	e_Remove_class_cluster: STRING_32 is do Result := i18n("Remove a class or a cluster from the system")
	e_Remove_exported_feature: STRING_32 is do Result := i18n("Remove the selected feature from this dynamic library definition")
	e_Remove_expressions: STRING_32 is do Result := i18n("Remove selected expressions")
	e_Remove_object: STRING_32 is do Result := i18n("Remove currently selected object")
	e_Running: STRING_32 is do Result := i18n("Application is running")
	e_Running_no_stop_points: STRING_32 is do Result := i18n("Application is running (ignoring breakpoints)")
	e_Save_call_stack: STRING_32 is do Result := i18n("Save call stack to a text file")
	e_Save_dynamic_lib_definition: STRING_32 is do Result := i18n("Save this dynamic library definition")
	e_Show_class_cluster: STRING_32 is do Result := i18n("Locate currently edited class or cluster")
	e_Send_stone_to_context: STRING_32 is do Result := i18n("Synchronize context")
	e_Separate_stone: STRING_32 is do Result := i18n("Unlink the context tool from the other components")
	e_Set_stack_depth: STRING_32 is do Result := i18n("Set maximum call stack depth")
	e_Shell: STRING_32 is do Result := i18n("Send to external editor")
	e_Switch_num_format_to_hex: STRING_32 is do Result := i18n("Switch to hexadecimal format")
	e_Switch_num_format_to_dec: STRING_32 is do Result := i18n("Switch to decimal format")
	e_Switch_num_formating: STRING_32 is do Result := i18n("Hexadecimal/Decimal formating")
	e_Toggle_state_of_expressions: STRING_32 is do Result := i18n("Enable/Disable expressions")
	e_Toggle_stone_management: STRING_32 is do Result := i18n("Link or not the context tool to other components")
	e_Undo: STRING_32 is do Result := i18n("Undo")
	e_Up_to_date: STRING_32 is do Result := i18n("Executable is up-to-date")
	e_Unify_stone: STRING_32 is do Result := i18n("Link the context tool to the other components")
	e_Terminate_c_compilation: STRING_32 is do Result := i18n("Terminate current C compilation in progress")

	e_Dbg_exception_handler: STRING_32 is do Result := i18n("Exception handling")
	e_Dbg_assertion_checking: STRING_32 is do Result := i18n("Disable or restore Assertion checking handling during debugging")

	e_open_selection_in_editor: STRING_32 is do Result := i18n("Open selected file name in specified external editor")
	e_save_c_compilation_output: STRING_32 is do Result := i18n("Save C Compilation output to file")
	e_go_to_w_code_dir: STRING_32 is do Result := i18n("Go to W_code directory of this system, or right click to open W_code in specified file browser")
	e_go_to_f_code_dir: STRING_32 is do Result := i18n("Go to F_code directory of this system, or right click to open F_code in specified file browser")
	e_f_code: STRING_32 is do Result := i18n("F_code")
	e_w_code: STRING_32 is do Result := i18n("W_code")
	e_no_text_is_selected: STRING_32 is do Result := i18n("No file name is selected.")
	e_selected_text_is_not_file: STRING_32 is do Result := i18n("Selected text is not a correct file name.")
	e_external_editor_not_defined: STRING_32 is do Result := i18n("External editor not defined")
	e_external_command_is_running: STRING_32 is do Result := i18n("An external command is running now. %NPlease wait until it exits.")
	e_external_command_list_full: STRING_32 is do Result := i18n("Your external command list is full.%NUse Tools->External Command... to delete one.")
	e_working_directory_invalid: STRING_32 is do Result := i18n("Cannot change to directory ")
	e_external_command_not_launched: STRING_32 is do Result := i18n("External command not launched.")
	e_refactoring_undo_sure: STRING_32 is do Result := i18n("Are you sure you want to undo the refactoring?%N If classes have been modified since the refactoring this can lead to corrupt classes and lost information!")
	e_refactoring_redo_sure: STRING_32 is do Result := i18n("Are you sure you want to redo the refactoring?%N If classes have been modified since the undo of the refactoring this can lead to corrupt classes and lost information!")
feature -- Wizard texts

	wt_Profiler_welcome: STRING_32 is do Result := i18n("Welcome to the Profiler Wizard")
	wb_Profiler_welcome: STRING is
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
				%To continue, click Next."

	wt_Compilation_mode: STRING_32 is do Result := i18n("Compilation mode")
	ws_Compilation_mode: STRING_32 is do Result := i18n("Select the Compilation mode.")

	wt_Execution_Profile: STRING_32 is do Result := i18n("Execution Profile")
	ws_Execution_Profile: STRING_32 is do Result := i18n("Reuse or Generate an Execution Profile.")
	wb_Execution_Profile: STRING is
			"You can generate the Execution Profile from a Run-time Information Record%N%
			%created by a profiler, or you can reuse an existing Execution Profile if you%N%
			%have already generated one for this system."

	wt_Execution_Profile_Generation: STRING_32 is do Result := i18n("Execution Profile Generation")
	ws_Execution_Profile_Generation: STRING_32 is do Result := i18n("Select a Run-time information record to generate the Execution profile")
	wb_Execution_Profile_Generation: STRING is
				"Once an execution of an instrumented system has generated the proper file,%N%
				%you must process it through a profile converter to produce the Execution%N%
				%Profile. The need for the converter comes from the various formats that%N%
				%profilers use to record run-time information during an execution.%N%
				%%N%
				%Provide the Run-time information record produced by the profiler and%N%
				%select the profiler used to create this record.%
				%%N%
				%The Execution Profile will be generated under the file %"profinfo.pfi%"."

	wt_Switches_and_query: STRING_32 is do Result := i18n("Switches and Query")
	ws_Switches_and_query: STRING_32 is do Result := i18n("Select the information you need and formulate your query.")

	wt_Generation_error: STRING_32 is do Result := i18n("Generation Error")
	wb_Click_back_and_correct_error: STRING_32 is do Result := i18n("Click Back if you can correct the problem or Click Abort.")

	wt_Runtime_information_record_error: STRING_32 is do Result := i18n("Runtime Information Record Error")
	wb_Runtime_information_record_error (generation_path: STRING): STRING is
		do
			Result :=
				"The file you have supplied as Runtime Information Record%N%
				%does not exist or is not valid.%N%
				%Do not forget that the Runtime Information Record has to%N%
				%be located in the project directory:%N"
				+ generation_path +
				"%N%N%
				%Please provide a valid file or execute your profiler again to%N%
				%generate a valid Runtime Information Record.%N%
				%%N%
				%Click Back and select a valid file or Click Abort."
		end

	wt_Execution_profile_error: STRING_32 is do Result := i18n("Execution Profile Error")
	wb_Execution_profile_error: STRING is
				"The file you have supplied as existring Execution Provide does%N%
				%not exist or is not valid. Please provide a valid file or generate%N%
				%a new one.%N%
				%Click Back and select a valid file or choose the generate option.";

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
