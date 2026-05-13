-- ============================================================
-- RLS KOMPLETT-FIX
-- Alle bestehenden Policies löschen und neu anlegen
-- ============================================================

-- 1. RLS aktivieren
ALTER TABLE countries           ENABLE ROW LEVEL SECURITY;
ALTER TABLE associations        ENABLE ROW LEVEL SECURITY;
ALTER TABLE leagues             ENABLE ROW LEVEL SECURITY;
ALTER TABLE clubs               ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams               ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches             ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_entries  ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_matches  ENABLE ROW LEVEL SECURITY;
ALTER TABLE worldcup_rounds     ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_profiles      ENABLE ROW LEVEL SECURITY;

-- 2. Alle alten Policies löschen
DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN (
    SELECT policyname, tablename
    FROM pg_policies
    WHERE schemaname = 'public'
  ) LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', r.policyname, r.tablename);
  END LOOP;
END $$;

-- 3. LESEN: alle Tabellen öffentlich lesbar (für PWA & Admin)
CREATE POLICY "read_countries"          ON countries          FOR SELECT USING (true);
CREATE POLICY "read_associations"       ON associations       FOR SELECT USING (true);
CREATE POLICY "read_leagues"            ON leagues            FOR SELECT USING (true);
CREATE POLICY "read_clubs"              ON clubs              FOR SELECT USING (true);
CREATE POLICY "read_teams"              ON teams              FOR SELECT USING (true);
CREATE POLICY "read_matches"            ON matches            FOR SELECT USING (true);
CREATE POLICY "read_tournaments"        ON tournaments        FOR SELECT USING (true);
CREATE POLICY "read_tournament_entries" ON tournament_entries FOR SELECT USING (true);
CREATE POLICY "read_tournament_matches" ON tournament_matches FOR SELECT USING (true);
CREATE POLICY "read_worldcup_rounds"    ON worldcup_rounds    FOR SELECT USING (true);
CREATE POLICY "read_admin_profiles"     ON admin_profiles     FOR SELECT USING (true);

-- 4. SCHREIBEN: nur eingeloggte Admins
CREATE POLICY "write_countries"          ON countries          FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_associations"       ON associations       FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_leagues"            ON leagues            FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_clubs"              ON clubs              FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_teams"              ON teams              FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_matches"            ON matches            FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_tournaments"        ON tournaments        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_tournament_entries" ON tournament_entries FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_tournament_matches" ON tournament_matches FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_worldcup_rounds"    ON worldcup_rounds    FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "write_admin_profiles"     ON admin_profiles     FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 5. Prüfen ob INSERT-Daten vorhanden sind
-- (Die Daten aus dem Schema sollten schon drin sein)
-- Falls nicht, hier nochmal einfügen:
INSERT INTO countries (code, name, flag) VALUES
  ('de','Deutschland','🇩🇪'),('ch','Schweiz','🇨🇭'),('at','Österreich','🇦🇹'),
  ('fr','Frankreich','🇫🇷'),('cz','Tschechien','🇨🇿'),('be','Belgien','🇧🇪'),
  ('jp','Japan','🇯🇵'),('hu','Ungarn','🇭🇺'),('gb','Großbritannien','🇬🇧')
ON CONFLICT (code) DO NOTHING;

INSERT INTO associations (country_id, code, name) VALUES
  (1,'BAY','Bayern'),(1,'WTB','Württemberg'),(1,'HES','Hessen'),
  (1,'NRW','Nordrhein-Westfalen'),(1,'SAC','Sachsen'),(1,'SAH','Sachsen-Anhalt'),
  (1,'THU','Thüringen'),(1,'MEV','Mecklenburg-Vorpommern'),(1,'NIE','Niedersachsen'),
  (1,'RLP','Rheinland-Pfalz'),(1,'BBR','Berlin-Brandenburg'),
  (2,'NLA','Nationalliga A (Schweiz)'),(2,'NLB','Nationalliga B (Schweiz)'),
  (3,'VBG','Vorarlberg'),(3,'NOE','Niederösterreich'),(4,'GRE','Grand Est')
ON CONFLICT DO NOTHING;

