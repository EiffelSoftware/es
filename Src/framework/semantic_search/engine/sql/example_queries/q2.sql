/* Test if LINKED_LIST.merge_left merged a non-empty argument list in various places of the target list.
t.merge_left (a)

Result:
There is no test case such that:
t.index = t.count + 1 (t.after = True)
*/

SELECT q.feature, p2.value as "t.count", p1.value as "a.count", p3.value as "t.index", q.uuid
FROM Queryables q, PropertyBindings1 t, PropertyBindings1 a, PropertyBindings1 p1, PropertyBindings1 p2, PropertyBindings1 p3
WHERE

/* The feature merge_left */
q.feature = "merge_left" AND
q.class = "LINKED_LIST"

/* Target list t */
AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.qry_id = q.qry_id AND
t.prop_kind = 2 AND       /* Precondition */
t.position = 0  AND       /* t is the 0-th operand */

/* Argument list a */
a.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
a.qry_id = q.qry_id AND
a.prop_kind = 2 AND       /* Precondition */
a.position = 1 AND        /* a is the 1-th operand */

/* Porperty p1: a.count > 0 */
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p1.prop_kind = 2 AND    /* Precondition */
p1.var1 = a.var1 AND    /* The first operand of p1 is the argument list a. */
p1.value > 0     AND    /* a.count > 0 */

/* Propety p2: t.count */
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p2.prop_kind = 2 AND  /* Precondition */
p2.var1 = t.var1 AND
p2.value > 0 AND      /* t.count > 0 */

/* Property p3: t.index */
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND
p3.prop_kind = 2 AND   /* Precondition */
p3.var1 = t.var1 AND
p3.value = p2.value                     /* Use this line to check in pre-state: t.index = t.count + 1 */
/* p3.value = p2.value */                  /* Use this line to check in pre-state: t.index = t.count */
/* p3.value > 1 AND p3.value < p2.value */ /* Use this line to check in pre-state: t.index > 1 and t.index < t.count */



