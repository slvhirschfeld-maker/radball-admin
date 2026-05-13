-- ============================================================
-- Schritt 1: Funktion anlegen
-- (separat im SQL Editor ausführen)
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS
$$
BEGIN
  INSERT INTO public.admin_profiles (id, name, role, country_id, active)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'league_admin'),
    (NEW.raw_user_meta_data->>'country_id')::INT,
    true
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- ============================================================
-- Schritt 2: Trigger anlegen
-- (danach separat ausführen)
-- ============================================================
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- Schritt 3: updated_at Funktion
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS
$$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ============================================================
-- Schritt 4: updated_at Trigger für matches
-- ============================================================
CREATE OR REPLACE TRIGGER matches_updated_at
  BEFORE UPDATE ON matches
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- Schritt 5: Neue Spalten für tournament_matches
-- ============================================================
ALTER TABLE tournament_matches
  ADD COLUMN IF NOT EXISTS phase       VARCHAR(30) DEFAULT 'Runde',
  ADD COLUMN IF NOT EXISTS group_label VARCHAR(5),
  ADD COLUMN IF NOT EXISTS ko_round    INT;

ALTER TABLE tournaments
  ADD COLUMN IF NOT EXISTS mode VARCHAR(20) DEFAULT 'round_robin';