INSERT INTO leagues (country_id, name, short_name, level, age_group, season) VALUES
  (1,'1. Bundesliga','BL1',1,'Elite','2025/26'),
  (1,'2. Bundesliga Mitte','BL2-M',2,'Elite','2025/26'),
  (1,'2. Bundesliga Nord','BL2-N',2,'Elite','2025/26'),
  (1,'2. Bundesliga Süd','BL2-S',2,'Elite','2025/26'),
  (1,'Bundespokal Frauen','BPF',1,'Frauen','2025/26'),
  (2,'Nationalliga A','NLA',1,'Elite','2025/26'),
  (2,'Nationalliga B','NLB',2,'Elite','2025/26'),
  (3,'1. Liga Österreich','L1-AT',1,'Elite','2025/26'),
  (4,'Championnat Elite','CFE',1,'Elite','2025/26'),
  (5,'Extraliga','EXT-CZ',1,'Elite','2025/26'),
  (6,'1. Liga Belgien','L1-BE',1,'Elite','2025/26')
ON CONFLICT DO NOTHING;

INSERT INTO clubs (name, country_id, city) VALUES
  ('RSV Muggensturm',1,'Muggensturm'),('RSV Denkingen',1,'Denkingen'),
  ('RSC Dittigheim',1,'Dittigheim'),('RC Waldshut',1,'Waldshut'),
  ('RC Steißlingen',1,'Steißlingen'),('RV Bietigheim',1,'Bietigheim'),
  ('RV Altdorf',1,'Altdorf'),('RV Hemsbach',1,'Hemsbach'),
  ('RV Sursee',2,'Sursee'),('RV Rickenbach',2,'Rickenbach'),
  ('RV Frenkendorf',2,'Frenkendorf'),('RV Wittnau',2,'Wittnau'),
  ('RV Oftringen',2,'Oftringen'),('RV Aarau',2,'Aarau'),
  ('RSV Korneuburg',3,'Korneuburg'),('RV Wieselburg',3,'Wieselburg'),
  ('RV Steyr',3,'Steyr'),('RV Grieskirchen',3,'Grieskirchen'),
  ('VC Wittenheim',4,'Wittenheim'),('VC Mulhouse',4,'Mulhouse'),
  ('VC Thann',4,'Thann'),('RC Colmar',4,'Colmar'),
  ('KK Liberec',5,'Liberec'),('KK Přerov',5,'Přerov'),
  ('RV Lüblow',1,'Lüblow'),('RVW Wimsheim',1,'Wimsheim'),
  ('RSV Zscherben',1,'Zscherben'),('RKV Bischberg',1,'Bischberg'),
  ('RMSV Klein-Gerau',1,'Klein-Gerau'),('RV Edelweiß Fraureuth',1,'Fraureuth')
ON CONFLICT DO NOTHING;

INSERT INTO worldcup_rounds (season, round_number, city, country_id, round_date, status, results_url, results_women_url) VALUES
  ('2025/26',1,'Kobe',7,'2026-02-22','finished','https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Kobe_2026.htm','https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Kobe_Damen_2026.htm'),
  ('2025/26',2,'Erzhausen',1,'2026-03-21','finished','https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Erzhausen_2026.htm',NULL),
  ('2025/26',3,'Baj',8,'2026-05-09','live',NULL,NULL),
  ('2025/26',4,'Hähnlein',1,'2026-08-29','upcoming',NULL,NULL),
  ('2025/26',5,'Großkoschen',1,'2026-09-12','upcoming',NULL,NULL),
  ('2025/26',6,'Prechtal',1,'2026-10-10','upcoming',NULL,NULL),
  ('2025/26',7,'Mosnang',2,'2026-11-21','upcoming',NULL,NULL),
  ('2025/26',8,'Sulgen',2,'2026-12-12','upcoming',NULL,NULL)
ON CONFLICT DO NOTHING;

-- 6. Admin-Profil für bestehenden User anlegen
-- (ersetze die UUID mit deiner echten User-ID aus Authentication → Users)
INSERT INTO admin_profiles (id, name, role, active)
VALUES ('3c882d0f-c8d8-409f-b4fe-a6ed13c350ef', 'Admin', 'superadmin', true)
ON CONFLICT (id) DO UPDATE SET role = 'superadmin', active = true;

-- 7. Kontrolle
SELECT 'countries'     AS tabelle, COUNT(*) AS zeilen FROM countries
UNION ALL SELECT 'associations', COUNT(*) FROM associations
UNION ALL SELECT 'leagues',      COUNT(*) FROM leagues
UNION ALL SELECT 'clubs',        COUNT(*) FROM clubs
UNION ALL SELECT 'worldcup_rounds', COUNT(*) FROM worldcup_rounds
UNION ALL SELECT 'admin_profiles',  COUNT(*) FROM admin_profiles;