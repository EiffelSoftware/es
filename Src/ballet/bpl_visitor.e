indexing
	description	: "superclass for the ast visitors in ballet"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

deferred class
   BPL_VISITOR

inherit

	AST_ROUNDTRIP_ITERATOR
		redefine
			process_feature_as,
			process_symbol_as,
			process_keyword_as,
			process_id_as
		end

	SHARED_BPL_ENVIRONMENT

feature{NONE} -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Class to process.
		require
			not_void: a_class /= Void
		do
			create factory
			current_class := a_class
		ensure
			class_set: current_class = a_class
		end

feature -- Access

	current_class: EIFFEL_CLASS_C
			-- Current class

	current_feature: FEATURE_I
			-- Current feature

feature -- Setup

	set_current_class (a_class: EIFFEL_CLASS_C) is
			-- Set the `current_class' to `a_class'.
		require
			not_void: a_class /= Void
		do
			current_class := a_class
		ensure
			value_set: current_class = a_class
		end

	set_current_feature (a_feature: FEATURE_I) is
			-- Set the `current_feature' to `a_feature'.
		do
			current_feature := a_feature
		ensure
			value_set: current_feature = a_feature
		end

feature -- Processing

	process_feature_as (l_as: FEATURE_AS) is
		do
			current_feature := current_class.feature_named (l_as.feature_name.name)
			Precursor (l_as)
			current_feature := Void
		end

	process_symbol_as (l_as: SYMBOL_AS) is
			-- Do nothing here (causes problems).
		do

		end

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Do nothing here (causes problems).
		do

		end

	process_id_as (l_as: ID_AS) is
			-- Do nothing here (causes problems).
		do

		end

