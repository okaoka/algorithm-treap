package Algorithm::Treap::Node;

use Mouse;

has 'value' => (
    is => 'rw',
    isa => 'Num'
    );

has 'left_child' => (
    is => 'rw',
    isa => 'Algorithm::Treap::Node'
    );

has 'right_child' => (
    is => 'rw',
    isa => 'Algorithm::Treap::Node'
    );

has 'priority' => (
    is => 'ro',
    isa => 'Num',
    default => sub{ rand() }
    );

has 'size' => (
    is => 'rw',
    isa => 'Int',
    default => 1
    );

has 'range_min' => (
    is => 'rw',
    isa => 'Num',
    default => ~0 >> 1 # INF
    );

sub left_child_size {
    my $self = shift;

    if(defined($self->{left_child})){
	return $self->{left_child}->{size};
    }
    return 0;
}

sub right_child_size {
    my $self = shift;

    if(defined($self->{right_child})){
	return $self->{right_child}->{size};
    }
    return 0;
}

sub left_child_range_min {
    my $self = shift;

    if(defined($self->{left_child})){
	return $self->{left_child}->{range_min};
    }
    return ~0 >> 1;
}

sub right_child_range_min {
    my $self = shift;

    if(defined($self->{right_child})){
	return $self->{right_child}->{range_min};
    }
    return ~0 >> 1;
}

1;
