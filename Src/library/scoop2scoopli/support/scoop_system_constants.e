note
	description: "SCOOP System level constants."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SYSTEM_CONSTANTS

inherit
	SYSTEM_CONSTANTS

feature -- Scoop system constants

	scoop_proxy_class_prefix: STRING is "SCOOP_SEPARATE__"

	scoop_proxy_prefix: STRING is "scoop_separate__"

	proxy_conversion_feature_name: STRING is "proxy_"

	scoop_override_cluster_name: STRING is "scoop_override_cluster"

	scoop_library_name: STRING is "scoopli"

	scoop_library_path: STRING is "$ISE_LIBRARY\library\scoopli\scoopli.ecf"

	scoop_library_processor_setter_name: STRING is "set_processor_"

	scoop_library_processor_getter_name: STRING is "processor_"

	scoop_library_implementation_getter_name: STRING is "implementation_"

	scoop_starter_class_name: STRING is "SCOOP_STARTER"

	scoop_starter_feature_name: STRING is "make"

	thread_library_name: STRING is "thread"

	thread_library_path: STRING is "$ISE_LIBRARY\library\thread\thread.ecf"

	multithreading_enabled_setting: STRING is "True"

	base_precompile_filename: STRING is "base.ecf"

	base_mt_precompile_filename: STRING is "base-mt.ecf"

	base_library_name: STRING is "base"

	net_library_name: STRING = "net"

	classes_to_be_compiled: LINKED_LIST[STRING] is
			-- returns classes to be compiled
			do
				create_classes_to_be_compiled_list
				result := classes_to_be_compiled_list
			ensure
				not_void: classes_to_be_compiled_list /= void
			end


	nonseparate_result: STRING is "nonseparate_result"

	creation_object: STRING is "creation_object"

	create_creation_wrapper: STRING is "create_creation_wrapper"

	general_wrapper_name_additive: STRING is "_scoop_separate_"

	individual_separate_postcondition_wrapper_name_additive: STRING is "_spc_"

	unseparated_postcondition_attribute_name_additive: STRING is "_unseparated_postconditions"

	unseparated_postcondition_attribute_type: STRING is "LINKED_LIST [ROUTINE [ANY, TUPLE]]"

	enclosing_routine_name_additive: STRING is "_enclosing_routine"

	wait_condition_wrapper_name_additive: STRING is "_wait_condition"

	separate_postcondition_wrapper_name_additive: STRING is "_separate_postcondition"

	non_separate_postcondition_wrapper_name_additive: STRING is "_non_separate_postcondition"

feature {NONE}

	classes_to_be_compiled_list: LINKED_LIST[STRING]

	create_classes_to_be_compiled_list is
			-- creates classes to be compiled list
			do
				create classes_to_be_compiled_list.make
