use Test::More;
use Data::Dumper;

require_ok 'Algorithm::Treap::Node';
require_ok 'Algorithm::Treap';

my $treap = Algorthm::Treap->new();
$treap->insert(0,36);
$treap->insert(1,20);
$treap->insert(2,3042);
$treap->insert(3,120);
$treap->insert(4,34);

is($treap->find(0),36);
is($treap->find(1),20);
is($treap->find(2),3042);
is($treap->find(3),120);
is($treap->find(4),34);

$treap->erase(4);
$treap->insert(4,23);
is($treap->find(4),23);

$treap->erase(4);
$treap->erase(3);
$treap->erase(2);
$treap->erase(1);
$treap->erase(0);

is($treap->find(0),undef);
is($treap->find(1),undef);
is($treap->find(2),undef);
is($treap->find(3),undef);
is($treap->find(4),undef);

$treap->insert(0,36);
$treap->insert(1,20);
$treap->insert(2,3042);
$treap->insert(3,120);
$treap->insert(4,34);

$treap->shift(0,1);
is($treap->find(0),20);
is($treap->find(1),36);

$treap->shift(0,1);
is($treap->find(0),36);
is($treap->find(1),20);

$treap->shift(0,4);
is($treap->find(0),34);
is($treap->find(1),36);
is($treap->find(2),20);
is($treap->find(3),3042);
is($treap->find(4),120);

$treap->erase(0);
$treap->erase(0);
$treap->erase(0);
$treap->erase(0);
$treap->erase(0);

is($treap->find(0),undef);
is($treap->find(1),undef);
is($treap->find(2),undef);
is($treap->find(3),undef);
is($treap->find(4),undef);

done_testing();
