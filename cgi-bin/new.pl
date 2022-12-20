#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

print "Content-type: text/html\n\n";
print <<HTML;
<html>
	<head>
		<link rel="icon" href="../icon/UNSA.ico">
		<link rel = "stylesheet" href = "../css/estilos.css" >
		<title> Visualizando markdown </title>

		<div class = "opciones">
			<a href="list.pl"  class="boton"> Listado de paginas </a>
		</div>
	</head>
	<body>
				
HTML

my $q = CGI->new;
my $titulo = $q->param("titulo");
my $markdown = $q->param("cuerpo");

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.5";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my @titulos;
my $sth = $dbh->prepare("SELECT nombrePag FROM wiki WHERE nombrePag=?");
$sth->execute($titulo);

while( my @row = $sth->fetchrow_array ) {
	push (@titulos,@row);
}

my $estado;
if(@titulos[0]eq($titulo)){
  my $sth1 = $dbh->prepare ("UPDATE wiki SET markdown=? WHERE nombrePag=?");
  $sth1->execute($markdown, $titulo);
  $sth1->finish;
  $estado="Pagina actualizada";
}
else{
  my $sth2 = $dbh->prepare("INSERT INTO wiki (nombrePag, markdown) VALUES (?,?)");
  $sth2->execute($titulo, $markdown);
  $sth2->finish;
  $estado="Pagina añadida";
}
$sth->finish;
$dbh->disconnect;

print <<HTML;
		<h1> $titulo</h1>
		<pre>$markdown</pre>
		<h2>$estado</h2><br>
	</body>
</html>
HTML
