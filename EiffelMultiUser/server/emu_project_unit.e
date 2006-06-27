indexing
	description: "Used to define a unit of an emu project. Namely clusters or classes."
	author: "Bernhard S. Buss"
	date: "20.june.2006"
	revision: "$Revision$"

deferred class
	EMU_PROJECT_UNIT


feature -- Creation

	make (a_name: STRING; a_project: EMU_PROJECT; a_creator: EMU_USER) is
			-- create a project unit by its name and the creator.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
			a_creator_valid: a_creator /= Void
		do
			name := a_name
			create creation_date.make_now
			creator := a_creator
			project := a_project
		ensure
			name_set: name = a_name
			creator_set: creator = a_creator
			project_set: a_project = project
		end


feature -- Modification

	set_parent (a_parent: EMU_PROJECT_CLUSTER) is
			-- set a parent of this unit.
		do
			parent := a_parent
		ensure
			parent_set: parent = a_parent
		end


feature -- Attributes

	name: STRING
			-- unit name. e.g. cluster name or class name.

	creation_date: DATE
			-- date and time of creation.

	creator: EMU_USER
			-- the creator of this unit.

	parent: EMU_PROJECT_CLUSTER
			-- parent cluster of this unit. if void then current is a head-cluster.

	project: EMU_PROJECT
			-- the project which this unit belongs to.


invariant
	name_set: name /= Void and then not name.is_empty
	creation_date_set: creation_date /= Void
	creator_set: creator /= Void
	project_associated: project /= Void
end
