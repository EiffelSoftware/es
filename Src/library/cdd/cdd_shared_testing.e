indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_SHARED_TESTING

inherit
	INTERNAL

feature -- Access

	is_set_up: BOOLEAN is
			-- Is test case set up?
		do
			Result := object_under_test /= Void
		end

	object_under_test: ANY is
			-- Object  beeing tested
		deferred
		end

	class_under_test: STRING is
			-- Name of the class beeing tested
		deferred
		end

	feature_under_test: STRING is
			-- Name of the feature beeing tested
		deferred
		end


feature -- Test execution

	set_up is
			-- Initialize `object_under_test' so the feature to test can be executed.
		deferred
		ensure
			is_set_up
		end

	run_feature_under_test is
			-- Call the feature under test with `object_under_test'.
		require
			is_set_up
		deferred
		end

feature -- Object creation

	build_object (a_class_name: STRING): ANY is
		local
			l_type: INTEGER
		do
			l_type := dynamic_type_from_string (a_class_name)
			Result := new_instance_of (l_type)
		end

	attributes: HASH_TABLE [ANY, STRING]

	set_attributes (obj: ANY) is
		local
			i: INTEGER
			name: STRING

			b: BOOLEAN
			c: CHARACTER
			i8: INTEGER_8
			i16: INTEGER_16
			i32: INTEGER_32
			i64: INTEGER_64
			n8: NATURAL_8
			n16: NATURAL_16
			n32: NATURAL_32
			n64: NATURAL_64
			r32: REAL_32
			r64: REAL_64
		do
			from
				i := 1
			until
				i > field_count (obj)
			loop
				name := field_name (i, obj)
				if attributes.has (name) then
					inspect field_type (i, obj)
					when reference_type then
						set_reference_field (i, obj, attributes.item (name))
					when boolean_type then
						b ?= attributes.item (name)
						set_boolean_field (i, obj, b)
					when character_type then
						c ?= attributes.item (name)
						set_character_field (i, obj, c)
					when integer_8_type then
						i8 ?= attributes.item (name)
						set_integer_8_field (i, obj, i8)
					when integer_16_type then
						i16 ?= attributes.item (name)
						set_integer_16_field (i, obj, i16)
					when integer_32_type then
						i32 ?= attributes.item (name)
						set_integer_32_field (i, obj, i32)
					when integer_64_type then
						i64 ?= attributes.item (name)
						set_integer_64_field (i, obj, i64)
					when natural_8_type then
						n8 ?= attributes.item (name)
						set_natural_8_field (i, obj, n8)
					when natural_16_type then
						n16 ?= attributes.item (name)
						set_natural_16_field (i, obj, n16)
					when natural_32_type then
						n32 ?= attributes.item (name)
						set_natural_32_field (i, obj, n32)
					when natural_64_type then
						n64 ?= attributes.item (name)
						set_natural_64_field (i, obj, n64)
					when real_32_type then
						r32 ?= attributes.item (name)
						set_real_32_field (i, obj, r32)
					when real_64_type then
						r64 ?= attributes.item (name)
						set_real_64_field (i, obj, r64)
					else
						-- Type we do not cover yet
					end
				else
					-- Test case does not reflect this attribute
				end
				i := i + 1
			end
		end

end
