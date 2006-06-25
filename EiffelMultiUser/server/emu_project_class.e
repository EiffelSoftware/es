indexing
	description: "A class of a project. Residing in a project cluster."
	author: "Bernhard S. Buss"
	date: "20.june.2006"
	revision: "$Revision$"

class
	EMU_PROJECT_CLASS

inherit
	EMU_PROJECT_UNIT

	redefine
		make
	end


create
	make

feature -- Creation

	make (a_name: STRING; a_creator: EMU_USER) is
			-- create a project unit by its name and the creator.
		do
			Precursor (a_name, a_creator)
			free := True
			-- SET CONTENT
			-- to be implemented...
			-- => do this in feature, which is called in upload...
		ensure then
			free_set: is_free()
		end

feature -- Procedures

	set_to_free() is
			-- set attribute 'free' to true
		do
			free:=True
		ensure
			free_set: is_free()
		end

	set_to_occupied() is
			-- set attribute 'free' to false
		do
			free:= False
		ensure
			occupied_set: not is_free()
		end

	set_content (a_file:RAW_FILE) is
			-- set content of class
		require
			a_file_exists: a_file /= void
		do
			content := a_file
		end
		
		
feature -- Queries

	is_free():BOOLEAN is
			-- may the client unlock this class?
		do
			result:= free
		end


feature -- Content

	content: RAW_FILE
			-- the code content of the class. Represented as a RAW_FILE.


feature -- Attributes

	modification_date: DATE
			-- last date and time of modification.

	modification_user: EMU_USER
			-- user who did the last modification.

	free: BOOLEAN
			-- true <=> class may be unlocked by client
			
	current_user: EMU_USER

end
