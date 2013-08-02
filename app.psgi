use Plack::Builder;
use Config::Reload;

my $devel   = ($ENV{PLACK_ENV} || '') eq 'development';
my $modules = Config::Reload->new( file => 'modules.json' );

builder {
    enable_if { $devel } 'Debug';
    enable_if { $devel } 'Debug::TemplateToolkit';
    enable Static =>
        path => qr{\.(png|ico|js|css)$},
        root => 'root';
    enable sub {
        my $app = shift;
        sub {
            my $env = shift;
            $env->{'tt.vars'}->{modules} = $modules->load;
            $app->($env);
        }
    };
    enable TemplateToolkit =>
        INCLUDE_PATH => 'root',
        INTERPOLATE  => 1;
};
