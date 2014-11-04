note
	description: "{NSS} represents the core of the NSS library."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	NSS

create {NSS_ACCESS}
	make

feature {NONE}
	make
		do
		end

feature -- Status report
	initialized: BOOLEAN

	config_directory: ESTRING_8 assign set_config_directory

	cert_prefix: ESTRING_8 assign set_cert_prefix

	key_prefix: ESTRING_8 assign set_key_prefix

	secmod_name: ESTRING_8 assign set_secmod_name

	flags: NATURAL_32 assign set_flags

feature -- Status setting
	set_config_directory (a_config_directory: ESTRING_8)
		require
			not initialized
		do
			config_directory := a_config_directory
		ensure
			config_directory = a_config_directory
		end

	set_cert_prefix (a_cert_prefix: ESTRING_8)
		require
			not initialized
		do
			cert_prefix := a_cert_prefix
		ensure
			cert_prefix = a_cert_prefix
		end

	set_key_prefix (a_key_prefix: ESTRING_8)
		require
			not initialized
		do
			key_prefix := a_key_prefix
		ensure
			key_prefix = a_key_prefix
		end

	set_secmod_name (a_secmod_name: ESTRING_8)
		require
			not initialized
		do
			secmod_name := a_secmod_name
		ensure
			secmod_name = a_secmod_name
		end

	set_flags (a_flags: NATURAL_32)
		require
			not initialized
		do
			flags := a_flags
		ensure
			flags = a_flags
		end

	initialize
		require
			not initialized
		do
			initialized := True
		ensure
			initialized
		end

feature {NONE} -- Implementation
	c: NSS_C

end
