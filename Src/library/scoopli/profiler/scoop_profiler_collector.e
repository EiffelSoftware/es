note
	description: "Profile data collector."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_COLLECTOR

inherit
	INTERNAL
		export {NONE}
			all
		end

create {SCOOP_PROCESSOR}
	make_with_processor

feature {NONE} -- Creation

	make_with_processor (a_processor: SCOOP_PROCESSOR)
			-- Creation procedure.
		require
			processor_not_void: a_processor /= Void
		do
			create events.make
			create store_handler
			processor := a_processor
		ensure
			events_not_void: events /= Void
			store_handler_not_void: store_handler /= Void
			processor_ser: processor = a_processor
		end

feature {SCOOP_PROCESSOR} -- Basic Operations

	set_information (a_info: like information)
			-- Set `information` to `a_info`.
		require
			info_not_void: a_info /= Void
		do
			information := a_info
		ensure
			information_set: information = a_info
		end

feature -- Status report

	has_separate_arguments (a_routine: ROUTINE [ANY, TUPLE]): BOOLEAN
			-- Does `a_routine` have separate arguments?
		local
			l_class, l_feature: INTEGER
		do
			l_class := class_id_of (a_routine)
			l_feature := feature_id_of (a_routine)
			if information.classes.has (l_class) and then information.classes.item (l_class).features.has (l_feature) then
				Result := information.classes.item (l_class).features.item (l_feature).has_separate_arguments
			end
		end

feature {SCOOP_PROFILER_COLLECTOR} -- Measurement

	collect_feature_external_call (a_routine: ROUTINE [ANY, TUPLE]; a_called: SCOOP_PROCESSOR; a_sync: BOOLEAN)
			-- Collect external call of feature `a_routine`, called on `a_called`, synchronous if `a_sync`.
		require
			routine_not_void: a_routine /= Void
			called_not_void: a_called /= Void
		local
			e: SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT
		do
			create e.make_now
			e.set_processor (processor_id_of (processor))
			e.set_called_id (processor_id_of (a_called))
			e.set_class_name (class_name_of (a_routine))
			e.set_feature_name (feature_name_of (a_routine))
			e.set_synchronous (a_sync)
			events.extend (e)
		ensure
			events_increased: events.count = old events.count + 1
		end

