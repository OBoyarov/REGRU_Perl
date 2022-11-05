package Knight; {

  use strict;
  use warnings;

  use Participant;
  our @ISA = qw(Participant);
  
  sub new {
    my $self = Participant->new();
    $self->setName("Рыцарь");
    $self->setCountHealth(2);
    $self->setSpecialWeapon("Копье");
    $self->setCountSpecialWeapon(2);
    $self->setNameMount("Конь");
    $self->setCountMount(2);
    bless($self);
    return $self;
  }

  sub normalDamage {
    my $self = shift;
    return $self->generateDamage(3, 10);    
  }

  sub specialDamage {
    my $self = shift;
    return $self->generateDamage(6, 20);
  }

  sub useMount {
    my $self = shift;
    return $self->specialDamage() * 2;
  }

  sub selfHeal {
    my $self = shift;
    return $self->setHealth($self->getHealth() + 30);
  }
}
1;


