/*
In pre-state:
LINKED_SET:
s.intersect (t)

there exists v, such that s.has (v), t.has (v)

Result:
Yes, there are test cases satisfying such criteria.
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, s.var1 as "s_id", t.var1 as "t_id", v.var1 as "v_id"
FROM
Queryables q, PropertyBindings1 s, PropertyBindings1 t, PropertyBindings1 v, PropertyBindings2 p1, PropertyBindings2 p2
WHERE

/* LINKED_LIST.search */
q.feature = "intersect" AND
q.class = "LINKED_SET"

/* target list s */
AND
s.qry_id = q.qry_id AND
s.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
s.prop_kind = 2 AND   /* Precondition */
s.position = 0    

/* argument t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
t.prop_kind = 2 AND
t.position = 1

/* item v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
v.prop_kind = 2

/* Property p1: pre s.has (v) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND   /* Property text */
p1.prop_kind = 2 AND
p1.var1 = s.var1 AND
p1.var2 = v.var1 AND
p1.value = 1

/* Property p2: pre t.has (v) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND   /* Property text */
p2.prop_kind = 2 AND
p2.var1 = t.var1 AND
p2.var2 = v.var1 AND
p2.value = 1


