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
	CA_UNNECESSARY_SIGN_OPERATOR

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
			a_checker.add_unary_pre_action (agent process_unary)
			a_checker.add_integer_pre_action (agent process_int)
			a_checker.add_real_pre_action (agent process_real)
		end

feature {NONE} -- Rule checking

		-- Simple unary expressions like "+3" or "-2" are directly parsed as numerical
		-- constants by the compiler, and process_unary is not invoked at all. It is only invoked for expressions with at least
		-- two consecutive signs or for simple unary expressions where the operand is *not* a constant (in that case, the
		-- unnecessary plus operator can be detected). For this reason, we need to handle integer and real expressions separately.

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
						-- Also, if the integer already has a sign, the current sign is redundant.
						-- TODO: this is a perfect example for the parenthesis rule with boolean assignments
					Result := (int_as.integer_64_value = 0 or int_as.sign_symbol (current_context.matchlist) /= Void)
				elseif attached {REAL_AS} a_expr.expr as real_as then
						-- Same as above
					Result := (real_as.value.to_real_64 = 0 or real_as.sign_symbol (current_context.matchlist) /= Void)
				end
			end
		end

	process_unary (a_expr: attached UNARY_AS)
		do
			if is_sign_redundant (a_expr) then
				add_violation (a_expr.start_location)
			end
		end

	process_int (a_integer: attached INTEGER_AS)
		do
			if attached a_integer.sign_symbol (current_context.matchlist) as sign then
				if sign.is_plus or (sign.is_minus and a_integer.natural_64_value = 0) then
					add_violation (sign.start_location)
				end
			end
		end

	process_real (a_real: attached REAL_AS)
		do
			if attached a_real.sign_symbol (current_context.matchlist) as sign then
				if sign.is_plus or (sign.is_minus and a_real.value.to_real_64 = 0) then
					add_violation (sign.start_location)
				end
			end
		end

	add_violation (a_location: LOCATION_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do
			create l_viol.make_with_rule (Current)
			l_viol.set_location (a_location)
			violations.extend (l_viol)
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
