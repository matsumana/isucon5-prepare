package Isucon::Web;

use strict;
use warnings;
use utf8;

use Kossy;
use DBIx::Sunny;

# TODO 後で消す
use Data::Dumper;
use DBIx::QueryLog;
use Log::Minimal;

sub dbh {
    my ($self) = @_;
    $self->{_dbh} ||= do {
        my $host      = '127.0.0.1';
        my $port      =  3306;
        my $database = 'isucon';
        my $user     = 'root';
        my $pass     = 'root';
        DBIx::Sunny->connect(
            "dbi:mysql:database=$database;host=$host;port=$port", $user, $pass, {
                RaiseError => 1,
                PrintError => 0,
                AutoInactiveDestroy => 1,
                mysql_enable_utf8   => 1,
                mysql_auto_reconnect => 1,
            },
        );
    };
}

get '/' => [qw()] => sub {
    my ($self, $c) = @_;

    my $count = $self->dbh->select_one(
        'SELECT COUNT(*) FROM table0 WHERE col1 != ?',
        999
    );

# TODO 後で消す
debugf("%s %d", "hoge!!", $count);

    $c->render('index.tx', {
        hoge => 'aaa',
        fuga => $count,
        piyo => 'bbb',
    });
};

1;
