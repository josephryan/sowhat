use ExtUtils::MakeMaker;

WriteMakefile(NAME => 'sowh.pl',
              clean => {FILES => 'test.output'},
              VERSION => '0.04',
              EXE_FILES => ['sowh.pl']);
