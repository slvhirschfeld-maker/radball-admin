-- ============================================================
-- RADBALL EUROPA – Supabase SQL Schema
-- Einfügen im Supabase Dashboard → SQL Editor → Run
-- ============================================================

-- ------------------------------------------------------------
-- 1. LÄNDER
-- ------------------------------------------------------------
CREATE TABLE countries (
  id   SERIAL PRIMARY KEY,
  code VARCHAR(3)  NOT NULL UNIQUE,  -- 'de', 'ch', 'at', 'fr', 'cz', 'be'
  name VARCHAR(100) NOT NULL,
  flag VARCHAR(10)
);

INSERT INTO countries (code, name, flag) VALUES
  ('de', 'Deutschland',  '🇩🇪'),
  ('ch', 'Schweiz',      '🇨🇭'),
  ('at', 'Österreich',   '🇦🇹'),
  ('fr', 'Frankreich',   '🇫🇷'),
  ('cz', 'Tschechien',   '🇨🇿'),
  ('be', 'Belgien',      '🇧🇪'),
  ('jp', 'Japan',        '🇯🇵'),
  ('hu', 'Ungarn',       '🇭🇺'),
  ('gb', 'Großbritannien','🇬🇧');

-- ------------------------------------------------------------
-- 2. VERBÄNDE (Bundesländer / Regionen)
-- ------------------------------------------------------------
CREATE TABLE associations (
  id         SERIAL PRIMARY KEY,
  country_id INT NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
  code       VARCHAR(10) NOT NULL,   -- 'BAY', 'MEV', 'WTB', 'NLA' ...
  name       VARCHAR(150) NOT NULL
);

INSERT INTO associations (country_id, code, name) VALUES
  (1, 'BAY',  'Bayern'),
  (1, 'WTB',  'Württemberg'),
  (1, 'HES',  'Hessen'),
  (1, 'NRW',  'Nordrhein-Westfalen'),
  (1, 'SAC',  'Sachsen'),
  (1, 'SAH',  'Sachsen-Anhalt'),
  (1, 'THU',  'Thüringen'),
  (1, 'MEV',  'Mecklenburg-Vorpommern'),
  (1, 'NIE',  'Niedersachsen'),
  (1, 'RLP',  'Rheinland-Pfalz'),
  (1, 'BBR',  'Berlin-Brandenburg'),
  (2, 'NLA',  'Nationalliga A (Schweiz)'),
  (2, 'NLB',  'Nationalliga B (Schweiz)'),
  (3, 'VBG',  'Vorarlberg'),
  (3, 'NOE',  'Niederösterreich'),
  (4, 'GRE',  'Grand Est');

-- ------------------------------------------------------------
-- 3. LIGEN
-- ------------------------------------------------------------
CREATE TABLE leagues (
  id         SERIAL PRIMARY KEY,
  country_id INT          NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
  name       VARCHAR(150) NOT NULL,
  short_name VARCHAR(50),
  level      INT          DEFAULT 1,   -- 1 = höchste Liga
  age_group  VARCHAR(20)  DEFAULT 'Elite', -- Elite, U19, U17, U15, U13, U11, Frauen
  season     VARCHAR(10)  NOT NULL,    -- '2025/26'
  active     BOOLEAN      DEFAULT TRUE,
  external_url TEXT                    -- Link zur Originalseite
);

