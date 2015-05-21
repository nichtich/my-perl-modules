AUTHOR=VOJ

index.html: modules.json
	echo '{"author":"${AUTHOR}","modules":' > tmp.json
	cat $< >> tmp.json
	echo '}' >> tmp.json
	cd htdocs && catmandu -Ilocal/lib/perl5 convert JSON --multiline 1 \
		to Template --template index.html --interpolate 1 \
			< ../tmp.json > ../index.html

modules.json:
	# get latest version of each CPAN module
	catmandu -Ilocal/lib/perl5 convert CPAN \
		--author ${AUTHOR} \
    	--fields distribution,version,date,abstract,resources \
		--fix cpan.fix \
    	to JSON --array 1 --pretty 1 > $@

deps:
	# first try to install Debian packages, ignore errors
	perl -nE 'say $$1 if /#\s+(lib.+-perl)/' < cpanfile | \
		sudo xargs sh -c "apt-get install || true"
	# then only install required additional packages
	cpanm -l local --skip-satisfied --installdeps .
