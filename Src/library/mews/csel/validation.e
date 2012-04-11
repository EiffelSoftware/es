indexing
	description: "Objects that are used to validate users of an application"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	VALIDATOR

create
	make

feature {NONE} -- Initialization

	make (user_dao:USER_DAO) is
			-- Initialize `Current'
		do
			users:=user_dao.user_list
			create administrators.make (5)
			administrators.put ("dummy","admin")
		end

feature -- Basic operations

	is_user_validated (userid,password:STRING):BOOLEAN
			--is user valid?
		local
			the_user:USER
			do
				if  is_field_value_valid (userid) AND is_field_value_valid (password) then
					users.search (userid)
					if users.found then
							the_user:=users.found_item
							if the_user.password.is_equal (password) then
						 		Result:= True
							end
					end
				end
			end

	is_existing_username (a_username:STRING):BOOLEAN
			--is username already been registered?
		require
			a_username_exists:a_username/=Void
		do
			users.search (a_username)
			if users.found then
				Result:= True
			else
				Result:=False
			end
		end

	is_administrator_validated (userid,password:STRING):BOOLEAN
			-- is administrator login valid?
		do
			if  is_field_value_valid (userid) AND is_field_value_valid (password) then
				administrators.search (userid)
				if administrators.found AND THEN password.is_equal (administrators.found_item) then
					 Result:= True
				end
			end
		end

	is_field_value_valid (field:STRING):BOOLEAN
			--is field value valid?
		do
			if  field /= Void then
				field.left_adjust
				field.right_adjust
				if (NOT field.is_empty) then
					Result:= True
				end
			end
		end

	is_email_valid (email:STRING):BOOLEAN
			--is email valid? (non-void, non-empty after eliminating leading and trailing spaces, with only one '@')
		do

			if  email /= Void then
				email.left_adjust
				email.right_adjust
				if (NOT email.is_empty AND THEN email.occurrences('@')=1) then
					Result:= True
				end
			end
		end

	is_date_valid (day,month,year:STRING):BOOLEAN
			-- is date valid?
		local
			date_checker:DATE_VALIDITY_CHECKER
		do
			if is_field_value_valid (day) AND is_field_value_valid (month) AND is_field_value_valid (year) then
				if day.is_integer AND month.is_integer AND year.is_integer then
					create date_checker
					if  date_checker.is_correct_date (year.to_integer,month.to_integer,day.to_integer) then
						Result:= True
					end
				end
			end
		end

	is_non_required_date_valid (day,month,year:STRING):BOOLEAN
			-- is date which is not required valid? It accepts n/a
		local
			date_checker:DATE_VALIDITY_CHECKER
		do
			if is_field_value_valid (day) AND is_field_value_valid (month) AND is_field_value_valid (year) then
				if day.is_equal("n/a") OR month.is_equal("n/a") OR year.is_equal("n/a") then
					Result:=True
				elseif day.is_integer AND month.is_integer AND year.is_integer then
					create date_checker
					if  date_checker.is_correct_date (year.to_integer,month.to_integer,day.to_integer) then
						Result:= True
					end
				end
			end
		end

	is_country_valid (country:STRING):BOOLEAN
			--is country valid (against a default value of "Please Choose")?
		require
			country_exists:country/=Void
		do
			if NOT country.is_equal ("Please choose") then
				Result:=True
			end
		end

feature {NONE} -- Implementation

	users:HASH_TABLE[USER,STRING]
	administrators:HASH_TABLE[STRING,STRING]

invariant
	invariant_clause: users/=Void
end
