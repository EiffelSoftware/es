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

feature -- Queries

	is_free():BOOLEAN is
			-- may the client unlock this class?
		do
			result:= free
		end


feature -- Content

	content: STRING
			-- the code content of the class. Represented as a long string.


feature -- Attributes

	modification_date: DATE
			-- last date and time of modification.

	modification_user: EMU_USER
			-- user who did the last modification.

	free: BOOLEAN
			-- true <=> class may be unlocked by client

end
