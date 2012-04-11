indexing
	description: "Class for testing db4o persistence of generic types"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	GENERICITY_TEST

inherit
	GENERICITY_HELPER

feature
	run is
			-- Run testing.
		local
			config: CONFIGURATION
			closed: BOOLEAN
		do
			io.put_string ("-----Testing genericity-----")
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
			-- Store generic objects.
		local
			gl: GLIST[PARALLELOGRAM]
			gsubl: GSUBLIST[PARALLELOGRAM]
			glstr: GLIST[STRING]
			gsublstr: GSUBLIST[STRING]
			glpnt: GLIST[POINT]
			gsublpnt: GSUBLIST[POINT]
			i: INTEGER
		do
			create gl
			gl.put (create {PARALLELOGRAM}.make (10, 10))
			gl.put (create {PARALLELOGRAM}.make (20, 20))
			gl.put (create {PARALLELOGRAM}.make (52, 72))
			gl.put (create {RHOMBUS}.make (10, 10))
			gl.put (create {RHOMBUS}.make (30, 30))
			gl.put (create {RHOMBUS}.make (53, 73))
			gl.put (create {RECTANGLE}.make (10, 10))
			gl.put (create {RECTANGLE}.make (40, 40))
			gl.put (create {RECTANGLE}.make (54, 74))
			gl.put (create {SQUARE}.make_with_side_length (10))
			gl.put (create {SQUARE}.make_with_side_length (50))
			gl.put (create {SQUARE}.make_with_side_length (55))
			db.store (gl)

			create gsubl
			gsubl.put (create {PARALLELOGRAM}.make (10, 10))
			gsubl.put (create {PARALLELOGRAM}.make (20, 20))
			gsubl.put (create {PARALLELOGRAM}.make (52, 72))
			gsubl.put (create {RHOMBUS}.make (10, 10))
			gsubl.put (create {RHOMBUS}.make (30, 30))
			gsubl.put (create {RHOMBUS}.make (53, 73))
			gsubl.put (create {RECTANGLE}.make (10, 10))
			gsubl.put (create {RECTANGLE}.make (40, 40))
			gsubl.put (create {RECTANGLE}.make (54, 74))
			gsubl.put (create {SQUARE}.make_with_side_length (10))
			gsubl.put (create {SQUARE}.make_with_side_length (50))
			gsubl.put (create {SQUARE}.make_with_side_length (55))
			db.store (gsubl)

			create glstr
			glstr.put ("10")
			glstr.put ("20")
			db.store (glstr)

			create gsublstr
			gsublstr.put ("110")
			gsublstr.put ("120")
			db.store (gsublstr)

			create glpnt
			glpnt.put (create {POINT}.make_with_x_y (1, 2))
			glpnt.put (create {POINT}.make_with_x_y (3, 4))
			db.store (glpnt)

			create gsublpnt
			gsublpnt.put (create {POINT}.make_with_x_y (11, 12))
			gsublpnt.put (create {POINT}.make_with_x_y (13, 14))
			db.store (gsublpnt)

		end

	retrieve_soda is
			-- Retrieve generic objects using SODA Query API.
		local
			query: QUERY
			subquery: QUERY
			constraint, subconstraint: CONSTRAINT
			subconstraint1, subconstraint2, subconstraint3, subconstraint4: CONSTRAINT
			resultos: IOBJECT_SET
			dq, dsubq: IQUERY
			dcon, dcon1, dcon2: ICONSTRAINT
			systype: SYSTEM_TYPE
			resultlist: LIST[SYSTEM_OBJECT]
			sw1, sw2: STOP_WATCH
		do
			io.put_string ("-------- SODA --------")
			io.put_new_line

			io.put_string ("***** All GLIST[PARALLELOGRAM] *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({GLIST[PARALLELOGRAM]})
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {GLIST[PARALLELOGRAM]})
			list (resultlist)

			io.put_string ("***** All GSUBLIST[PARALLELOGRAM] *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({GSUBLIST[PARALLELOGRAM]})
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {GSUBLIST[PARALLELOGRAM]})
			list (resultlist)

			io.put_string ("***** GLIST[PARALLELOGRAM].item.height1 > 10 *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({GLIST[PARALLELOGRAM]})
			subquery := query.descend ("item", {GLIST[PARALLELOGRAM]})
			subquery := subquery.descend ("height1", {PARALLELOGRAM})
			constraint := subquery.constrain (10).greater
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {GLIST[PARALLELOGRAM]})
			list (resultlist)
		end

	retrieve_nq is
			-- Retrieve generic objects using Native Queries.
		local
			resultos: IOBJECT_SET
			sw: STOP_WATCH
		do
			io.put_string ("------- Native Queries --------")
			io.put_new_line
			io.put_string ("***** GLIST[PARALLELOGRAM].item.height1 > 10 *****")
			io.put_new_line
			resultos := db.query (create {GLIST_PREDICATE})
			list_objectset (resultos)
		end

feature  -- Print

	list_objectset (os: IOBJECT_SET) is
			-- Output `os'.
		require
			os_not_void: os /= Void
		local
			obj: SYSTEM_OBJECT
			gl: GLIST[PARALLELOGRAM]
			gsubl: GSUBLIST[PARALLELOGRAM]
		do
			io.put_string (os.count.out + " instances found")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				obj := os.next
				gsubl ?= obj
				gl ?= obj
				if (gsubl /= Void) then
					io.put_string ("GSUBLIST: ")
					io.put_string (gl.item.to_eiffel_string)
				else
					io.put_string ("GLIST: ")
					io.put_string (gl.item.to_eiffel_string)
				end
				io.put_new_line
			end
		end

	list (l: LIST[SYSTEM_OBJECT]) is
			-- Output `l'.
		require
			l_not_void: l /= Void
		local
			obj: SYSTEM_OBJECT
			gl: GLIST[PARALLELOGRAM]
			gsubl: GSUBLIST[PARALLELOGRAM]
		do
			io.put_string (l.count.out + " instances found")
			io.put_new_line
			from
				l.start
			until
				l.after
			loop
				obj := l.item
				gsubl ?= obj
				gl ?= obj
				if (gsubl /= Void) then
					io.put_string ("GSUBLIST: ")
					io.put_string (gl.item.to_eiffel_string)
				else
					io.put_string ("GLIST: ")
					io.put_string (gl.item.to_eiffel_string)
				end
				io.put_new_line
				l.forth
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
