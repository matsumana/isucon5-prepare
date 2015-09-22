package Isucon::Web;

use strict;
use warnings;
use utf8;

use Kossy;
use DBIx::Sunny;

get '/' => [qw()] => sub {
    my ($self, $c) = @_;

    $c->render('index.tx', {
        hoge => 'aaa',
        fuga => 123,
        piyo => 'bbb',
    });
};

1;
