\echo "Compiling project..."
ec -config false_precondition.ecf -target false_precondition -c_compile
echo "Running project..."
ec -config false_precondition.ecf -target false_precondition -loop < input.txt
echo "Done"