--				classes_to_be_compiled_list.extend ("ROUTINE")
--				classes_to_be_compiled_list.extend ("PROCEDURE")
--				classes_to_be_compiled_list.extend ("PREDICATE")
--				classes_to_be_compiled_list.extend ("FUNCTION")
--				classes_to_be_compiled_list.extend ("HASHABLE")
--				classes_to_be_compiled_list.extend ("TUPLE")
--				classes_to_be_compiled_list.extend ("MISMATCH_CORRECTOR")
--				classes_to_be_compiled_list.extend ("STRING_8")
--			    classes_to_be_compiled_list.extend ("STRING_32")
--			    classes_to_be_compiled_list.extend ("TO_SPECIAL")
--			    classes_to_be_compiled_list.extend ("RESIZABLE")
--			    classes_to_be_compiled_list.extend ("INDEXABLE")
--			    classes_to_be_compiled_list.extend ("READABLE_STRING_32")
--			    classes_to_be_compiled_list.extend ("STRING_GENERAL")
--			    classes_to_be_compiled_list.extend ("READABLE_STRING_8")
--			    classes_to_be_compiled_list.extend ("READABLE_STRING_GENERAL")
--			    classes_to_be_compiled_list.extend ("PART_COMPARABLE")
--			    classes_to_be_compiled_list.extend ("TABLE")
--			    classes_to_be_compiled_list.extend ("COLLECTION")
--			    classes_to_be_compiled_list.extend ("BOX")
--			    classes_to_be_compiled_list.extend ("BOUNDED")
--			    classes_to_be_compiled_list.extend ("BAG")
--			    classes_to_be_compiled_list.extend ("CONTAINER")
--			    classes_to_be_compiled_list.extend ("COMPARABLE")
--			    classes_to_be_compiled_list.extend ("FINITE")
--			    classes_to_be_compiled_list.extend ("PART_COMPARABLE")
--			    classes_to_be_compiled_list.extend ("STRING_HANDLER")
--			    classes_to_be_compiled_list.extend ("INTEGER_INTERVAL")
--			    classes_to_be_compiled_list.extend ("DISPENSER")
--			    classes_to_be_compiled_list.extend ("COUNTABLE_SEQUENCE")
--			    classes_to_be_compiled_list.extend ("SEQUENCE")
--			    classes_to_be_compiled_list.extend ("ARRAY")
--			    classes_to_be_compiled_list.extend ("HASH_TABLE")
--			    classes_to_be_compiled_list.extend ("CHARACTER_32_REF")
--			    classes_to_be_compiled_list.extend ("CHARACTER_8_REF")
--			    classes_to_be_compiled_list.extend ("READABLE_STRING_GENERAL")
--			    classes_to_be_compiled_list.extend ("INTEGER_64_REF")
--			    classes_to_be_compiled_list.extend ("INTEGER_16_REF")
--			    classes_to_be_compiled_list.extend ("INTEGER_8_REF")
--				classes_to_be_compiled_list.extend ("INTEGER_32_REF")
--			    classes_to_be_compiled_list.extend ("NATURAL_64_REF")
--			    classes_to_be_compiled_list.extend ("NATURAL_16_REF")
--			    classes_to_be_compiled_list.extend ("NATURAL_8_REF")
--				classes_to_be_compiled_list.extend ("NATURAL_32_REF")
--			    classes_to_be_compiled_list.extend ("REAL_32_REF")
--			    classes_to_be_compiled_list.extend ("REAL_64_REF")
--			    classes_to_be_compiled_list.extend ("NUMERIC")
--			    classes_to_be_compiled_list.extend ("DEBUG_OUTPUT")
--			    classes_to_be_compiled_list.extend ("UNBOUNDED")
--			    classes_to_be_compiled_list.extend ("SET")
--			    classes_to_be_compiled_list.extend ("CHAIN")
--			    classes_to_be_compiled_list.extend ("ARRAYED_QUEUE")
--			    classes_to_be_compiled_list.extend ("FILE")
--			    classes_to_be_compiled_list.extend ("ACTIVE")
--			    classes_to_be_compiled_list.extend ("QUEUE")
--			    classes_to_be_compiled_list.extend ("BILINEAR")
--			    classes_to_be_compiled_list.extend ("LINEAR")
--			    classes_to_be_compiled_list.extend ("TRAVERSABLE")
--			    classes_to_be_compiled_list.extend ("DYNAMIC_CHAIN")
--			    classes_to_be_compiled_list.extend ("DYNAMIC_LIST")
--			    classes_to_be_compiled_list.extend ("ARRAYED_LIST")
--			    classes_to_be_compiled_list.extend ("LIST")
--			    classes_to_be_compiled_list.extend ("CURSOR_STRUCTURE")
--			    classes_to_be_compiled_list.extend ("COUNTABLE")
--			    classes_to_be_compiled_list.extend ("IO_MEDIUM")
--			    classes_to_be_compiled_list.extend ("INFINITE")
--			    classes_to_be_compiled_list.extend ("DISPOSABLE")
--			    classes_to_be_compiled_list.extend ("STRING")
--			    classes_to_be_compiled_list.extend ("NATIVE_ARRAY")
--			    classes_to_be_compiled_list.extend ("SPECIAL")
--			    classes_to_be_compiled_list.extend ("ABSTRACT_SPECIAL")
			  --  l_list.extend ("MANAGED_POINTER")
			   -- l_list.extend ("CURSOR")
			   -- l_list.extend ("SYSTEM_STRING")
			    --l_list.extend ("PLATFORM")
			end


note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_SYSTEM_CONSTANTS