INSERT INTO leagues (country_id, name, short_name, level, age_group, season, external_url) VALUES
  (1, '1. Bundesliga',          'BL1',     1, 'Elite',  '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/Bundesliga1_Radball_2026.html'),
  (1, '2. Bundesliga Mitte',    'BL2-M',   2, 'Elite',  '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/Bundesliga2_Radball_Mitte_2026.html'),
  (1, '2. Bundesliga Nord',     'BL2-N',   2, 'Elite',  '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/Bundesliga2_Radball_Nord_2026.html'),
  (1, '2. Bundesliga Süd',      'BL2-S',   2, 'Elite',  '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/Bundesliga2_Radball_Sued_2026.html'),
  (1, 'Bundespokal Frauen',     'BPF',     1, 'Frauen', '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/Bundespokal_Radball_Frauen_2026.html'),
  (2, 'Nationalliga A',         'NLA',     1, 'Elite',  '2025/26', 'https://www.vfh-muecheln.de/2026/Ergebnisse/Schweiz/Meisterschaft/NLA_Qualifikation_2026.html'),
  (2, 'Nationalliga B',         'NLB',     2, 'Elite',  '2025/26', NULL),
  (2, '1. Liga',                'L1-CH',   3, 'Elite',  '2025/26', NULL),
  (2, '2. Liga',                'L2-CH',   4, 'Elite',  '2025/26', NULL),
  (2, '3. Liga',                'L3-CH',   5, 'Elite',  '2025/26', NULL),
  (3, '1. Liga Österreich',     'L1-AT',   1, 'Elite',  '2025/26', NULL),
  (4, 'Championnat Elite',      'CFE',     1, 'Elite',  '2025/26', NULL),
  (4, 'Grand Est Liga 1',       'GE-L1',   2, 'Elite',  '2025/26', NULL),
  (5, 'Extraliga',              'EXT-CZ',  1, 'Elite',  '2025/26', NULL),
  (6, '1. Liga Belgien',        'L1-BE',   1, 'Elite',  '2025/26', NULL);

-- ------------------------------------------------------------
-- 4. VEREINE
-- ------------------------------------------------------------
CREATE TABLE clubs (
  id             SERIAL PRIMARY KEY,
  name           VARCHAR(150) NOT NULL,
  short_name     VARCHAR(50),
  country_id     INT REFERENCES countries(id),
  association_id INT REFERENCES associations(id),
  city           VARCHAR(100),
  founded_year   INT,
  website        TEXT
);

INSERT INTO clubs (name, country_id, association_id, city) VALUES
  ('RSV Muggensturm',    1, 1,  'Muggensturm'),
  ('RSV Denkingen',      1, 2,  'Denkingen'),
  ('RSC Dittigheim',     1, 2,  'Dittigheim'),
  ('RV Bietigheim',      1, 2,  'Bietigheim'),
  ('RC Waldshut',        1, 2,  'Waldshut'),
  ('RC Steißlingen',     1, 2,  'Steißlingen'),
  ('RV Altdorf',         1, 1,  'Altdorf'),
  ('RV Hemsbach',        1, 3,  'Hemsbach'),
  ('RV Sursee',          2, 12, 'Sursee'),
  ('RV Rickenbach',      2, 12, 'Rickenbach'),
  ('RV Frenkendorf',     2, 12, 'Frenkendorf'),
  ('RV Wittnau',         2, 12, 'Wittnau'),
  ('RV Oftringen',       2, 12, 'Oftringen'),
  ('RV Aarau',           2, 12, 'Aarau'),
  ('RSV Korneuburg',     3, 16, 'Korneuburg'),
  ('RV Wieselburg',      3, 15, 'Wieselburg'),
  ('RV Steyr',           3, 15, 'Steyr'),
  ('RV Grieskirchen',    3, 15, 'Grieskirchen'),
  ('VC Wittenheim',      4, 16, 'Wittenheim'),
  ('VC Mulhouse',        4, 16, 'Mulhouse'),
  ('VC Thann',           4, 16, 'Thann'),
  ('RC Colmar',          4, 16, 'Colmar'),
  ('KK Liberec',         5, NULL,'Liberec'),
  ('KK Přerov',          5, NULL,'Přerov'),
  ('RV Lüblow',          1, 8,  'Lüblow'),
  ('RVW Wimsheim',       1, 2,  'Wimsheim'),
  ('RSV Zscherben',      1, 6,  'Zscherben'),
  ('RKV Bischberg',      1, 1,  'Bischberg'),
  ('RMSV Klein-Gerau',   1, 3,  'Klein-Gerau'),
  ('RV Edelweiß Fraureuth', 1, 5, 'Fraureuth');

