note
	description: "[
					RULE #30: Unnecessary sign operand
		
					All unary operands for numbers are unnecessary, except for a single minus sign.
					They should be removedor the instruction should be checked for errors.
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNECESSARY_SIGN_OPERAND

inherit

	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			make_with_defaults
			create {CA_SUGGESTION} severity
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_unary_pre_action (agent process_expr)
		end

feature {NONE} -- Rule checking

		-- Known limitation: unfortunately, simple unary expressions like "+3" or "-2" are directly parsed as numerical
		-- constant by the compiler, and this rule is not invoked at all. It is only invoked for expressions with at least
		-- two consecutive signs or for simple unary expressions where the operand is *not* a constant (in that case, the
		-- unnecessary plus operator can be detected).

	is_sign_redundant (a_expr: attached UNARY_AS): BOOLEAN
		do
			Result := False
			if attached {UN_PLUS_AS} a_expr then
					-- The unary plus is always redudant
				Result := True
			elseif attached {UN_MINUS_AS} a_expr as minus_expr then
					-- This is fine, but if the operand of this expression is another
					-- plus or minus unary expression, then this sign is redundant.
				if attached {UN_PLUS_AS} a_expr.expr or attached {UN_MINUS_AS} a_expr.expr then
					Result := True
				elseif attached {INTEGER_AS} a_expr.expr as int_as then
						-- No sign is necessary for zero
						-- TODO: this is a perfect example for the parenthesis rule with boolean assignments
					Result := (int_as.integer_64_value = 0)
				elseif attached {REAL_AS} a_expr.expr as real_as then
						-- No sign is necessary for zero
						-- TODO: Same as above
						-- TODO: Ask somebody how to properly parse a double constant
					Result := is_double_string_zero (real_as.value)
				end
			end
		end

	is_double_string_zero (a_string: STRING): Boolean
		do
				-- Trick: we trim leading and traling zeros. If nothing or a single dot is left,
				-- this was a zero expression.
			from
			until
				not a_string.starts_with ("0")
			loop
				a_string.remove_head (1)
			end
			from
			until
				not a_string.ends_with ("0")
			loop
				a_string.remove_tail (1)
			end
			Result := a_string.is_empty or a_string ~ "0"
		end

	process_expr (a_expr: attached UNARY_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do
			if is_sign_redundant (a_expr) then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_expr.start_location)
				violations.extend (l_viol)
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.unnecessary_sign_operand_title
		end

	id: STRING_32 = "CA030"

	description: STRING_32
		do
			Result := ca_names.unnecessary_sign_operand_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.unnecessary_sign_operand_violation_1)
		end

end
