package:
	D=`date "+%Y%m%d"` $$SHELL -c 'tar vczf make_dmg-$$D.tgz -s ",^,make_dmg-$$D/,g" Mac make_dmg'

upstream-import:
	@if [ "$(shell hg branch)" != 'upstream' ]; then echo you must be on the upstream branch. execute: hg checkout upstream; false; fi
	@if [ "$(shell hg status --all | grep -v ^C)" != '' ]; then echo the working directory has changes. commit or revert them first.; false; fi
	rm -rf tmp VERSIONS
	mkdir tmp
	hg clone http://www.hhhh.org/src/hg/parsealias tmp/parsealias && (cd tmp/parsealias && perl Build.PL && ./Build)
	hg clone http://www.hhhh.org/src/hg/dsstore tmp/dsstore && (cd tmp/dsstore && perl Build.PL && ./Build)
	rm -rf Mac
	cp -a tmp/parsealias/blib/lib/* .
	cp -a tmp/dsstore/blib/lib/* .
	cp tmp/dsstore/examples/make_dmg.pl make_dmg
	chmod +x make_dmg
	echo parsealias `hg id --id tmp/parsealias` >> VERSIONS
	echo dsstore `hg id --id tmp/dsstore` >> VERSIONS
	@echo done.

clean:
	rm -rf tmp make_dmg-*.tgz

