note
	description: "Maintenance tasks for database"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_DATABASE_MAINTENANCE

inherit
	SEMQ_DATABASE

create
	make

feature -- Basic operations

	empty_tables
			-- Empties all tables
		do
			open_mysql
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings1`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings2`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings3`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings4`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings5`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings6`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings7`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings8`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`PropertyBindings9`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`Queryables`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`Properties`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`Conformances`")
			mysql.execute_query (once "TRUNCATE `semantic_search`.`Types`")
			close_mysql
		end

	rebuilds_conformances
			-- Empties Conformances table and rebuilds it from types in Types table
		local
			types: SEMQ_DATABASE_TYPES
			num_rows, type_id, conf_type_id: INTEGER
		do
			create types.make (config)
			types.load_from_database
			make_type_conformance_calc

			-- Add types to conformance calculator
			from
				types.types.start
			until
				types.types.off
			loop
				type_conformance_calc.add_type (create {SQL_TYPE}.make_with_type_name (types.types.key_for_iteration, types.types.item_for_iteration))
				types.types.forth
			end

			open_mysql
			mysql.execute_query (once "TRUNCATE `semantic_search`.`Conformances`")

			-- Insert calculated conformances into database
			from
				type_conformance_calc.conformance.start
			until
				type_conformance_calc.conformance.off
			loop
				from
					type_conformance_calc.conformance.item_for_iteration.start
				until
					type_conformance_calc.conformance.item_for_iteration.off
				loop
					type_id := types.get_id (type_conformance_calc.conformance.key_for_iteration.name)
					conf_type_id := types.get_id (type_conformance_calc.conformance.item_for_iteration.item_for_iteration.name)
					mysql.execute_query (once "INSERT INTO `semantic_search`.`Conformances` VALUES ("+type_id.out+once ", "+conf_type_id.out+once ")")
					type_conformance_calc.conformance.item_for_iteration.forth
				end
				type_conformance_calc.conformance.forth
			end

			close_mysql
		end

feature{SEMQ_DATABASE} -- MySQL Client

	cleanup_mysql
			-- Close statements
		do
		end

end
