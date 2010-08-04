EC=${EIFFEL_SRC}/Eiffel/Ace/EIFGENs/batch/W_code/ecb

EC_STABLE=ec

EC_OPTS=-config prodcons.ecf -target prodcons -c_compile -stop -verbose

all:
	touch application.e && ${EC} ${EC_OPTS}

regular:
	${EC_STABLE} ${EC_OPTS}
