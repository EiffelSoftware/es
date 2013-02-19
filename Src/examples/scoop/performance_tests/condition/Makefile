all: application.e
	ec -config condition.ecf -target condition -c_compile -finalize
final: application.e
	ec -config condition.ecf -target condition -c_compile

clean:
	@rm -rf EIFGENs
