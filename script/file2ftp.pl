#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = '0.0101';

use Net::FTP;

my $conf_file = $ENV{FILE2FTP_CONF} || $ENV{HOME} . '/file2ftp.conf';

my $config = do $conf_file
    or die "Failed to load config file $conf_file [$! $@]\n";

@ARGV
    or die "Usage: $0 [--tag foo] file1 .. fileN\n";

my $tag = 'default';
if ( $ARGV[0] eq '--tag' ) {
    shift;
    $tag = shift;
}

die "No such tag '$tag'\n"
    unless exists $config->{tags}{ $tag };

my @files = @ARGV;

my $ftp = Net::FTP->new( $config->{host} )
    or die "Cannot connect to $config->{host}: $@\n";

$ftp->login( @$config{ qw/login pass/ } )
    or die "Cannot login: " . $ftp->message . "\n";

$ftp->cwd( $config->{tags}{ $tag } )
    or die "Cannot change working directory: " . $ftp->message . "\n";

for ( @files ) {
    my $ret = $ftp->put( $_ );
    defined $ret
        or print "*** Failed to upload $_\n"
            and next;

    print "Uploaded: $_\n";
}

$ftp->quit;

=head1 NAME

file2ftp - upload files to FTP server based on preset config

=head1 USAGE

    file2ftp.pl [--tag dir_tag] file1 file2 .. fileN

=head1 DESCRIPTION

The script came to life when I found myself constantly starting up my FTP client just to
put up a single file.

=head1 CONFIG FILE

    {
        host  => 'ftp.example.com',
        login => 'ftp_login',
        pass  => 'ftp_password',
        tags  => {
            new => '/public_html/new/',
            default => '/public_html/new/del/',
        },
    }

The script relies on a config file. If C<FILE2FTP_CONF> enviromental variable is set then
its value is the file name of the config file, otherwise the name is derived from
C<$ENV{HOME} . '/file2ftp.conf'>.

The config file must contain a hashref (sample above shows an entire config file). The possible
keys/values of that hashref are as follows:

=head2 C<host>

    host  => 'ftp.example.com',

B<Mandatory>. The C<host> key takes a string as a value. That string must contain a hostname
of the server to which you wish to connect.

=head2 C<login> and C<pass>

    login => 'ftp_login',
    pass  => 'ftp_password',

B<Mandatory>. The C<login> and C<pass> keys as values
take your FTP login and FTP password respectively.

=head2 C<tags>

    tags  => {
        new => '/public_html/new/',
        default => '/public_html/new/del/',
    },

B<Mandatory>. The C<tags> key takes a hashref as a value. The keys of that hashref are "tags"
that you can pass to C<file2ftp.pl> as C<file2ftp.pl --tag tag_name>. The tags represent
short names for directories on the FTP server into which you wish to upload. If the C<--tag>
argument is not given to C<file2ftp.pl> then the script will assume that the name
of the tag is C<default>.

=head1 AUTHOR

Zoffix Znet <zoffix@cpan.org>
( L<http://zoffix.com>, L<http://haslayout.net> )

=head1 LICENSE

Same as Perl

=cut