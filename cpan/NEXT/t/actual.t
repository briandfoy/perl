use Test::More tests => 10;

BEGIN { use_ok('NEXT') };
my $order = 0;

package A;
our @ISA = qw/B C D/;

sub test { ++$order; ::ok($order==1,"test A"); $_[0]->NEXT::ACTUAL::test;}

package B;
our @ISA = qw/D C/;
sub test { ++$order; ::ok($order==2,"test B"); $_[0]->NEXT::ACTUAL::test;}

package C;
our @ISA = qw/D/;
sub test {
	++$order; ::ok($order==4||$order==6,"test C");
	$_[0]->NEXT::ACTUAL::test;
}

package D;

sub test {
	++$order; ::ok($order==3||$order==5||$order==7||$order==8,"test D");
        $_[0]->NEXT::ACTUAL::test;
}

package main;

my $foo = {};

bless($foo,"A");

eval{ $foo->test }
	? fail("Didn't die on missing ancestor")
	: pass("Correctly dies after full traversal");
