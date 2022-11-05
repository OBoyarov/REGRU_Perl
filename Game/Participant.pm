package Participant; {
  
  use strict;
  use warnings;

  sub new {
    my $self = {};
    $self->{NAME} = "Unknown";
    $self->{STATUS} = "Alive";
    $self->{HEALTH} = 100;
    $self->{USEHEALTH} = 0;
    $self->{MOUNT} = undef;
    $self->{USEMOUNT} = 0;
    $self->{WEAPON} = undef;
    $self->{USEWEAPON} = 0;
    $self->{SPELL} = undef;
    $self->{USESPELL} = 0;
    $self->{INFLUENCED} = 0;
    bless($self);
    return $self;
  }

  sub getName {
    my $self = shift;
    return $self->{NAME};
  }

  sub setName {
    my $self = shift;
    $self->{NAME} = shift;
  }

  sub getStatus {
    my $self = shift;
    return $self->{STATUS};
  }

  sub getHealth {
    my $self = shift;
    my $health = $self->{HEALTH};
    if ($health < 0) {
      $health = 0;
    }
    return $health;
  }

  sub setHealth {
    my $self = shift;
    if ($self < $self->{HEALTH}) {
      $self->{HEALTH} = 0;
    } else {
      $self->{HEALTH} = shift;
    }
    if ($self->{HEALTH} <= 0) {
        $self->{STATUS} = "Die";
    }  
  }

  sub getCountHealth {
    my $self = shift;
    return $self->{USEHEALTH};
  }

  sub setCountHealth {
    my $self = shift;
    $self->{USEHEALTH} = shift;
  }

  sub getCountSpecialWeapon {
    my $self = shift;
    return $self->{USEWEAPON};
  }

  sub setCountSpecialWeapon {
    my $self = shift;
    $self->{USEWEAPON} = shift;
  }

  sub getSpecialWeapon {
    my $self = shift;
    return $self->{WEAPON};
  }

  sub setSpecialWeapon {
    my $self = shift;
    $self->{WEAPON} = shift;
  }

  sub getNameMount {
    my $self = shift;
    return $self->{MOUNT};
  }

  sub setNameMount {
    my $self = shift;
    $self->{MOUNT} = shift;
  }

  sub getCountMount {
    my $self = shift;
    return $self->{USEMOUNT};
  }

  sub setCountMount {
    my $self = shift;
    $self->{USEMOUNT} = shift;
  }

  sub getNameSpell {
    my $self = shift;
    return $self->{SPELL};
  }

  sub setNameSpell {
    my $self = shift;
    $self->{SPELL} = shift;
  }

  sub getCountSpell {
    my $self = shift;
    return $self->{USESPELL};
  }

  sub setCountSpell {
    my $self = shift;
    $self->{USESPELL} = shift;
  }

  sub getInfluenced {
    my $self = shift;
    return $self->{INFLUENCED};
  }

  sub setInfluenced {
    my $self = shift;
    $self->{INFLUENCED} = shift;
  }

  sub generateDamage {
      my ($self, $min, $max) = @_;
      return ($min + int rand($max - $min + 1));
  }
}
1;


