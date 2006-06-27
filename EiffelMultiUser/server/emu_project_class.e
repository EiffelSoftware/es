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
	make,
	make_with_content

feature -- Creation

	make (a_name: STRING; a_project: EMU_PROJECT; a_creator: EMU_USER) is
			-- create a project unit by its name and the creator.
		do
			Precursor (a_name, a_project, a_creator)
			free := True
			create content.make_empty
		ensure then
			free_set: is_free
		end


	make_with_content (a_name, a_content: STRING; a_project: EMU_PROJECT; a_creator: EMU_USER) is
			-- create a project unit by its name and the creator.
		do
			make (a_name, a_project, a_creator)
			free := True
			content := a_content
		ensure
			free_set: is_free
		end

feature -- Procedures

	set_to_free is
			-- set attribute 'free' to true
		do
			free := True
			current_user := Void
			project.update_persist_storage
		ensure
			free_set: is_free()
			no_current_user: current_user = Void
		end

	set_to_occupied (a_user: EMU_USER) is
			-- set attribute 'free' to false
		require
			a_user_not_void: a_user /= Void
		do
			free:= False
			current_user := a_user
			project.update_persist_storage
		ensure
			occupied_set: not is_free()
			current_user_set: current_user = a_user
		end

	set_content (new_content: STRING) is
			-- change the class content to `new_content'.
		require
			new_content_not_void: new_content /= Void
			class_is_unlocked: not is_free
		do
			content := new_content
			create modification_date.make_now
			modification_user := current_user
			project.update_persist_storage
		ensure
			content_set: content = new_content
		end


feature -- Queries

	is_free: BOOLEAN is
			-- may the client unlock this class?
		do
			result := free
		end

	get_cluster_path: STRING is
			-- compute complete cluster path of current class.
		local
			a_unit: EMU_PROJECT_UNIT
		do
			from
				create Result.make_empty
				a_unit := Current
			until
				a_unit.parent = Void
			loop
				a_unit := a_unit.parent
				Result := "/" + a_unit.name + Result
			end
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

	current_user: EMU_USER
			-- the user who currently has this class locked. Void if noone.


invariant
	content_not_void: content /= Void
	occupied_implies_user: not is_free implies current_user /= Void
	free_implies_nouser: is_free implies current_user = Void
	has_parent_cluster: parent /= Void
end
