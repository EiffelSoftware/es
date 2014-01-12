note
	description: "User-defined Boogie types; consist of a type constructor with zero or more parameters."
	date: "$Date$"
	revision: "$Revision$"

class
	IV_USER_TYPE

inherit
	IV_TYPE
		redefine
			default_value,
			is_equal,
			has_rank,
			rank_leq
		end

create
	make

feature {NONE} -- Initialization

	make (a_constructor: STRING; a_params: ARRAY [IV_TYPE])
			-- Create a type by applying `a_constructor' to `a_params'.
		require
			a_constructor_exists: a_constructor /= Void
			a_params_exists: a_params /= Void
			all_params_exist: across a_params as p all p.item /= Void end
		do
			constructor := a_constructor
			parameters := a_params
			parameters.compare_objects
		ensure
			constrcutor_set: constructor = a_constructor
			params_set: parameters = a_params
		end

feature -- Access

	constructor: STRING
			-- Type constructor.

	parameters: ARRAY [IV_TYPE]
			-- Type parameters.

	default_value: IV_EXPRESSION
			-- <Precursor>

feature -- Element change

	set_default_value (a_value: IV_EXPRESSION)
			-- Set `default_value' to `a_value'.
--		require
--			correct_type: a_value /= Void and then a_value.type ~ Current
		do
			default_value := a_value
		end

feature -- Visitor

	process (a_visitor: IV_TYPE_VISITOR)
			-- Process type.
		do
			a_visitor.process_user_type (Current)
		end

feature -- Equality

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' same type as this?
		local
			i: INTEGER
		do
			Result := constructor ~ a_other.constructor and
				parameters ~ a_other.parameters
		end

feature -- Termination

	rank_leq_function: STRING
			-- Name of the Boogie function that defined the well-founded order on this type.

	set_rank_function (a_function: STRING)
			-- Set `rank_leq_function' to `a_function'.
		do
			rank_leq_function := a_function
		end

	has_rank: BOOLEAN
			-- <Precursor>
		do
			Result := rank_leq_function /= Void
		end

	rank_leq (e1, e2: IV_EXPRESSION): IV_EXPRESSION
			-- <Precursor>	
		do
			Result := factory.function_call (rank_leq_function, << e1, e2 >>, create {IV_BASIC_TYPE}.make_boolean)
		end

invariant
	constructor_exists: constructor /= Void
	params_exists: parameters /= Void
	all_params_exist: across parameters as p all p.item /= Void end
end
