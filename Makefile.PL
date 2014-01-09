use ExtUtils::MakeMaker;

WriteMakefile(NAME => 'sowhat',
              clean => {FILES => 'test.output'},
              EXE_FILES => ['sowhat']);
