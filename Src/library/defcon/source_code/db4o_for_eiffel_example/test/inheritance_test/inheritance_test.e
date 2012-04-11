indexing
	description: "Class for testing db4o persistence of reference types"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	INHERITANCE_TEST

feature
	run is
			-- Run testing.
		local
			closed: BOOLEAN
		do
			io.put_string ("----- Testing inheritance -----")
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
			-- Store instances of reference types.
		local
			rand: SYSTEM_RANDOM
		do
			create rand.make
			db.store (create {PARALLELOGRAM}.make (10, 10))
			db.store (create {PARALLELOGRAM}.make (20, 20))
			db.store (create {PARALLELOGRAM}.make (rand.next (51, 60), rand.next (71, 80)))
			db.store (create {RECTANGLE}.make (10, 10))
			db.store (create {RECTANGLE}.make (30, 30))
			db.store (create {RECTANGLE}.make (rand.next (51, 60), rand.next (71, 80)))
			db.store (create {RHOMBUS}.make (10, 10))
			db.store (create {RHOMBUS}.make (40, 40))
			db.store (create {RHOMBUS}.make (rand.next (51, 60), rand.next (71, 80)))
			db.store (create {SQUARE}.make_with_side_length (10))
			db.store (create {SQUARE}.make_with_side_length (50))
			db.store (create {SQUARE}.make_with_side_length (rand.next (51, 60)))
		end

	retrieve_soda is
			-- Retrieve instances of reference types using SODA Query API.
		local
			query: QUERY
			subquery: QUERY
			constraint, subconstraint: CONSTRAINT
			subconstraint1, subconstraint2, subconstraint3, subconstraint4: CONSTRAINT
			resultos: IOBJECT_SET
			dq, dsubq: IQUERY
			dcon, dcon1, dcon2: ICONSTRAINT
			systype: SYSTEM_TYPE
		do
			io.put_string ("-------- SODA --------")
			io.put_new_line
			io.put_string ("***** All {PARALLELOGRAM} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({PARALLELOGRAM})
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {RECTANGLE}.width > 0 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({RECTANGLE})
			subconstraint := query.descend ("width", {RECTANGLE}).constrain (0).greater
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {SQUARE}.side_length > 10 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({SQUARE})
			subconstraint := query.descend ("side_length", {SQUARE}).constrain (10).greater
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {PARALLELOGRAM}.height1 > 50 and {PARALLELOGRAM}.height2 > 70 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({PARALLELOGRAM})
			subconstraint1 := query.descend ("height1", {PARALLELOGRAM}).constrain (50).greater
			subconstraint2 := query.descend ("height2", {PARALLELOGRAM}).constrain (70).greater
			subconstraint := subconstraint1.and_ (subconstraint2)
			resultos := query.execute
			list (resultos)

			io.put_string ("***** {PARALLELOGRAM}.height1 = 10 or {PARALLELOGRAM}.height2 > 70 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({PARALLELOGRAM})
			subconstraint1 := query.descend ("height1", {PARALLELOGRAM}).constrain (10)
			subconstraint2 := query.descend ("height2", {PARALLELOGRAM}).constrain (70).greater
			subconstraint := subconstraint1.or_ (subconstraint2)
			resultos := query.execute
			list (resultos)

			io.put_string ("***** IQUERY: {PARALLELOGRAM}.height1 != 10 *****")
			io.put_new_line
			-- wrong query result with db4o version 7.2.31.10304
			-- NOT constraint does not work correctly.			
			dq := db.query
			systype := {PARALLELOGRAM}
			dcon := dq.constrain (systype)
			dcon1 := dq.descend ("$$height1").constrain (10).not_
			resultos := dq.execute
			list (resultos)

			io.put_string ("***** {PARALLELOGRAM}.height1 in [20, 50] *****")
			io.put_new_line
			-- wrong query result with db4o version 7.2.31.10304
			-- AND constraint does not work correctly
			create query.make_from_query (db.query)
			constraint := query.constrain ({PARALLELOGRAM})
			subconstraint1 := query.descend ("height1", {PARALLELOGRAM}).constrain (20).greater.equal_
			subconstraint2 := query.descend ("height1", {PARALLELOGRAM}).constrain (50).smaller.equal_
			subconstraint3 := subconstraint1.and_ (subconstraint2)
			resultos := query.execute
			list (resultos)
		end

	retrieve_nq is
			-- Retrieve instances of reference types using Native Queries.
		local
			resultos: IOBJECT_SET
		do
			io.put_string ("------- Native Queries --------")
			io.put_new_line
			io.put_string ("***** Open target agent: height1 + height2 > 20 *****")
			io.put_new_line
			resultos := db.query (create {EIFFEL_PREDICATE[PARALLELOGRAM]}.make_open_target_agent (agent {PARALLELOGRAM}.h1_plus_h2_greater_than (20), create {PARALLELOGRAM}.make (1, 1)))
			list (resultos)

			io.put_string ("***** Closed target agent: height1 + height2 > 20 *****")
			io.put_new_line
			resultos := db.query (create {EIFFEL_PREDICATE[PARALLELOGRAM]}.make_closed_target_agent (agent h1_plus_h2_greater_than (?, 20), create {PARALLELOGRAM}.make (1,1)))
			list (resultos)

			io.put_string ("***** PREDICATE: height1 + height2 > 20 *****")
			io.put_new_line
			resultos := db.query (create {PARALLELOGRAM_PREDICATE})
			list (resultos)
		end

	h1_plus_h2_greater_than (p: PARALLELOGRAM; v: INTEGER): BOOLEAN is
			-- Is `p.height1 + p.height2' greater than `v'?
			-- Used as an agent in a Native Query
		do
			Result := (p.height1 + p.height2) > v
		end

feature  -- Print

	list (os: IOBJECT_SET) is
			-- Output `os'.
		require
			os_not_void: os /= Void
		local
			pol: PARALLELOGRAM
		do
			io.put_string (os.count.out + " instances found")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				pol ?= os.next
				io.put_string (pol.to_eiffel_string)
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
