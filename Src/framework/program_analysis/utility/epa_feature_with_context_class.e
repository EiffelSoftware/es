note
	description: "Summary description for {EPA_FEATURE_WITH_CONTEXT_CLASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_WITH_CONTEXT_CLASS

inherit
	EPA_HASH_CALCULATOR
		redefine
			is_equal, out
		end

	INTERNAL_COMPILER_STRING_EXPORTER
		redefine
			is_equal, out
		end

	DEBUG_OUTPUT
		redefine
			is_equal, out
		end

	EPA_UTILITY
		redefine
			is_equal, out
		end

create
	make, make_from_names

feature{NONE} -- Initialization

	make (a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Initialization.
		require
			feature_attached: a_feature /= Void
			class_attached: a_context_class /= Void
		do
			feature_ := a_feature;
			context_class := a_context_class
		ensure
			feature_set: feature_ = a_feature
			context_class_set: context_class = a_context_class
		end

	make_from_names (a_feature_name, a_class_name: STRING)
			--
		do
			feature_ := feature_from_class (a_class_name, a_feature_name)
			context_class := first_class_starts_with_name (a_class_name)
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature.

	context_class: CLASS_C
			-- Context class.

	written_feature: FEATURE_I
			-- Feature in written class.
		do
			Result := written_class.feature_of_rout_id_set (feature_.rout_id_set)
		end

	written_class: CLASS_C
			-- Written class.
		do
			Result := feature_.written_class
		end

	qualified_feature_name: STRING
			-- ClassName.FeatureName
		do
			Result := context_class.name_in_upper + "." + feature_.feature_name
		end

	is_equal(other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := context_class.class_id = other.context_class.class_id and then feature_.rout_id_set ~ other.feature_.rout_id_set
		end

	is_about_same_feature (other: EPA_FEATURE_WITH_CONTEXT_CLASS): BOOLEAN
		do
			Result := context_class.class_id = other.context_class.class_id and then feature_.rout_id_set ~ other.feature_.rout_id_set
		end

feature -- Status report

	is_public: BOOLEAN
			-- Is feature public?
		do
			Result := feature_.is_exported_for (system.any_class.compiled_representation)
		end

	is_creation_feature: BOOLEAN
			-- Is feature a creation feature?
		do
			Result := context_class.creators /= Void and then context_class.creators.has (feature_.feature_name_32)
		end

	is_query: BOOLEAN
			-- Is feature a query?
		do
			Result := feature_.is_function
		end

	is_command: BOOLEAN
			-- Is feature a command?
		do
			Result := feature_.is_routine and then not feature_.is_function
		end

	argument_count: INTEGER
			-- Number of arguments.
		do
			Result := feature_.argument_count
		end

	is_argumentless_public_command: BOOLEAN
			-- Is current an argumentless public command?
		do
			Result := is_public and then (argument_count = 0) and then is_command and then not is_creation_feature
		end

feature -- Output

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

	out: STRING
			-- <Precursor>
		do
			Result := context_class.name_in_upper + "." + feature_.feature_name
		end

feature -- Static structure

	first_breakpoint_in_body: INTEGER
			-- First breakpoint in the body of Current.
		do
			Result := ast_structure.first_breakpoint_slot_number
		end

	last_breakpoint_in_body: INTEGER
			-- Last breakpoint in the body of Current.
		do
			Result := ast_structure.last_breakpoint_slot_number
		end

	breakpoint_to_evaluate_precondition: INTEGER = 1
			-- Breakpoint where evaluation of precondition happens during monitoring.

	breakpoint_to_evaluate_postcondition: INTEGER
			-- Breakpoint where evaluation of postcondition happens during monitoring.
		local
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
		do
			if breakpoint_to_evaluate_postcondition_cache = 0 then
				create l_contract_extractor
				breakpoint_to_evaluate_postcondition_cache := feature_.number_of_breakpoint_slots
--				breakpoint_to_evaluate_postcondition_cache := feature_.e_feature.number_of_breakpoint_slots - l_contract_extractor.postcondition_of_feature (feature_, context_class).count
--				breakpoint_to_evaluate_postcondition_cache := feature_.e_feature.number_of_breakpoint_slots - l_contract_extractor.postcondition_of_feature (feature_, context_class).count + 1
			end
			Result := breakpoint_to_evaluate_postcondition_cache
		end

	ast_structure: EPA_FEATURE_AST_STRUCTURE_NODE
			-- AST structure of Current.
		local
			l_structure_gen: EPA_AST_STRUCTURE_NODE_GENERATOR
		do
			if ast_structure_cache = Void then
				create l_structure_gen
				l_structure_gen.generate (context_class, feature_)
				ast_structure_cache := l_structure_gen.structure
			end
			Result := ast_structure_cache
		end

	body_compound_ast: EIFFEL_LIST [INSTRUCTION_AS]
			-- AST node for body of the recipient.
			-- It is the compound part of a DO_AS.
		do
			if attached {BODY_AS} feature_.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						Result := l_do.compound
					end
				end
			end
		end

	body_ast: DO_AS
			-- AST node for body of the recipient.
			-- It is a DO_AS.
		do
			if attached {BODY_AS} feature_.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						Result := l_do
					end
				end
			end
		end

	feature_as_ast: FEATURE_AS
			-- AST for the recipient.
		do
			Result := feature_.e_feature.ast
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (2)
			l_list.force_last (feature_.feature_name_id)
			l_list.force_last (context_class.class_id)
			Result := l_list
		end

feature{NONE} -- Cache

	breakpoint_to_evaluate_postcondition_cache: INTEGER
			-- Cache for `breakpoint_to_evaluate_postcondition'.

	ast_structure_cache: EPA_FEATURE_AST_STRUCTURE_NODE
			-- Cache for `ast_structure'.

invariant
	feature_attached: feature_ /= Void
	class_attached: context_class /= Void

end
