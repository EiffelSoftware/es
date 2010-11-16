/* Find out for l: LINKED_LIST, i: INTEGER. For feature l.move (i), if there is a test case where in pre-state, i = l.count. */

/*
foo (l: LINKED_LIST [ANY]; i: INTEGER)
require
    feature = move
    l.count = i    
*/

SELECT q.feature, q.content, q.qry_id, p1.value as "l.count", i.value as "i", q.hit_breakpoints
FROM Queryables q, PropertyBindings1 i, PropertyBindings1 l, PropertyBindings1 p1
WHERE
q.feature = "move" AND
q.class = "LINKED_LIST"


/* LINKED_LIST l */
AND
q.qry_id = l.qry_id AND
l.position = 0 AND
l.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
l.prop_kind = 2 AND

/* INTEGER i */
q.qry_id = i.qry_id AND
i.position = 1 AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
i.prop_kind = 2 AND

/* l.count */
p1.qry_id = q.qry_id AND 
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p1.prop_kind = 2 AND
p1.value > 1 AND
i.value = p1.value AND /* Check if i = l.count, this means if we tried to move cursor to the end of list */
p1.var1 = l.var1




