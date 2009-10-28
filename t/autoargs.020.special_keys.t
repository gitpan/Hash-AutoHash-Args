use lib map {glob($_)} qw(../lib ~/lib/perl5 ~/lib/perl5/site_perl/5.8.5);
use Carp;
use Hash::AutoHash::Args;
use Hash::AutoHash::Args::V0;
use Test::More qw/no_plan/;
use Test::Deep;

sub test_special_keys {
  my($V,@keys)=@_;
  my $args_class=$V? 'Hash::AutoHash::Args': 'Hash::AutoHash::Args::V0';
  my $label=$V? 'V1': 'V0';
  # test object class for sanity sake
  my $args=new $args_class;
  is(ref $args,$V? 'Hash::AutoHash::Args': 'Hash::AutoHash::Args::V0',
     "$label class is $args_class - sanity check");


  my $args=new $args_class;
  my(@ok,@fail);
  for my $key (@keys) {
    my $value="value_$key";
    $args->$key($value);	# set value
    my $actual=$args->$key;	# get value
#    ($actual eq $value)? push(@ok,$key): push(@fail,$key);
    is($actual,$value,"$label key=$key");
  }
#   # like 'report'
#   $label.=' special keys';
#   unless (@fail) {
# #     pass("$label. keys=@keys");
#     pass($label);
#   } else {
#     fail($label);
#     diag(scalar(@ok)." keys have correct values: @ok");
#     diag(scalar(@fail)." keys have wrong values: @fail");
#   }
}
my @keys=
  (qw(import new can isa DOES VERSION AUTOLOAD DESTROY),
   map {my $copy=$_; $copy=~s/^autohash/autoargs/; $copy} @Hash::AutoHash::SUBCLASS_EXPORT_OK);
test_special_keys(0,@keys);

my @keys=
  (qw(import new can isa DOES VERSION AUTOLOAD DESTROY),
   qw(get_args getall_args set_args fix_args fix_keyword fix_keywords is_keyword is_positional),
   map {my $copy=$_; $copy=~s/^autohash/autoargs/; $copy} @Hash::AutoHash::SUBCLASS_EXPORT_OK);
test_special_keys(1,@keys);


