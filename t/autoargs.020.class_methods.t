use lib map {glob($_)} qw(../lib ~/lib/perl5 ~/lib/perl5/site_perl/5.8.5);
use Carp;
use Hash::AutoHash::Args;
use Hash::AutoHash::Args::V0;
use Test::More qw/no_plan/;
use Test::Deep;

#################################################################################
# test class methods
#################################################################################
sub test_class_methods {
  my($V)=@_;
  my $args_class=$V? 'Hash::AutoHash::Args': 'Hash::AutoHash::Args::V0';
  my $label=$V? 'V1': 'V0';
  # test object class for sanity sake
  my $args=new $args_class;
  is(ref $args,$V? 'Hash::AutoHash::Args': 'Hash::AutoHash::Args::V0',
     "$label class is $args_class - sanity check");

  my $args=new $args_class;
  ok($args,"$label $args_class new");

  my $can=can $args_class('can');
  ok($can,"$label can: can");
  my $can=can $args_class('new');
  ok($can,"$label can: new");
  my $can=can $args_class('not_defined');
  ok(!$can,"$label can: can\'t");

  my $isa=$args_class->isa($args_class);
  ok($isa,"$label isa: is $args_class");
  my $isa=$args_class->isa('Hash::AutoHash');
  ok($isa,"$label isa: is Hash::AutoHash");
  my $isa=$args_class->isa('UNIVERSAL');
  ok($isa,"$label isa: is UNIVERSAL");
  my $isa=$args_class->isa('not_defined');
  ok(!$isa,"$label isa: isn\'t");

# Test DOES in perls > 5.10. 
# Note: $^V returns real string in perls > 5.10, and v-string in earlier perls
#   regexp below fails in earlier perls. this is okay
  my($perl_main,$perl_minor)=$^V=~/^v(\d+)\.(\d+)/; # perl version
  if ($perl_main==5 && $perl_minor>=10) {
    my $does=$args_class->DOES($args_class);
    ok($does,"$label DOES: is $args_class");
    my $does=$args_class->DOES('Hash::AutoHash');
    ok($does,"$label DOES: is Hash::AutoHash");
    my $does=$args_class->DOES('UNIVERSAL');
    ok($does,"$label DOES: is UNIVERSAL");
    my $does=$args_class->DOES('not_defined');
    ok(!$does,"$label DOES: isn\'t");
  }

  my $version=VERSION $args_class;
  is($version,$V? $Hash::AutoHash::Args::VERSION: 
     $Hash::AutoHash::Args::V0::VERSION,"$label VERSION");

  my @imports=($V? @Hash::AutoHash::Args::EXPORT_OK: @Hash::AutoHash::Args::V0::EXPORT_OK);
  import $args_class @imports;
  pass("$label import all functions");
}
test_class_methods(0);
test_class_methods(1);