-- ------------------------------------------------------------
-- 5. TEAMS (Paarung pro Saison & Liga)
-- ------------------------------------------------------------
CREATE TABLE teams (
  id         SERIAL PRIMARY KEY,
  club_id    INT         NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
  league_id  INT         NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
  player1    VARCHAR(100),
  player2    VARCHAR(100),
  season     VARCHAR(10) NOT NULL,
  UNIQUE (club_id, league_id, season)
);

-- ------------------------------------------------------------
-- 6. SPIELE / ERGEBNISSE
-- ------------------------------------------------------------
CREATE TABLE matches (
  id           SERIAL PRIMARY KEY,
  league_id    INT         NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
  home_team_id INT         NOT NULL REFERENCES teams(id),
  away_team_id INT         NOT NULL REFERENCES teams(id),
  home_score   INT,
  away_score   INT,
  match_date   TIMESTAMPTZ,
  round        INT,
  venue        VARCHAR(200),
  status       VARCHAR(20) NOT NULL DEFAULT 'scheduled',
  -- scheduled | live | finished | cancelled
  notes        TEXT,
  created_at   TIMESTAMPTZ DEFAULT now(),
  updated_at   TIMESTAMPTZ DEFAULT now()
);

-- Auto-Update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER matches_updated_at
  BEFORE UPDATE ON matches
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ------------------------------------------------------------
-- 7. TURNIERE
-- ------------------------------------------------------------
CREATE TABLE tournaments (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  country_id   INT          REFERENCES countries(id),
  city         VARCHAR(100),
  venue        VARCHAR(200),
  venue_address TEXT,
  start_date   DATE         NOT NULL,
  end_date     DATE,
  start_time   TIME,
  category     VARCHAR(50)  NOT NULL,
  -- 'WM' | 'EM' | 'Weltcup' | 'National' | 'International' | 'Regional'
  age_group    VARCHAR(20)  DEFAULT 'Elite',
  organizer    VARCHAR(150),           -- z.B. 'Bund Deutscher Radfahrer e.V.'
  quali_spots  INT,                    -- Qualiplätze für nächste Runde
  quali_note   TEXT,                   -- Hinweistext zur Quali
  external_url TEXT,
  season       VARCHAR(10),
  active       BOOLEAN DEFAULT TRUE,
  created_at   TIMESTAMPTZ DEFAULT now()
);

INSERT INTO tournaments (name, country_id, city, venue, venue_address, start_date, end_date, start_time, category, age_group, organizer, quali_spots, quali_note, external_url, season) VALUES
  ('Halbfinale Quali U13 DM 2026 – Gruppe 1', 1, 'Demmin', 'Sporthalle Demmin', 'Jahnstraße 9, 17109 Demmin',
   '2026-05-09', '2026-05-09', '14:00', 'National', 'U13',
   'Bund Deutscher Radfahrer e.V.', 2,
   'Die ersten 2 Mannschaften qualifizieren sich für das Finale am 30. und 31. Mai 2026',
   'https://www.vfh-muecheln.de/2026/Ergebnisse/Deutschland/Meisterschaft/DM_Quali_U13_Halbfinale_Gruppe1_2026.html', '2025/26'),
  ('UCI Weltcup 2026 – 3. Runde', 8, 'Baj', NULL, NULL,
   '2026-05-09', '2026-05-09', NULL, 'Weltcup', 'Elite', 'UCI', NULL, NULL,
   'https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Baj_2026.htm', '2025/26'),
  ('UCI Weltcup 2026 – 4. Runde', 1, 'Hähnlein', NULL, NULL,
   '2026-08-29', '2026-08-29', NULL, 'Weltcup', 'Elite', 'UCI', NULL, NULL, NULL, '2025/26'),
  ('UCI Weltcup 2026 – 5. Runde', 1, 'Großkoschen', NULL, NULL,
   '2026-09-12', '2026-09-12', NULL, 'Weltcup', 'Elite', 'UCI', NULL, NULL, NULL, '2025/26'),
  ('UCI Indoor Cycling WM 2026', 9, 'Derby', NULL, NULL,
   '2026-10-16', '2026-10-18', NULL, 'WM', 'Elite', 'UCI', NULL, NULL, NULL, '2025/26'),
  ('UCI Weltcup 2026 – 7. Runde', 2, 'Mosnang', NULL, NULL,
   '2026-11-21', '2026-11-21', NULL, 'Weltcup', 'Elite', 'UCI', NULL, NULL, NULL, '2025/26'),
  ('UCI Weltcup 2026 – Finale', 2, 'Sulgen', NULL, NULL,
   '2026-12-12', '2026-12-12', NULL, 'Weltcup', 'Elite', 'UCI', NULL, NULL, NULL, '2025/26');

