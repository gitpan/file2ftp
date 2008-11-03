use 5.008008;
use ExtUtils::MakeMaker;

WriteMakefile(
     NAME => 'file2ftp',
     VERSION_FROM => 'script/file2ftp.pl',
     PREREQ_PM => {
     	'Net::FTP' => 2.77,
     },
     EXE_FILES => [ 'script/file2ftp.pl' ],
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'script/file2ftp.pl',
       AUTHOR         => 'Zoffix Znet <zoffix@cpan.org>') : ()),
);
