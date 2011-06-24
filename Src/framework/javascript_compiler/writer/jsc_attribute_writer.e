note
	description : "Translate an attribute to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_ATTRIBUTE_WRITER

inherit
	SHARED_JSC_CONTEXT
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize writer.
		do
			create output.make
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript

feature -- Basic operations

	reset (a_indentation: attached STRING)
		do
			output.reset (a_indentation)
		end

	write_attribute (a_feature: attached FEATURE_I)
			-- Write JavaScript code for attribute `a_feature'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_feature_name: STRING
			default_value_writer: JSC_DEFAULT_VALUE_WRITER
			attr: ATTRIBUTE_I
			l_attr_type: TYPE_A
		do
			l_feature_name := a_feature.feature_name
			check l_feature_name /= Void end

			attr ?= a_feature
			check attr /= Void end

			l_attr_type := attr.type
			check l_attr_type /= Void end

			if jsc_context.is_reserved_javascript_word (l_feature_name) then
				jsc_context.add_warning ("JavaScript reserved word", "What to do: Rename attribute " + l_feature_name + ".")
			end

			create default_value_writer.make

			output.put_indentation
			output.put (jsc_context.name_mapper.feature_name (a_feature, false))
			output.put (": ")
			output.put (default_value_writer.default_value (l_attr_type))
		end
end
