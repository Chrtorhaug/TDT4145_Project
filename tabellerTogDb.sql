--Kun tabellene som opprettes uten tilhørende scriptverdier (Brukes hvis man ønsker å teste BrukerhistorieX.sql filer)
CREATE TABLE "Stasjon" (
	"StasjonNavn"	TEXT NOT NULL,
	"Moh"	NUMERIC,
	PRIMARY KEY("StasjonNavn")
);

CREATE TABLE "Operatør" (
	"Navn"	TEXT NOT NULL,
	PRIMARY KEY("Navn")
);

CREATE TABLE "Togrute" (
	"RuteID"	INTEGER NOT NULL,
	"Retning"	INTEGER NOT NULL,
	PRIMARY KEY("RuteID")
);

CREATE TABLE "Ukedag" (
	"Dag"	TEXT NOT NULL,
	PRIMARY KEY("Dag")
);

CREATE TABLE "Kunde" (
	"KundeNr"	INTEGER NOT NULL,
	"Navn"	TEXT,
	"Epostaddresse"	TEXT,
	"Mobilnummer"	TEXT,
	PRIMARY KEY("KundeNr")
);

CREATE TABLE "Strekning" (
	"StrekningNavn"	TEXT NOT NULL,
	"Fremdriftsenergi"	TEXT,
	"Startstasjon"	TEXT NOT NULL,
	"Endestasjon"	TEXT NOT NULL,
	FOREIGN KEY("Startstasjon") REFERENCES "Stasjon"("StasjonNavn") ON UPDATE CASCADE,
	FOREIGN KEY("Endestasjon") REFERENCES "Stasjon"("StasjonNavn") ON UPDATE CASCADE,
	PRIMARY KEY("StrekningNavn")
);

CREATE TABLE "Delstrekning" (
	"DelstrekningID"	INTEGER NOT NULL,
	"StrekningNavn"	TEXT NOT NULL,
	"Lengde"	INTEGER,
	"Spor"	INTEGER,
	"Stasjon1"	TEXT NOT NULL,
	"Stasjon2"	TEXT NOT NULL,
	FOREIGN KEY("StrekningNavn") REFERENCES "Strekning"("StrekningNavn") ON UPDATE CASCADE,
	FOREIGN KEY("Stasjon2") REFERENCES "Stasjon"("StasjonNavn") ON UPDATE CASCADE,
	FOREIGN KEY("Stasjon1") REFERENCES "Stasjon"("StasjonNavn") ON UPDATE CASCADE,
	PRIMARY KEY("DelstrekningID","StrekningNavn")
);

CREATE TABLE "KjørerDag" (
	"RuteID"	INTEGER NOT NULL,
	"Dag"	TEXT NOT NULL,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("Dag") REFERENCES "Ukedag"("Dag"),
	PRIMARY KEY("RuteID","Dag")
);

CREATE TABLE "GårInnom" (
	"RuteID"	INTEGER NOT NULL,
	"StasjonNavn"	TEXT NOT NULL,
	"Ankomsttid"	TEXT,
	"Avgangstid"	TEXT,
	FOREIGN KEY("StasjonNavn") REFERENCES "Stasjon"("StasjonNavn") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("RuteID","StasjonNavn")
);

CREATE TABLE "KjørerDelstrekning" (
	"RuteID"	INTEGER NOT NULL,
	"DelstrekningID"	INTEGER NOT NULL,
	"StrekningNavn"	TEXT NOT NULL,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("StrekningNavn") REFERENCES "Strekning"("StrekningNavn") ON UPDATE CASCADE,
	FOREIGN KEY("DelstrekningID") REFERENCES "Delstrekning"("DelstrekningID"),
	PRIMARY KEY("StrekningNavn","DelstrekningID","RuteID")
);

CREATE TABLE "Kundeordre" (
	"OrdreNr"	INTEGER NOT NULL,
	"Dato"	TEXT,
	"Tid"	TEXT,
	"KundeNr"	INTEGER NOT NULL,
	"RuteID"	INTEGER NOT NULL,
	"Reisedag"	TEXT NOT NULL,
	"UkeNr"     INTEGER NOT NULL,
	"År"        INTEGER NOT NULL,
	FOREIGN KEY("KundeNr") REFERENCES "Kunde"("KundeNr") ON DELETE CASCADE,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("Reisedag") REFERENCES "Ukedag"("Dag"),
	PRIMARY KEY("OrdreNr")
);

CREATE TABLE "BetjenerStrekning" (
	"Operatør"   TEXT NOT NULL,
	"StrekningNavn"   TEXT NOT NULL,
	FOREIGN KEY("Operatør") REFERENCES "Operatør"("Navn") ON UPDATE CASCADE,
	FOREIGN KEY("StrekningNavn") REFERENCES "Strekning"("StrekningNavn") ON UPDATE CASCADE,
	PRIMARY KEY("Operatør","StrekningNavn")
);

