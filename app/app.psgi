use FindBin;
use lib "$FindBin::Bin/extlib/lib/perl5";
use lib "$FindBin::Bin/lib";

use Plack::Builder;

use Plack::Middleware::Session::Simple;
use Cache::Memcached::Fast;
use Sereal;

use Isucon::Web;

my $decoder = Sereal::Decoder->new();
my $encoder = Sereal::Encoder->new();
my $app = Isucon::Web->psgi($root_dir);

builder {
    enable 'ReverseProxy';
    enable 'Session::Simple',
        store => Cache::Memcached::Fast->new({
            servers => [{
                           address => "localhost:11211",
                           noreply => 0
                       }],
            serialize_methods => [ sub { $encoder->encode($_[0])}, 
                                   sub { $decoder->decode($_[0])} ],
        }),
        httponly    => 1,
        cookie_name => "isucon_session",
        keep_empty  => 0;
    $app;
};
