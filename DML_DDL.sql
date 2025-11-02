use inf1_gruppe19;

-- DML update und delete

-- update der beschreibung für eine wohnung über die attribute, die als unique key genutzt werden
update fewo
	set beschreibung = 'Schöne Wohnung mit Blick aufs Wasser'
	where strasse = 'Hafenweg 7'
		and plz = '23673'
		and stadt = 'Schönkirchen';

select fewo.id, avg(bewertung.sterne) as durchschnitt_bewertung
	from fewo
	inner join buchung on buchung.fewo_id = fewo.id
	inner join bewertung on bewertung.buchung_id = buchung.id
	group by fewo.id
	having avg(bewertung.sterne) < 3;

-- Wohnungen mit einer durchschnittlichen Bewertung von weniger als 3 Sternen bekommen den Bannhammer zu spüren
SET SQL_SAFE_UPDATES = 0;
delete from fewo
	where id in (
		select fewo.id from ( -- schnappt sich alle ids aus der Menge in Klammern
			select fewo.id, avg(bewertung.sterne) as durchschnitt_bewertung
				from fewo
				inner join buchung on buchung.fewo_id = fewo.id
				inner join bewertung on bewertung.buchung_id = buchung.id
				group by fewo.id -- erzeugt eine Schnittmenge von fewos mit Buchungen und Bewertungen, die durch den fewo index gruppiert sind
				having avg(bewertung.sterne) < 3 -- reduziert die Menge auf fewos, die weniger als 3 Sterne haben
		) as temp -- wir brauchen einen alias damit die subquery unterschieden werden kann
	);
SET SQL_SAFE_UPDATES = 1;
    
-- DDL alter table statements
select version();

alter table fewo 
	add column if not exists titel varchar(50);

alter table fewo 
	rename column titel to bezeichnung;

alter table fewo 
	drop column bezeichnung;