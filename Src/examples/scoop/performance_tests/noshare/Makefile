all: application.e
	ec -config noshare.ecf -target noshare -c_compile -finalize
final: application.e
	ec -config noshare.ecf -target noshare -c_compile

clean:
	@rm -rf EIFGENs
