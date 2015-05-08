use v5.14;
use JSON;
use LWP::Simple qw(get);

# usage: $0 debian-package-name

foreach my $package (@ARGV) {
    my $url = "https://sources.debian.net/api/src/$package/";
    my $versions = eval { decode_json(get($url))->{versions} } || [];
    foreach my $version (@$versions) {
        my @suites = @{delete $version->{suites}};
        foreach my $suite (@suites) {
            $version->{suite} = $suite;
            say encode_json($version);
        }
    }
}

