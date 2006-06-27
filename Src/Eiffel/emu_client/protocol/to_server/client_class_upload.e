indexing
	description: "Class for uploading a class"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CLASS_UPLOAD

inherit
	EMU_CLIENT_MESSAGE
create
	make

feature --Initialization

	make(a_project_name, an_abs_path, a_location,a_class_name:STRING) is
			-- initialize message and set attributes
			-- an_abs_path = absolute path on local machine
			-- a_location = location of project folder on local machine
		require
			a_project_name_not_void : a_project_name /= void
			an_abs_path_not_void: an_abs_path /= void
			an_abs_path_not_empty: not an_abs_path.is_empty
		do
			project_name := a_project_name
			content := file_to_string(an_abs_path)
			parse_path (an_abs_path, a_location)
			create emu_class_name.make_from_string(a_class_name)


		ensure
			project_name_set: a_project_name = project_name
			content_not_void: content /= void
			emu_class_name_not_void: emu_class_name /= void
			cluster_path_not_void: cluster_path /= void
		end

feature -- Attributes

	emu_class_name:STRING

	content: STRING

	cluster_path: STRING

feature {NONE} -- Implementation

	file_to_string (a_file_path: STRING): STRING is
			-- retrieve the content of the source code file and store it in a string
		require
			a_file_path_not_void: a_file_path /= void
			a_file_path_not_empty: not a_file_path.is_empty
		local
			file: RAW_FILE
			source: STRING
			file_name: FILE_NAME
		do
			create file_name.make_from_string (a_file_path)
			if file_name.is_valid() then
				create file.make (file_name)
			end
			if file.exists then
				file.open_read
				file.read_stream(file.count)
				file.close
				source:=file.last_string
				Result:=source
			end
		end

	parse_path (a_file_path, a_location: STRING) is
			-- parse absolute path and return cluster_path and emu_class_name
			-- a_location= path to project folder
		require
			a_file_path_not_void: a_file_path /= void
			a_file_path_not_empty: not a_file_path.is_empty
		local
			pos: INTEGER -- position start
			c: INTEGER -- position upper bound

		do
			c:=a_file_path.count
			pos:= 1+ a_file_path.last_index_of('/',c)
			c:=pos - 1
			pos := 1 + a_location.count
			create cluster_path.make_empty
			cluster_path.set(a_file_path,pos,c)
			if(cluster_path.is_equal ("/")) then
				cluster_path := "/root_cluster"
			end
		end


end
