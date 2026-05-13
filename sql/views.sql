-- ============================================================
-- league_standings View – neu erstellen
-- ============================================================
CREATE OR REPLACE VIEW league_standings AS
SELECT
  t.id AS team_id,
  t.league_id,
  c.name AS club_name,
  COUNT(m.id)::INT AS played,
  COUNT(CASE
    WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 1
    WHEN m.away_team_id = t.id AND m.away_score > m.home_score THEN 1
  END)::INT AS wins,
  COUNT(CASE
    WHEN m.status = 'finished' AND m.home_score = m.away_score THEN 1
  END)::INT AS draws,
  COUNT(CASE
    WHEN m.home_team_id = t.id AND m.home_score < m.away_score THEN 1
    WHEN m.away_team_id = t.id AND m.away_score < m.home_score THEN 1
  END)::INT AS losses,
  COALESCE(SUM(CASE
    WHEN m.home_team_id = t.id THEN m.home_score
    WHEN m.away_team_id = t.id THEN m.away_score
    ELSE 0
  END), 0)::INT AS goals_for,
  COALESCE(SUM(CASE
    WHEN m.home_team_id = t.id THEN m.away_score
    WHEN m.away_team_id = t.id THEN m.home_score
    ELSE 0
  END), 0)::INT AS goals_against,
  COALESCE(SUM(CASE
    WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 2
    WHEN m.away_team_id = t.id AND m.away_score > m.home_score THEN 2
    WHEN m.status = 'finished' AND m.home_score = m.away_score THEN 1
    ELSE 0
  END), 0)::INT AS points
FROM teams t
JOIN clubs c ON c.id = t.club_id
LEFT JOIN matches m
  ON (m.home_team_id = t.id OR m.away_team_id = t.id)
  AND m.status = 'finished'
GROUP BY t.id, t.league_id, c.name;

-- ============================================================
-- tournament_standings View – neu erstellen
-- ============================================================
CREATE OR REPLACE VIEW tournament_standings AS
SELECT
  e.tournament_id,
  e.id AS entry_id,
  e.team_name,
  e.association,
  COUNT(m.id)::INT AS played,
  COUNT(CASE
    WHEN m.home_entry_id = e.id AND m.home_score > m.away_score THEN 1
    WHEN m.away_entry_id = e.id AND m.away_score > m.home_score THEN 1
  END)::INT AS wins,
  COUNT(CASE
    WHEN m.status = 'finished' AND m.home_score = m.away_score THEN 1
  END)::INT AS draws,
  COUNT(CASE
    WHEN m.home_entry_id = e.id AND m.home_score < m.away_score THEN 1
    WHEN m.away_entry_id = e.id AND m.away_score < m.home_score THEN 1
  END)::INT AS losses,
  COALESCE(SUM(CASE
    WHEN m.home_entry_id = e.id THEN m.home_score
    WHEN m.away_entry_id = e.id THEN m.away_score
    ELSE 0
  END), 0)::INT AS goals_for,
  COALESCE(SUM(CASE
    WHEN m.home_entry_id = e.id THEN m.away_score
    WHEN m.away_entry_id = e.id THEN m.home_score
    ELSE 0
  END), 0)::INT AS goals_against,
  COALESCE(SUM(CASE
    WHEN m.home_entry_id = e.id AND m.home_score > m.away_score THEN 2
    WHEN m.away_entry_id = e.id AND m.away_score > m.home_score THEN 2
    WHEN m.status = 'finished' AND m.home_score = m.away_score THEN 1
    ELSE 0
  END), 0)::INT AS points
FROM tournament_entries e
LEFT JOIN tournament_matches m
  ON (m.home_entry_id = e.id OR m.away_entry_id = e.id)
  AND m.status = 'finished'
GROUP BY e.tournament_id, e.id, e.team_name, e.association;