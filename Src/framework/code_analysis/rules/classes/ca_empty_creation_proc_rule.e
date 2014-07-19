note
	description: "[
			RULE #38: Empty argumentless creation procedure can be removed
	
			If there exists only one creation procedure in a class and this procedure
			takes no arguments and has an empty body then the creation procedure should
			be considered to be removed. Note that in this case all the clients of the
			class need to call 'create c' instead of 'create c.make', where 'c' is an
			object of the relevant class and 'make' is its creation procedure.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_CREATION_PROC_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			make_with_defaults
		end

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_create_pre_action (agent process_create)
			a_checker.add_feature_clause_pre_action (agent process_feature_clause)
			a_checker.add_class_post_action (agent do_post_class_cleanup)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.empty_creation_procedure_title
		end

	id: STRING_32 = "CA038"
		-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.empty_creation_procedure_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.empty_creation_procedure_violation_1)
			if attached {STRING_32} a_violation.long_description_info.at(2) as l_class_name then
				a_formatter.add (l_class_name)
			end
			a_formatter.add (ca_messages.empty_creation_procedure_violation_2)
			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end
			a_formatter.add (ca_messages.empty_creation_procedure_violation_3)
			if attached {STRING_32} a_violation.long_description_info.at(2) as l_class_name then
				a_formatter.add (l_class_name)
			end
			a_formatter.add (ca_messages.empty_creation_procedure_violation_4)
		end

feature {NONE} -- AST Visitor

	process_create (a_create: CREATE_AS)
			-- Stores the creation procedures of `a_create'.
		do
			creation_procedures := a_create.feature_list
		end

	do_post_class_cleanup (a_class: CLASS_AS)
		do
			if attached creation_procedures then
				-- If there was no violation, `creation_procedures' would have been made Void in process_feature_clause

				viol.long_description_info.extend (a_class.class_name.name_32)
				violations.extend (viol)

				-- Set the creation procedures to Void. Prevents errors when
				-- the next class does not have any creation procedures.
				creation_procedures := Void
			end
		end

	process_feature_clause (a_clause: FEATURE_CLAUSE_AS)
			-- Checks `a_clause' for features that are creation procedures.
		do
			if creation_procedures /= Void then
				if creation_procedures.count = 1 then
					across creation_procedures as p loop
						if attached a_clause.feature_with_name(p.item.internal_name.name_id) as l_feature then
							if attached l_feature.body.arguments or not l_feature.body.is_empty then
								-- Set the creation procedures to Void. This will ensure that
								-- the violation won't be created in the post class cleanup
								creation_procedures := Void
							else
								create viol.make_with_rule (Current)
								viol.long_description_info.extend (p.item.visual_name_32)
								viol.set_location (l_feature.start_location)
							end
						end
					end
				else
					creation_procedures := Void
				end
			end
		end

feature {NONE} -- Attributes

	viol: CA_RULE_VIOLATION
			-- The violation of this rule.

	creation_procedures: EIFFEL_LIST [FEATURE_NAME]
			-- List of creation procedures of the current class.
end
