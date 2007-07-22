indexing
	description: "General Origo workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_WORKITEM

inherit
	EB_ORIGO_CONSTANTS
		export {NONE}
				all
			{ANY}
				out
		redefine
			out
		end

create
	make

feature -- Initialisation

	make is
			-- creation feature
		do
			create creation_time.make (0, 1, 1, 0, 0, 0)
			project := "Not set"
			user := "Not set"
		end


feature -- Access

	workitem_id: INTEGER
		-- workitem id

	type: INTEGER
		-- workitem type

	creation_time: DATE_TIME
		-- date of workitem creation

	project_id: INTEGER
		-- project id

	project: STRING
		-- project name

	user: STRING
		-- user who created workitem

	detailed: BOOLEAN
		-- is the detail data provided?

	type_name: STRING is
			-- returns string representation of `type'
		do
			Result := type.out
		ensure
			not_void: Result /= Void
		end

feature -- Element change

	set_workitem_id (a_id: like workitem_id) is
			-- set `workitem_id'
		do
			workitem_id := a_id
		ensure
			set: workitem_id = a_id
		end

	set_type (a_type: like type) is
			-- set `type'
		do
			type := a_type
		ensure
			set: type = a_type
		end

	set_creation_time (a_date: like creation_time) is
			-- set `creation_time'
		require
			not_void: creation_time /= Void
		do
			creation_time := a_date
		ensure
			set: creation_time = a_date
		end

	set_project_id (a_id: like project_id) is
			-- set `project_id'
		do
			project_id := a_id
		ensure
			set: project_id = a_id
		end

	set_project (a_project: like project) is
			-- set `project'
		require
			not_void: a_project /= Void
		do
			project := a_project.out
		ensure
			set: project.is_equal (a_project)
		end

	set_user (a_user: like user) is
			-- set `user'
		require
			not_void: a_user /= Void
		do
			user := a_user.out
		ensure
			set: user.is_equal (a_user)
		end

	set_detailed (a_boolean: like detailed) is
			--  set `detailed'
		do
			detailed := a_boolean
		ensure
			set: detailed = a_boolean
		end


feature -- Output

	out: STRING is
			-- short string representation
		do
			Result := "Unknown type: " + type.out
		end

	label_text: STRING is
			-- text for detail label
		do
			Result := "Type: " + type_name + " (ID: " + type.out + ")%N"
			Result.append ("Workitem ID: " + workitem_id.out + "%N")
			Result.append ("Creation time: " + creation_time.out + "%N")
			Result.append ("Project: " + project + " (ID: " + project_id.out + ")%N")
			Result.append ("User: " + user)
		ensure
			not_void: Result /= Void
		end

	text_field_text: STRING	is
			-- text of detail text field
		do
			Result := ""
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Implementation


invariant
	creation_time_not_void: creation_time /= Void
	user_not_void: user /= Void
	project_not_void: project /= Void
end
