package Isucon::Web;

use strict;
use warnings;
use utf8;

use Kossy;
use DBIx::Sunny;

# TODO 後で消す
use Data::Dumper;
use Log::Minimal;

get '/' => [qw()] => sub {
    my ($self, $c) = @_;

# TODO 後で消す
debugf("%s %d", "hoge!!", 100);

    $c->render('index.tx', {
        hoge => 'aaa',
        fuga => 123,
        piyo => 'bbb',
    });
};

1;