feature -- Measurement

	collect_feature_call (a_routine: ROUTINE [ANY, TUPLE]; a_caller: SCOOP_PROCESSOR; a_sync: BOOLEAN)
			-- Collect external call of feature `a_routine`, called from `a_caller`, synchronous if `a_sync`.
		require
			routine_not_void: a_routine /= Void
			caller_not_void: a_caller /= Void
		local
			e: SCOOP_PROFILER_FEATURE_CALL_EVENT
		do
			if information.classes.has (class_id_of (a_routine)) then
				create e.make_now
				e.set_processor (processor_id_of (processor))
				e.set_caller_id (processor_id_of (a_caller))
				e.set_class_name (class_name_of (a_routine))
				e.set_feature_name (feature_name_of (a_routine))
				e.set_synchronous (a_sync)
				events.extend (e)

				-- Send external call event to caller
				a_caller.profile_collector.collect_feature_external_call (a_routine, processor, a_sync)
			end
		ensure
			events_increased: events.count = old events.count + 2
		end

	collect_feature_wait (a_routine: ROUTINE [ANY, TUPLE]; a_requested_processors: LINKED_LIST [SCOOP_PROCESSOR])
			-- Collect feature `a_routine` wait, requesting `a_requested_processors`.
		require
			routine_not_void: a_routine /= Void
			requested_processors_not_void: a_requested_processors /= Void
		local
			e: SCOOP_PROFILER_FEATURE_WAIT_EVENT
		do
			if information.classes.has (class_id_of (a_routine)) then
				-- Collect wait
				create e.make_now
				e.set_processor (processor_id_of (processor))
				e.set_class_name (class_name_of (a_routine))
				e.set_feature_name (feature_name_of (a_routine))
				from
					a_requested_processors.start
				variant
					a_requested_processors.count - a_requested_processors.index + 1
				until
					a_requested_processors.after
				loop
					e.requested_processor_ids.extend (processor_id_of (a_requested_processors.item))
					a_requested_processors.forth
				end
				events.extend (e)
			end
		ensure
			events_increased: events.count = old events.count + 1
		end

	collect_feature_application (a_routine: ROUTINE [ANY, TUPLE])
			-- Collect application of `a_routine`.
		require
			a_routine /= Void
		local
			e: SCOOP_PROFILER_FEATURE_APPLICATION_EVENT
		do
			if information.classes.has (class_id_of (a_routine)) then
				create e.make_now
				e.set_processor (processor_id_of (processor))
				e.set_class_name (class_name_of (a_routine))
				e.set_feature_name (feature_name_of (a_routine))
				events.extend (e)
			end
		ensure
			events_increased: events.count = old events.count + 1
		end

	collect_feature_return (a_routine: ROUTINE [ANY, TUPLE])
			-- Collect return of `a_routine`.
		require
			a_routine /= Void
		local
			e: SCOOP_PROFILER_FEATURE_RETURN_EVENT
		do
			if information.classes.has (class_id_of (a_routine)) then
				create e.make_now
				e.set_processor (processor_id_of (processor))
				e.set_class_name (class_name_of (a_routine))
				e.set_feature_name (feature_name_of (a_routine))
				events.extend (e)
			end
			flush_events
		ensure
			events_processed: events.count = old events.count + 1 or events.is_empty
		end

	collect_wait_condition (a_routine: ROUTINE [ANY, TUPLE])
			-- Collect wait condition try of `a_routine`.
		require
			a_routine /= Void
		local
			e: SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT
		do
			create e.make_now
			e.set_processor (processor_id_of (processor))
			e.set_class_name (class_name_of (a_routine))
			e.set_feature_name (feature_name_of (a_routine))
			events.extend (e)
		ensure
			events_increased: events.count = old events.count + 1
		end

	collect_processor_add
			-- Collect new processor.
		local
			e: SCOOP_PROFILER_PROCESSOR_START_EVENT
		do
			create e.make_now
			e.set_processor (processor_id_of (processor))
			events.extend (e)
			setup
		ensure
			events_increased: events.count = old events.count + 1
		end

	collect_processor_end
			-- Collet processor removal.
		local
			e: SCOOP_PROFILER_PROCESSOR_END_EVENT
		do
			create e.make_now
			e.set_processor (processor_id_of (processor))
			events.extend (e)
			flush_all_events
		ensure
			events_increased: events.is_empty
		end

	collect_join (t1, t2 : SCOOP_PROCESSOR)
		do
			io.put_string ("Collecting join%N")
		end

	collect_lock (t, o : SCOOP_PROCESSOR)
		do
			io.put_string ("Collecting lock%N")
		end

	collect_unlock (t, o : SCOOP_PROCESSOR)
		do
			io.put_string ("Collecting unlock%N")
		end

feature {NONE} -- Serialization

	start_time, stop_time: DATE_TIME
			-- Start and stop times, for file name.

	file_number: INTEGER
			-- Actual file number, for file name.

	epoch: DATE_TIME
			-- What's the reference point for all times?
		once
			create Result.make_from_epoch (0)
		ensure
			result_not_void: Result /= Void
		end

	directory: DIRECTORY
			-- Directory where to store profile data

	setup
			-- Setup files.
		local
			l_file_name: FILE_NAME
		do
			create directory.make (information.directory.name)
			directory.open_read

			-- Create log file
			create l_file_name.make
			l_file_name.set_directory (directory.name)
			l_file_name.set_file_name ("processor-" + processor_id_of (processor).out)
			if not {SCOOP_LIBRARY_CONSTANTS}.Profile_log_extension.is_empty then
				l_file_name.add_extension ({SCOOP_LIBRARY_CONSTANTS}.Profile_log_extension)
			end
			create log_file.make (l_file_name.out)
			file_number := 1
		ensure
			log_file /= Void
		end

	prepare_serialization
			-- Prepare for serialization.
		local
			e: SCOOP_PROFILER_PROFILING_START_EVENT
			l_file_name: FILE_NAME
		do
			-- Send profiling start event
			create e.make_now
			e.set_processor (processor_id_of (processor))
			events.extend (e)
			start_time := events.item.time

			-- Prepare profile file
			create l_file_name.make
			l_file_name.set_directory (directory.name)
			l_file_name.set_file_name ("current-" + processor_id_of (processor).out)
			create profile_file.make_create_read_write (l_file_name.out)
			create serializer.make (profile_file)
			serializer.set_for_writing
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_log then
				log_file.open_append
			end
		ensure
			serializer_for_writing: not serializer.is_for_reading
			log_file_open: {SCOOP_LIBRARY_CONSTANTS}.Enable_log = log_file.is_open_append
			profile_file_open: profile_file.is_open_write
		end

	cleanup_serialization
			-- Cleanup the serialization.
		local
			e: SCOOP_PROFILER_PROFILING_END_EVENT
		do
			-- Send profiling end event
			create e.make_now
			e.set_processor (processor_id_of (processor))
			serialize (e)
			stop_time := e.time

			-- Close files
			profile_file.close
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_log then
				log_file.close
			end

			-- Rename file
			profile_file.change_name (directory.name + Operating_environment.directory_separator.out + file_name)
			file_number := file_number + 1
		ensure
			file_number_incremented: file_number = old file_number + 1
			profile_file_closed: profile_file.is_closed
			log_file_closed: log_file.is_closed
		end

	serialize (a_event: SCOOP_PROFILER_EVENT)
			--
		require
			a_event /= Void
		do
			store_handler.independent_store (a_event, serializer, True)
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_log then
				log_file.put_string (a_event.out + " " + a_event.code + "%R%N")
			end
