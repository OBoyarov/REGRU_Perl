#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use Text::SimpleTable::AutoWidth;

#password for db: https://paste.reg.ru/48f9bc896bf7
my $connect = DBI->connect("DBI:mysql:database=u1614732_perl;host=31.31.198.124;port=3306", "u1614732_perl","see comment") or die "Error connecting to database"; 
$connect->do(qq{SET NAMES 'utf8mb4';});

### таблица users
my $query = "SELECT * FROM users";
my $result = $connect->selectall_arrayref($query, {Slice => {}});
my $table = Text::SimpleTable::AutoWidth->new(captions => ['user_id', 'name']);

foreach my $row (@$result) {
	$table->row($row->{user_id}, $row->{name}, '');
}
print $table->draw;

### таблица domains
my $query2 = "SELECT * FROM domains";
my $result2 = $connect->selectall_arrayref($query2, {Slice => {}});
my $table2 = Text::SimpleTable::AutoWidth->new(captions => ['user_id', 'dname']);

foreach my $row2 (@$result2) {
	$table2->row($row2->{user_id}, $row2->{dname}, '');
}
print $table2->draw;

### вывод имен доменов, которые есть у пользователя с именем Иван Иванов
my $query3 = "SELECT 
	d.dname,
    u.user_id,
	u.name
FROM 
	domains as d
LEFT JOIN
	users as u
ON
	d.user_id = u.user_id
WHERE
	u.name = N'Иван Иванов'";
my $result3 = $connect->selectall_arrayref($query3, {Slice => {}});
my $table3 = Text::SimpleTable::AutoWidth->new(captions => ['dname', 'user_id', 'name']);

foreach my $row3 (@$result3) {
	$table3->row($row3->{dname}, $row3->{user_id}, $row3->{name});
}
print $table3->draw;

$connect->disconnect();


