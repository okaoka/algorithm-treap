package Algorthm::Treap;

use Mouse;
use Algorithm::Treap::Node;
use List::Util qw/min/;

has 'root' => (
    is => 'rw',
    isa => 'Algorithm::Treap::Node'
    );

sub _update {
    my ($self, $current) = @_;

    $current->{size} = $current->left_child_size() + $current->right_child_size() + 1;
    $current->{range_min} = min(min($current->left_child_range_min(),$current->{value}),
				min($current->right_child_range_min(),$current->{value}));
    return $current;
}

sub _merge {
    my ($self, $lhs, $rhs) = @_;
    
    if(!defined($lhs) || !defined($rhs)){
	return (!defined($lhs) ? $rhs : $lhs);
    }
    
    if($lhs->{priority} > $rhs->{priority}) {
	$lhs->{right_child} = $self->_merge($lhs->{right_child},$rhs);
	return $self->_update($lhs);
    } else {
	$rhs->{left_child} = $self->_merge($lhs,$rhs->{left_child});
	return $self->_update($rhs);
    }
}

sub _split {
    my ($self, $current, $k) = @_; # [0,k) [k,n)

    if(!defined($current)){
	return [undef,undef];
    }
    
    if ($k <= $current->left_child_size()) {
	my $s = $self->_split($current->{left_child}, $k);
	$current->{left_child} = $s->[1];
	return [$s->[0], $self->_update($current)];
    }
    else {
      my $s = $self->_split($current->{right_child},
			    $k - $current->left_child_size() - 1);
      $current->{right_child} = $s->[0];
      return [$self->_update($current), $s->[1]];
    }
}

sub _insert {
    my ($self, $current, $k, $v) = @_;

    my $s = $self->_split($current, $k);
    $current = $self->_merge($s->[0], Algorithm::Treap::Node->new(value => $v));
    $current = $self->_merge($current, $s->[1]);
    return $self->_update($current);
}

sub _erase {
    my ($self, $current, $k) = @_;

    my $lhs = $self->_split($current, $k + 1);
    my $rhs = $self->_split($lhs->[0], $k);
    return $self->_merge($rhs->[0], $lhs->[1]);
}

sub _find {
    my ($self, $current, $k) = @_;

    return undef if(!defined($current));

    if($k < $current->left_child_size()) {
	return $self->_find($current->{left_child}, $k);
    }
    elsif($k == $current->left_child_size()) {
	return $current;
    }
    else {
	return $self->_find($current->{right_child}, $k - $current->left_child_size() - 1);
    }
}

sub _shift { # [left_i,right_i]
    my ($self, $current, $left_i, $right_i) = @_;

    my $rhs = $self->_split($current, $right_i + 1);
    my $lhs = $self->_split($rhs->[0], $right_i);
    my $mid = $self->_split($lhs->[0], $left_i);
    return $self->_merge($self->_merge($self->_merge($mid->[0],$lhs->[1])
				       ,$mid->[1])
			 ,$rhs->[1]);
}

sub insert {
    my ($self, $k, $v) = @_;
    $self->{root} = $self->_insert($self->{root}, $k, $v);
}

sub erase {
    my ($self, $k) = @_;
    $self->{root} = $self->_erase($self->{root}, $k); 
}

sub find {
    my ($self, $k) = @_;
    my $node = $self->_find($self->{root}, $k);
    return $node->{value};
}

sub shift {
    my ($self, $left_i, $right_i) = @_;
    $self->{root} = $self->_shift($self->{root}, $left_i, $right_i);
}

1;