--			io.put_string (a_event.out + " " + a_event.code + "%N")
		end

	file_name: STRING
			-- What's the file name where to put profile data?
		local
			l_duration: DATE_TIME_DURATION
		do
			create Result.make_empty
			l_duration := start_time.duration.minus (epoch.duration)
			l_duration.set_origin_date_time (epoch)
			Result.append (l_duration.fine_seconds_count.truncated_to_integer.out)
			l_duration := stop_time.duration.minus (epoch.duration)
			l_duration.set_origin_date_time (epoch)
			Result.append ("_" + l_duration.fine_seconds_count.truncated_to_integer.out)
			Result.append ("_" + processor_id_of (processor).out + "_" + file_number.out)
			Result.append ("." + {SCOOP_LIBRARY_CONSTANTS}.Profile_file_extension)
		ensure
			result_valid: Result /= Void and then not Result.is_empty
		end

	serializer: SED_MEDIUM_READER_WRITER
	profile_file, log_file: RAW_FILE
	store_handler: SED_STORABLE_FACILITIES

feature {NONE} -- Conversion

	processor_id_of (a_processor: SCOOP_PROCESSOR): INTEGER
			-- What's the id of `a_processor`?
		require
			processor_not_void: a_processor /= Void
		do
			Result := a_processor.thread_id.hash_code
		ensure
			result_positive: Result > 0
		end

	feature_name_of (a_feature: ROUTINE [ANY, TUPLE]): STRING
			-- What's the name of `a_feature`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := information.classes.item (class_id_of (a_feature)).features.item (feature_id_of (a_feature)).name
		ensure
			result_valid: Result /= Void and then not Result.is_empty
		end

	feature_id_of (a_feature: ROUTINE [ANY, TUPLE]): INTEGER
			-- What's the id of `a_feature`?
		require
			a_feature /= Void
		do
			Result := a_feature.feature_id
		ensure
			result_positive: Result > 0
		end

	class_name_of (a_feature: ROUTINE [ANY, TUPLE]): STRING
			-- What's the class name of `a_object`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := information.classes.item (dynamic_class_id_of (a_feature)).name
		ensure
			result_valid: Result /= Void and then not Result.is_empty
		end

	dynamic_class_id_of (a_feature: ROUTINE [ANY, TUPLE]): INTEGER
			-- What's the dynamic class id of `a_feature`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := dynamic_type (a_feature.target) + 1
		ensure
			result_positive: Result > 0
		end

	class_id_of (a_feature: ROUTINE [ANY, TUPLE]): INTEGER
			-- What's the class id of `a_object`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := a_feature.class_id + 1
		ensure
			result_positive: Result > 0
		end

feature {NONE} -- Implementation

	information: SCOOP_PROFILER_INFORMATION
			-- Reference to profile information

	flush_events
			-- Flush the events.
		do
			if events.count > information.buffer_size then
				flush_all_events
			end
		ensure
			events_flushed: old events.count > information.buffer_size implies events.is_empty
		end

	flush_all_events
			-- Flush all events.
		local
			e: SCOOP_PROFILER_EVENT
		do
			prepare_serialization
			from
			variant
				events.count
			until
				events.is_empty
			loop
				e := events.item
				serialize (e)
				events.remove
			end
			cleanup_serialization
		ensure
			events_empty: events.is_empty
		end

	processor: SCOOP_PROCESSOR
			-- Reference to the processor

	events: LINKED_QUEUE [SCOOP_PROFILER_EVENT]
			-- Events buffer

invariant
	events_not_void: events /= Void
	store_handler_not_void: store_handler /= Void
	processor_not_void: processor /= Void

end
