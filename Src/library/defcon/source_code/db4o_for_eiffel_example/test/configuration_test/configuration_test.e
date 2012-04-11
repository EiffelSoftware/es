indexing
	description: "[
			Class for testing wrapper classes of 
			ICONFIGURATION, IOBJECT_CLASS and IOBJECT_FIELD"
		]"
	author: "Ruihua Jin"
	date: "$Date: 2008/03/18 17:35:00$"
	revision: "$Revision: 1.0$"

class
	CONFIGURATION_TEST

feature

	run is
			-- Run test.
		local
			root: BTREE
			closed: BOOLEAN
		do
			create random.make

			io.put_string ("-----Testing configuration-----")
			io.put_new_line
			open_database
			root := make_tree (0)
			db.store (root)
			close_database

			io.put_string ("*** Testing activation depth ***")
			io.put_new_line
			test_activation_depth

			io.put_string ("*** Testing update depth ***")
			io.put_new_line
			test_update_depth

			io.put_string ("*** Testing delete behavior ***")
			io.put_new_line
			test_delete
		rescue
			if (db /= Void) then
				closed := db.close
			end
		end

feature  -- Test

	test_activation_depth is
			-- Test activation depth.
		local
			config: CONFIGURATION
			r: BTREE
			resultos: IOBJECT_SET
			resultroot, left, right: BTREE
			left_level, right_level: INTEGER
		do
			create r.make_id (ROOT_ID)

			create config.make_global
			--config.activation_depth_integer (7)
			config.object_class ({BTREE}).cascade_on_activate (True)
			--config.object_class ({BTREE}).minimum_activation_depth_integer (7)
			--config.object_class ({BTREE}).maximum_activation_depth (3)
			--config.object_class ({BTREE}).object_field ("left").cascade_on_activate (True)
			--config.object_class ({BTREE}).object_field ("right").cascade_on_activate (True)			
			open_database
			resultos := db.get (r)
			resultroot ?= resultos.next
			from
				left_level := 0
				right_level := 0
				left := resultroot
				right := resultroot
			until
				left = Void and right = Void
			loop
				if (left /= Void) then
					left_level := left_level + 1
					left := left.left
				end
				if (right /= Void) then
					right_level := right_level + 1
					right := right.right
				end
			end
			io.put_string ("activated left level = " + left_level.out + ", right level = " + right_level.out)
			io.put_new_line
			close_database
		end

	test_update_depth is
			-- Modify one node of the tree and then update the modification in the database.
		local
			dr, resr: BTREE
			config: CONFIGURATION
			results: IOBJECT_SET
		do
			create dr.make_id (ROOT_ID)
			create config.make_global
			config.object_class ({BTREE}).cascade_on_activate (True)
			--config.update_depth (3)
			config.object_class ({BTREE}).cascade_on_update (True)
			--config.object_class ({BTREE}).object_field ("left").cascade_on_update (True)
			--config.object_class ({BTREE}).object_field ("right").cascade_on_update (True)
			--config.object_class ({BTREE}).update_depth (3)
			open_database
			results := db.get (dr)
			if (results.has_next) then
				resr ?= results.next
				if (resr /= Void) then
					resr.left.left.right.set_id (200)
					db.set (resr)
				end
			end
			close_database

			open_database
			results := db.get (dr)
			resr ?= results.next
			if (resr.left.left.right.id = 200) then
				io.put_string ("tree node updated.")
			else
				io.put_string ("tree node not updated.")
			end
			io.put_new_line
			close_database
		end

	test_delete is
			-- Test delete behavior.
		local
			dr: BTREE
			config: CONFIGURATION
			results: IOBJECT_SET
		do
			create dr.make_id (ROOT_ID)
			create config.make_global
			--config.object_class ({BTREE}).cascade_on_delete (True)
			config.object_class ({BTREE}).object_field ("left").cascade_on_delete (True)
			config.object_class ({BTREE}).object_field ("right").cascade_on_delete (True)
			open_database
			results := db.get (dr)
			from

			until
				not results.has_next
			loop
				db.delete (results.next)
			end
			create dr.make_id (0)
			results := db.get (dr)
			if (results.count = 0) then
				io.put_string ("all trees deleted.")
			else
				io.put_string (results.count.out + " trees not deleted.")
			end
			io.put_new_line
			close_database
		end


feature  -- Database control

	db: IOBJECT_CONTAINER

	database_file: STRING is "eiffel.db4o"

	open_database is
			-- Open `db' of `database_file'.
		do
			db := {DB_4O_FACTORY}.open_file (database_file)
		end

	close_database is
			-- Close `db'.
		local
			close_result: BOOLEAN
		do
			close_result := db.close
		end


feature {NONE}  -- Implementation

	make_tree (level: INTEGER): BTREE is
			-- Make a binary tree.
		require
			level_not_negative: level >= 0
		local
			node: BTREE
		do
			if (level > TREE_LEVEL) then
				Result := Void
			else
				if (level = 0) then
					create node.make_id (ROOT_ID)
				else
					create node.make_id (random.next (1,100))
				end
				node.set_left (make_tree (level+1))
				node.set_right (make_tree (level+1))
				Result := node
			end
		end

	random: SYSTEM_RANDOM

	ROOT_ID: INTEGER is 123	-- The root of the tree has the ID 123, all the other child nodes have an ID between 1 and 100.
								-- The ROOT_ID constant is introduced for query convenience.
	TREE_LEVEL: INTEGER is 10

end
