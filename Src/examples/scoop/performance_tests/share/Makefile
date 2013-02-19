all: application.e
	ec -config share.ecf -target share -c_compile -finalize
final: application.e
	ec -config share.ecf -target share -c_compile

clean:
	@rm -rf EIFGENs
