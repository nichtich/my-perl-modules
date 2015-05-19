requires 'Catmandu'; # libcatmandu-perl

requires 'Catmandu::Importer::CPAN';
requires 'Catmandu::Importer::getJSON', '0.50';

requires 'Template'; # libtemplate-perl

requires 'Catmandu::Exporter::Template';

feature 'psgi' => sub {
    requires 'Plack'; # libplack-perl
    requires 'Plack::Middleware::Debug'; # libplack-middleware-debug-perl
    requires 'Plack::Middleware::TemplateToolkit'; 
};

# cpanm -l local --skip-satisfied --installdeps .
