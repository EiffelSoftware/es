indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT

inherit
	ANY
		redefine
			default_create
		end

feature -- Initalization

	default_create is
		do
			balance := 300
			owner := "Me"
			some_tuple := ["Hello", 0.112233445566778899, create {SPECIAL [STRING]}.make_from_native_array (<< "This", "is", "an", "eiffel", "special" >>)]
			some_agent := agent deposit
			some_special := create {SPECIAL [INTEGER]}.make_from_native_array (<< 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 >>)
		end

feature -- Access

	balance: INTEGER

feature -- Basic operations

	deposit (an_amount: INTEGER) is
		local
			l_other: BANK_ACCOUNT
		do
			l_other := Current + 200
		ensure
			balance_increased: balance > old balance
			deposited: balance = old balance + an_amount
		end

	withdraw (an_amount: INTEGER) is
		local
			l_other: BANK_ACCOUNT
		do
			l_other := +Current
		ensure
			balance_decreased: balance < old balance
			withdrawn: balance = old balance - an_amount
		end

feature -- Access (for testing cdd)

	owner: STRING

	some_tuple: TUPLE [STRING, DOUBLE, SPECIAL [STRING]]

	some_special: SPECIAL [INTEGER]

	some_agent: PROCEDURE [ANY, TUPLE [INTEGER]]

feature -- Infixes & prefixes

	infix "+" (other: like balance): like Current is
		do
			create Result
			--Result.deposit (other)
		ensure
			not_void: Result /= Void
			correct_balance: Result.balance = other
		end

	prefix "+": like Current is
		do
		ensure
			not_void: Result /= Void
		end

invariant
	balance_not_negativ: balance >= 0

end
