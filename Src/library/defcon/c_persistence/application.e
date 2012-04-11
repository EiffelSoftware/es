indexing
	description: "Project root class"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make is
			-- Run application.
		do
			open_database
			store
			close_database
			open_database
			retrieve
			close_database
			io.read_line
		end

	store is
			-- Store `POINT' instances.
		local
			p : POINT
		do
			create p.make_with_x_y (1, 2)
			db.store(p)
			create p.make_with_x_y (3, 4)
			db.store(p)
		end

	retrieve is
			-- Retrieve `POINT' instances.
		local
			query : IQUERY
			constraint : ICONSTRAINT
			resultos : IOBJECT_SET
			p : POINT
		do
			io.put_string("***** All {POINT} instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain(({POINT}).to_cil)
			resultos := query.execute
			print_result(resultos)

			io.put_string("***** {POINT}.x > 1 *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain(({POINT}).to_cil)
			constraint := query.descend("$$x").constrain (1).greater
			resultos := query.execute
			print_result(resultos)
		end

	print_result(os : IOBJECT_SET) is
			-- Output `os'.
		local
			p : POINT
		do
			io.put_string (os.count.out + " instances retrieved")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				p ?= os.next
				if (p /= Void) then
					io.put_string("Point: (" + p.x.out + ", " + p.y.out + ")")
				else
					io.put_string("not a POINT")
				end
				io.put_new_line
			end
		end

feature

	db : IOBJECT_CONTAINER

	database_file : STRING is "c_structs.db4o"

	open_database is
			-- Open `db' of `database_file'.
		do
			db := {DB_4O_FACTORY}.open_file(database_file)
		end

	close_database is
			-- Close `db'.
		local
			close_result : BOOLEAN
		do
			close_result := db.close
		end


end
