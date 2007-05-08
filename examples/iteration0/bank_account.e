indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT

inherit
	OBSERVABLE
		redefine
			is_observed
		end
create
	make

feature -- creation
	make (a_name: STRING)
			--
		require
			a_name_not_void: a_name /= Void
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("make", Current, [a_name])
			end
			if (not controller.is_replay_phase) or is_observed then
				the_name := a_name
			end
			if controller.is_capture_replay_enabled then
				ignore_result ?= controller.methodbody_end (Void)
			end
		end

feature -- Access

	name: STRING is
			--Name of the account
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("name", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
				Result := the_name
			end
			if controller.is_capture_replay_enabled then
				Result ?= controller.methodbody_end (Result)
			end
		end

	balance: REAL is
			--Balance of the account
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("balance", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
				Result := the_balance
			end
			if controller.is_capture_replay_enabled then
				Result ?= controller.methodbody_end (Result)
			end
		end

	is_observed: BOOLEAN is True

feature {BANK} -- Restricted
	withdraw (an_amount: REAL) is
			-- Withdraw 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("withdraw", Current, [an_amount])
			end
			if (not controller.is_replay_phase) or is_observed then
				the_balance := the_balance - an_amount
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
			end

		ensure
			amount_withdrawn: balance = old balance - an_amount
		end


	deposit (an_amount: REAL) is
			--Deposit 'an_amount'
		require
			an_amount_reasonable: an_amount >= 0
		local
			ignore_result: ANY
		do
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("deposit", Current, [an_amount])
			end
			if (not controller.is_replay_phase) or is_observed then
				the_balance := the_balance + an_amount
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
			end
		ensure
			an_amount_deposited: balance = old balance + an_amount
		end

feature {NONE} -- Implementation
	the_balance: REAL

	the_name: STRING
invariant
	a_name_not_void: the_name /= Void
end
