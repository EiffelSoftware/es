note
	description: "{PR_ERROR_C} interfaces with the NSPR error handling."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	PR_ERROR_C

feature -- Error handling
	PR_GetError: INTEGER_32
		external
			"C use <nspr4/prerror.h>"
		alias
			"PR_GetError"
		end

	PR_GetErrorTextLength: INTEGER_32
		external
			"C use <nspr4/prerror.h>"
		alias
			"PR_GetErrorTextLength"
		end

	PR_GetErrorText (a_string: POINTER): INTEGER_32
		external
			"C use <nspr4/prerror.h>"
		alias
			"PR_GetErrorText"
		end

feature -- Error codes
	pr_out_of_memory_error: INTEGER_32 = -6000
	pr_bad_descriptor_error: INTEGER_32 = -5999
	pr_would_block_error: INTEGER_32 = -5998
	pr_access_fault_error: INTEGER_32 = -5997
	pr_invalid_method_error: INTEGER_32 = -5996
	pr_illegal_access_error: INTEGER_32 = -5995
	pr_unknown_error: INTEGER_32 = -5994
	pr_pending_interrupt_error: INTEGER_32 = -5993
	pr_not_implemented_error: INTEGER_32 = -5992
	pr_io_error: INTEGER_32 = -5991
	pr_io_timeout_error: INTEGER_32 = -5990
	pr_io_pending_error: INTEGER_32 = -5989
	pr_directory_open_error: INTEGER_32 = -5988
	pr_invalid_argument_error: INTEGER_32 = -5987
	pr_address_not_available_error: INTEGER_32 = -5986
	pr_address_not_supported_error: INTEGER_32 = -5985
	pr_is_connected_error: INTEGER_32 = -5984
	pr_bad_address_error: INTEGER_32 = -5983
	pr_address_in_use_error: INTEGER_32 = -5982
	pr_connect_refused_error: INTEGER_32 = -5981
	pr_network_unreachable_error: INTEGER_32 = -5980
	pr_connect_timeout_error: INTEGER_32 = -5979
	pr_not_connected_error: INTEGER_32 = -5978
	pr_load_library_error: INTEGER_32 = -5977
	pr_unload_library_error: INTEGER_32 = -5976
	pr_find_symbol_error: INTEGER_32 = -5975
	pr_insufficient_resources_error: INTEGER_32 = -5974
	pr_directory_lookup_error: INTEGER_32 = -5973
	pr_tpd_range_error: INTEGER_32 = -5972
	pr_proc_desc_table_full_error: INTEGER_32 = -5971
	pr_sys_desc_table_full_error: INTEGER_32 = -5970
	pr_not_socket_error: INTEGER_32 = -5969
	pr_not_tcp_socket_error: INTEGER_32 = -5968
	pr_socket_address_is_bound_error: INTEGER_32 = -5967
	pr_no_access_rights_error: INTEGER_32 = -5966
	pr_operation_not_supported_error: INTEGER_32 = -5965
	pr_protocol_not_supported_error: INTEGER_32 = -5964
	pr_remote_file_error: INTEGER_32 = -5963
	pr_buffer_overflow_error: INTEGER_32 = -5962
	pr_connect_reset_error: INTEGER_32 = -5961
	pr_range_error: INTEGER_32 = -5960
	pr_deadlock_error: INTEGER_32 = -5959
	pr_file_is_locked_error: INTEGER_32 = -5958
	pr_file_too_big_error: INTEGER_32 = -5957
	pr_no_device_space_error: INTEGER_32 = -5956
	pr_pipe_error: INTEGER_32 = -5955
	pr_no_seek_device_error: INTEGER_32 = -5954
	pr_is_directory_error: INTEGER_32 = -5953
	pr_loop_error: INTEGER_32 = -5952
	pr_name_too_long_error: INTEGER_32 = -5951
	pr_file_not_found_error: INTEGER_32 = -5950
	pr_not_directory_error: INTEGER_32 = -5949
	pr_read_only_filesystem_error: INTEGER_32 = -5948
	pr_directory_not_empty_error: INTEGER_32 = -5947
	pr_filesystem_mounted_error: INTEGER_32 = -5946
	pr_not_same_device_error: INTEGER_32 = -5945
	pr_directory_corrupted_error: INTEGER_32 = -5944
	pr_file_exists_error: INTEGER_32 = -5943
	pr_max_directory_entries_error: INTEGER_32 = -5942
	pr_invalid_device_state_error: INTEGER_32 = -5941
	pr_device_is_locked_error: INTEGER_32 = -5940
	pr_no_more_files_error: INTEGER_32 = -5939
	pr_end_of_file_error: INTEGER_32 = -5938
	pr_file_seek_error: INTEGER_32 = -5937
	pr_file_is_busy_error: INTEGER_32 = -5936
	pr_operation_aborted_error: INTEGER_32 = -5935
	pr_in_progress_error: INTEGER_32 = -5934
	pr_already_initiated_error: INTEGER_32 = -5933
	pr_group_empty_error: INTEGER_32 = -5932
	pr_invalid_state_error: INTEGER_32 = -5931
	pr_network_down_error: INTEGER_32 = -5930
	pr_socket_shutdown_error: INTEGER_32 = -5929
	pr_connect_aborted_error: INTEGER_32 = -5928
	pr_host_unreachable_error: INTEGER_32 = -5927
	pr_library_not_loaded_error: INTEGER_32 = -5926
	pr_call_once_error: INTEGER_32 = -5925
	pr_max_error: INTEGER_32 = -5924

	get_tag (l_error_code: INTEGER_32): STRING_8
		do
			inspect l_error_code
			when -6000 then
				 Result := "pr_out_of_memory_error"
			when -5999 then
				 Result := "pr_bad_descriptor_error"
			when -5998 then
				 Result := "pr_would_block_error"
			when -5997 then
				 Result := "pr_access_fault_error"
			when -5996 then
				 Result := "pr_invalid_method_error"
			when -5995 then
				 Result := "pr_illegal_access_error"
			when -5994 then
				 Result := "pr_unknown_error"
			when -5993 then
				 Result := "pr_pending_interrupt_error"
			when -5992 then
				 Result := "pr_not_implemented_error"
			when -5991 then
				 Result := "pr_io_error"
			when -5990 then
				 Result := "pr_io_timeout_error"
			when -5989 then
				 Result := "pr_io_pending_error"
			when -5988 then
				 Result := "pr_directory_open_error"
			when -5987 then
				 Result := "pr_invalid_argument_error"
			when -5986 then
				 Result := "pr_address_not_available_error"
			when -5985 then
				 Result := "pr_address_not_supported_error"
			when -5984 then
				 Result := "pr_is_connected_error"
			when -5983 then
				 Result := "pr_bad_address_error"
			when -5982 then
				 Result := "pr_address_in_use_error"
			when -5981 then
				 Result := "pr_connect_refused_error"
			when -5980 then
				 Result := "pr_network_unreachable_error"
			when -5979 then
				 Result := "pr_connect_timeout_error"
			when -5978 then
				 Result := "pr_not_connected_error"
			when -5977 then
				 Result := "pr_load_library_error"
			when -5976 then
				 Result := "pr_unload_library_error"
			when -5975 then
				 Result := "pr_find_symbol_error"
			when -5974 then
				 Result := "pr_insufficient_resources_error"
			when -5973 then
				 Result := "pr_directory_lookup_error"
			when -5972 then
				 Result := "pr_tpd_range_error"
			when -5971 then
				 Result := "pr_proc_desc_table_full_error"
			when -5970 then
				 Result := "pr_sys_desc_table_full_error"
			when -5969 then
				 Result := "pr_not_socket_error"
			when -5968 then
				 Result := "pr_not_tcp_socket_error"
			when -5967 then
				 Result := "pr_socket_address_is_bound_error"
			when -5966 then
				 Result := "pr_no_access_rights_error"
			when -5965 then
				 Result := "pr_operation_not_supported_error"
			when -5964 then
				 Result := "pr_protocol_not_supported_error"
			when -5963 then
				 Result := "pr_remote_file_error"
			when -5962 then
				 Result := "pr_buffer_overflow_error"
			when -5961 then
				 Result := "pr_connect_reset_error"
			when -5960 then
				 Result := "pr_range_error"
			when -5959 then
				 Result := "pr_deadlock_error"
			when -5958 then
				 Result := "pr_file_is_locked_error"
			when -5957 then
				 Result := "pr_file_too_big_error"
			when -5956 then
				 Result := "pr_no_device_space_error"
			when -5955 then
				 Result := "pr_pipe_error"
			when -5954 then
				 Result := "pr_no_seek_device_error"
			when -5953 then
				 Result := "pr_is_directory_error"
			when -5952 then
				 Result := "pr_loop_error"
			when -5951 then
				 Result := "pr_name_too_long_error"
			when -5950 then
				 Result := "pr_file_not_found_error"
			when -5949 then
				 Result := "pr_not_directory_error"
			when -5948 then
				 Result := "pr_read_only_filesystem_error"
			when -5947 then
				 Result := "pr_directory_not_empty_error"
			when -5946 then
				 Result := "pr_filesystem_mounted_error"
			when -5945 then
				 Result := "pr_not_same_device_error"
			when -5944 then
				 Result := "pr_directory_corrupted_error"
			when -5943 then
				 Result := "pr_file_exists_error"
			when -5942 then
				 Result := "pr_max_directory_entries_error"
			when -5941 then
				 Result := "pr_invalid_device_state_error"
			when -5940 then
				 Result := "pr_device_is_locked_error"
			when -5939 then
				 Result := "pr_no_more_files_error"
			when -5938 then
				 Result := "pr_end_of_file_error"
			when -5937 then
				 Result := "pr_file_seek_error"
			when -5936 then
				 Result := "pr_file_is_busy_error"
			when -5935 then
				 Result := "pr_operation_aborted_error"
			when -5934 then
				 Result := "pr_in_progress_error"
			when -5933 then
				 Result := "pr_already_initiated_error"
			when -5932 then
				 Result := "pr_group_empty_error"
			when -5931 then
				 Result := "pr_invalid_state_error"
			when -5930 then
				 Result := "pr_network_down_error"
			when -5929 then
				 Result := "pr_socket_shutdown_error"
			when -5928 then
				 Result := "pr_connect_aborted_error"
			when -5927 then
				 Result := "pr_host_unreachable_error"
			when -5926 then
				 Result := "pr_library_not_loaded_error"
			when -5925 then
				 Result := "pr_call_once_error"
			when -5924 then
				 Result := "pr_max_error"
			end
		end

end
