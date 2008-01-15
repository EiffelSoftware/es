indexing
	description:
		"[
			Objects that represent CDD_TREE_VIEW updates.
			They contain the root node of the subtree affected by the update
			and can represent a general change of the subtree, removal or
			the subtree or adding a subtree. The path to the subtree is represented
			as integers in a list.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_NODE_UPDATE

create
	make_added, make_removed, make_changed

feature {NONE} -- Initialization

	make (a_node: like node) is
			-- Initialize `Current'.
		require
			a_node_not_void: a_node /= Void
		do
			create path.make
			node := a_node
		end

	make_added (a_node: like node) is
			-- Initialize `Current' with code `add_code'.
		require
			a_node_not_void: a_node /= Void
		do
			code := add_code
			make (a_node)
		ensure
			added: is_added
		end

	make_removed (a_node: like node) is
			-- Initialize `Current' with code `removed_code'.
		require
			a_node_not_void: a_node /= Void
		do
			code := remove_code
			make (a_node)
		ensure
			removed: is_removed
		end

	make_changed (a_node: like node) is
			-- Initialize `Current' with code `changed_code'.
		require
			a_node_not_void: a_node /= Void
		do
			code := changed_code
			make (a_node)
		ensure
			changed: is_changed
		end

feature -- Access

	path: DS_LINKED_LIST [INTEGER]
			-- Path represented as indexes in the
			-- tree to `node' including the index of `node'

	node: CDD_TREE_NODE
			-- Root node of the subtree beeing
			-- affected by the update

	is_added: BOOLEAN is
			-- Does `Current' notify that `test_routine' has been added to the test suite?
		do
			Result := code = add_code
		ensure
			correct_result: Result = (code = add_code)
		end

	is_removed: BOOLEAN is
			-- Does `Current' notify that `test_routine' has been removed from the test suite?
		do
			Result := code = remove_code
		ensure
			correct_result: Result = (code = remove_code)
		end

	is_changed: BOOLEAN is
			-- Does `Current' notify about a new outcome in `test_routine'?
		do
			Result := code = changed_code
		ensure
			correct_result: Result = (code = changed_code)
		end

	code: INTEGER
			-- Status code

	add_code,
	remove_code,
	changed_code: INTEGER is unique
			-- Available status codes

	is_valid_code (a_code: like code): BOOLEAN is
			-- Is `a_code' a valid code?
		do
			Result :=
				a_code = add_code or
				a_code = remove_code or
				a_code = changed_code
		end

feature -- Element change

	set_node (a_node: like node) is
			-- Set `node' to `a_node'.
		do
			node := a_node
		ensure
			node_set: node = a_node
		end

invariant

	node_not_void: node /= Void
	path_not_void: path /= Void
	valid_code: is_valid_code (code)

end
