package Giant; {

  use strict;
  use warnings;

  use Participant;
  our @ISA = qw(Participant);
  
  sub new {
    my $self = Participant->new();
    $self->setName("Великан");
    $self->setHealth(150);
    $self->setSpecialWeapon("Дубина");
    $self->setCountSpecialWeapon(1);
    $self->setNameSpell("Околдовать");
    $self->setCountSpell(1);
    bless($self);
    return $self;
  }

  sub normalDamage {
    my $self = shift;
    return $self->generateDamage(5, 12);
  }

  sub specialDamage {
    my $self = shift;
    return $self->generateDamage(10, 24);
  }

  sub useMount {
    return undef;
  }

  sub selfHeal {
    return undef;
  }
}
1;


