indexing
	description: "Objects that logs information"
	author: "Peizhu Li"
	date: "November 2007"
	revision: "$0.6$"

class
	LOGGER

create
	make

feature {none}-- Attribute

	output_file :PLAIN_TEXT_FILE
	filename :STRING
	log_level: INTEGER


feature -- Creation

make(path: STRING; level: INTEGER) is

	do
		log_level := level
	 	create filename.make_from_string (path)
	 	create output_file.make_open_append (filename)

	 ensure
	 	output_file.is_open_append
	end

feature -- access

	stamp is
		--
		local
			time:TIME
			date:DATE
		do
			if log_level >= 1 then
				create time.make_now
				create date.make_now
				output_file.put_string ("-----------------------------------------------------------------%N")
				output_file.put_string ("logging file '" + filename + "' timestamp: " + time.out + " " +  date.out + "%N")
			end
		end

	write (str:STRING; bAppendCRLF: BOOLEAN) is
			--
		require
			str /=void
		do
			if log_level >= 1 then
				if str.has_substring ("[INFO]") and  log_level >= 3 then
					output_file.put_string (str)
				elseif str.has_substring ("[WARNNING]") and log_level >= 2 then
						output_file.put_string (str)
				elseif str.has_substring ("[ERROR]") and log_level >= 1 then
						output_file.put_string (str)
				end

				if bAppendCRLF then
					output_file.new_line
				end
				output_file.flush
			end

		end

	writeln (str:STRING) is
			--
		require
			str /=void
		do
			write(str, True)
		end



	write_form_data(hash:HASH_TABLE [LINKED_LIST [STRING], STRING]) is
			-- write the hash table
		require
			hash_is_not_void:hash /=void
		local

			list :ARRAY [STRING]
			i :INTEGER
		do
			output_file.put_string ("Printing from data")
			output_file.put_string ("Number of elements in the hash: ")
		    output_file.put_string (hash.count.out)
			list:=hash.current_keys

			from i:=1  until list.count < i
			loop
				output_file.put_string ("Field:")
				output_file.put_string (list.item (i))
				output_file.put_string (", Value:")
				output_file.put_string (hash.item(list[i]).item)
				i:=i+1
			end
			output_file.flush
		end

invariant
	invariant_clause: True -- Your invariant here

end
