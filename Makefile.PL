use ExtUtils::MakeMaker;

WriteMakefile(NAME => 'sowhat',
              clean => {FILES => 't.output'},
              EXE_FILES => ['sowhat']);
