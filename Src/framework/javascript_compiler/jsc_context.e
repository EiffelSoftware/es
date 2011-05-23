note
	description : "Context of translation. Available to children of SHARED_JSC_ENVIRONMENT."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima."
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_CONTEXT

inherit
	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

	SHARED_JSC_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object.
		do
			create name_mapper.make
			create informer.make
			create {LINKED_STACK[attached FEATURE_I]}current_features.make
			create {LINKED_STACK[attached LIST[attached JSC_BUFFER_DATA]]}old_locals.make
			create {LINKED_STACK[INTEGER]}object_test_locals.make
			create {LINKED_STACK[INTEGER]}reverse_locals.make
			create {LINKED_STACK[INTEGER]}line_numbers.make

			push_line_number(0)
		end

feature -- Access

	name_mapper: attached JSC_NAME_MAPPER
		-- Names provider

	informer: attached JSC_CLASS_INFORMER
		-- Class info provider

feature -- Class Context

	has_current_class: BOOLEAN
		do
			Result := unsafe_current_class /= Void
		end

	current_class: attached CLASS_C assign set_current_class
		require
			has_current_class: has_current_class
		local
			l_current_class: CLASS_C
		do
			l_current_class := unsafe_current_class
			check l_current_class /= Void end

			Result := l_current_class
		end

	set_current_class (a_current_class: attached CLASS_C)
		do
			unsafe_current_class := a_current_class
		end

	current_class_name: attached STRING
		local
			l_name: STRING
		do
			l_name := current_class.name_in_upper
			check l_name /= Void end
			Result := l_name
		end

feature -- Feature Context

	feature_nesting_level: INTEGER
		do
			Result := current_features.count
		end

	has_current_feature: BOOLEAN
		do
			Result := current_features.count > 0
		end

	current_feature: attached FEATURE_I
		require
			has_current_feature: has_current_feature
		do
			Result := current_features.item
		end

	current_feature_name: attached STRING
		require
			has_current_feature: has_current_feature
		local
			l_name: STRING
		do
			l_name := current_feature.feature_name
			check l_name /= Void end

			Result := l_name
		end

	push_feature (a_feature: attached FEATURE_I)
		do
			current_features.put (a_feature)
			push_locals
		end

	push_locals
		local
			l_list: LINKED_LIST[attached JSC_BUFFER_DATA]
		do
			create l_list.make
			old_locals.put (l_list)

			object_test_locals.put (0)
			reverse_locals.put (0)
		end

	pop_feature
		do
			current_features.remove
			pop_locals
		end

	pop_locals
		do
			old_locals.remove
			object_test_locals.remove
			reverse_locals.remove
		end

feature -- Line number context

	current_line_number: INTEGER
		do
			Result := line_numbers.item
		end

	push_line_number (a_line_number: INTEGER)
		do
			line_numbers.put (a_line_number)
		end

	pop_line_number
		do
			line_numbers.remove
		end

feature -- old() expressions

	current_old_locals: attached LIST[attached JSC_BUFFER_DATA]
		do
			Result := old_locals.item
		end

	add_old_local (a_data: attached JSC_BUFFER_DATA)
		do
			current_old_locals.extend (a_data)
		end

	old_local_name (i: INTEGER): attached STRING
		do
			Result := "$old" + i.out
		end

	last_old_local: attached STRING
		do
			Result := old_local_name (current_old_locals.count)
		end

feature -- Object Test Locals

	current_object_test_locals: INTEGER
		do
			Result := object_test_locals.item
		end

	current_reverse_locals: INTEGER
		do
			Result := reverse_locals.item
		end

	add_object_test_local: attached STRING
		local
			current_cnt: INTEGER
		do
			current_cnt := current_object_test_locals
			object_test_locals.remove
			object_test_locals.extend (current_cnt + 1)
			Result := object_test_local_name (current_cnt + 1)
		end

	add_reverse_local: attached STRING
		local
			current_cnt: INTEGER
		do
			current_cnt := current_reverse_locals
			reverse_locals.remove
			reverse_locals.extend (current_cnt + 1)
			Result := reverse_local_name (current_cnt + 1)
		end

	object_test_local_name (a_index: INTEGER): attached STRING
		do
			Result := "$obj_test" + a_index.out
		end

	reverse_local_name (a_index: INTEGER): attached STRING
		do
			Result := "$reverse" + a_index.out
		end

feature -- Helpers

	create_error (a_message, a_description: attached STRING): JSC_ERROR
		do
			create Result.make (a_message, a_description)
			Result.use_data_from_context
		end

	add_error (a_message, a_description: attached STRING)
		do
			errors.extend (create_error (a_message, a_description))
		end

	add_warning (a_message, a_description: attached STRING)
		do
			warnings.extend (create_error (a_message, a_description))
		end

feature -- Reserved JavaScript words

	is_reserved_javascript_word (a_str: attached STRING): BOOLEAN
		do
			Result := reserved_javascript_words.has (a_str);
		end

feature {NONE} -- Implementation

	current_features : attached STACK[attached FEATURE_I]
		-- Stack of features

	old_locals : attached STACK[attached LIST[attached JSC_BUFFER_DATA]]
		-- Stack of locals resulted from the usage of old()

	object_test_locals : attached STACK[INTEGER]
		-- Stack of locals resulted from object tests

	reverse_locals : attached STACK[INTEGER]
		-- Stack of locals resulted from object tests

	unsafe_current_class: CLASS_C
		-- Current class

	line_numbers : attached STACK[INTEGER]
		-- Stack of line numbers

feature {NONE} -- Implementation

	reserved_javascript_words: attached SET[attached STRING]
			-- See: https://developer.mozilla.org/en/JavaScript/Reference/Reserved_Words
		local
			l_reserved: ARRAY[attached STRING]
			i: INTEGER
		once
			create {LINKED_SET[attached STRING]}Result.make
			Result.compare_objects

				-- The following are reserved words and may not be used as variables, functions, methods, or object identifiers.
			l_reserved := <<
				-- The following are reserved as existing keywords by the ECMAScript specification:
			"break", "case", "catch", "continue", "default", "delete", "do", "else",
			"finally", "for", "function", "if", "in", "instanceof", "new", "return",
			"switch", "this", "throw", "try", "typeof", "var", "void", "while", "with",
				-- The following are reserved as future keywords by the ECMAScript specification:
			"abstract", "boolean", "byte", "char", "class", "const", "debugger", "double",
			"enum", "export", "extends", "final", "float", "goto", "implements", "import",
			"int", "interface", "long", "native", "package", "private", "protected",
			"public", "short", "static", "super", "synchronized", "throws", "transient",
			"volatile",
				-- Additionally, null is reserved as null literals by the ECMAScript specification, and
				-- true and false are reserved as boolean literals by the ECMAScript specification.
			"null", "true", "false" >>

			from
				i := l_reserved.lower
			until
				i > l_reserved.upper
			loop
				Result.extend (l_reserved[i])
				i := i + 1
			end
		end

end
