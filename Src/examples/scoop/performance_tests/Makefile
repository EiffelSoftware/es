SUBDIRS = anneal condition mutex noshare prodcons share

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS): 
	$(MAKE) -C $@


SUBDIRS_CLEAN = $(patsubst %, %.clean, $(SUBDIRS))
.PHONY: $(SUBDIRS_CLEAN)

clean: $(SUBDIRS_CLEAN)

$(SUBDIRS_CLEAN):
	$(MAKE) -C $(@:.clean=) clean
