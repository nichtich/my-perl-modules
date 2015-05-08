# get latest version of each CPAN module
update:
	catmandu -Ilocal/lib/perl5 convert CPAN --author VOJ \
    	--fields distribution,version,date,abstract,resources \
		--fix 'move_field(distribution,name) copy_field(name,module) replace_all(module,"-","::")' \
    	to JSON --array 1, --pretty 1 > modules.json

# install required CPAN modules (TODO: try Debian packages)
deps:
	cpanm -l local --skip-satisfied --installdeps .
