SELECT DISTINCT SovevognSerieNr, KupeNr, VognNr
                        FROM KjørerDag INNER JOIN SovevognPåTog USING (RuteID)
                            INNER JOIN Sovekupe USING (SovevognSerieNr)
                        WHERE RuteID = 2 AND Dag = "Mandag"
                        EXCEPT
                        SELECT SovevognSerieNr, KupeNr, VognNr
                        FROM ReservertKupe INNER JOIN SovevognPåTog USING(SovevognSerieNr)
                            INNER JOIN Kundeordre USING (OrdreNr)
                            INNER JOIN KjørerDag USING (RuteID)
                        WHERE Kundeordre.Reisedag = KjørerDag.Dag AND Kundeordre.UkeNr = 14 AND Kundeordre.Reisedag = "Mandag";