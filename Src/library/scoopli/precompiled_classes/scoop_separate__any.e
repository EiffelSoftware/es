indexing
	description: "Objects that act as proxies for objects of type ANY"
	author: "Piotr Nienaltowski"
	date: "$ 2005/11/11 20:55:00 $"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_SEPARATE__ANY

inherit
	ANY
		rename
			out as any_out_, default_create as any_default_create_, conforms_to as any_conforms_to_,
			copy as any_copy_,
			default_rescue as any_default_rescue_, io as any_io_, is_equal as any_is_equal_,
			generator as any_generator
		select
			any_copy_, any_out_, any_default_create_, any_conforms_to_, any_default_rescue_, any_io_, any_is_equal_
		end

	SCOOP_SEPARATE_PROXY
		rename
			is_equal as separate_supplier_is_equal, conforms_to as separate_supplier_conforms_to,
			default_create as separate_supplier_default_create, default_rescue as separate_supplier_default_rescue,
			out as separate_supplier_out, io as separate_supplier_io, copy as separate_supplier_copy,
			generator as any_generator
		end

create
	make_from_local, set_processor_

convert
	make_from_local ({ANY})

feature -- Status report

	conforms_to (a_caller_: SCOOP_SEPARATE_TYPE; other: SCOOP_SEPARATE__ANY): BOOLEAN
		local
			a_function_to_evaluate: FUNCTION [ANY, TUPLE, BOOLEAN]
		do
			if other /= void and then other.processor_ = void then other.set_processor_ (a_caller_.processor_) end	-- Repeat for each separate formal argument that is not converted to non-separate.
			a_function_to_evaluate := agent implementation_.conforms_to (other)
			scoop_synchronous_execute (a_caller_, a_function_to_evaluate) -- Call the feature with auxiliary arguments.
			Result := a_function_to_evaluate.last_result
		end

feature -- Comparison

	is_equal (a_caller_: SCOOP_SEPARATE_TYPE; other: like Current): BOOLEAN
		local
			a_function_to_evaluate: FUNCTION [ANY, TUPLE, BOOLEAN]
 		do
			if other /= void and then other.processor_ = void then other.set_processor_ (a_caller_.processor_) end	-- Repeat for each separate formal argument that is not converted to non-separate.
			a_function_to_evaluate := agent implementation_.is_equal (other)
			scoop_synchronous_execute (a_caller_, a_function_to_evaluate) -- Call the feature with auxiliary arguments.
			Result := a_function_to_evaluate.last_result
		end

feature -- Output

	io (a_caller_: SCOOP_SEPARATE_TYPE): STD_FILES
			-- Handle to standard file setup
		once
			create Result
			Result.set_output_default
		end

	out (a_caller_: SCOOP_SEPARATE_TYPE): STRING_8 -- SCOOP_SEPARATE__STRING_8 is -- should it return SEPARATE_STRING?
		local
			a_function_to_evaluate: FUNCTION [ANY, TUPLE, STRING_8]
 		do
			Result := implementation_.out
--			a_function_to_evaluate := agent implementation_.out
--			scoop_synchronous_execute (a_caller_, a_function_to_evaluate) -- Call the feature with auxiliary arguments.
--			Result ?= a_function_to_evaluate.last_result
		end


feature -- Initialization

	default_create (a_caller_: SCOOP_SEPARATE_TYPE)
		do
			scoop_asynchronous_execute (a_caller_, agent implementation_.default_create)
		end

	default_create_scoop_separate_any (a_caller_: SCOOP_SEPARATE_TYPE) is
			-- Wrapper for creation procedure `default_create'.
		do
			scoop_asynchronous_execute (a_caller_, agent effective_default_create_scoop_separate_any)
		end

	effective_default_create_scoop_separate_any is
			-- Wrapper for creation procedure `default_create'.
		do
			create implementation_
		end

feature -- Basic operations

	default_rescue is
			-- Process exception for routines with no Rescue clause.
			-- (Default: do nothing.)
			-- Later on, proper exception handling for concurrent case should be performed.
		do
		end

	copy (a_caller_: SCOOP_SEPARATE_TYPE; other: like Current) is
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		local
			aux_other: like implementation_
 		do
			if other /= void then aux_other := other.implementation_ end -- Repeat for each separate formal argument that has to be converted to non-separate.
			scoop_asynchronous_execute (a_caller_, agent implementation_.copy (aux_other))
		end

feature -- Conversion

	make_from_local (l: like implementation_)
			-- Convert from non-separate object.
			-- Note that `processor_' will be void unless `l' is a separate client and its processor is set.
		local
			a_separate_client: SCOOP_SEPARATE_CLIENT
			special_class: SPECIAL [ANY]
		do
			create special_class.make (1)
			implementation_ := l
			a_separate_client ?= l
			if not l.conforms_to (special_class) and then a_separate_client /= void and then  a_separate_client.processor_ /= Void then
				processor_ := a_separate_client.processor_
			else
--				scoop_scheduler.find_and_set_processor_ (Current)
--				processor_ := void			
			end
		ensure
			implementation_ = l
		end

	import (a_caller_: SCOOP_SEPARATE_TYPE): like implementation_
			-- Return a local (deep) copy of `implementation_'
		local
			a_function_to_evaluate: FUNCTION [ANY, TUPLE, ANY]
			a_processor, a_new_processor: SCOOP_PROCESSOR
			a_sep_client: SCOOP_SEPARATE_CLIENT
			a_field: SCOOP_SEPARATE_PROXY
			a_new_field: SCOOP_SEPARATE_CLIENT
			l_internal: INTERNAL
			i: INTEGER_32
		do
			create l_internal
			a_function_to_evaluate := agent implementation_.twin
			a_sep_client ?= implementation_
			if a_sep_client /= Void then
				a_processor := a_sep_client.processor_
				a_sep_client.set_processor_ (create {SCOOP_PROCESSOR}.make (scoop_scheduler))

				scoop_synchronous_execute (a_caller_, a_function_to_evaluate)
				Result ?= a_function_to_evaluate.last_result

				from
					i := 1
				until
					i >	l_internal.field_count (Result)
				loop
					a_field ?= l_internal.field (i, Result)
					if a_field = Void and then not l_internal.field_name (i, Result).is_equal ("processor_") then
						a_new_field ?= l_internal.field (i, Result).twin
						if a_new_field /= Void then
							a_new_field.set_processor_ (a_sep_client.processor_)
							l_internal.set_reference_field (i, Result, a_new_field)
						elseif l_internal.field_type (i, Result) = l_internal.reference_type then
							l_internal.set_reference_field (i, Result, l_internal.field (i, Result).twin)
						end
					end
					i := i + 1
				end


				a_sep_client.set_processor_ (a_processor)
			else
				scoop_synchronous_execute (a_caller_, a_function_to_evaluate)
				Result ?= a_function_to_evaluate.last_result
			end
--			a_function_to_evaluate := agent implementation_.deep_twin

		end

end