CREATE TABLE "Sittevogn" (
	"SerieNr"	INTEGER NOT NULL,
	"Navn"	TEXT NOT NULL,
	PRIMARY KEY("SerieNr")
);

CREATE TABLE "SittevognInfo" (
	"Navn"	TEXT NOT NULL,
	"Operatør"	TEXT NOT NULL,
	"Rader"	INTEGER,
	"SeterPrRad"	INTEGER,
	FOREIGN KEY("Operatør") REFERENCES "Operatør"("Navn") ON UPDATE CASCADE,
	PRIMARY KEY("Navn")
);

CREATE TABLE "Sitteplass" (
	"Plass"	INTEGER NOT NULL,
	"SittevognSerieNr"	INTEGER NOT NULL,
	FOREIGN KEY("SittevognSerieNr") REFERENCES "Sittevogn"("SerieNr") ON DELETE CASCADE,
	PRIMARY KEY("Plass","SittevognSerieNr")
);

CREATE TABLE "SittevognPåTog" (
	"RuteID"	INTEGER NOT NULL,
	"SittevognSerieNr"	INTEGER NOT NULL,
	"VognNr"	INTEGER,
	FOREIGN KEY("SittevognSerieNr") REFERENCES "Sittevogn"("SerieNr") ON DELETE CASCADE,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("SittevognSerieNr","RuteID")
);

CREATE TABLE "ReservertPlass" (
	"OrdreNr"	INTEGER NOT NULL,
	"DelstrekningID"	INTEGER NOT NULL,
	"Plass"	INTEGER NOT NULL,
	"SittevognSerieNr"	INTEGER NOT NULL,
	FOREIGN KEY("OrdreNr") REFERENCES "Kundeordre"("OrdreNr"),
	FOREIGN KEY("Plass") REFERENCES "Sitteplass"("Plass") ON DELETE CASCADE,
	FOREIGN KEY("SittevognSerieNr") REFERENCES "Sitteplass"("SittevognSerieNr") ON DELETE CASCADE,
	FOREIGN KEY("DelstrekningID") REFERENCES "Delstrekning"("DelstrekningID"),
	PRIMARY KEY("SittevognSerieNr","Plass","DelstrekningID","OrdreNr")
);

CREATE TABLE "Sovevogn" (
	"SovevognSerieNr"	INTEGER NOT NULL,
	"Navn"	TEXT NOT NULL,
	PRIMARY KEY("SovevognSerieNr","Navn")
);

CREATE TABLE "SovevognInfo" (
	"Navn"	TEXT NOT NULL,
	"AntallSovekupeer"	INTEGER,
	"Operatør"	TEXT NOT NULL,
	FOREIGN KEY("Operatør") REFERENCES "Operatør"("Navn") ON UPDATE CASCADE,
	PRIMARY KEY("Navn")
);

CREATE TABLE "Sovekupe" (
	"KupeNr"	INTEGER NOT NULL,
	"SovevognSerieNr"	INTEGER NOT NULL,
	FOREIGN KEY("SovevognSerieNr") REFERENCES "Sovevogn"("SovevognSerieNr") ON DELETE CASCADE,
	PRIMARY KEY("KupeNr","SovevognSerieNr")
);

CREATE TABLE "SovevognPåTog" (
	"RuteID"	INTEGER NOT NULL,
	"SovevognSerieNr"	INTEGER NOT NULL,
	"VognNr"	INTEGER,
	FOREIGN KEY("SovevognSerieNr") REFERENCES "Sovevogn"("SovevognSerieNr") ON DELETE CASCADE,
	FOREIGN KEY("RuteID") REFERENCES "Togrute"("RuteID") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("RuteID","SovevognSerieNr")
);

CREATE TABLE "ReservertKupe" (
	"OrdreNr"	INTEGER NOT NULL,
	"KupeNr"	INTEGER NOT NULL,
	"SovevognSerieNr"	INTEGER NOT NULL,
	"ØvreSeng"	INTEGER,
	"NedreSeng"	INTEGER,
	FOREIGN KEY("KupeNr") REFERENCES "Sovekupe"("KupeNr") ON DELETE CASCADE,
	FOREIGN KEY("SovevognSerieNr") REFERENCES "Sovevogn"("SovevognSerieNr") ON DELETE CASCADE,
	FOREIGN KEY("OrdreNr") REFERENCES "Kundeordre"("OrdreNr"),
	PRIMARY KEY("SovevognSerieNr","KupeNr","OrdreNr")
);