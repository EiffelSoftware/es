indexing
	description: "Constants for warning messages."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	conventions: "w_: Warning message"
	date: "$Date$"
	revision: "$Revision$"

class
	WARNING_MESSAGES

inherit
	SHARED_I18N_LOCALIZATOR
	PRODUCT_NAMES
		export
			{NONE} workbench_name
		end

feature -- Project file/directory warnings

	w_Select_project_to_load: STRING_32 is
		do
			i18n("Please select a project in the list or Click%N%
			%on the %"Browse%" button to open a project.")
		end

	w_Select_project_to_create: STRING_32 is
		do
			i18n("Please select the kind of project you want to create.")
		end

	w_Cannot_open_project: STRING_32 is
		do
			Result := i18n("Project is not readable. Check permissions.")
		end

	w_Cannot_create_project_directory (dir_name: STRING_32): STRING_32 is
		require
--			create Result.make (128)?
			dir_name_not_void: dir_name /= Void
		do
			Result := i18n_comp("Cannot create project directory in: $1%NYou may try again after fixing the permissions.",[dir_name])
		end

	w_Project_directory_not_exist (file_name, dir_name: STRING_32): STRING_32 is
			-- Error message when something is missing in the Project directory.
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (256)?
			Result := i18n_comp("%NCannot open project `$1'.%N%NMake sure you have a complete EIFGEN directory in `$2'.",[file_name,dir_name])
		end

	w_Cannot_compile: STRING_32 is
		do
			Result := i18n("Read-only project: cannot compile.")
		end

	w_Project_exists (dir_name: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (128)?
			Result := i18n_comb ("In `$1' an Eiffel project already exists.%NDo you wish to overwrite it?",[dir_name])
		end

	w_Project_corrupted (dir_name: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (30)
			Result := i18n_comp ("Prokect in: $1%Nis corrupted. Cannot continue.",[dir_name])
		end

	w_Project_incompatible (dir_name: STRING_32; comp_version, incomp_version: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void
			valid_version: comp_version /= Void and then incomp_version /= Void
		do
--			create Result.make (30)? --In both if
			if incomp_version.is_empty then
				Result := i18n_comp ("No version information about project found in:%N$1.",[dir_name])
			else
				Result := i18n_comp ("Incompatible version for project compiled in: $1.%N$2 version is $3.%NProject was compiled with version $4.",
									[dir_name, Workbench_name, comp_version, incomp_version])
			end
		end

	w_Project_incompatible_version (dir_name: STRING_32; comp_version, incomp_version: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void and then not dir_name.is_empty
			valid_comp_version: comp_version /= Void and then not comp_version.is_empty
			valid_incomp_version: incomp_version /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("Incompatible version for project compiled in: $1.%N%
								 %$2 version is $3.%NProject was compiled with version $4.%N%N%
								 %Click OK to convert this project to version $3.%N",
								 [dir_name, Workbench_name, comp_version, incomp_version])
		end

	w_Project_interrupted (dir_name: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("Retrieving project in: $1%Nwas interrupted. Cannot continue.",[dir_name])
		end

	w_no_compilable_target: STRING_32 is
			-- Error when no compilable target was found.
		do
			Result := i18n ("Cannot compile project: no valid target found.")
		end

	w_None_system: STRING_32 is
		do
			Result := i18n ("A system whose root class is NONE is not runnable.")
		end

feature -- File warnings

	w_Cannot_create_file (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
			Result := i18n_comp ("Cannot create file:%N$1.",[file_name])
		end

	w_Cannot_create_directory (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("Cannot create directory:%N$1.",[file_name])
		end

	w_Cannot_read_file (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (file_name.count + 25)
			Result := i18m_comp ("File: '$1' cannot be read.",[file_name])
		end

	w_cannot_read_ace_file_from_epr (epr_name, file_name: STRING_32): STRING_32 is
		require
			epr_name_not_void: epr_name /= Void
		do
--			create Result.make (50)?
			if file_name = Void then
				Result := i18n_comp ("Cannot read Ace file from configuration file '$1'.",[epr_name])
			else
				Result := i18n_comp ("Ace file: '$1'%N%
									  %referenced from configuration file: '$2' cannot be read.", [file_name, epr_name])
			end
			Result.append (i18n ("%NSelect a 5.6 or older version of an Eiffel project."))
		end

	w_Cannot_read_file_retry (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
			Result := i18n_comp ("$1. Try again?", [w_Cannot_read_file (file_name)])
		end

	w_file_not_exist (f_name: STRING_32): STRING_32 is
			-- Error message when `f_name' does not exist.
		require
			f_name_not_void: f_name /= Void
		do
--			create Result.make (128)?
			Result := i18n_comp ("File: $1%Ndoes not exist.",[f_name])
		end

	w_File_does_not_exist_execution_impossible: STRING_32 is
		do
			Result := i18n (" does not exist.%NExecution impossible.%N")
		end

	w_Directory_not_exist (dir_name: STRING_32): STRING_32 is
			-- Error message when a directory does not exist.
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (128)?
			Result := i18n_comp ("Directory $1%Ndoes not exist.",[dir_name])
		end

	w_Not_a_plain_file (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("$1%Nis not a plain file.",[file_name])
		end

	w_Not_creatable (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("File: $1 cannot be created.%NPlease check permissions.",[file_name])
		end

	w_Not_writable (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("File: $1%Nis not writable.%NPlease check permissions.",[file_name])
		end

	w_Still_referenced (a_class_name: STRING_32; referenced_classes: STRING_32): STRING_32 is
		require
			a_class_name_not_void: a_class_name /= Void
			referenced_classes_not_void: referenced_classes /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("Can't delete class $1 because it is referenced by%N%
								  %$2%N%N%
								  %If this is not the case recompile the system and try again.",
								  [a_class_name, referenced_classes])
		end

	w_File_modified_by_another_editor: STRING_32 is
		do
			Result := i18n ("This file has been modified by another editor.")
		end

	w_File_exists (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("File: $1 already exists.%NDo you wish to overwrite it?",[file_name])
		end

	w_File_exists_edit_it (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("File: $1 already exists.%NDo you wish to edit it?",[file_name])
		end

	w_Not_a_directory (dir_name: STRING_32): STRING_32 is
		require
			dir_name_not_void: dir_name /= Void
		do
--			create Result.make (30)?
			Result := i18n_comp ("$1%Nis not a directory.",[dir_name])
		end

	w_Not_a_file (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
--			create Result.make (file_name.count + 18)?
			Result := i18n_comp ("'$1' is not a file.",[file_name])
		end

	w_Not_a_file_retry (file_name: STRING_32): STRING_32 is
		require
			file_name_not_void: file_name /= Void
		do
			Result := i18n_comp ("$1. Try again?",[file_name])
		end

	w_Cannot_open_any_file: STRING_32 is
			-- An attempt was made to open a file that does not correspond to a class in the universe.
		do
			Result := i18n ("Only files representing known%N%
							%classes can be opened.")
		end


feature -- Project settings warnings

	w_cluster_with_name_exists: STRING_32 is
		do
			Result := i18n ("A cluster with this name already exists. Please use another name.")
		end

	w_cluster_name_not_valid: STRING_32 is
		do
			Result := i18n ("Cluster name is not valid.")
		end

	w_cluster_path_not_valid: STRING_32 is
		do
			Result := i18n ("Cluster path is not valid.")
		end

feature -- Debug warnings

	w_Cannot_debug: STRING_32 is
		do
			Result := i18n ("Current version of system has not been successfully compiled.%N%
						%Cannot use debugging facilities.")
		end

	w_Debug_not_compiled: STRING_32 is
			-- The user tries to launch an application that is not fully compiled.
		do
			Result := i18n ("The last compilation was not complete.%N%
							%Running the last compiled application in these conditions%N%
							%may lead to inconsistent information, or to an unexpected behavior.")
		end

	w_Removed_class_debug: STRING_32 is
			-- The user tries to launch an application from which classes were removed.
		do
			Result := i18n ("Classes were manually removed since last compilation.%N%
							%Running the last compiled application in these conditions%N%
							%may lead to inconsistent information, or to an unexpected behavior.")
		end

	w_Invalid_working_directory (wd: STRING_32): STRING_32 is
			-- Message when working directory is incorrect.
		require
			wd_not_void: wd /= Void
		do
			Result := i18n_comp ("Could not launch system in %"$1%".",[wd])
		end

	w_Not_a_condition (expr: STRING_32): STRING_32 is
			-- Message when an expression is not a condition.
		require
			expr_not_void: expr /= Void
		do
			Result := i18n_comp ("%'$1%' is not a condition.",[expr])
		end

	w_Invalid_address (addr: STRING_32): STRING_32 is
			-- Message when an address does not correspond to an object.
		require
			addr_not_void: addr /= Void
		do
			if addr.is_empty then
				Result := i18n ("Please enter a valid address.")
			else
				Result := i18n_comp ("%'$1%' is not a valid address.%N%
				   					  %Addresses only make sense while an application is stopped.",[addr])
			end
		end

	w_Overflow_detected: STRING_32 is
		do
			Result := i18n ("Possible stack overflow detected.%N%
									%The application was paused to let you%N%
									%examine its current status.")
		end

	w_Syntax_error_in_expression (expr: STRING_32): STRING_32 is
			-- Message when an expression has an invalid syntax.
		require
			expr_not_void: expr /= Void
		do
			Result := i18n_comp ("%'$1%' is an invalid or not supported syntax.",[expr])
		end

feature -- Cluster tree warnings

	w_Cannot_move_class: STRING_32 is
			-- A class involved in a move operation could not be moved.
		do
			Result := i18n ("Source file cannot be moved.%N%
							%Please make sure that:%N%
							%the source file exists,%N%
							%the source file is not being edited,%N%
							%the destination directory can be written in.")
		end

	w_Cannot_delete_read_only_class (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
--			create Result.make (100)?
			Result := i18n_comp ("Cannot delete class $1%N%
								  %because it is either precompiled%N%
								  %or in a library cluster.",[class_name])
		end

	w_Cannot_delete_library_cluster (cluster_name: STRING_32): STRING_32 is
		require
			cluster_name_not_void: cluster_name /= Void
		do
--			create Result.make (100)?
			Result.append ("Cannot delete cluster ")
			Result.append (cluster_name.as_upper)
			Result.append ("%Nbecause it is read only.")
		end

	w_Cannot_delete_none_empty_cluster (cluster_name: STRING_32): STRING_32 is
		require
			cluster_name_not_void: cluster_name /= Void
		do
			create Result.make (100)
			Result.append ("Cannot delete cluster ")
			Result.append (cluster_name.as_upper)
			Result.append ("%Nbecause cluster is not empty")
		end

	w_Cannot_add_to_library_cluster (cluster_name: STRING_32): STRING_32 is
		require
			cluster_name_not_void: cluster_name /= Void
		do
			create Result.make (100)
			Result.append ("Cannot add a cluster to cluster%N")
			Result.append (cluster_name.as_upper)
			Result.append ("%Nbecause it is read only.")
		end

	w_Cannot_find_class (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			create Result.make (30)
			Result.append ("Cannot find class ")
			Result.append (class_name.as_upper)
			Result.append (".")
		end

	w_Cannot_find_cluster (cluster_name: STRING_32): STRING_32 is
		require
			cluster_name_not_void: cluster_name /= Void
		do
			create Result.make (30)
			Result.append ("Cannot find cluster ")
			Result.append (cluster_name.as_upper)
			Result.append (".")
		end

	w_Choose_class_or_cluster: STRING_32 is
			-- No class/cluster stone was selected in the development window.
		"Please first select in the editor the class or cluster%Nthat you want to locate."

	w_Class_already_in_cluster (base_name: STRING_32): STRING_32 is
		require
			base_name_not_void: base_name /= Void
		do
			create Result.make (30)
			Result.append ("Class with file name ")
			Result.append (base_name)
			Result.append (" already exists.")
		end

	w_Class_already_exists (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			create Result.make (100)
			Result.append ("Class with name: '")
			Result.append (class_name)
			Result.append ("' already exists.%NPlease select a different class name.")
		end

	w_Class_already_exists_info (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			create Result.make (100)
			Result.append ("Class with name: '")
			Result.append (class_name)
			Result.append ("' already exists.%NDo you want to proceed?")
		end

	w_Enter_path: STRING_32 is "Please enter a folder%Nto receive the new cluster."

	w_Invalid_class_name (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			create Result.make (100)
			if class_name.is_empty then
				Result.append ("An empty class name is not valid.%N")
			else
				Result.append ("'")
				Result.append (class_name)
				Result.append ("' is not a valid class name.%N")
			end
			Result.append ("Class names should only include%N%
						%alphanumeric characters or underscores,%N%
						%and start with an alphabetic character.%N%
						%Please select a different class name.")
		end

	w_Invalid_cluster_name (cluster_name: STRING_32): STRING_32 is
		require
			cluster_name_not_void: cluster_name /= Void
		do
			create Result.make (100)
			if cluster_name.is_empty then
				Result.append ("An empty cluster name is not valid.%N")
			else
				Result.append ("'")
				Result.append (cluster_name)
				Result.append ("' is not a valid cluster name.%N")
			end
			Result.append ("Cluster names should only include %N%
						%alphanumeric characters or underscores,%N%
						%and start with an alphabetic character.%N%
						%Please select a different cluster name.")
		end

	w_Invalid_feature_name (feature_name: STRING_32): STRING_32 is
		require
			feature_name_not_void: feature_name /= Void
		do
			create Result.make (100)
			if feature_name.is_empty then
				Result.append ("An empty feature name is not valid.%N")
			else
				Result.append ("'")
				Result.append (feature_name)
				Result.append ("' is not a valid feature name.%N")
			end
			Result.append ("Feature names should only include %N%
						%alphanumeric characters or underscores,%N%
						%and start with an alphabetic character.%N%
						%Please select a different feature name.")
		end

	w_Clear_breakpoints: STRING_32 is "Forget all breakpoints?"

	w_Cluster_path_already_exists (path: STRING_32): STRING_32 is
		require
			path_not_void: path /= Void
		do
			create Result.make (70);
			Result.append ("Cluster with path ");
			Result.append (path.as_upper);
			Result.append (" already exists in the universe.")
		end;

	w_Cluster_name_already_exists (name: STRING_32): STRING_32 is
		require
			name_not_void: name /= Void
		do
			create Result.make (70);
			Result.append ("Cluster with name ");
			Result.append (name.as_upper);
			Result.append (" already exists in the universe.")
		end;

	w_Confirm_delete_class (class_name: STRING_32): STRING_32 is
		do
			Result := "Class " + class_name + " will be permanently%N%
						%removed from the system and from the disk.%N%N%
						%Are you sure this is what you want?"
		end

	w_Confirm_delete_cluster (cluster_name: STRING_32): STRING_32 is
		do
			Result := "Cluster " + cluster_name + " will be permanently%N%
						%removed from the system.%N%N%
						%Are you sure this is what you want?"
		end

	w_Confirm_delete_cluster_debug (cluster_name: STRING_32): STRING_32 is
		do
			Result := "Stop debug and remove cluster " + cluster_name + " permanently%N%
						%from the system.%N%N%
						%Are you sure this is what you want?"
		end

	w_Cannot_delete_need_recompile: STRING_32 is "Compiled configuration is not up to date, please recompile."


	w_Could_not_locate (cl_name: STRING_32): STRING_32 is
			-- Class/cluster could not be found in the cluster tree.
		do
			Result := "Could not locate " + cl_name + ".%NPlease make sure system is correctly compiled."
		end

	w_Unsufficient_compilation (degree: INTEGER): STRING_32 is
			-- The last or current compilation of the project did not
			-- go through degree `degree', so that a command cannot be executed.
		require
			valid_degree: degree >= -5 and degree <= 6
		do
			Result := "Command cannot be executed unless compilation%N%
						%goes through degree " + degree.out + "."
		end

	w_Project_not_compiled: STRING_32 is
			"Command cannot be executed because the project%N%
			%has never been compiled.%N%
			%Please compile the project before calling this command."

	w_Feature_is_not_compiled: STRING_32 is
			"An error occurred on breakpoints because a feature%N%
			%was not correctly compiled.%N%N%
			%Recompiling the project completely will solve the problem."

	w_Formatter_failed: STRING_32 is
			-- A formatter crashed, most probably because the last compilation was not successful
			-- or because we are compiling.
		"Format could not be generated.%N%
		%Please make sure that the system is not being compiled %
		%and that the last compilation was successful."

	w_Files_not_saved_before_compiling: STRING_32 is
			"Some files have not been saved.%N%
			%Do you want to save them before compiling?%N"

	w_Degree_needed (n: INTEGER): STRING_32 is
			-- A command needs a certain degree during a compilation.
		require
			valid_degree: n >= -5 and n <= 6
		do
			Result := "Command cannot be executed until degree " + n.out + " completed.%N%
						%Please wait until then before calling this command."
		end

	w_Select_parent_cluster: STRING_32 is
			-- User needs to select a cluster in the new cluster dialog.
		"Please select a cluster from the list.%N%
		%A parent cluster is needed."

feature -- Backup warnings

	w_Crashed: STRING_32 is
		once
			Result := "An unexpected error occurred.%N"+
					WorkBench_name+" will now make an attempt to create%N%
						%a backup of the edited files."
		end

	w_Backup_succeeded: STRING_32 is "Backup was successful.%N%
								%Class files were saved with a .swp extension."

	w_Backup_partial (i: INTEGER): STRING_32 is
			-- `i' files could not be saved during a backup.
		do
			Result := i.out
			if i = 1 then
				Result.append ("file")
			else
				Result.append (" files")
			end
			Result.append (" could not be backed up.%N%
					%Other class files were saved with a .swp extension.")
		end

	w_Backup_failed: STRING_32 is "Backup failed for some files.%N%
								%The state of the system was too damaged."

	w_Found_backup: STRING_32 is "A backed up version of the file was found.%N%
							%Do you want to open the original file or the backup file?%N%
							%If you choose the original file, the backup file will be%N%
							%deleted. If choose the backup file, then the original file%N%
							%will be overwritten with the contents of the backup file%N%
							%when you save.%N"

	w_Save_backup: STRING_32 is "You are about to overwrite the original file with%N%
					%the backup file. Previous content will be lost%N%
					%and the backup file deleted."

feature -- Dynamic library warnings

	w_Save_invalid_definition: STRING_32 is
			-- The user tries to save an invalid definition file.
		"There are problems in this library definition.%N%
		%Call 'Check' to have more information.%N%
		%Save anyway?"

	w_Invalid_feature_exportation: STRING_32 is
			-- A feature export is invalid.
		"This feature export clause contains errors.%N%
		%Try editing it to have more information."

	w_Conflicting_exports: STRING_32 is
			-- Some feature exportation clauses have conflicts.
		"Some feature export clauses are conflicting.%N%
		%Please make sure that export clauses do not share%N%
		%either their indices or their exported names."

	w_No_errors_found: STRING_32 is
			-- The export feature definitions seem ok.
		"No errors were found."

	w_Not_a_compiled_class (cl_name: STRING_32): STRING_32 is
			-- The `cl_name' does not represent a valid class.
		do
			if cl_name /= Void then
				Result := "%"" + cl_name + "%"%N%
				%is not a compiled class."
			else
				Result := "Please specify a class name."
			end
		end

	w_Not_a_compiled_class_line (cl_name: STRING_32): STRING_32 is
			-- The `cl_name' does not represent a valid class.
		do
			if cl_name /= Void then
				Result := "%"" + cl_name + "%" %
				%is not a compiled class."
			else
				Result := "Please specify a class name."
			end
		end

	w_Class_cannot_export: STRING_32 is "This class cannot export features.%N%
				%Please make sure that it is neither deferred nor generic%N%
				%and that the system is correctly compiled."

	w_No_exported_feature (f_name, cl_name: STRING_32): STRING_32 is
			-- `f_name' cannot be found in class `cl_name'.
		require
			f_not_void_implies_c_not_void: f_name /= Void implies cl_name /= Void
		do
			if f_name = Void then
				Result := "Please enter a feature name."
			else
				Result := "Class %"" + cl_name + "%"%N%
					%has no feature named %"" + f_name + "%"."
			end
		end

	w_Feature_cannot_be_exported: STRING_32 is "This feature cannot be exported.%N%
				%Deferred features, external ones,%N%
				%and attributes cannot be exported."

	w_No_valid_creation_routine: STRING_32 is
			"No valid creation routine%N%
			%could be found for this class.%N%
			%Please make sure the chosen class%N%
			%has a creation routine taking no argument."

	w_Invalid_parameters: STRING_32 is
			-- The chosen export parameters are invalid.
		"These parameters are invalid."

	w_Invalid_index: STRING_32 is
			-- The chosen index is not valid.
		"Index is out of range.%N%
		%Indices should be positive integers."

	w_Invalid_alias: STRING_32 is
			-- The chosen parameters are not valid.
		"Alias is invalid.%N%
		%Please check that it is a valid C identifier."

	w_Cannot_load_library (fn: STRING_32): STRING_32 is
			-- The library located in file `fn' cannot be read.
		do
			Result := "The file " + fn + "%N%
					%either cannot be read or does not represent%N%
					%a valid dynamic library definition."
		end

	w_Cannot_save_library (fn: STRING_32): STRING_32 is
			-- The library cannot be written in file `fn'.
		do
			Result := "Could not save the library definition to%N" + fn + "."
		end

	w_Error_parsing_the_library_file: STRING_32 is
			-- An error occurred while parsing a .def file.
		"This file seems to be corrupted.%N%
		%Not all items inside could be loaded."

	w_Unsaved_changes: STRING_32 is
			-- The user tries to exit the dialog although some modifications were not saved.
		"This will discard the modifications."

feature -- Ace/Project settings warnings

	w_Could_not_parse_ace: STRING_32 is "An error occurred while parsing the Ace file.%N%
									%Please try using the system configuration tool."

	w_Incorrect_ace_configuration: STRING_32 is "Some values are invalid, %
									%please correct the corresponding entries"

feature -- Profiler messages

	w_Profiler_Bad_query: STRING_32 is
			-- Message displayed when detecting a bad query
		do
			create Result.make (0)
			Result.append ("Please enter a correct query, for example:%N")
			Result.append ("%Tfeaturename = WORD.t*%N")
			Result.append ("%Tfeaturename < WORD.mak?%N")
			Result.append ("%Tcalls > 2%N")
			Result.append ("%Tself <= 3.4%N")
			Result.append ("%Tdescendants in 23 - 34%N")
			Result.append ("%Ttotal >= 12.3%N")
			Result.append ("%Tpercentage /= 2%N")
			Result.append ("%Tcalls > avg%N")
			Result.append ("%Tself <= max%N")
			Result.append ("%Ttotal > min%N")
			Result.append ("%N")
			Result.append ("You can also combine subqueries with 'and' and 'or', for example:%N")
			Result.append ("%Tcalls > 2 and self <= 3.4 or percentage in 2.3 - 3.5")
		end

	w_Profiler_select_one_output_switch: STRING_32 is "Select at least one output switch."

	w_Profiler_select_one_language: STRING_32 is "Select at least one language."

feature -- Project creation, retrieval, ...

	w_Unable_to_retrieve_project: STRING_32 is "Unable to retrieve the project, it may be corrupted."

	w_Fill_in_location_field: STRING_32 is "Please fill in the 'Location' field."

	w_Fill_in_project_name_field: STRING_32 is "Please fill in the 'Project Name' field."

	w_Fill_in_ace_field: STRING_32 is "Please fill in the 'Ace file' field."

	w_Unable_to_load_ace_file (an_ace_name: STRING_32): STRING_32 is
		do
			Result := "Unable to load the ace file `" + an_ace_name + "'."
		end

	w_Unable_to_load_config_file (an_ace_name: STRING_32): STRING_32 is
		do
			Result := "Unable to load the project file `" + an_ace_name + "'."
		end

	w_Invalid_directory_or_cannot_be_created (a_directory_name: STRING_32): STRING_32 is
		do
			Result := "'" + a_directory_name + "' is not a valid directory and/or cannot be created%N%
				%Please choose a valid and writable directory."
		end

feature -- Refactoring

	w_Feature_not_written_in_class: STRING_32 is "Feature is not written in selected class."
	w_Select_class_feature_to_rename: STRING_32 is "Select class or feature to rename."
	w_Select_feature_to_pull: STRING_32 is "Select a feature to pull up."

feature -- Warning messages

	w_Assertion_warning: STRING_32 is
		"By default assertions enabled in the Ace file are kept%N%
		%in final mode.%N%
		%%N%
		%Keeping assertion checking inhibits any optimization%N%
		%specified in the Ace (inlining, array optimization,%N%
		%dead-code removal) and will produce a final executable%N%
		%that is not optimal in speed and size.%N%
		%%N%
		%Are you sure you want to keep the assertions in your%N%
		%finalized executable?"

	w_Backup_file_not_editable: STRING_32 is "Backup file cannot be modified.%NTo edit it, save it first."

	w_Cannot_move_favorite_to_a_child: STRING_32 is
		"Moving a folder to one of its children%N%
		%is not possible."

	w_Cannot_move_feature_alone: STRING_32 is
		"Moving a feature favorite is not supported by the favorite manager."

	w_Class_not_modifiable: STRING_32 is "The text of this class cannot be modified."

	w_could_not_modify_class: STRING_32 is "The text of this class could not be modified."

	w_Could_not_save_all: STRING_32 is "Some files could not be saved.%N%
									%Exit was cancelled."

	w_cannot_save_file (a_file_name: STRING_32): STRING_32 is
		do
			if a_file_name /= Void then
				Result := "Could not save file into '" + a_file_name + "'"
			else
				Result := "Could not save file to specified location."
			end
		end

	w_cannot_convert_file (a_file_name: STRING_32): STRING_32 is
		require
			a_file_name_not_void: a_file_name /= Void
		do
			Result := "Could not convert file '" + a_file_name + "' into new configuration format."
		end

	w_cannot_save_png_file (a_file_name: STRING_32): STRING_32 is
		do
			if a_file_name /= Void then
				Result := "Could not save diagram to " + a_file_name
			else
				Result := "Could not save diagram to specified location."
			end
		end

	w_cannot_generate_png: STRING_32 is "Could not generate PNG file.%NInsufficient video memory."

	w_does_not_have_enclosing_cluster: STRING_32 is "This cluster does not have an enclosing cluster."

	w_No_internet_browser_selected: STRING_32 is "No browser was given in the preferences"

	w_No_url_to_replace: STRING_32 is "There is no $url part in the browser preference.%N%
									%Please fix your preferences."

	w_No_ise_eiffel: STRING_32 is "Environment variable ISE_EIFFEL is not defined."

	w_Page_not_exist: STRING_32 is "The requested page does not exist.%N%
								%Please check your ISE Eiffel installation."

	w_Environment_not_initialized: STRING_32 is "$ISE_EIFFEL is not initialized. Execution impossible%N"

	w_Freeze_warning: STRING_32 is
		"Freezing implies some C compilation and linking.%N%
		% - Click Yes to compile the Eiffel system (including C compilation)%N%
		% - Click No  to compile the Eiffel system (no C compilation)%N%
		% - Click Cancel to abort%N%
		%%N"

	w_Finalize_warning: STRING_32 is
		"Finalizing implies some C compilation and linking.%N%
		% - Click Yes to compile the C code after finalizing the system%N%
		% - Click No  to skip the C compilation (no executable will be generated)%N%
		% - Click Cancel to abort%N%
		%%N"

	w_Load_configuration: STRING_32 is	"An error occurred while loading the %
									%configuration for your profiler.%N%
									%Please check with your system %
									%administrator whether your profiler is %
									%supported.%N"

	w_Ignoring_all_stop_points: STRING_32 is "Application will ignore all breakpoints."

	w_Unknown_cluster_name: STRING_32 is "No cluster in the system has this name.";

	w_Invalid_folder_name: STRING_32 is "Invalid folder name"

	w_Invalid_cluster: STRING_32 is
			-- One of the clusters involved in a move operation was invalid.
		"One of the clusters is invalid.%N%N%
		%Please check that none is precompiled or a library,%N%
		%and that the corresponding directories have sufficient rights."

	w_Makefile_more_recent (make_file: STRING_32): STRING_32 is
		require
			make_file_not_void: make_file /= Void
		do
			create Result.make (30)
			Result.append (make_file)
			Result.append (" is more recent than the system.%N")
			Result.append ("Do you want to compile the generated C code?")
		end

	w_Makefile_does_not_exist (make_file: STRING_32): STRING_32 is
		require
			make_file_not_void: make_file /= Void
		do
			create Result.make (30)
			Result.append (make_file)
			Result.append (" does not exist.%N")
			Result.append ("Cannot invoke C compilation.")
		end

	w_MakefileSH_more_recent: STRING_32 is "The Makefile.SH is more recent than the system."

	w_Must_compile_first: STRING_32 is "You must compile a project first."

	w_Must_finalize_first: STRING_32 is "You must finalize your project first."

	w_No_class_matches: STRING_32 is "No class in any cluster matches this name."

	w_No_cluster_matches: STRING_32 is "No cluster in the system matches this name."

	w_No_feature_matches: STRING_32 is "No feature in this class matches this name."

	w_No_feature_to_display: STRING_32 is "No features in this file"

	w_No_such_feature_in_this_class (feature_name, class_name: STRING_32): STRING_32 is
		do
			Result := "No feature named " + feature_name + " could be found in class " + class_name + "."
		end

	w_No_system_generated: STRING_32 is "No system was generated.%N%
						%Please make sure the C compilation ended correctly."

	w_No_system: STRING_32 is "No system was defined.%NCannot launch the application."

	w_Not_an_integer: STRING_32 is "Please enter an integer value."

	w_Select_class_cluster_to_remove: STRING_32 is "Please select a class or a cluster %N%
										%before calling this command.%N%
										%It will then be removed."

	w_Specify_a_class: STRING_32 is "Please specify a compiled class (or * for all classes)."

	w_Exiting_stops_compilation: STRING_32 is "It is not possible to exit EiffelStudio%N%
											%while the project is being compiled."

	w_Exiting_stops_c_compilation: STRING_32 is "It is not possible to exit EiffelStudio%N%
											%while c compilation is running."

	w_Exiting_stops_external: STRING_32 is "It is not possible to exit EiffelStudio%N%
											%while an external command is running."

	w_Save_before_closing: STRING_32 is "Do you want to save your changes%N%
									%before closing the window?"

	w_Stop_debugger: STRING_32 is "This command will stop the debugger."

	w_Exiting_stops_debugger: STRING_32 is "Exiting will stop the debugger."

	w_Closing_stops_debugger: STRING_32 is "Closing the window will stop the debugger."

	w_Unexisting_system: STRING_32 is "System doesn't exist."

	w_File_changed (class_name: STRING_32): STRING_32 is
		do
			if class_name = Void then
				Result := "File has been modified.%NDo you want to save changes?"
			else
				Result := "Class "+ class_name + " has been modified.%NDo you want to save changes?"
			end
		end

	w_Syntax_error: STRING_32 is "Class has syntax error.%NText will not be clickable.%NSee highlighted area."

	w_Select_object_to_remove: STRING_32 is "Please select a top-level item%N%
										%different from the current object%N%
										%(i.e. the first one) in the object tree%N%
										%to have it removed."

	w_Text_not_editable: STRING_32 is "Current text is not editable."

	w_Class_header_syntax_error (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			Result := "Syntax error in class "
			Result.append (class_name)
		end

	w_Class_syntax_error_before_generation (class_name: STRING_32): STRING_32 is
		require
			class_name_not_void: class_name /= Void
		do
			Result := "Class " + class_name + " has syntax error.%N"
			Result.append ("Code generation cancelled.")
		end

	w_Class_modified_outside_diagram: STRING_32 is "Class was modified outside the diagram.%N%
												%Previous commands are not undoable any longer."

	w_Inheritance_from_any: STRING_32 is "Cannot remove inheritance from ANY."

	w_Class_syntax_error: STRING_32 is "Current class text has a syntax error.%NCode generation was cancelled."

	w_New_feature_syntax_error: STRING_32 is "New feature has syntax error.%NCode generation cancelled."

	w_Wrong_class_name: STRING_32 is "Syntax error in name or generics"

	w_Class_name_changed: STRING_32 is "Class name has changed since last compilation.%NCurrent text will not be clickable.%N%
						%Recompile to make it clickable again."

	w_Unable_to_execute_wizard (wizard_file: STRING_32): STRING_32 is
		do
			Result :=
				"Unable to execute the wizard.%N%
				%Check that `"+wizard_file+"' exists and is executable.%N"
		end

	w_short_internal_error (a_code: STRING_32): STRING_32 is
			-- Short internal error using `a_code'.
		require
			a_code_not_void: a_code /= Void
		do
			Result := "Internal error ("
			Result.append (a_code)
			Result.append ("): Submit bug at http://support.eiffel.com")
		end

	w_Internal_error: STRING_32 is
		"An internal error occurred.%N%N%
		%1 - Check that you have enough space to compile.%N%
		%2 - If this happens even after relaunching the environment%N%
		%     delete your EIFGEN and recompile from scratch.%N%N%
		%Follow the instructions at http://support.eiffel.com/submit.html in%N%
		%order to submit a bug report at http://support.eiffel.com"

	w_Class_already_edited: STRING_32 is "This class is already being edited%N%
										%in another editor.%N%
										%Editing a class in several editors%N%
										%may cause loss of data."
	w_Invalid_options: STRING_32 is "The selected options are invalid.%N%
								%Please select different ones."

	w_Index_already_taken: STRING_32 is "This index is already used.%N%
									%Please select another one."

	w_Command_needs_class: STRING_32 is "This command requires a class name.%N%
									%It cannot be executed."

	w_Command_needs_file: STRING_32 is "This command requires a file name.%N%
									%It cannot be executed."

	w_Command_needs_directory: STRING_32 is "This command requires a directory.%N%
									%It cannot be executed."

	w_Finalize_precompile: STRING_32 is    ".NET precompiled libraries can be finalized to create%N%
									%an optimized version as well as a workbench version.%N%
									%Would you like to create a finalized verion?"

	w_Replace_all: STRING_32 is "This operation can not be undone %N%
									%to files not loaded to the editor.%N%
									%Would you like to continue replacing all?"

	w_No_system_defined: STRING_32 is "No system was defined.%N"

	w_Finalizing_running: STRING_32 is "Finalizing is in progress, start Eiffel compilation%N%
								    %may terminate current finalizing.%NContinue?"

	w_Freezing_running: STRING_32 is "Freezing is in progress, start Eiffel compilation%N%
								  %may terminate currernt freezing.%NContinue?"

	w_cannot_clear_when_c_compilation_running: STRING_32 is "Please clear this window after c compilation has exited."
	w_cannot_save_when_c_compilation_running: STRING_32 is "Please save output after c compilation has exited."
	w_cannot_clear_when_external_running: STRING_32 is "Please clear this window after external command has exited."
	w_cannot_save_when_external_running: STRING_32 is "Please save output after external command has exited."
	w_external_command_running_in_development_window: STRING_32 is "An external command is running, close this window will terminate it.%NContinue?";

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

end -- class WARNING_MESSAGES
