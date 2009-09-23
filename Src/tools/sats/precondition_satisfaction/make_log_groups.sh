#!/bin/bash


# definition of groups (can't assign list to array members...)
groups=(ignored lex lists hashed queue sets stack string tree)
ignored=(METALEX LX_LEX_PARSER DS_SPARSE_TABLE_KEYS)
lex=(FIXED_DFA HIGH_BUILDER LINKED_DFA LX_ACTION_FACTORY LX_DESCRIPTION LX_DFA LX_DFA_REGULAR_EXPRESSION LX_DFA_STATE LX_EQUIVALENCE_CLASSES LX_FULL_DFA LX_LEX_SCANNER LX_NFA LX_NFA_STATE LX_PROTO LX_PROTO_QUEUE LX_REGEXP_PARSER LX_REGEXP_SCANNER LX_RULE LX_START_CONDITIONS LX_SYMBOL_CLASS LX_TEMPLATE_LIST LX_TRANSITION_TABLE PDFA STATE STATE_OF_DFA UT_ERROR_HANDLER YY_BUFFER LEXICAL LEX_BUILDER LINKED_AUTOMATON)
lists=(ACTIVE_LIST ARRAY ARRAYED_CIRCULAR ARRAYED_LIST ARRAYED_LIST_CURSOR CIRCULAR_CURSOR DS_ARRAYED_LIST DS_ARRAYED_LIST_CURSOR DS_BILINKED_LIST DS_BILINKED_LIST_CURSOR DS_LINKED_LIST DS_LINKED_LIST_CURSOR LINKED_CIRCULAR LINKED_LIST LINKED_LIST_CURSOR MULTAR_LIST_CURSOR MULTI_ARRAY_LIST PART_SORTED_TWO_WAY_LIST SORTED_TWO_WAY_LIST TWO_WAY_CIRCULAR TWO_WAY_LIST TWO_WAY_LIST_CURSOR CURSOR KL_EQUALITY_TESTER)
hashed=(DS_MULTIARRAYED_HASH_TABLE DS_MULTIARRAYED_HASH_TABLE_CURSOR)
queue=(ARRAYED_QUEUE BOUNDED_QUEUE DS_LINKED_QUEUE LINKED_PRIORITY_QUEUE)
sets=(ARRAYED_SET BINARY_SEARCH_TREE_SET DS_BINARY_SEARCH_TREE_SET DS_BINARY_SEARCH_TREE_SET_CURSOR DS_HASH_SET DS_HASH_SET_CURSOR DS_MULTIARRAYED_HASH_SET DS_MULTIARRAYED_HASH_SET_CURSOR LINKED_SET PART_SORTED_SET TWO_WAY_SORTED_SET)
stack=(DS_LINKED_STACK)
string=(KL_STRING)
tree=(ARRAYED_TREE BINARY_TREE COMPACT_CURSOR_TREE COMPACT_TREE_CURSOR DS_AVL_TREE DS_BINARY_SEARCH_TREE DS_BINARY_SEARCH_TREE_CURSOR DS_LEFT_LEANING_RED_BLACK_TREE DS_RED_BLACK_TREE FIXED_TREE LINKED_CURSOR_TREE LINKED_CURSOR_TREE_CURSOR LINKED_TREE LINKED_TREE_CURSOR SUBSET_STRATEGY_TREE TWO_WAY_CURSOR_TREE TWO_WAY_CURSOR_TREE_CURSOR TWO_WAY_TREE TWO_WAY_TREE_CURSOR)


if [ $# -ne 1 ]; then
    echo "Usage: $0 <folder>."
    exit 1
fi
if [ ! -d $1 ]; then
    echo "'$1' is not a folder."
    exit 2
fi

inpath=$1/../grouped/duplicated/
echo -n "Duplicating $1 to $inpath.. "
\mkdir -p $inpath 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Failed mkdir -p $inpath."
    exit 3
fi
\cp -r $1/ $inpath 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Failed cp -r $1/ $inpath."
    exit 3
fi
echo "Done."
echo

for group in ${groups[*]}; do
    outpath=$1/../grouped/$group
    echo "$group into '$outpath':"
    \mkdir -p $outpath 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed mkdir -p $outpath."
        exit 4
    fi
    
    eval leaders=\${$group[*]}
    for leader in $leaders; do
        echo -n "  $leader"
        \mv $inpath/*_${leader}_*.txt $outpath 2>/dev/null
        if [ $? -ne 0 ]; then
            echo " (failed)"
        else
            echo
        fi
    done
    
    echo
done

echo "Done."