-- ------------------------------------------------------------
-- 8. TURNIER-TEILNEHMER
-- ------------------------------------------------------------
CREATE TABLE tournament_entries (
  id            SERIAL PRIMARY KEY,
  tournament_id INT         NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  team_name     VARCHAR(150),
  player1       VARCHAR(100),
  player2       VARCHAR(100),
  association   VARCHAR(20),           -- 'BAY', 'MEV', ...
  seed          INT,                   -- Setzung
  club_id       INT REFERENCES clubs(id)
);

INSERT INTO tournament_entries (tournament_id, team_name, player1, player2, association) VALUES
  (1, 'RV Lüblow 1',           'Ludwig Badel',    'Louis Ihlenfeld',    'MEV'),
  (1, 'RVW Wimsheim',          'Raphael Böhringer','Niklas Engel',       'WTB'),
  (1, 'RSV Zscherben 1',       'Cedric Kern',      'Mateo Hirschfeld',   'SAH'),
  (1, 'RKB Bischberg',         'Nils Walther',     'Luca Krug',          'BAY'),
  (1, 'RMSV Klein-Gerau 2',    'Emilio Garbisch',  'Lorenzo Garbisch',   'HES'),
  (1, 'RV Edelweiß Fraureuth', 'Noah Teichmann',   'Alois Hupfer',       'SAC');

-- ------------------------------------------------------------
-- 9. TURNIER-SPIELE
-- ------------------------------------------------------------
CREATE TABLE tournament_matches (
  id             SERIAL PRIMARY KEY,
  tournament_id  INT NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  home_entry_id  INT REFERENCES tournament_entries(id),
  away_entry_id  INT REFERENCES tournament_entries(id),
  home_score     INT,
  away_score     INT,
  match_number   INT,
  match_time     TIME,
  status         VARCHAR(20) DEFAULT 'scheduled',
  updated_at     TIMESTAMPTZ DEFAULT now()
);

-- Spielplan für Turnier 1 (Gruppe 1, 6 Teams, 15 Spiele)
INSERT INTO tournament_matches (tournament_id, home_entry_id, away_entry_id, match_number) VALUES
  (1, 1, 2, 1), (1, 3, 4, 2), (1, 5, 6, 3),
  (1, 1, 3, 4), (1, 2, 5, 5), (1, 4, 6, 6),
  (1, 1, 5, 7), (1, 3, 6, 8), (1, 2, 4, 9),
  (1, 1, 4, 10),(1, 3, 5, 11),(1, 2, 6, 12),
  (1, 1, 6, 13),(1, 3, 2, 14),(1, 4, 5, 15);

-- ------------------------------------------------------------
-- 10. WELTCUP-RUNDEN
-- ------------------------------------------------------------
CREATE TABLE worldcup_rounds (
  id           SERIAL PRIMARY KEY,
  season       VARCHAR(10) NOT NULL,
  round_number INT         NOT NULL,
  city         VARCHAR(100),
  country_id   INT REFERENCES countries(id),
  round_date   DATE,
  status       VARCHAR(20) DEFAULT 'upcoming',
  -- upcoming | live | finished
  results_url  TEXT,
  results_women_url TEXT
);

