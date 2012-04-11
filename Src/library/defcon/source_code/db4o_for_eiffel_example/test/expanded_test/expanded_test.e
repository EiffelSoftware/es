indexing
	description: "Class for testing db4o persistence of expanded type POINT"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	EXPANDED_TEST

feature
	run is
			-- Run testing.
		local
			closed: BOOLEAN
		do
			io.put_string ("-----Testing custom expanded type {POINT}-----")
			io.put_new_line
			open_database
			store
			close_database
			open_database
			retrieve_soda
			close_database
			open_database
			retrieve_nq
			close_database
		rescue
			if (db /= Void) then
				closed := db.close
			end
		end

	store is
			-- Store `POINT' instances.
		local
			i: INTEGER
		do
			db.store (create {POINT}.make_with_x_y (1, 2))
			db.store (create {POINT}.make_with_x_y (1, 7))
			db.store (create {POINT}.make_with_x_y (3, 4))
			db.store (create {POINT}.make_with_x_y (23, 5))
			db.store (create {POINT}.make_with_x_y (5, 6))
		end

	retrieve_soda is
			-- Retrieve `POINT' instances using SODA Queries API.
		local
			query: QUERY
			subquery: QUERY
			constraint: CONSTRAINT
			resultos: IOBJECT_SET
			subconstraint: CONSTRAINT
		do
			io.put_string ("-------- SODA --------")
			io.put_new_line
			io.put_string ("***** All {POINT} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({POINT})
			subquery := query.descend ("x", {POINT}).order_descending
			subquery := query.descend ("y", {POINT}).order_descending
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {POINT}.x > 1 and {POINT}.y < 5 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({POINT})
			constraint := query.descend ("x", {POINT}).constrain (1).greater.and_ (query.descend ("y", {POINT}).constrain (5).smaller)
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {POINT}.x >= 5 or {POINT}.y < 3 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({POINT})
			constraint := query.descend ("x", {POINT}).constrain (5).greater.equal_.or_ (query.descend ("y", {POINT}).constrain (3).smaller)
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {POINT}.x /= 1 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({POINT})
			constraint := query.descend ("x", {POINT}).constrain (1).not_
			resultos := query.execute
			list (resultos)
		end

	retrieve_nq is
			-- Retrieve `POINT' instances using Native Queries.
		local
			resultos: IOBJECT_SET
		do
			io.put_string ("------- Native query --------")
			io.put_new_line
			io.put_string ("***** {POINT}.x > 10 *****")
			io.put_new_line
			resultos := db.query (create {POINT_PREDICATE})
			list(resultos)
		end

	list (os: IOBJECT_SET) is
			-- Output `os'.
		require
			os_not_void: os /= Void
		local
			pnt: POINT
		do
			io.put_string (os.count.out + " instances found")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				pnt ?= os.next
				io.put_string (pnt.to_string)
				io.put_new_line
			end
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


end
