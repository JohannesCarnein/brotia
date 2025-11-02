use INF1_Gruppe19;

-- alle möglichen raum Zahlen
select distinct anzahl_raeume from fewo;

-- select wohnungen mit buchungen und bewertungen
-- joine die durchschnittliche bewertung und die anzahl der bewertungen
select fewo.strasse, fewo.plz, fewo.stadt, fewo.anzahl_raeume, fewo.anzahl_betten, fewo.kueche, fewo.raucher, fewo.sauna, fewo.pool, fewo.extras, fewo.beschreibung, 
	round(avg(bewertung.sterne), 2) as durchschnitt_bewertung,
    count(bewertung.id) as anzahl_bewertungen
	from fewo
		inner join buchung on buchung.fewo_id = fewo.id
		inner join bewertung on bewertung.buchung_id = buchung.id
group BY fewo.id, fewo.strasse, fewo.plz, fewo.stadt, fewo.anzahl_raeume, fewo.anzahl_betten, fewo.kueche, fewo.raucher, fewo.sauna, fewo.pool, fewo.extras, fewo.beschreibung;
-- ich groupe alle attribute, weil er iwie probleme hat wenn ich nur by id groupe.

-- alle wohungen, die park in ihrer beschreibung haben und in einem der wunschorte sind
select * from fewo 
	where beschreibung like '%park%'
	and fewo.stadt in ('Timmendorfer See', 'Lübeck')

union

select * from fewo 
	where beschreibung like '%pool%'
	and fewo.stadt in ('Kiel-Mitte', 'Schönkirchen');

-- nimm die ersten 10 zeichen als vorschau für die beschreibung
-- Fallunterscheidung mit case und logic operatoren
select 
    case 
        when CHAR_LENGTH(beschreibung) > 10 then substring(beschreibung, 1, 10)
        else beschreibung
    end as beschreibung_vorschau
	from fewo;

-- auswahl aller wohnungen mit dem aktuellen preis für das gewählte wunschdatum
-- mit dem left join erhalte ich einen großen table, der alle infos zu fewo und saisonalen preisen enthält
-- von diesem großen table wähle ich aber nur die  attribute der fewo abzüglich des Preises aus,
-- den ich als aktueller_preis benannt aus dem ersten attribute, dass nicht null ist baue mit coalesce

set @wunschdatum := '2025-05-10';
select strasse, plz, stadt, anzahl_raeume, anzahl_betten, kueche, raucher, sauna, pool, extras, beschreibung,
	coalesce(sp.saison_preis, fewo.preis) as aktueller_preis -- if a not null then a else b
	from fewo
	left join saisonale_preise as sp
	on fewo.id = sp.fewo_id and @wunschdatum between sp.saison_start and sp.saison_ende;

-- DML update und delete

-- update der beschreibung für eine wohnung über die attribute, die als unique key genutzt werden
update fewo
	set beschreibung = 'Schöne Wohnung mit Blick aufs Wasser'
	where strasse = 'Hafenweg 7'
		and plz = '23673'
		and stadt = 'Schönkirchen';

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
