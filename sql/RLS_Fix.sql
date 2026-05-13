-- ============================================================
-- RLS FIX – Öffentliches Lesen für alle Tabellen erlauben
-- Im Supabase SQL Editor ausführen
-- ============================================================

-- 1. RLS aktivieren (falls noch nicht aktiv)
ALTER TABLE countries         ENABLE ROW LEVEL SECURITY;
ALTER TABLE leagues           ENABLE ROW LEVEL SECURITY;
ALTER TABLE clubs             ENABLE ROW LEVEL SECURITY;
ALTER TABLE associations      ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches           ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams             ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments       ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE worldcup_rounds   ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_profiles    ENABLE ROW LEVEL SECURITY;

-- 2. Alte Policies löschen (falls vorhanden, um Duplikate zu vermeiden)
DROP POLICY IF EXISTS "public_read_countries"          ON countries;
DROP POLICY IF EXISTS "public_read_leagues"            ON leagues;
DROP POLICY IF EXISTS "public_read_clubs"              ON clubs;
DROP POLICY IF EXISTS "public_read_associations"       ON associations;
DROP POLICY IF EXISTS "public_read_matches"            ON matches;
DROP POLICY IF EXISTS "public_read_teams"              ON teams;
DROP POLICY IF EXISTS "public_read_tournaments"        ON tournaments;
DROP POLICY IF EXISTS "public_read_tournament_entries" ON tournament_entries;
DROP POLICY IF EXISTS "public_read_tournament_matches" ON tournament_matches;
DROP POLICY IF EXISTS "public_read_worldcup_rounds"    ON worldcup_rounds;
DROP POLICY IF EXISTS "admin_read_profiles"            ON admin_profiles;
DROP POLICY IF EXISTS "admin_write_matches"            ON matches;
DROP POLICY IF EXISTS "admin_write_tournaments"        ON tournaments;
DROP POLICY IF EXISTS "admin_write_tournament_matches" ON tournament_matches;

-- 3. Public READ für alle öffentlichen Tabellen
CREATE POLICY "public_read_countries"
  ON countries FOR SELECT USING (true);

CREATE POLICY "public_read_leagues"
  ON leagues FOR SELECT USING (true);

CREATE POLICY "public_read_clubs"
  ON clubs FOR SELECT USING (true);

CREATE POLICY "public_read_associations"
  ON associations FOR SELECT USING (true);

CREATE POLICY "public_read_matches"
  ON matches FOR SELECT USING (true);

CREATE POLICY "public_read_teams"
  ON teams FOR SELECT USING (true);

CREATE POLICY "public_read_tournaments"
  ON tournaments FOR SELECT USING (true);

CREATE POLICY "public_read_tournament_entries"
  ON tournament_entries FOR SELECT USING (true);

CREATE POLICY "public_read_tournament_matches"
  ON tournament_matches FOR SELECT USING (true);

CREATE POLICY "public_read_worldcup_rounds"
  ON worldcup_rounds FOR SELECT USING (true);

-- 4. admin_profiles: nur eingeloggte Admins dürfen lesen
CREATE POLICY "admin_read_profiles"
  ON admin_profiles FOR SELECT
  USING (auth.role() = 'authenticated');

-- 5. Schreiben: nur eingeloggte Admins
CREATE POLICY "admin_write_matches"
  ON matches FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_tournaments"
  ON tournaments FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_tournament_matches"
  ON tournament_matches FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_worldcup_rounds"
  ON worldcup_rounds FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_leagues"
  ON leagues FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_clubs"
  ON clubs FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "admin_write_profiles"
  ON admin_profiles FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- ============================================================
-- Kontrolle: alle aktiven Policies anzeigen
-- ============================================================
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd;