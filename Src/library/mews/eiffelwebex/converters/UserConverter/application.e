indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	APPLICATION_CONSTANTS

create
	make

feature -- Initialization

	make is
			-- Run application.
		local
--			user1: USER
--			user1_dao: USER_DAO_FILE_IMPL
			user2: MID_USER
			user2_dao: MID_USER_DAO_FILE_IMPL
			user: INFORMATICS_USER
			user_dao: USER_MANAGER_FILE_IMPL

--			count1, count2: INTEGER
			encryptor: ENIGMA
			admin: INFORMATICS_USER
		do

			create user2_dao.make

			create encryptor.make(5)
			create user_dao.make ("D:\Li\UserConverter\EIFGENs\dataconverter\W_code\", "users", encryptor)


--			count1 := user2_dao.user_list.count

			from
				user2_dao.user_list.start
			until
				user2_dao.user_list.after
			loop
				user2 := user2_dao.user_list.item_for_iteration

				create user.make

				user.set_email (user2.email)
				user.set_first_name (user2.first_name)
				if not user2.last_name.is_empty then
					user.set_last_name (user2.last_name)
				else
					user.set_last_name (" ")
				end
				user.set_organization (user2.organization)
				user.set_password (user2.password)
				user.set_role (role_normal_user)
				user.set_status (User_Active)
				user.set_telephone ("-")
				user.set_username (user2.username)

				user_dao.add_user (user)

				user2_dao.user_list.forth
			end


--			count2 := user_dao.user_list.count

			create admin.make
			admin.set_username (admin_email)
			admin.set_first_name (admin_first_name)
			admin.set_last_name (admin_last_name)
			admin.set_email (admin_email)
			admin.set_password (admin_password)
			admin.set_organization (admin_organization)
			admin.set_telephone (admin_telephone)

			admin.set_role (role_administrator)

			user_dao.add_user(admin)

			user_dao.persist_data

		end

end -- class APPLICATION
