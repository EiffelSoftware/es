note
	description : "SQL_Statement_Creater application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make


feature
	--Startup
	make
		local
			update_m: SEM_DB_BOOST_UPDATE_MANAGER
		do
			create update_m.make
			print ("start%N%N")
			update_m.run_table_update ("DS_LINKED_LIST", "extend")
			print ("%N%NFINISH")
		end

end
