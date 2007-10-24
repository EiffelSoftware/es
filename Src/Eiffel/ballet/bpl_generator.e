indexing
	description	: 	"ast visitor to generate bpl"
	legal: 			"See notice at end of class."
	status: 		"See notice at end of class."
	date		: 	"$Date$"
	revision	: 	"$Revision$"

class
	BPL_GENERATOR

inherit

	SHARED_SERVER
		export
			{NONE} all
		end

	SHARED_WORKBENCH

	BPL_VISITOR
		redefine
			process_class_as,
			make
		end

	SHARED_BPL_ENVIRONMENT
	
create
	make

feature {NONE} -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Initialization routine.
		do
			Precursor {BPL_VISITOR}(a_class)
			already_processed := False
		end

feature -- Actual Processing of a class

	process_class_as (l_as: CLASS_AS) is
			-- Process a class and generate BoogiePL
		do
			if already_processed then
				add_error (create {BPL_ERROR}.make ("Ballet can not handle multiple class definitions in one file."))
			else
				already_processed := True
				analyse_usage
				define_attributes
				define_functions
				define_signatures
				define_implementations
				define_used_features
			end
		end

feature {NONE} -- Implementation

	already_processed: BOOLEAN
		-- A class has already been processed, so there has to be more than one class definition in the file.

	analyse_usage is
			-- Analyse the usage.
		local
			a_list: LIST [FEATURE_I]
			usage_analyser: BPL_FEATURE_LIST_GENERATOR
		do
			create usage_analyser.make (current_class)
			usage_analyser.analyse
			environment.set_usage_analyser (usage_analyser)
			
			bpl_out ("// FEATURE LISTS ------------------------------------------%N")
			a_list := usage_analyser.query_list
			from a_list.start until a_list.off loop
				bpl_out ("// Query: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.command_list
			from a_list.start until a_list.off loop
				bpl_out ("// Command: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.deferred_command_list
			from a_list.start until a_list.off loop
				bpl_out ("// Def. Command: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.deferred_query_list
			from a_list.start until a_list.off loop
				bpl_out ("// Def. Query: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.attribute_list
			from a_list.start until a_list.off loop
				bpl_out ("// Attribute: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.function_list
			from a_list.start until a_list.off loop
				bpl_out ("// Function: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.constant_list
			from a_list.start until a_list.off loop
				bpl_out ("// Constant: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			a_list := usage_analyser.procedure_list
			from a_list.start until a_list.off loop
				bpl_out ("// Procedure: " + a_list.item.feature_name + "%N")
				a_list.forth
			end
			bpl_out ("%N")
		end

	attribute_writer: BPL_BN_ATTRIBUTE_WRITER

	define_attributes is
			-- Define all attributes of the current class.
		local
			a_list: LIST [FEATURE_I]
		do
			bpl_out ("// defining attributes%N")
			create attribute_writer.make (current_class)
			attribute_writer.set_leaf_list (match_list)

			a_list := environment.usage_analyser.attribute_list
			from a_list.start until a_list.off loop
				attribute_writer.write_attribute (a_list.item)
				a_list.forth
			end
		end

	function_writer: BPL_BN_FUNCTION_WRITER

	define_functions is
			-- Define all functions of the current class.
		local
			a_list: LIST [FEATURE_I]
		do
			bpl_out ("// defining functions%N")
			create function_writer.make (current_class)
			function_writer.set_leaf_list (match_list)

			a_list := environment.usage_analyser.deferred_query_list
			from a_list.start until a_list.off loop
				function_writer.write_function (a_list.item)
				a_list.forth
			end
			a_list := environment.usage_analyser.function_list
			from a_list.start until a_list.off loop
				function_writer.write_function (a_list.item)
				a_list.forth
			end
			a_list := environment.usage_analyser.constant_list
			from a_list.start until a_list.off loop
				function_writer.write_function (a_list.item)
				a_list.forth
			end
		end

	signature_writer: BPL_BN_SIGNATURE_WRITER

	define_signatures is
			-- Define all signatures of the current class.
		local
			a_list: LIST [FEATURE_I]
		do
			bpl_out ("// defining signatures: def_command%N")
			create signature_writer.make (current_class)
			signature_writer.set_leaf_list (match_list)

			a_list := environment.usage_analyser.deferred_command_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
			bpl_out ("// defining signatures: deferred_queries%N")
			a_list := environment.usage_analyser.deferred_query_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
			bpl_out ("// defining signatures: functions%N")
			a_list := environment.usage_analyser.function_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
			bpl_out ("// defining signatures: procedures%N")
			a_list := environment.usage_analyser.procedure_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
			bpl_out ("// defining signatures: attributes%N")
			a_list := environment.usage_analyser.attribute_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
			bpl_out ("// defining signatures: constants%N")
			a_list := environment.usage_analyser.constant_list
			from a_list.start until a_list.off loop
				signature_writer.write_signature (a_list.item)
				a_list.forth
			end
		end

	implementation_writer: BPL_BN_IMPLEMENTATION_WRITER

	define_implementations is
			-- Define all implementations of the current class.
		local
			a_list: LIST [FEATURE_I]
		do
			bpl_out ("// defining implementations%N")
			create implementation_writer.make (current_class)
			implementation_writer.set_leaf_list (match_list)

			a_list := environment.usage_analyser.function_list
			from a_list.start until a_list.off loop
				implementation_writer.write_implementation (a_list.item)
				a_list.forth
			end
			a_list := environment.usage_analyser.procedure_list
			from a_list.start until a_list.off loop
				implementation_writer.write_implementation (a_list.item)
				a_list.forth
			end
			a_list := environment.usage_analyser.constant_list
			from a_list.start until a_list.off loop
				implementation_writer.write_implementation (a_list.item)
				a_list.forth
			end
		end

	define_used_features is
			-- Define the features of all elements of all used elements.
		local
			generated_features: HASH_TABLE[ARRAYED_SET[FEATURE_I], EIFFEL_CLASS_C]
			some_feature: FEATURE_I
			some_class: EIFFEL_CLASS_C
			used_features: LIST[FEATURE_I]
		do
			from
				bpl_out ("// defining used features%N")
				create generated_features.make (0)
				used_features := environment.usage_analyser.used_feature_list.twin
			until
				used_features.is_empty
			loop
				used_features.start

				some_feature := used_features.item
				some_class ?= some_feature.written_class
				if
					some_class /= Void and then
					((generated_features.item (some_class) = Void)
								  or else (not generated_features.item (some_class).has (some_feature))) and
					bpl_type_for_class (some_class).is_equal ("ref") and
					some_class.class_id /= current_class.class_id
				 then
					if not types_in_background_theory.has (some_class.name) then
						if some_feature.is_function or some_feature.is_attribute or some_feature.is_constant then
							if some_feature.is_attribute then
								create attribute_writer.make (some_class)
								attribute_writer.write_attribute (some_feature)
							else
								create function_writer.make (some_class)
								function_writer.set_leaf_list (match_list)
								function_writer.write_function (some_feature)
							end
						end
						create signature_writer.make (some_class)
						signature_writer.set_leaf_list (match_list)
						signature_writer.write_signature (some_feature)
					end
					if generated_features.item (some_class) = Void then
						generated_features.put (create {ARRAYED_SET[FEATURE_I]}.make (8), some_class)
					end
					generated_features.item (some_class).extend (some_feature)
				end
				used_features.prune (some_feature)
			end
		end
	

indexing
	copyright:	"Copyright (c) 2006, 2007 Raphael Mack, Bernd Schöller"
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

end -- class BPL_GENERATOR
