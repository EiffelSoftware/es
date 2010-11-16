/*
Check if there is a test case LINKED_LIST.search, l.search (v) such that in pre-state:

(1) there exists an integer i such that l.i_th (i) = v and i < l.index
(2) l.object_comparison = False

*/

SELECT q.feature, q.content, q.qry_id, q.uuid, l.var1 as "l_id", v.var1 as "v_id", i.var1 as "i_id", i.value as "i"
FROM
Queryables q, PropertyBindings1 l, PropertyBindings1 v, PropertyBindings1 i, PropertyBindings1 p1, PropertyBindings1 p2, PropertyBindings2 p3
WHERE

q.feature = "search" AND
q.class = "LINKED_LIST"

/* target list l */
AND
l.qry_id = q.qry_id AND
l.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
l.prop_kind = 2 AND   /* Precondition */
l.position = 0        /* Target */

/* Argument v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
v.prop_kind = 2 AND   /* Precondition */
v.position = 1        /* Target */

/* Property p2: pre: l.index */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND   /* Property text */
p1.prop_kind = 2 AND   /* Precondition */
p1.var1 = l.var1

/* Some integer i */
AND
i.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
v.prop_kind = 2    /* Precondition */

/* Property p3: l.i_th (i)  */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.i_th ($)") AND   /* Property text */
p3.prop_kind = 2 AND
p3.var1 = l.var1 AND
p3.var2 = i.var1 AND
p3.value = v.value

/* l.i_th (i) = v */
AND
(p3.value_type_kind = v.value_type_kind AND p3.value = v.value)

/* i < l.index */
AND
i.value < p2.value

/* Property p1: pre:l.object_comparison = False */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.object_comparison") AND   /* Property text */
p1.prop_kind = 2 AND   /* Precondition */
p1.var1 = l.var1 AND
p1.value = 0


