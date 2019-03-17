CXXFLAGS = -std=c++11 -O3 -fopenmp \
           -fno-loop-interchange -fno-loop-unroll-and-jam -march=native

clang-tidy: $(SRCS)
	clang-tidy $(filter %.cpp, $^) -- -Wall

tar: $(UID).tar.gz

$(UID).tar.gz: $(REQUIRED_FILES)
	@test "$(UID)" -eq "$(UID)" 2>/dev/null || \
	  (echo "Usage: make tar UID=<your 9-digit student id>"; exit 1)
	@$(MAKE)
	@rm -rf $(UID)
	@mkdir $(UID)
	@cp $^ $(UID)
	@$(foreach f,$(OPTIONAL_FILES),test -f $(f) && cp $(f) $(UID)/;exit 0)
	tar czvf $(UID).tar.gz $(UID)
	@rm -rf $(UID)

check:
	@tar tf $(UID).tar.gz $(addprefix $(UID)/, $(REQUIRED_FILES))
	@$(foreach f,$(OPTIONAL_FILES),echo;echo -n "optional file \`$(UID)/$$(basename $(f))\` is ";tar tf $(UID).tar.gz $(UID)/$$(basename $(f)) >/dev/null 2>&1 || echo -n 'not ';echo 'in the tarball')
