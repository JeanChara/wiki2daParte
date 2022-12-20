#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

## borramos elemento seleccionado

my $q = CGI->new;
my $titulo = $q->param('titulo');

my $user= 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.5";
my $dbh = DBI->connect($dsn, $user, $password) or die ("No se puede conectar");

my $sth = $dbh->prepare("DELETE FROM wiki WHERE nombrePag=?");
$sth->execute($titulo);

$dbh->disconnect;
print $q->redirect("list.pl");
