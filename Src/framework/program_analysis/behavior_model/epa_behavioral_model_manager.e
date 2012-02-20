note
	description: "Summary description for {EPA_BEHAVIORAL_MODEL_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BEHAVIORAL_MODEL_MANAGER

create
	make

feature -- Initialization

	make (a_directory: DIRECTORY)
			-- Initialization.
		require
			directory_readable: a_directory.is_readable
		do
			model_directory := a_directory
			create models.make_equal (10)
		end

feature -- Basic operation

	model_for_class (a_class: CLASS_C): EPA_BEHAVIORAL_MODEL
			-- Behavioral model for `a_class'.
			-- If no model is available for `a_class', return Void.
		require
			class_attached: a_class /= Void
		do
			if models.has (a_class) then
				Result := models.item (a_class)
			else
				Result := load_model_for_class (a_class)
				models.force (Result, a_class)
			end
		end

feature{NONE} -- Implementation

	load_model_for_class (a_class: CLASS_C): EPA_BEHAVIORAL_MODEL
			-- Load model for class `a_class' from `model_directory'.
			-- Return Void if no model can be loaded for `a_class'.
		require
			class_attached: a_class /= Void
		local
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
			create l_file_name.make_from_string (model_directory.name)
			l_file_name.set_file_name (a_class.name_in_upper)
			l_file_name.add_extension ("txt")
			create l_file.make (l_file_name)
			if l_file.exists then
				create Result.make_from_file (l_file_name)
			end
		end

	model_directory: DIRECTORY
			-- Directory containing the behavioral models.

	models: DS_HASH_TABLE [EPA_BEHAVIORAL_MODEL, CLASS_C]
			-- Behavioral models in memory.

end
