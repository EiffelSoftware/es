/* 
Check if for HASH_TABLE.force: t.force (v, k), there is a test case such that in pre-state:
t.object_comparison = False
t.occurrences (v) > 0
not t.has (k)

Result: Yes, there are some test cases satisfying such criteria.
In an earlier experiment, AutoInfer reported a wrong postcondition: t.occurrences (v) = 1.
This query shows that the reported postcondition is wrong, the reason is that in that experiment, some test cases are not included.
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, t.var1 as "t_id", v.value as "v.value", k.var1 as "k_id", p1.value as "pre:t.occurrences(v)", p4.value as "post:t.occurrences(v)"
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 v, PropertyBindings1 k, PropertyBindings2 p1, PropertyBindings2 p2, PropertyBindings1 p3, PropertyBindings2 p4
WHERE

/* feature = merge */
q.feature = "force" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 

/* argument v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v.position = 1 AND
v.prop_kind = 2 

/* argument k */
AND
k.qry_id = q.qry_id AND
k.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
k.position = 2 AND
k.prop_kind = 2 

/* Property p1: t.occurrences (v) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.occurrences ($)") AND
p1.prop_kind = 2 AND
p1.var1 = t.var1 AND
p1.var2 = v.var1

/* t.occurrences (v) > 0 */
AND
p1.value > 0

/* Property p2: not t.has (k) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p2.prop_kind = 2 AND
p2.var1 = t.var1 AND
p2.var2 = k.var1 AND
p2.value = 0


/* Property p3: t.object_comparison = False */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.object_comparison") AND
p3.prop_kind = 2 AND
p3.var1 = t.var1 AND
p3.value = 0

/* Property p4: post: t.occurrences (v) */
AND
p4.qry_id = q.qry_id AND
p4.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.occurrences ($)") AND
p4.prop_kind = 3 AND
p4.var1 = t.var1 AND
p4.var2 = v.var1 AND
p4.value > 1
