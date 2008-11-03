
use Test::More;

eval "use Test::Script";
plan skip_all => "Test::Script required for testing" if $@;

plan( tests => 1 );
script_compiles_ok( 'script/file2ftp.pl', 'script/file2ftp.pl compiles');
