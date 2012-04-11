indexing
	description: "Class for testing db4o persistence of TUPLEs"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_TEST

inherit
	GENERICITY_HELPER

feature
	run is
			-- Run testing.
		local
			closed: BOOLEAN
		do
			io.put_string ("-----Testing tuples-----")
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
			-- Store `TUPLE_CLASS' instances.
		do
			db.store (create {TUPLE_CLASS}.make)
		end

	retrieve_soda is
			-- Retrieve `TUPLE' instances using SODA Query API.
		local
			query: QUERY
			subquery: QUERY
			constraint: CONSTRAINT
			resultos: IOBJECT_SET
			resultlist: LIST[SYSTEM_OBJECT]
			systype: SYSTEM_TYPE
		do
			io.put_string ("-------- SODA --------")
			io.put_new_line
			io.put_string ("***** All {TUPLE} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({TUPLE})
			resultos := query.execute
			list (resultos)

			io.put_string ("***** All {TUPLE[TUPLE[INTEGER]]} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({TUPLE[TUPLE[INTEGER]]})
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {TUPLE[TUPLE[INTEGER]]})
			print_list (resultlist)

			io.put_string ("***** All {TUPLE[GLIST[INTEGER]]} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({TUPLE[GLIST[INTEGER]]})
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {TUPLE[GLIST[INTEGER]]})
			print_list (resultlist)

			io.put_string ("***** All {GLIST[TUPLE[INTEGER]]} instances *****")
			io.put_new_line
			create query.make_from_query (db.query)
			constraint := query.constrain ({GLIST[TUPLE[INTEGER]]})
			resultos := query.execute
			resultlist := get_conforming_objects (resultos, create {GLIST[TUPLE[INTEGER]]})
			print_list (resultlist)
		end

	retrieve_nq is
			-- Retrieve `TUPLE' instances using Native Queries.
		local
			resultos: IOBJECT_SET
		do
			io.put_string ("------- Native query --------")
			io.put_new_line
			io.put_string ("***** All {TUPLE[BOOLEAN]} instances *****")
			io.put_new_line
			resultos := db.query (create {TUPLE_PREDICATE})
			list (resultos)
		end

feature  -- Print

	list (os: IOBJECT_SET) is
			-- Output `os'.
		require
			os_not_void: os /= Void
		local
			obj: SYSTEM_OBJECT
		do
			io.put_string (os.count.out + " instances found")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				obj := os.next
				io.put_string (obj.to_string)
				io.put_new_line
			end
		end

	print_list (l: LIST[SYSTEM_OBJECT]) is
			-- Output `l'.
		require
			l_not_void: l /= Void
		do
			io.put_string (l.count.out + " instances found")
			io.put_new_line
			from
				l.start
			until
				l.after
			loop
				io.put_string (l.item.to_string)
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
