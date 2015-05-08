use Plack::Builder;
use Catmandu qw(importer);

my $devel   = ($ENV{PLACK_ENV} || '') eq 'development';
my $modules = importer('JSON', multiline => 1, file => 'modules.json' )->to_array;

builder {
    enable_if { $devel } 'Debug';
    enable_if { $devel } 'Debug::TemplateToolkit';
    enable Static =>
        path => qr{\.(png|ico|js|css)$},
        root => 'htdocs';
    enable sub {
        my $app = shift;
        sub {
            my $env = shift;
            $env->{'tt.vars'}->{modules} = $modules;
            $env->{'tt.vars'}->{author}  = 'VOJ';
            $app->($env);
        }
    };
    enable TemplateToolkit =>
        INCLUDE_PATH => 'htdocs',
        INTERPOLATE  => 1;
};
