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
			retrieve_dotnet_objects
			io.read_line
		end

	retrieve_dotnet_objects is
			--
		local
			db : IOBJECT_CONTAINER
			closed : BOOLEAN
			query : IQUERY
			constraint : ICONSTRAINT
			resultos : IOBJECT_SET
		do
			db := {DB_4O_FACTORY}.open_file("NetObjects.db4o")

			io.put_string("***** All IFIGURE instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({IFIGURE}).to_cil)
			resultos := query.execute
			print_queryresult(resultos)

			io.put_string("***** All IFIGURE._sideLength1 > 4 instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({IFIGURE}).to_cil)
			constraint := query.descend ("_sideLength1").constrain (4).greater
			resultos := query.execute
			print_queryresult(resultos)

			io.put_string("***** All PARALLELOGRAM instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({PARALLELOGRAM}).to_cil)
			resultos := query.execute
			print_queryresult(resultos)

			io.put_string("***** All PARALLELOGRAM._sideLength1 > 4 instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({PARALLELOGRAM}).to_cil)
			constraint := query.descend ("_sideLength1").constrain (4).greater
			resultos := query.execute
			print_queryresult(resultos)

			io.put_string("***** All POINT instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({POINT}).to_cil)
			resultos := query.execute
			print_queryresult(resultos)

			io.put_string("***** All POINT.x > 30 instances *****")
			io.put_new_line
			query := db.query
			constraint := query.constrain (({POINT}).to_cil)
			constraint := query.descend("_x").constrain (30).greater
			resultos := query.execute
			print_queryresult(resultos)

			closed := db.close
		rescue
			if (not closed and then db /= Void) then
				closed := db.close
			end
		end

	print_queryresult(os : IOBJECT_SET) is
			--
		local
			obj : SYSTEM_OBJECT
			f : IFIGURE
			p : POINT
		do
			io.put_string(os.count.out + " instances retrieved.")
			io.put_new_line
			from

			until
				not os.has_next
			loop
				obj := os.next
				f ?= obj
				p ?= obj
				if (f /= Void) then
					f.draw
				elseif (p /= Void) then
					io.put_string("Point (" + p.x.out + ", " + p.y.out + ")")
					io.put_new_line
				end
			end
			io.put_new_line
		end



end