feature -- Helper

	nested_as_to_nested_expr_as (a_nested_as: NESTED_AS): NESTED_EXPR_AS is
			-- Transform a NESTED_AS subtree into a NESTED_EXPR_AS subtree
		require
			not_void: a_nested_as /= Void
		local
			sub_n: NESTED_AS
			sub_ne: NESTED_EXPR_AS
			new_expr: EXPR_CALL_AS
		do
			sub_n ?= a_nested_as.message
			new_expr := factory.new_expr_call_as (a_nested_as.target)
			if sub_n /= Void then
				sub_ne := nested_as_to_nested_expr_as (sub_n)
				Result := prefix_expression (new_expr,sub_ne)
			else
				Result := factory.new_nested_expr_as (new_expr,a_nested_as.message,Void,Void,Void)
			end
		ensure
			not_void: Result /= Void
		end

	prefix_expression (e: EXPR_CALL_AS; ne: NESTED_EXPR_AS): NESTED_EXPR_AS is
			-- Prefix the call of `ne' with a target `e'.
		local
			sub_ne: NESTED_EXPR_AS
			new_expr: EXPR_CALL_AS
		do
			sub_ne ?= ne.target
			if sub_ne /= Void then
				new_expr := factory.new_expr_call_as (prefix_expression (e,sub_ne))
				Result := factory.new_nested_expr_as (new_expr, ne.message, Void, Void, Void)
			else
				new_expr ?= ne.target
				check
					must_be_expr_call: new_expr /= Void
				end
				sub_ne := factory.new_nested_expr_as (e,new_expr.call, Void, Void, Void)
				new_expr := factory.new_expr_call_as (sub_ne)
				Result := factory.new_nested_expr_as (new_expr,ne.message, Void, Void, Void)
			end
		end

	factory: AST_FACTORY

	location_info (pos: AST_EIFFEL; tag: STRING): STRING is
			-- The information tag for `x'.
		do
			Result := "// eiffel:"
			Result.append (current_class.name)
			Result.append (";")
			Result.append (pos.start_location.line.out)
			Result.append (";")
			Result.append (pos.start_location.column.out)
			Result.append (";")
			Result.append (pos.end_location.line.out)
			Result.append (";")
			Result.append (pos.end_location.column.out)
			Result.append (";")
			if tag /= Void then
				Result.append (tag)
			end
			Result.append ("%N")
		end

	bpl_type_for_class (a_class: CLASS_C):STRING is
			-- BPL type for class `a_class'.
		require
			not_void: a_class /= Void
		do
			if mapping_table.item(a_class.name) /= Void then
				Result := mapping_table.item (a_class.name)
			elseif a_class.is_expanded then
				add_error(create {BPL_ERROR}.make("Cannot handle type '" + a_class.name
											  + "' since it's expanded."))
				Result := ""
			else
				Result := once "ref"
			end
		end

	bpl_type_for_type_a (type: TYPE_A): STRING is
			-- Compute the suitable type in BPL for `type'.
		require
			type_not_void: type /= Void
		local
			actual: TYPE_A
			name: STRING
		do
			actual := type
			if actual.has_associated_class then
				name := actual.associated_class.name
			else
				if actual.is_boolean then
					name := "BOOLEAN"
				elseif actual.is_integer or actual.is_character then
					name := "INTEGER_32"
				else
					name := "ANY"
				end
			end
			if mapping_table.item(name) /= Void then
				Result := mapping_table.item (name)
			elseif actual.is_expanded then
				Result := "wrong_type"
				add_error(create {BPL_ERROR}.make("Cannot handle type '"+actual.dump+"' since it's expanded."))
			else
				Result := "ref"
			end
         io.put_string("Result = " + Result + "2%N")
		ensure
			Result_not_void: Result /= Void
		end

	bpl_infix_operator_for (op:STRING): STRING is
			-- BPL version of the infix operator `op'
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if infix_operator_table.item (op) /= Void then
				Result := infix_operator_table.item (op)
			else
				Result := op
			end
		ensure
			not_void: Result /= Void
		end

	bpl_prefix_operator_for (op:STRING): STRING is
			-- BPL version of the prefix operator `op'
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if prefix_operator_table.item (op) /= Void then
				Result := prefix_operator_table.item (op)
			else
				Result := op
			end
		ensure
			not_void: Result /= Void
		end

	bpl_mangled_operator (op:STRING): STRING is
			-- Operator mangled that it can be used as function name in BPL
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if operator_names_mangled.item (op) /= Void then
				Result := operator_names_mangled.item (op)
			else
				-- Self-defined operator, we just make up a name
				Result := "op$"+operator_names_mangled.count.out
				operator_names_mangled.put (Result, op)
			end
		ensure
			not_void: Result /= Void
		end

	bpl_mangled_feature_name (op: STRING): STRING is
			-- Feature name mangled that it can be used as function name in BPL
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if op.substring (1, 7).is_equal ("infix %"") then
				Result := bpl_mangled_operator (op.substring (8, op.count-1))
			elseif op.substring (1, 8).is_equal ("prefix %"") then
				Result := bpl_mangled_operator (op.substring (9, op.count-1))
			else
				Result := op
			end
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Implementation
   types_in_background_theory: ARRAY[STRING] is
         -- names of all types, which are defined in the background theory
      once
         Result := <<"ANY", "INTEGER", "INTEGER_8",
         "INTEGER_16", "INTEGER_32", "INTEGER_64",
         "STRING", "STRING_8",
         "MML_DEFAULT_SET", "MML_SET",
         "FRAME">>
      end

	Mapping_table: TABLE[STRING, STRING] is
			-- Table of mappings between Eiffel and BPL types
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(19)
			Result.compare_objects
			Result.put("ref", "ANY")
			Result.put("int", "INTEGER")
			Result.put("int", "INTEGER_8")
			Result.put("int", "INTEGER_16")
			Result.put("int", "INTEGER_32")
			Result.put("int", "INTEGER_REF")
			Result.put("int", "INTEGER_8_REF")
			Result.put("int", "INTEGER_16_REF")
			Result.put("int", "INTEGER_32_REF")
			Result.put("int", "CHARACTER")
			Result.put("int", "CHARACTER_8")
			Result.put("int", "CHARACTER_32")
			Result.put("int", "CHARACTER_REF")
			Result.put("int", "CHARACTER_8_REF")
			Result.put("int", "CHARACTER_32_REF")
			Result.put("bool", "BOOLEAN")
			Result.put("frame", "FRAME")
			Result.put("set", "MML_SET")
			Result.put("set", "MML_DEFAULT_SET")
		end

	Infix_Operator_table: TABLE[STRING, STRING] is
			-- String-Versions of Operators
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(9)
			Result.compare_objects
			Result.put ("==", "=")
			Result.put ("!=", "/=")
			Result.put ("&&","and")
			Result.put ("||","or")
			Result.put ("&&","and then")
			Result.put ("||","or else")
			Result.put ("==>","implies")
		end

	Prefix_Operator_table: TABLE[STRING, STRING] is
			-- String-Versions of Operators
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(9)
			Result.compare_objects
			Result.put ("!","not")
		end

	Operator_names_mangled: HASH_TABLE[STRING, STRING] is
			-- Names for simple operators.
		do
			create Result.make(9)
			Result.compare_objects
			Result.put ("op$not","not")
			Result.put ("op$plus","+")
			Result.put ("op$minus","-")
			Result.put ("op$mult","*")
			Result.put ("op$div","/")
			Result.put ("op$less","<")
			Result.put ("op$more",">")
			Result.put ("op$leq","<=")
			Result.put ("op$meq",">=")
			Result.put ("op$divdiv","//")
			Result.put ("op$vidvid","\\")
			Result.put ("op$hat","^")
			Result.put ("op$and","and")
			Result.put ("op$or","or")
			Result.put ("op$xor","xor")
			Result.put ("op$andthen","and then")
			Result.put ("op$orelse","or else")
			Result.put ("op$implies","implies")
		end

invariant
	factory_exists: factory /= Void

indexing
	copyright:	"Copyright (c) 2006, Raphael Mack and Bernd Schoeller"
	license:	"GPL version 2 or later"
	copying: "[

             This program is free software; you can redistribute it and/or
             modify it under the terms of the GNU General Public License as
             published by the Free Software Foundation; either version 2 of
             the License, or (at your option) any later version.
             
             This program is distributed in the hope that it will be useful,
             but WITHOUT ANY WARRANTY; without even the implied warranty of
             MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
             GNU General Public License for more details.
             
             You should have received a copy of the GNU General Public
             License along with this program; if not, write to the Free Software
             Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
             MA 02110-1301  USA

		]"

end -- class BPL_VISITOR
