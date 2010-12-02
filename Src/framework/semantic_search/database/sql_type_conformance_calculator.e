note
	description: "Class to calculate type conformance relations"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_TYPE_CONFORMANCE_CALCULATOR

inherit
	SEM_SHARED_EQUALITY_TESTER

	ETR_CONTRACT_TOOLS

create
	make,
	make_empty

feature{NONE} -- Initialization

	make (a_types: like types; a_conformance: like conformance)
			-- Initialize Current.
		require
			a_types_valid: a_types.for_all (agent {SQL_TYPE}.is_id_set)
		local
			l_cursor: DS_HASH_SET_CURSOR [SQL_TYPE]
			l_set: DS_HASH_SET [SQL_TYPE]
			l_con_cur: like conformance.new_cursor
		do
			make_empty

				-- Initialize `types'.
			from
				l_cursor := a_types.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				types.force_last (l_cursor.item)
				if l_cursor.item.id > maximal_type_id then
					maximal_type_id := l_cursor.item.id
				end
				l_cursor.forth
			end

				-- Initialize `conformance'.
			from
				l_con_cur := a_conformance.new_cursor
				l_con_cur.start
			until
				l_con_cur.after
			loop
				create l_set.make (l_con_cur.item.count + 20)
				l_set.set_equality_tester (sql_type_equality_tester)
				l_set.append (l_con_cur.item)
				conformance.force_last (l_set, l_con_cur.key)
				l_con_cur.forth
			end

		end

	make_empty
			-- Initialize Current with nothing.
		do
			create types.make (1000)
			types.set_equality_tester (sql_type_equality_tester)

			create conformance.make (500)
			conformance.set_key_equality_tester (sql_type_equality_tester)

			create added_types.make (200)
			added_types.set_equality_tester (sql_type_equality_tester)

			create added_conformance.make (500)
			added_conformance.set_key_equality_tester (sql_type_equality_tester)

			create type_added_actions.make
			create conformance_added_actions.make

		end

feature -- Access

	types: DS_HASH_SET [SQL_TYPE]
			-- Types maintained in Current.

	conformance: DS_HASH_TABLE [DS_HASH_SET [SQL_TYPE], SQL_TYPE]
			-- Conformance relation
			-- Key is a type, value is the list of types that the type conformances to

	added_types: like types
			-- New types added through `add_type'

	added_conformance: like conformance
			-- New conformance relations added through `add_type'

	dumped_types_and_conformance: STRING
			-- Dumped string for `types' and `conformance'
		do
			Result := dumped (types, conformance)
		end

	dumped_added_types_and_conformance: STRING
			-- Dumped string for `added_types' and `added_conformance'
		do
			Result := dumped (added_types, added_conformance)
		end

	type_added_actions: ACTION_SEQUENCE [TUPLE [a_type: SQL_TYPE]]
			-- Actions to be performed if a type is added to added_types

	conformance_added_actions: ACTION_SEQUENCE [TUPLE [a_conformant_type, a_type: SQL_TYPE]]
			-- Actions to be performed if a conformance is added to added_conformances

feature -- Basic operations

	add_type (a_type: SQL_TYPE)
			-- Add a_type' into Current.
		local
			l_new_type: SQL_TYPE
			l_ancestor: CLASS_C
			l_ancestor_type: SQL_TYPE
		do
			types.search (a_type)
			if not types.found then
				maximal_type_id := maximal_type_id + 1
				create l_new_type.make_with_context_class (a_type.type, maximal_type_id, a_type.context_class)
				types.force_last (l_new_type)
				added_types.force_last (l_new_type)
				type_added_actions.call ([l_new_type])
				add_conformance (l_new_type, l_new_type)
			else
				l_new_type := types.found_item
			end

			if l_new_type.has_associated_class then
				add_conformance (l_new_type, l_new_type)
					-- Iterate through all ancestor classes to get types that conform to `l_new_type'.
				across ancestors (l_new_type.associated_class) as l_ancestors loop
					l_ancestor := l_ancestors.item
					create l_ancestor_type.make_with_context_class (l_ancestor.constraint_actual_type, 0, a_type.context_class)

					if not types.has (l_ancestor_type) then
							-- We don't have this ancestor type, so add it into Current.
						maximal_type_id := maximal_type_id + 1
						l_ancestor_type.set_id (maximal_type_id)
						types.force_last (l_ancestor_type)
						added_types.force_last (l_ancestor_type)
						type_added_actions.call ([l_ancestor_type])
					end
					add_conformance (l_new_type, l_ancestor_type)
				end
			end
		end

feature{NONE} -- Implementation

	maximal_type_id: INTEGER
			-- Maximal type id seen so far

	add_conformance (a_type: SQL_TYPE; a_conformant_type: SQL_TYPE)
			-- Add the information that `a_type' conforms to `a_conformant_type' into Current.
		require
			a_type_exists: types.has (a_type)
			a_conformant_type_exists: types.has (a_conformant_type)
		local
			l_conformance_exists: BOOLEAN
			l_set: DS_HASH_SET [SQL_TYPE]
		do
			l_conformance_exists := True
			conformance.search (a_conformant_type)
			if conformance.found then
				l_set := conformance.found_item
			else
				l_conformance_exists := False
				create l_set.make (50)
				l_set.set_equality_tester (sql_type_equality_tester)
				conformance.force_last (l_set, a_conformant_type)
			end
			if not l_set.has (a_type) then
				l_conformance_exists := False
				l_set.force_last (a_type)
			end

			if not l_conformance_exists then
				added_conformance.search (a_conformant_type)
				if added_conformance.found then
					l_set := added_conformance.found_item
				else
					create l_set.make (50)
					l_set.set_equality_tester (sql_type_equality_tester)
					added_conformance.force_last (l_set, a_conformant_type)
				end
				if not l_set.has (a_type) then
					l_set.force_last (a_type)
					conformance_added_actions.call ([a_conformant_type, a_type])
				end
			end
		end

	dumped (a_types: like types; a_conformance: like conformance): STRING
			-- Test representation of Current.
		local
			l_types_cursor: like types.new_cursor
			l_con_cursor: like conformance.new_cursor
		do
			create Result.make (1024 * 10)
			Result.append (once "Types:%N%T")
			from
				l_types_cursor := a_types.new_cursor
				l_types_cursor.start
			until
				l_types_cursor.after
			loop
				Result.append (l_types_cursor.item.name)
				Result.append_character ('(')
				Result.append (l_types_cursor.item.id.out)
				Result.append_character (')')
				Result.append_character (';')
				Result.append_character (' ')
				l_types_cursor.forth
			end
			Result.append_character ('%N')

			Result.append (once "Conformance:%N")
			from
				l_con_cursor := a_conformance.new_cursor
				l_con_cursor.start
			until
				l_con_cursor.after
			loop
				Result.append_character ('%T')
				Result.append (l_con_cursor.key.name)
				Result.append_character ('(')
				Result.append (l_con_cursor.key.id.out)
				Result.append_character (')')
				Result.append_character (':')
				Result.append_character (' ')
				Result.append_character (' ')
				from
					l_types_cursor := l_con_cursor.item.new_cursor
					l_types_cursor.start
				until
					l_types_cursor.after
				loop
					Result.append (l_types_cursor.item.name)
					Result.append_character ('(')
					Result.append (l_types_cursor.item.id.out)
					Result.append_character (')')
					Result.append_character (';')
					Result.append_character (' ')
					l_types_cursor.forth
				end
				Result.append_character ('%N')
				l_con_cursor.forth
			end
		end

end
