#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

$| = 1; # Disable output buffering

use lib "./";
use Knight;
use Giant;

my $player1 = undef;
my $player2 = undef;

if (randomBoolean()) {
	$player1 = Knight->new();
	$player2 = Giant->new();
} else {
	$player1 = Giant->new();
	$player2 = Knight->new();
}

my $p1Health = $player1->getHealth();
my $p2Health = $player2->getHealth();

print "Игра начата!\n\n"; sleep 1;
print "Участники: " . $player1->getName() . " [здоровье: " . $player1->getHealth() . "] и " . $player2->getName() . " [здоровье: " . $player2->getHealth() . "]\n";
print "Первый ход начинает участник " . $player1->getName() . "!\n\n";

while () {
	sleep 1;
	playersActions();
	if (playersStatus()) {
		last;
	}
}
print "Игра окончена!\n";

sub playersActions { 
	if ($player1->getHealth() > 0) {
		if (!$player1->getInfluenced()) {
			if ($player1->getHealth() <= ($p1Health - ($p1Health / 4)) and $player1->getCountSpecialWeapon() > 0 and randomBoolean()) {
				$player1->setCountSpecialWeapon($player1->getCountSpecialWeapon() - 1);
				my $p1SpecialDamage = $player1->specialDamage();
				$player2->setHealth($player2->getHealth() - $p1SpecialDamage);
				print "Участник " . $player1->getName(). " [" . $player1->getHealth() . "] наносит специальный урон (" . $player1->getSpecialWeapon() . ") " . $p1SpecialDamage . " участнику " . $player2->getName() . " [" . $player2->getHealth() . "]\n";
			
			} elsif ($player1->getHealth() <= ($p1Health - ($p1Health / 4)) and $player1->getCountSpell() > 0 and randomBoolean()) {
				$player1->setCountSpell($player1->getCountSpell() - 1);
				$player2->setInfluenced(1);
				print "Участник " . $player1->getName(). " [" . $player1->getHealth() . "] использует заклинание (" . $player1->getNameSpell() . ") на участника " . $player2->getName() . " [" . $player2->getHealth() . "]\n";

			} elsif ($player1->getHealth() <= ($p1Health - ($p1Health / 3)) and $player1->getCountMount() > 0 and randomBoolean()) {
				$player1->setCountMount($player1->getCountMount() - 1);
				my $p1MountSpecialDamage = $player1->useMount();
				$player2->setHealth($player2->getHealth() - $p1MountSpecialDamage);
				print "Участник " . $player1->getName(). " [" . $player1->getHealth() . "] используя питомца (" . $player1->getNameMount() .  ") наносит специальный урон (" . $player1->getSpecialWeapon() . ") " . $p1MountSpecialDamage . " участнику " . $player2->getName() . " [" . $player2->getHealth() . "]\n";

			} elsif (($player1->getHealth() <= ($p1Health - ($p1Health / 2)) and $player1->getCountHealth() > 0 and randomBoolean()) or ($player1->getHealth() <= ($p1Health / 4) and $player1->getCountHealth() > 0)) {
				$player1->setCountHealth($player1->getCountHealth() - 1);
				my $p1MountSpecialDamage = $player1->selfHeal();
				print "Участник " . $player1->getName(). " использует исцеление [" . $player1->getHealth() . "]\n"; 

			} else {
				my $p1Damage = $player1->normalDamage();
				$player2->setHealth($player2->getHealth() - $p1Damage);
				print "Участник " . $player1->getName(). " [" . $player1->getHealth() . "] наносит урон " . $p1Damage . " участнику " . $player2->getName() . " [" . $player2->getHealth() . "]\n"; 
			}
		} else {
			print "Участник " . $player1->getName(). " [" . $player1->getHealth() . "] находится под заклинанием и пропускает ход!\n";
			$player1->setInfluenced(0);
		}

	}

	if ($player2->getHealth() > 0) {
		if (!$player2->getInfluenced()) {
			if ($player2->getHealth() <= ($p2Health - ($p2Health / 4)) and $player2->getCountSpecialWeapon() > 0 and randomBoolean()) {
				$player2->setCountSpecialWeapon($player2->getCountSpecialWeapon() - 1);
				my $p2SpecialDamage = $player2->specialDamage();
				$player1->setHealth($player1->getHealth() - $p2SpecialDamage);
				print "Участник " . $player2->getName(). " [" . $player2->getHealth() . "]" . " наносит специальный урон (" . $player2->getSpecialWeapon() . ") " . $p2SpecialDamage . " участнику " . $player1->getName() . " [" . $player1->getHealth() . "]\n";
			
			} elsif ($player2->getHealth() <= ($p2Health - ($p2Health / 4)) and $player2->getCountSpell() > 0 and randomBoolean()) {
				$player2->setCountSpell($player2->getCountSpell() - 1);
				$player1->setInfluenced(1);
				print "Участник " . $player2->getName(). " [" . $player2->getHealth() . "] использует заклинание (" . $player2->getNameSpell() . ") на участника " . $player1->getName() . " [" . $player1->getHealth() . "]\n";			

			} elsif ($player2->getHealth() <= ($p2Health - ($p2Health / 3)) and $player2->getCountMount() > 0 and randomBoolean()) {
				$player2->setCountMount($player2->getCountMount() - 1);
				my $p2MountSpecialDamage = $player2->useMount();
				$player1->setHealth($player1->getHealth() - $p2MountSpecialDamage);
				print "Участник " . $player2->getName(). " [" . $player2->getHealth() . "] используя питомца (" . $player2->getNameMount() .  ") наносит специальный урон (" . $player2->getSpecialWeapon() . ") " . $p2MountSpecialDamage . " участнику " . $player1->getName() . " [" . $player1->getHealth() . "]\n";

			} elsif ($player2->getHealth() <= ($p2Health - ($p2Health / 2)) and $player2->getCountHealth() > 0 and randomBoolean()) {
				$player2->setCountHealth($player2->getCountHealth() - 1);
				my $p2MountSpecialDamage = $player2->selfHeal();
				print "Участник " . $player2->getName(). " использует исцеление [" . $player2->getHealth() . "]\n"; 		
			
			} else {
				my $p2Damage = $player2->normalDamage();
				$player1->setHealth($player1->getHealth() - $p2Damage);
				print "Участник " . $player2->getName(). " [" . $player2->getHealth() . "]" . " наносит урон " . $p2Damage . " участнику " . $player1->getName() . " [" . $player1->getHealth() . "]\n";
			}
		} else {
			print "Участник " . $player2->getName(). " [" . $player2->getHealth() . "] находится под заклинанием и пропускает ход!\n";
			$player2->setInfluenced(0);
		}
	}
	print "\n";
}

sub playersStatus {
	my $winner = undef;
	my $loser = undef;
	if ($player1->getStatus() eq "Die") {
		$winner = $player2;
		$loser = $player1;
	} elsif ($player2->getStatus() eq "Die") {
		$winner = $player1;
		$loser = $player2;
	}
	if (defined $winner) {
		print "\n" . $loser ->getName() . " проиграл, победитель " . $winner->getName() . "!\n\n"; 
		return 1;
	}
}

sub randomBoolean {
	return int rand(2);
}


