generate:
	@sh ./BuildTools/Scripts/Base/generate.sh

open:
	@sh ./BuildTools/Scripts/Base/open.sh

distclean:
	@sh ./BuildTools/Scripts/Base/clean.sh global

clean:
	@sh ./BuildTools/Scripts/Base/clean.sh

mocks:
	@sh ./BuildTools/Scripts/Mockolo/mockolo.sh