indexing
	description: "Origo constants"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_CONSTANTS

feature -- Workitem Types

	Workitem_type_issue: INTEGER is 1
	Workitem_type_release: INTEGER is 2
	Workitem_type_commit: INTEGER is 3
	Workitem_type_wiki: INTEGER is 4
	Workitem_type_blog: INTEGER is 5

feature -- Workitem grid column order

	Column_index_date: INTEGER is 1
	Column_index_project: INTEGER is 2
	Column_index_user: INTEGER is 3
	Column_index_type: INTEGER is 4
	Column_index_text: INTEGER is 5

end