INSERT INTO worldcup_rounds (season, round_number, city, country_id, round_date, status, results_url, results_women_url) VALUES
  ('2025/26', 1, 'Kobe',          7, '2026-02-22', 'finished',
   'https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Kobe_2026.htm',
   'https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Kobe_Damen_2026.htm'),
  ('2025/26', 2, 'Erzhausen',     1, '2026-03-21', 'finished',
   'https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Erzhausen_2026.htm', NULL),
  ('2025/26', 3, 'Baj',           8, '2026-05-09', 'live',
   'https://www.vfh-muecheln.de/2026/Ergebnisse/WorldCup/WorldCup_Baj_2026.htm', NULL),
  ('2025/26', 4, 'Hähnlein',      1, '2026-08-29', 'upcoming', NULL, NULL),
  ('2025/26', 5, 'Großkoschen',   1, '2026-09-12', 'upcoming', NULL, NULL),
  ('2025/26', 6, 'Prechtal',      1, '2026-10-10', 'upcoming', NULL, NULL),
  ('2025/26', 7, 'Mosnang',       2, '2026-11-21', 'upcoming', NULL, NULL),
  ('2025/26', 8, 'Sulgen',        2, '2026-12-12', 'upcoming', NULL, NULL);

-- ------------------------------------------------------------
-- 11. ADMIN-PROFILE & ROLLEN
-- ------------------------------------------------------------
CREATE TABLE admin_profiles (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name       VARCHAR(100) NOT NULL,
  role       VARCHAR(30)  NOT NULL DEFAULT 'league_admin',
  -- superadmin | country_admin | league_admin
  country_id INT REFERENCES countries(id),  -- NULL = alle Länder
  league_id  INT REFERENCES leagues(id),    -- NULL = alle Ligen
  active     BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ------------------------------------------------------------
-- 12. ROW LEVEL SECURITY (RLS)
-- ------------------------------------------------------------
ALTER TABLE matches            ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams              ENABLE ROW LEVEL SECURITY;

-- Lesen: alle dürfen lesen (für die PWA)
CREATE POLICY "public_read_matches"
  ON matches FOR SELECT USING (true);

CREATE POLICY "public_read_tournament_matches"
  ON tournament_matches FOR SELECT USING (true);

CREATE POLICY "public_read_tournaments"
  ON tournaments FOR SELECT USING (true);

CREATE POLICY "public_read_teams"
  ON teams FOR SELECT USING (true);

-- Schreiben: nur eingeloggte Admins
CREATE POLICY "admin_write_matches"
  ON matches FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_tournament_matches"
  ON tournament_matches FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_tournaments"
  ON tournaments FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- ------------------------------------------------------------
-- 13. HILFREICHE VIEWS
-- ------------------------------------------------------------

-- Aktuelle Tabelle für eine Liga berechnen
CREATE OR REPLACE VIEW league_standings AS
SELECT
  t.id AS team_id,
  t.league_id,
  c.name AS club_name,
  COUNT(m.id) AS played,
  COUNT(CASE
    WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 1
    WHEN m.away_team_id = t.id AND m.away_score > m.home_score THEN 1
  END) AS wins,
  COUNT(CASE
    WHEN m.home_score = m.away_score THEN 1
  END) AS draws,
  COUNT(CASE
    WHEN m.home_team_id = t.id AND m.home_score < m.away_score THEN 1
    WHEN m.away_team_id = t.id AND m.away_score < m.home_score THEN 1
  END) AS losses,
  COALESCE(SUM(CASE WHEN m.home_team_id = t.id THEN m.home_score ELSE m.away_score END), 0) AS goals_for,
  COALESCE(SUM(CASE WHEN m.home_team_id = t.id THEN m.away_score ELSE m.home_score END), 0) AS goals_against,
  COALESCE(SUM(CASE
    WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 2
    WHEN m.away_team_id = t.id AND m.away_score > m.home_score THEN 2
    WHEN m.home_score = m.away_score THEN 1
    ELSE 0
  END), 0) AS points
FROM teams t
JOIN clubs c ON c.id = t.club_id
LEFT JOIN matches m ON (m.home_team_id = t.id OR m.away_team_id = t.id)
  AND m.status = 'finished'
GROUP BY t.id, t.league_id, c.name
ORDER BY points DESC, (goals_for - goals_against) DESC;

-- Turnier-Tabelle berechnen
CREATE OR REPLACE VIEW tournament_standings AS
SELECT
  e.tournament_id,
  e.id AS entry_id,
  e.team_name,
  e.association,
  COUNT(m.id) AS played,
  COUNT(CASE
    WHEN m.home_entry_id = e.id AND m.home_score > m.away_score THEN 1
    WHEN m.away_entry_id = e.id AND m.away_score > m.home_score THEN 1
  END) AS wins,
  COUNT(CASE WHEN m.home_score = m.away_score AND m.status = 'finished' THEN 1 END) AS draws,
  COUNT(CASE
    WHEN m.home_entry_id = e.id AND m.home_score < m.away_score THEN 1
    WHEN m.away_entry_id = e.id AND m.away_score < m.home_score THEN 1
  END) AS losses,
  COALESCE(SUM(CASE WHEN m.home_entry_id = e.id THEN m.home_score ELSE m.away_score END), 0) AS goals_for,
  COALESCE(SUM(CASE WHEN m.home_entry_id = e.id THEN m.away_score ELSE m.home_score END), 0) AS goals_against,
  COALESCE(SUM(CASE
    WHEN m.home_entry_id = e.id AND m.home_score > m.away_score THEN 2
    WHEN m.away_entry_id = e.id AND m.away_score > m.home_score THEN 2
    WHEN m.home_score = m.away_score AND m.status = 'finished' THEN 1
    ELSE 0
  END), 0) AS points
FROM tournament_entries e
LEFT JOIN tournament_matches m ON (m.home_entry_id = e.id OR m.away_entry_id = e.id)
  AND m.status = 'finished'
GROUP BY e.tournament_id, e.id, e.team_name, e.association
ORDER BY points DESC, (goals_for - goals_against) DESC;

-- ------------------------------------------------------------
-- 14. REALTIME AKTIVIEREN
-- ------------------------------------------------------------
ALTER PUBLICATION supabase_realtime ADD TABLE matches;
ALTER PUBLICATION supabase_realtime ADD TABLE tournament_matches;
ALTER PUBLICATION supabase_realtime ADD TABLE worldcup_rounds;

-- ============================================================
-- 15. AUTO-TRIGGER: admin_profiles bei neuem Auth-User anlegen
-- ============================================================

-- Funktion: wird bei jedem neuen User in auth.users aufgerufen
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $
BEGIN
  INSERT INTO public.admin_profiles (id, name, role, country_id, active)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'league_admin'),
    (NEW.raw_user_meta_data->>'country_id')::INT,
    true
  )
  ON CONFLICT (id) DO NOTHING;  -- kein Fehler wenn Profil schon existiert
  RETURN NEW;
END;
$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: feuert nach jedem INSERT in auth.users
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- VERWENDUNG:
-- Wenn du einen User in Supabase Auth anlegst, kannst du
-- Metadaten mitgeben:
--
-- Supabase Dashboard → Authentication → Users → Add User
-- → "User Metadata" (optional):
-- {
--   "name": "Anna Schmidt",
--   "role": "country_admin",
--   "country_id": 2
-- }
--
-- Ohne Metadaten: name = E-Mail-Prefix, role = 'league_admin'
-- ============================================================

-- Funktion: Passwort-Reset per E-Mail auslösen (optional, via API)
-- Kann vom Superadmin in der Admin-Oberfläche aufgerufen werden.
CREATE OR REPLACE FUNCTION request_password_reset(user_email TEXT)
RETURNS void AS $
BEGIN
  -- Wird über Supabase Auth API ausgelöst, nicht direkt in SQL
  -- Platzhalter für Dokumentation
  RAISE NOTICE 'Passwort-Reset für % angefordert', user_email;
END;
$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- FERTIG! Alle Tabellen, Daten, Views, Policies und
-- Trigger sind gesetzt.
-- ============================================================