#!perl 
use Statistics::R;

my $R = Statistics::R->new() ;
my $cmds = <<EOF;
pt <- .libPaths()
write(file="tmp.txt",pt)
EOF
$R->run($cmds);