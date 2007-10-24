MML - the mathematical model library
------------------------------------

The purpose of this library is to give you a library of classes that
model first-order logic and typed set theory. All classes in this
library are immutable, that means that instances of these classes will
never change the internal state over time.

An example of such a contracted class can be found in the 'example'
directory. The class FLAT_LINKED_LIST is a flattened version of the
LINKED_LIST class from EiffelBase. The class was contracted using
the MML_SEQUENCE model available from MML.

The work on this library is ongoing research. For further information,
see http://se.inf.ethz.ch/people/schoeller/mml.html. Feedback is
welcome.

Version: 0.7
Release date: 2007-01-31

Changes between 0.7 and 0.7.1:
------------------

Removed the expanded status from MML_CONVERSION, MML_CONVERSION_2 and
MML_COMPOSITION, as this made the EiffelStudio compiler choke (a known
bug).

Changes between 0.6 and 0.7:
------------------

- Bugfixes

Changes between 0.5 and 0.6:
------------------

- The directory structure was refactored.
- The original system.xace was split into a library.xace for the
  library and a system.xace file for the example.
- A first version of MML_GRAPH and MML_DEFAULT_GRAPH was implemented.
- Addition of FLAT_LINKED_LIST (and support classes). These classes
  are derived from EiffelBase and still require parts of EiffelBase
  to work properly.
- New features in MML_SEQUENCE: subsequence and index_of_i_th_item

For copyright information, please see License.txt. Please be also
aware that the FLAT_* files in the examples directory use another
license (http://archive.eiffel.com/products/base/license.html).
