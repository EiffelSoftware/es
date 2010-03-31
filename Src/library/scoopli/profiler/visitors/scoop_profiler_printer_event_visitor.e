note
	description: "Printed event visitor.%
				 %This only prints out the events it sees."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PRINTER_EVENT_VISITOR

inherit
	SCOOP_PROFILER_EVENT_VISITOR
		redefine
			visit_processor_start,
			visit_processor_end,
			visit_profiling_start,
			visit_profiling_end,
			visit_feature_external_call,
			visit_feature_call,
			visit_feature_wait,
			visit_feature_application,
			visit_feature_return,
			visit_feature_wait_condition
		end

feature -- Visitor

	visit_processor_start (a_event: SCOOP_PROFILER_PROCESSOR_START_EVENT)
			-- Visit processor start.
		do
			print_event (a_event)
		end

	visit_processor_end (a_event: SCOOP_PROFILER_PROCESSOR_END_EVENT)
			-- Visit processor end.
		do
			print_event (a_event)
		end

	visit_profiling_start (a_event: SCOOP_PROFILER_PROFILING_START_EVENT)
			-- Visit profiling start.
		do
			print_event (a_event)
		end

	visit_profiling_end (a_event: SCOOP_PROFILER_PROFILING_END_EVENT)
			-- Visit profiling end.
		do
			print_event (a_event)
		end

	visit_feature_external_call (a_event: SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT)
			-- Visit external call.
		do
			print_event (a_event)
		end

	visit_feature_call (a_event: SCOOP_PROFILER_FEATURE_CALL_EVENT)
			-- Visit feature call.
		do
			print_event (a_event)
		end

	visit_feature_wait (a_event: SCOOP_PROFILER_FEATURE_WAIT_EVENT)
			-- Visit feature wait.
		do
			print_event (a_event)
		end

	visit_feature_application (a_event: SCOOP_PROFILER_FEATURE_APPLICATION_EVENT)
			-- Visit feature application.
		do
			print_event (a_event)
		end

	visit_feature_return (a_event: SCOOP_PROFILER_FEATURE_RETURN_EVENT)
			-- Visit feature return.
		do
			print_event (a_event)
		end

	visit_feature_wait_condition (a_event: SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT)
			-- Visit wait condition try.
		do
			print_event (a_event)
		end

feature {NONE} -- Implementation

	print_event (a_event: SCOOP_PROFILER_PROCESSOR_EVENT)
			-- Print `a_event`.
		require
			a_event /= Void
		do
			io.put_string (a_event.out + " " + a_event.code + "%N")
			loader.continue (a_event.processor_id)
		end

end
