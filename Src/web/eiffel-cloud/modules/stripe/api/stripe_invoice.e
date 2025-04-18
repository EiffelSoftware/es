note
	description: "[
		Summary description for {STRIPE_INVOICE}.

			See also: https://stripe.com/docs/api/invoices/object
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=invoices", "protocol=URI", "src=https://stripe.com/docs/api/invoices/object"

class
	STRIPE_INVOICE

inherit
	STRIPE_OBJECT
		redefine
			make_with_json
		end

create
	make_with_json

feature {NONE} -- Initialization

	make_with_json (j: like json)
		local
			pi: STRIPE_PAYMENT_INTENT
			cust: STRIPE_CUSTOMER
			sub: STRIPE_SUBSCRIPTION
			ch: STRIPE_PAYMENT_CHARGE
		do
			create id.make_empty
			create lines.make (0)

			Precursor (j)

			if not j.is_empty then
				id := safe_string_8_item (j, "id", id)

				account_name := string_32_item (j, "account_name")

				customer_email := string_8_item (j, "customer_email")
				customer_name := string_32_item (j, "customer_name")

				if attached {JSON_OBJECT} j.item ("customer") as j_customer then
					create cust.make_with_json (j_customer)
					customer := cust
					customer_id := cust.id
					if customer_email = Void then
						customer_email := cust.email
					end
					if customer_name = Void then
						customer_name := cust.name
					end
				else
					customer_id := string_8_item (j, "customer")
				end

				amount_due := natural_32_item (j, "amount_due")
				amount_paid := natural_32_item (j, "amount_paid")
				amount_remaining := natural_32_item (j, "amount_remaining")

				billing_reason := string_8_item (j, "billing_reason")

				if attached {JSON_OBJECT} j.item ("charge") as j_charge then
					create ch.make_with_json (j_charge)
					charge := ch
					charge_id := ch.id
				else
					charge_id := string_8_item (j, "charge")
				end

				currency := string_8_item (j, "currency")

				creation_timestamp := integer_32_item (j, "created")

				hosted_invoice_url := string_8_item (j, "hosted_invoice_url")
				invoice_pdf := string_8_item (j, "invoice_pdf")

				if
					attached {JSON_OBJECT} j.item ("lines") as j_lines and then
					attached {JSON_ARRAY} j_lines.item ("data") as j_data
				then
					across
						j_data as ic
					loop
						if attached {JSON_OBJECT} ic.item as j_line then
							lines.force (create {STRIPE_INVOICE_LINE}.make_with_json (j_line))
						end
					end
				end

				if attached {JSON_OBJECT} j.item ("payment_intent") as j_pi then
					create pi.make_with_json (j_pi)
					payment_intent := pi
					payment_intent_id := pi.id
				else
					payment_intent_id := string_8_item (j, "payment_intent")
				end

				if attached {JSON_OBJECT} j.item ("subscription") as j_sub then
					create sub.make_with_json (j_sub)
					subscription := sub
					subscription_id := sub.id
				else
					subscription_id := string_8_item (j, "subscription")
				end

				status := string_8_item (j, "status")

				metadata := table_item (j, "metadata")
			end
		end

feature -- Access

	account_name: detachable READABLE_STRING_32

	customer: detachable STRIPE_CUSTOMER
	customer_id: detachable READABLE_STRING_8
	customer_email: detachable READABLE_STRING_8
	customer_name: detachable READABLE_STRING_32

	amount_due,
	amount_paid,
	amount_remaining: NATURAL_32

	currency: detachable READABLE_STRING_8

	creation_timestamp: INTEGER

	creation_date: DATE_TIME
		do
			create Result.make_from_epoch (creation_timestamp)
		end

	hosted_invoice_url,
	invoice_pdf: detachable READABLE_STRING_8


	billing_reason: detachable READABLE_STRING_8

	status: detachable READABLE_STRING_8

	charge: detachable STRIPE_PAYMENT_CHARGE
	charge_id: detachable READABLE_STRING_8

	payment_intent: detachable STRIPE_PAYMENT_INTENT
	payment_intent_id: detachable READABLE_STRING_8

	subscription: detachable STRIPE_SUBSCRIPTION
	subscription_id: detachable READABLE_STRING_8

	lines: ARRAYED_LIST [STRIPE_INVOICE_LINE]

	metadata: detachable STRING_TABLE [detachable ANY]
			-- Set of key-value pairs that you can attach to an object.
			-- This can be useful for storing additional information about the object in a structured format.

	metadata_string_item (v: READABLE_STRING_GENERAL; a_is_recursive: BOOLEAN): detachable READABLE_STRING_GENERAL
		local
			l_line: STRIPE_INVOICE_LINE
			res: detachable READABLE_STRING_32
			has_conflict: BOOLEAN
		do
			if attached metadata as md then
				if attached {READABLE_STRING_GENERAL} md [v] as s then
					Result := s
				end
			end
			if Result = Void and a_is_recursive then
				across
					lines as ic
				loop
					l_line := ic.item
					if attached l_line.metadata as md then
						if attached {READABLE_STRING_GENERAL} md [v] as s then
							res := s
						else
							res := Void
						end
						if Result = Void then
							Result := res
						elseif
							res /= Void and then
							not res.is_case_insensitive_equal_general (Result)
						then
							has_conflict := True
						end
					end
				end
				if has_conflict then
					Result := Void
				end
			end
		end

feature -- Query

	description: detachable STRING_32
		do
			if attached lines as l_lines then
				across
					l_lines as ic
				loop
					if attached ic.item.description as d then
						if Result = Void then
							Result := d
						else
							Result := Result + "%N" + d
						end
					end
				end
			end
		end

end
