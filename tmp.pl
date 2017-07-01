#!perl 
use Statistics::R;

my $R = Statistics::R->new() ;
my $cmds = <<EOF;
.libPaths( c( .libPaths(), "~/R_lib") )
pt <- .libPaths()
write(file="tmp.txt",pt)
EOF
$R->run($cmds);