// ----------------------------------------------------------------------
// Class SPECIAL

const unique SPECIAL: Type;

// Helper functions to implement functionality that is too complex
// for having a theory (e.g. agent applications to the SPECIAL).
procedure SPECIAL.some_command(Current: ref);
	modifies Heap;
procedure SPECIAL.some_query<T>(Current: ref) returns (result: T);
	modifies Heap;



// Features of SPECIAL
// - features marked with ** are needed for V_ARRAY)

// make_empty **
// make_filled **

// item / at **
// index_of
// item_address
// base_address
// to_array
// index_set

// lower
// upper
// count
// capacity

// filled_with
// same_items **
// valid_index

// put **
// force
// extend
// extend_filled
// fill_with **
// fill_with_default **
// insert_data
// copy_data **
// move_data **
// overlapping_move
// non_overlapping_move

// keep_head
// keep_tail
// remove_head
// remove_tail
// resized_area **
// resized_area_with_default
// aliased_resized_area
// aliased_resized_area_with_default **

// replace_all
// wipe_out
// clear_all

// do_all_in_bounds
// do_if_in_bounds
// there_exists_in_bounds
// for_all_in_bounds
// do_all_with_index_in_bounds
// do_if_with_index_in_bounds
