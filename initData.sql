SELECT DISTINCT Kundeordre.OrdreNr, Kundeordre.Reisedag, Kundeordre.Dato, Kundeordre.Tid, Kundeordre.RuteID, Kundeordre.UkeNr, Kundeordre.År, DelstrekningID, Stasjon1, ReservertPlass.Plass, VognNr, Retning
                            FROM (Kundeordre INNER JOIN Togrute USING(RuteID)
                                INNER JOIN SittevognPåTog USING(RuteID)
                                INNER JOIN Kunde USING(KundeNr)
                                INNER JOIN ReservertPlass USING(OrdreNr)
                                INNER JOIN Delstrekning USING(DelstrekningID))
                            WHERE KundeNr = 1 AND År >= 2023 AND UkeNr >= 13
                            GROUP BY ReservertPlass.Plass, VognNr, OrdreNr
                            HAVING ReservertPlass.DelstrekningID = MIN(ReservertPlass.DelstrekningID)
                            UNION
                            SELECT DISTINCT Kundeordre.OrdreNr, Kundeordre.Reisedag, Kundeordre.Dato, Kundeordre.Tid, Kundeordre.RuteID, Kundeordre.UkeNr, Kundeordre.År, DelstrekningID, Stasjon2, ReservertPlass.Plass, VognNr, Retning
                            FROM (Kundeordre INNER JOIN Togrute USING(RuteID)
                                INNER JOIN SittevognPåTog USING(RuteID)
                                INNER JOIN Kunde USING(KundeNr)
                                INNER JOIN ReservertPlass USING(OrdreNr)
                                INNER JOIN Delstrekning USING(DelstrekningID))
                            WHERE KundeNr = 1 AND År >= 2023 AND UkeNr >= 13
                            GROUP BY ReservertPlass.Plass, VognNr, OrdreNr
                            HAVING ReservertPlass.DelstrekningID = MAX(ReservertPlass.DelstrekningID)
                            ORDER BY OrdreNr, VognNr, Plass;