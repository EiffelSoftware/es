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

feature -- Access

	workitem_id: INTEGER
		-- workitem id

	type: INTEGER
		-- workitem type

	creation_time: DATE
		-- date of workitem creation

	project_id: INTEGER
		-- project id

	project: STRING
		-- project name

	user: STRING
		-- user who created workitem

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
		do
			if a_project = Void then
				project := Void
			else
				project := a_project.out
			end
		ensure
			set_if_void: a_project = Void implies project = Void
			set_if_not_void: a_project /= Void implies project.is_equal (a_project)
		end

	set_user (a_user: like user) is
			-- set `user'
		do
			if a_user = Void then
				user := Void
			else
				user := a_user.out
			end
		ensure
			set_if_void: a_user = Void implies user = void
			set_if_not_void: a_user /= Void implies user.is_equal (a_user)
		end

feature -- Output

	out_short: STRING is
			-- short string representation
		do
			Result := "Unknown type"
		ensure
			set: Result /= Void
		end

	out: STRING is
			-- redefine
		do
			Result := "Type: " + type_name + "%N"
			Result.append ("Workitem ID: " + workitem_id.out + "%N")
			Result.append ("Project ID: " + project_id.out + "%N")
			Result.append ("Project: " + project + "%N")
			Result.append ("User: " + user + "%N")
			Result.append ("Creation Time: " + creation_time.out)
		end

feature {NONE} -- Implementation

end
