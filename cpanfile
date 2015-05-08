requires 'Catmandu'; # libcatmandu-perl

requires 'Catmandu::Importer::CPAN';

requires 'Plack'; # libplack-perl
requires 'Plack::Middleware::Debug'; # libplack-middleware-debug-perl
requires 'Template'; # libtemplate-perl

requires 'Plack::Middleware::TemplateToolkit'; 

# cpanm -l local --skip-satisfied --installdeps .
