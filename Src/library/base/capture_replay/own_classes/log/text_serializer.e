indexing
	description: "Objects that serializers captured events to a text file"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	TEXT_SERIALIZER

inherit
	CAPTURE_SERIALIZER

create
	make_on_textfile

feature -- Creation

	make_on_textfile(filename: STRING)
			-- Create the Serializer on the textfile `filename'
		do
			create {PLAIN_TEXT_FILE}file.make_open_write(filename)
	 	end

 feature -- Access
	file: FILE

	file_open: BOOLEAN  --log file open and initialized.
		do
			Result := file.is_open_write
		end

	debug_output: BOOLEAN
			--Should debug output be printed?

feature -- Status change

	set_debug_output(new_debug_output: BOOLEAN)
			-- Set `debug_output' to `new_debug_output'
		do
			debug_output := new_debug_output
		end

feature -- Basic operations

	write_incall (feature_name: STRING; target: ANY; arguments: TUPLE)
			-- Log an INCALL event for `target'.`feature'(`arguments').
		do
			write_call ("INCALL", feature_name, target, arguments)
		end

	write_incallret (the_result: ANY)
			-- Write the INCALLRET event for result `the_result'.
		do
			write_return ("INCALLRET", the_result)
		end

	write_outcall(feature_name: STRING; target: ANY; arguments: TUPLE)
			-- Write the OUTCALL event for `target'.`feature'(`arguments').
		do
			write_call ("OUTCALL", feature_name, target, arguments)
		end

	write_outcallret(the_result: ANY)
			-- Write the OUTCALLRET event for result `the_result'
		do
			write_return ("OUTCALLRET", the_result)
		end

	close_file
			-- See comment in 'open_file'
		do
			file.flush
			file.close
		ensure then
			file_closed: not file_open
		end

feature {NONE} -- Implementation

	Manifest_special_name: STRING is "MANIFEST_SPECIAL"


	basic_types: ARRAY[STRING]
			-- Array of all typenames that are considered to be a basic type.
		once
			create 	Result.make (1, 20)
			Result.put ("NONE", 1)
			Result.put ("POINTER", 2)
			Result.put ("CHARACTER_8", 3)
			Result.put ("BOOLEAN", 4)
			Result.put ("INTEGER_32", 5)
			Result.put ("INTEGER", 6)
			Result.put ("REAL", 7)
			Result.put ("REAL_32", 8)
			Result.put ("DOUBLE", 9)
			Result.put ("REAL_64", 10)
			Result.put ("POINTER", 11)
			Result.put ("INTEGER_8", 12)
			Result.put ("INTEGER_16", 13)
			Result.put ("INTEGER_64", 14)
			Result.put ("CHARACTER_32", 15)
			Result.put ("NATURAL_8", 16)
			Result.put ("NATURAL_16", 17)
			Result.put ("NATURAL_32", 18)
			Result.put ("NATURAL_64", 19)
				-- Simplify comparison with other strings:
			Result.compare_objects
		end

	internal: INTERNAL is
			-- The standard INTERNAL - instance
		once
			create Result
		end


	is_basic_type (value: ANY): BOOLEAN
			-- Is `value' of a reference type (and not of a basic type)?
		local
			type_name: STRING
			is_manifest_special: BOOLEAN
		do
			if value = Void then
				Result := False
			else
				type_name := value.generating_type
				is_manifest_special :=  type_name.substring_index ("MANIFEST_SPECIAL", 1) = 1
				Result := basic_types.has (type_name) or is_manifest_special
			end
		end

	write_object (value: ANY)
			-- Write a value (both basic and object types)
		do
			if is_basic_type (value) then
				write_basic (value)
			else --basic type
				write_non_basic (value)
			end
		end

	write_non_basic(object: ANY)
			-- serialize an object
		require
			argument_is_non_basic_type: not is_basic_type (object)
		do
			if object = Void then
				write (" [NON_BASIC NONE 0]")
			else
				write (" [NON_BASIC " + object.generating_type + " " + object.cr_object_id.out + "]")
			end
		end

	write_basic(value: ANY)
			-- Serialize a basic value
		require
			object_not_void: value /= Void
			argument_is_basic_type: is_basic_type (value)
		do
			write (" [BASIC ")
			write (value.generating_type)
			write (" %"")
			write (value.out)
			write ("%"]")
		end

	write_call(call_tag: STRING; feature_name: STRING; target: ANY; arguments: TUPLE)
			-- Serialize a call of type `call_tag' to `target'.`feature_name'(`arguments')
		require
			call_tag_not_void: call_tag /= Void
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void: arguments /= Void
		do
			write (call_tag)
			write_object (target)
			write (" " + feature_name)
			write_arguments (arguments)
			write_endline
		end

	write_return(return_tag: STRING; return_value: ANY)
			-- Write a return event with tag 'return_tag' (e.g. OUTCALLRET)
			-- and value 'return_value' 
		require
			return_tag_not_void: return_tag /= Void
		do
			write(return_tag)
			if return_value /= Void then
				write_object(return_value)
			end
			write_endline
		end

	write_arguments(arguments: TUPLE)
			--Write out 'arguments'
		require
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > arguments.count
			loop
				write_object(arguments.item(i))
				i := i+1
			end
		end


	write(content: STRING)
			-- Write `content'
		require
			content_not_void: content /= Void
			file_is_open: file.is_open_write
		do
			file.put_string (content)
			--XXX for debugging this is to make sure all events are in the file
			--    just in case of crashes.
			file.flush
			print_debug(content)
		end

	write_endline
			-- Append an newline character to the file.
		require
			file_is_open: file.is_open_write
		do
			file.put_new_line
			print_debug("%N")
		end

	report_error(message: STRING)
			-- Report the Error `message'
		require
			message_not_void: message /= Void
		do
			print("##ERROR: " + message)
		end

	print_debug(message: STRING)
			-- Print `message' if `debug_output' is enabled.
		do
			if debug_output then
				print("{TEXT_SERIALIZER}" + message)
			end
		end

invariant
	file_not_void: file /= Void -- Your invariant here

end
