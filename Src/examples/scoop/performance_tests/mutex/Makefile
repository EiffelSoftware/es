all: application.e
	ec -config mutex.ecf -target mutex -c_compile -finalize
final: application.e
	ec -config mutex.ecf -target mutex -c_compile

clean:
	@rm -rf EIFGENs
