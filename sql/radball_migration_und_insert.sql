-- ============================================================
--  Migration: team_number hinzufügen + Constraint anpassen
--  Danach: Vollständiges INSERT aller 202 Teams
-- ============================================================


-- ── 1. MIGRATION ─────────────────────────────────────────────
-- Alten Constraint entfernen
ALTER TABLE teams
  DROP CONSTRAINT IF EXISTS teams_club_id_league_id_season_key;

-- Spalte team_number ergänzen (Standard = 1)
ALTER TABLE teams
  ADD COLUMN IF NOT EXISTS team_number SMALLINT NOT NULL DEFAULT 1;

-- Neuen Constraint mit team_number
ALTER TABLE teams
  ADD CONSTRAINT teams_club_league_season_number_key
  UNIQUE (club_id, league_id, season, team_number);

-- ── Optional: bestehende Duplikate vorher bereinigen ─────────
-- Falls die Tabelle bereits Daten enthält und Duplikate
-- vorhanden sind, erst aufräumen:
--
-- DELETE FROM teams
-- WHERE id NOT IN (
--   SELECT MIN(id) FROM teams
--   GROUP BY club_id, league_id, season
-- );


-- ════════════════════════════════════════════════════════════
-- 2. LÄNDER
-- ════════════════════════════════════════════════════════════
INSERT INTO countries (id, code, flag, name) VALUES
  (1, 'de', '🇩🇪', 'Deutschland'),
  (2, 'ch', '🇨🇭', 'Schweiz'),
  (3, 'at', '🇦🇹', 'Österreich'),
  (4, 'fr', '🇫🇷', 'Frankreich'),
  (5, 'be', '🇧🇪', 'Belgien'),
  (6, 'cz', '🇨🇿', 'Tschechien')
ON CONFLICT (id) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 3. LIGEN
-- ════════════════════════════════════════════════════════════
INSERT INTO leagues (id, name, country_id, season) VALUES
  (1,  '1. Bundesliga',                             1, '2025/26'),
  (2,  '2. Bundesliga Mitte',                       1, '2025/26'),
  (3,  '2. Bundesliga Nord',                        1, '2025/26'),
  (4,  '2. Bundesliga Süd',                         1, '2025/26'),
  (5,  'Bundespokal Frauen',                        1, '2025/26'),
  (7,  'DM U13 HF Gruppe 1',                        1, '2025/26'),
  (8,  'DM U13 HF Gruppe 2',                        1, '2025/26'),
  (9,  'DM U19 HF Gruppe 1',                        1, '2025/26'),
  (10, 'DM U19 HF Gruppe 2',                        1, '2025/26'),
  (6,  'NLA',                                       2, '2025/26'),
  (30, 'NLB',                                       2, '2025/26'),
  (31, '3. Liga',                                   2, '2025/26'),
  (32, 'SM U17/U19',                                2, '2025/26'),
  (33, 'SM U15',                                    2, '2025/26'),
  (34, 'SM U11',                                    2, '2025/26'),
  (11, '1. Liga Österreich',                        3, '2025/26'),
  (20, 'LM Vorarlberg – 1. Liga',                   3, '2025/26'),
  (21, 'LM Vorarlberg – Junioren',                  3, '2025/26'),
  (22, 'LM Vorarlberg – Jugend',                    3, '2025/26'),
  (12, 'Championnat de France Elite',               4, '2025/26'),
  (40, 'Championnat Grand Est Liga 1',              4, '2025/26'),
  (41, 'Championnat de France U19',                 4, '2025/26'),
  (42, 'Championnat de France U15',                 4, '2025/26'),
  (50, 'Kampioenschap van Belgie – Elite',          5, '2025/26'),
  (60, 'Extraliga Elite',                           6, '2025/26')
ON CONFLICT (id) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 4. VEREINE
-- ════════════════════════════════════════════════════════════
INSERT INTO clubs (id, name, country_id) VALUES
  -- Deutschland
  (1001, 'RMC Stein',                    1),
  (1002, 'RVW Naurod',                   1),
  (1003, 'RSV Großkoschen',              1),
  (1004, 'RSV Waldrems',                 1),
  (1005, 'TuS Iserlohn',                 1),
  (1006, 'RV Gärtringen',                1),
  (1007, 'SV Nordshausen',               1),
  (1008, 'RVI Ailingen',                 1),
  (1009, 'RKV Denkendorf',               1),
  (1010, 'RSV Kissing',                  1),
  (1011, 'RVC Prechtal',                 1),
  (1012, 'RV Kemnat',                    1),
  (1013, 'RSV Sangerhausen',             1),
  (1014, 'RSV Gifhorn',                  1),
  (1015, 'RSG Ginsheim',                 1),
  (1016, 'RSV Krofdorf',                 1),
  (1017, 'RSC Schiefbahn',               1),
  (1018, 'RfV Wiednitz',                 1),
  (1019, 'SG Langenwolschendorf',        1),
  (1020, 'SG Niederlauterstein',         1),
  (1021, 'SG Lückersdorf',               1),
  (1022, 'KSC Leipzig',                  1),
  (1023, 'MTV Saalfeld',                 1),
  (1024, 'Reideburger SV',               1),
  (1025, 'SG Chemie Zeitz',              1),
  (1026, 'Tollwitzer RSV',               1),
  (1027, 'RKV Hofen',                    1),
  (1028, 'RVE Sulgen',                   1),
  (1029, 'RV Bonlanden',                 1),
  (1030, 'SV Erzhausen',                 1),
  (1031, 'VC Darmstadt',                 1),
  (1032, 'SG Hofen/Prechtal',            1),
  (1033, 'SG Fraureuth/Langenleuba',     1),
  (1034, 'SG Arheilgen/Prechtal',        1),
  (1035, 'RVW Merklingen',               1),
  (1036, 'SG Ebersbach/Reichenbach',     1),
  (1037, 'RV Lüblow',                    1),
  (1038, 'RVW Wimsheim',                 1),
  (1039, 'RSV Zscherben',                1),
  (1040, 'RKB Bischberg',                1),
  (1041, 'RMSV Klein-Gerau',             1),
  (1042, 'RV Edelweiß Fraureuth',        1),
  (1043, 'SG Suderwich',                 1),
  (1044, 'RSV Lauterbach',               1),
  (1045, 'RSV Nellingen',                1),
  (1046, 'SV BG Ehrenberg',              1),
  (1047, 'RSV Öflingen',                 1),
  (1048, 'RSV Reichenbach',              1),
  (1049, 'RV Obernfeld',                 1),
  (1050, 'Ludwigsfelder RC',             1),
  (1051, 'RC Worfelden',                 1),
  (1052, 'RC Luckau',                    1),
  (1053, 'RV Velbert',                   1),
  -- Schweiz
  (2001, 'RV Mosnang',                   2),
  (2002, 'RV Oftringen',                 2),
  (2003, 'RV Altdorf',                   2),
  (2004, 'RV Winterthur',                2),
  (2005, 'RV Möhlin',                    2),
  (2006, 'RV Schöftland',                2),
  (2007, 'RV Pfungen',                   2),
  (2008, 'RV Amriswil',                  2),
  (2009, 'RV Liestal',                   2),
  (2010, 'RV St. Gallen',                2),
  (2011, 'RV Wettingen',                 2),
  (2012, 'RV Männedorf',                 2),
  (2013, 'RV Seon-Niederlenz',           2),
  (2014, 'RV Frauenfeld',                2),
  (2015, 'RV Bremgarten',                2),
  (2016, 'RV Gümligen',                  2),
  (2017, 'RV Bassersdorf-Nürensdorf',    2),
  (2018, 'SG Schöftland/Liestal',        2),
  (2019, 'RV Rothenburg',                2),
  -- Österreich
  (3001, 'RC Dornbirn',                  3),
  (3002, 'RV Sulz',                      3),
  (3003, 'RC Höchst',                    3),
  (3004, 'SV Schwechat',                 3),
  -- Frankreich
  (4001, 'VCE Dorlisheim',               4),
  (4002, 'VC Cronenbourg',               4),
  (4003, 'JCF Balbigny',                 4),
  (4004, 'CCS Feurs',                    4),
  (4005, 'Entente JCF/CCS Feurs',        4),
  (4006, 'Entente CCS Feurs/EC Clermont',4),
  (4007, 'Pédale Combs la Villaise',     4),
  -- Belgien
  (5001, 'CB Genk ''68',                 5),
  (5002, 'SNA Gent',                     5),
  (5003, 'HZG Beringen',                 5)
ON CONFLICT (id) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 5. TEAMS  (mit team_number)
-- Spalten: club_id, league_id, team_number, name, player1, player2, season
-- team_number unterscheidet Mannschaft 1, 2, 3 … desselben Vereins
-- in derselben Liga/Saison.
-- ════════════════════════════════════════════════════════════

-- ── Deutschland – 1. Bundesliga (Liga 1) ────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1001, 1, 1, 'RMC Stein',       'Michael Birkner',   'Robert Mlady',         '2025/26'),
  (1002, 1, 1, 'RVW Naurod',      'Marco Wagner',      'Till Wehner',          '2025/26'),
  (1003, 1, 1, 'RSV Großkoschen', 'Eric Lehmann',      'Tim Lehmann',          '2025/26'),
  (1004, 1, 1, 'RSV Waldrems',    'Björn Bootsmann',   'Marcel Schüle',        '2025/26'),
  (1005, 1, 1, 'TuS Iserlohn',    'Daniel Endrowait',  'Sven Holland-Moritz',  '2025/26'),
  (1006, 1, 1, 'RV Gärtringen 1', 'Simon Becker',      'Jannes Müller',        '2025/26'),
  (1006, 1, 2, 'RV Gärtringen 2', 'Luis Müller',       'Kai Schäfer',          '2025/26'),
  (1007, 1, 1, 'SV Nordshausen',  'Luca Grellert',     'Marius Hermanns',      '2025/26'),
  (1008, 1, 1, 'RVI Ailingen',    'Michael Brugger',   'Markus Lang',          '2025/26'),
  (1009, 1, 1, 'RKV Denkendorf',  'Valentin Notheis',  'Felix Weinert',        '2025/26'),
  (1010, 1, 1, 'RSV Kissing',     'Martin Egarter',    'Dr. Thomas Kieferle',  '2025/26'),
  (1011, 1, 1, 'RVC Prechtal',    'Simon Becherer',    'Marco Joos',           '2025/26');

-- ── Deutschland – 2. Bundesliga Mitte (Liga 2) ──────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1012, 2, 1, 'RV Kemnat 1',      'Max Rückschloss',    'Chris Rapp',          '2025/26'),
  (1013, 2, 1, 'RSV Sangerhausen', 'Peter Krause',       'Eric Haedicke',       '2025/26'),
  (1014, 2, 1, 'RSV Gifhorn',      'Christian Kramer',   'Corvin Rowold',       '2025/26'),
  (1004, 2, 1, 'RSV Waldrems 3',   'Moritz Völk',        'Philipp Völk',        '2025/26'),
  (1004, 2, 2, 'RSV Waldrems 4',   'Andre Klinger',      'Martin Frey',         '2025/26'),
  (1015, 2, 1, 'RSG Ginsheim',     'Andre Müller',       'Mika Ehrhard',        '2025/26'),
  (1002, 2, 1, 'RVW Naurod 2',     'Pascal van Klev',    'Timo Wagner',         '2025/26'),
  (1005, 2, 1, 'TuS Iserlohn 2',   'Cedrik Perla',       'Jan Pannach',         '2025/26'),
  (1012, 2, 2, 'RV Kemnat 3',      'Florenc Rapp',       'Lean Patzelt',        '2025/26'),
  (1016, 2, 1, 'RSV Krofdorf',     'Steven Johncox',     'Kai Kraft',           '2025/26'),
  (1007, 2, 1, 'SV Nordshausen 2', 'Christian Gallinger','Lars Degenhardt',     '2025/26'),
  (1017, 2, 1, 'RSC Schiefbahn',   'Robin Leusch',       'Jannis Leusch',       '2025/26');

-- ── Deutschland – 2. Bundesliga Nord (Liga 3) ───────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1018, 3, 1, 'RfV Wiednitz 1',          'Sullivan Pittner', 'Patrick Richter',    '2025/26'),
  (1003, 3, 1, 'RSV Großkoschen 2',       'Norman Tuppatsch', 'Oliver Noack',       '2025/26'),
  (1003, 3, 2, 'RSV Großkoschen 3',       'Vin Görlich',      'Karl Oscar Müller',  '2025/26'),
  (1019, 3, 1, 'SG Langenwolschendorf 1', 'Nils Kebsch',      'Manuel Paschka',     '2025/26'),
  (1020, 3, 1, 'SG Niederlauterstein 1',  'Lucas Neubert',    'Tobias Buschbeck',   '2025/26'),
  (1020, 3, 2, 'SG Niederlauterstein 2',  'Paul Simon',       'Falk Langer',        '2025/26'),
  (1021, 3, 1, 'SG Lückersdorf 1',        'Sascha Michala',   'Ricardo Slota',      '2025/26'),
  (1022, 3, 1, 'KSC Leipzig 1',           'Kay Fritsche',     'Lenny Schwarzbauer', '2025/26'),
  (1023, 3, 1, 'MTV Saalfeld 1',          'Dominic Espen',    'Jonas Zetzsche',     '2025/26'),
  (1024, 3, 1, 'Reideburger SV 1',        'Max Berndt',       'Paul Berndt',        '2025/26'),
  (1025, 3, 1, 'SG Chemie Zeitz 1',       'Johannes Helm',    'Alexander Jose',     '2025/26'),
  (1026, 3, 1, 'Tollwitzer RSV 1',        'Oliver Uhlirsch',  'Paul Bretschneider', '2025/26');

-- ── Deutschland – 2. Bundesliga Süd (Liga 4) ────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1006, 4, 1, 'RV Gärtringen 3',  'Nico Quast',          'Till Ganser',         '2025/26'),
  (1006, 4, 2, 'RV Gärtringen 4',  'Kevin Seeber',        'Markus Schäfer',      '2025/26'),
  (1027, 4, 1, 'RKV Hofen 1',      'Dennis Berner',       'Magnus Öhlert',       '2025/26'),
  (1010, 4, 1, 'RSV Kissing 2',    'Andreas Pongratz',    'Lukas Keller',        '2025/26'),
  (1031, 4, 1, 'VC Darmstadt 1',   'Luca Kovacevic',      'Markus Dürr',         '2025/26'),
  (1012, 4, 1, 'RV Kemnat 2',      'Mark Beinschrodt',    'Philipp Kling',       '2025/26'),
  (1029, 4, 1, 'RV Bonlanden 1',   'Johannes Beck',       'Marcel Düring',       '2025/26'),
  (1028, 4, 1, 'RVE Sulgen 1',     'Lukas Öhler',         'Manuel Ehrmann',      '2025/26'),
  (1011, 4, 1, 'RVC Prechtal 2',   'Simon Wisser',        'Claudius Holzer',     '2025/26'),
  (1004, 4, 1, 'RSV Waldrems 2',   'David Piesch',        'Patrick Fleischmann', '2025/26'),
  (1030, 4, 1, 'SV Erzhausen 1',   'Dominik Leiser',      'Florian Bartl',       '2025/26'),
  (1009, 4, 1, 'RKV Denkendorf 2', 'Sascha Henn',         'Andreas Stahl',       '2025/26');

-- ── Deutschland – Bundespokal Frauen (Liga 5) ───────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1032, 5, 1, 'SG Hofen/Prechtal',        'Danielle Holzer',  'Judith Wolf',       '2025/26'),
  (1033, 5, 1, 'SG Fraureuth/Langenleuba', 'Isabell Kaiser',   'Leonie Reinicke',   '2025/26'),
  (1034, 5, 1, 'SG Arheilgen/Prechtal',    'Daria Dönig',      'Verena Volk',       '2025/26'),
  (1035, 5, 1, 'RVW Merklingen',           'Claire Feyler',    'Nadine Schuler',    '2025/26'),
  (1036, 5, 1, 'SG Ebersbach/Reichenbach', 'Amely Klügel',     'Sarah Urbanitsch',  '2025/26');

-- ── Deutschland – DM U13 HF Gruppe 1 Demmin (Liga 7) ────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1037, 7, 1, 'RV Lüblow 1',           'Ludwig Badel',      'Louis Ihlenfeld',   '2025/26'),
  (1038, 7, 1, 'RVW Wimsheim',          'Raphael Böhringer', 'Niklas Engel',      '2025/26'),
  (1039, 7, 1, 'RSV Zscherben 1',       'Cedric Kern',       'Mateo Hirschfeld',  '2025/26'),
  (1040, 7, 1, 'RKB Bischberg',         'Nils Walther',      'Luca Krug',         '2025/26'),
  (1041, 7, 1, 'RMSV Klein-Gerau 2',    'Emilio Garbisch',   'Lorenzo Garbisch',  '2025/26'),
  (1042, 7, 1, 'RV Edelweiß Fraureuth', 'Noah Teichmann',    'Alois Hupfer',      '2025/26');

-- ── Deutschland – DM U13 HF Gruppe 2 Ailingen (Liga 8) ──────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1043, 8, 1, 'SG Suderwich',      'Amelie Göttken',    'Moritz Göttken',    '2025/26'),
  (1044, 8, 1, 'RSV Lauterbach',    'Luca Haas',         'Silvan Buchholz',   '2025/26'),
  (1045, 8, 1, 'RSV Nellingen',     'Lukas Ehret',       'Levi Hörsch',       '2025/26'),
  (1039, 8, 1, 'RSV Zscherben 2',   'Lukas Gerdes-Treff','Marlon Döbel',      '2025/26'),
  (1046, 8, 1, 'SV BG Ehrenberg 2', 'Matteo Lehmann',    'Kurt Schwendler',   '2025/26'),
  (1008, 8, 1, 'RVI Ailingen',      'Theo Braunger',     'Benjamin Brugger',  '2025/26');

-- ── Deutschland – DM U19 HF Gruppe 1 Reichenbach (Liga 9) ───
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1004, 9, 1, 'RSV Waldrems',      'Emil Heckelmann',  'Philipp Stang',     '2025/26'),
  (1047, 9, 1, 'RSV Öflingen',      'Frederik Kranz',   'Quentin Schumann',  '2025/26'),
  (1048, 9, 1, 'RSV Reichenbach 1', 'Niklas Wittchen',  'Henri Teichmann',   '2025/26'),
  (1049, 9, 1, 'RV Obernfeld',      'Lois Dette',       'Simon Morick',      '2025/26'),
  (1050, 9, 1, 'Ludwigsfelder RC',  'Julius Eckardt',   'Laurens Parlow',    '2025/26');

-- ── Deutschland – DM U19 HF Gruppe 2 Luckau (Liga 10) ───────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (1051, 10, 1, 'RC Worfelden',    'Mika Rüttel',      'Bjarne Diehl',      '2025/26'),
  (1044, 10, 1, 'RSV Lauterbach 1','Patrick Fischer',  'Max Echtle',        '2025/26'),
  (1026, 10, 1, 'Tollwitzer RSV',  'Niklas Hennig',    'Tim Riedel',        '2025/26'),
  (1053, 10, 1, 'RV Velbert',      'Thilo Peters',     'Fritz Reinbott',    '2025/26'),
  (1052, 10, 1, 'RC Luckau',       'Lennert Kuboth',   'Lukas Knopf',       '2025/26');

-- ── Schweiz – NLA (Liga 6) ───────────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2001, 6, 1, 'Mosnang 1', 'Björn Vogel',         'Rafael Artho',       '2025/26'),
  (2001, 6, 2, 'Mosnang 2', 'Manuel Mutti',        'Roger Artho',        '2025/26'),
  (2002, 6, 1, 'Oftringen', 'Rafael Stadelmann',   'Andreas Zaugg',      '2025/26'),
  (2003, 6, 1, 'Altdorf 1', 'Timon Fröhlich',      'Yannick Fröhlich',   '2025/26'),
  (2003, 6, 2, 'Altdorf 2', 'Fabian Hauri',        'Jon Müller',         '2025/26'),
  (2003, 6, 3, 'Altdorf 3', 'Valentin Stadler',    'Jan Brand',          '2025/26'),
  (2004, 6, 1, 'Winterthur','Roman Baumann',       'Tim Russenberger',   '2025/26'),
  (2005, 6, 1, 'Möhlin 1',  'Stefan Lützelschwab', 'Simon Fischler',     '2025/26'),
  (2005, 6, 2, 'Möhlin 2',  'Yosuke Degen',        'Tom Graf',           '2025/26');

-- ── Schweiz – NLB (Liga 30) ──────────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2006, 30, 1, 'Schöftland', 'Michael Baumann',    'Freddy Schenk',      '2025/26'),
  (2003, 30, 1, 'Altdorf 1',  'Jari Kern',          'Michael Grütter',    '2025/26'),
  (2003, 30, 2, 'Altdorf 2',  'Claudio Zotter',     'Matteo Baumann',     '2025/26'),
  (2007, 30, 1, 'Pfungen',    'Florian Grunder',    'Luca Aeberhard',     '2025/26'),
  (2002, 30, 1, 'Oftringen',  'Mathias Eggen',      'Samuel Niklaus',     '2025/26'),
  (2001, 30, 1, 'Mosnang 1',  'Joel Schnellmann',   'Ralf Breitenmoser',  '2025/26'),
  (2001, 30, 2, 'Mosnang 2',  'Ueli Signer',        'Yannick Eggenberger','2025/26'),
  (2004, 30, 1, 'Winterthur', 'Basil Rödlinger',    'Marcel Chaves',      '2025/26'),
  (2008, 30, 1, 'Amriswil',   'Stefan Bichsel',     'Severin Sutter',     '2025/26'),
  (2009, 30, 1, 'Liestal 1',  'Andry Accola',       'Lukas Oberer',       '2025/26'),
  (2009, 30, 2, 'Liestal 2',  'Simon Müller',       'Levin Fankhauser',   '2025/26'),
  (2005, 30, 1, 'Möhlin 1',   'Tazuya Degen',       'Romano Cicchetti',   '2025/26'),
  (2005, 30, 2, 'Möhlin 2',   'Stuart Müller',      'Raphael Schmid',     '2025/26'),
  (2005, 30, 3, 'Möhlin 3',   'Marc Graf',          'Fabian Burch',       '2025/26'),
  (2010, 30, 1, 'St. Gallen', 'Charlie Hollenstein','Rico Niklaus',       '2025/26');

-- ── Schweiz – 3. Liga (Liga 31) ──────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2011, 31, 1, 'Wettingen',               'Pedro Carvalho',    'Rico Götschmann',     '2025/26'),
  (2001, 31, 1, 'Mosnang 1',               'Simon Hollenstein', 'Andreas Grümiger',    '2025/26'),
  (2001, 31, 2, 'Mosnang 2',               'Urs Walliser',      'Rene Ziegler',        '2025/26'),
  (2001, 31, 3, 'Mosnang 3',               'Tamas Szitas',      'Jozesf Grosz',        '2025/26'),
  (2001, 31, 4, 'Mosnang 4',               'Boris Kuklj',       'Sandro Koller',       '2025/26'),
  (2002, 31, 1, 'Oftringen 1',             'Efraim Flury',      'Jeremia Flury',       '2025/26'),
  (2002, 31, 2, 'Oftringen 2',             'Flurin König',      'Julian Lanzenecker',  '2025/26'),
  (2003, 31, 1, 'Altdorf',                 'Niklaus Gisler',    'Tim Walker',          '2025/26'),
  (2004, 31, 1, 'Winterthur 1',            'Sava Baumann',      'Chiara Dotoli',       '2025/26'),
  (2004, 31, 2, 'Winterthur 2',            'Luc Vock',          'Joshua Kebede',       '2025/26'),
  (2004, 31, 3, 'Winterthur 3',            'Lukas Weibel',      'Patrick Tisch',       '2025/26'),
  (2012, 31, 1, 'Männedorf 1',             'Daniel Fritschi',   'Marc Honegger',       '2025/26'),
  (2012, 31, 2, 'Männedorf 2',             'Vincente Herrera',  'Tobis Schmitz',       '2025/26'),
  (2013, 31, 1, 'Seon-Niederlenz',         'Markus Roth',       'Amel Hodzic',         '2025/26'),
  (2014, 31, 1, 'Frauenfeld',              'Michael Baschleben','Patrick Ehrbar',      '2025/26'),
  (2015, 31, 1, 'Bremgarten',              'Fabian Koch',       'Dominic Schmidt',     '2025/26'),
  (2008, 31, 1, 'Amriswil',               'Jürgen Stauder',    'Etienne Grof',        '2025/26'),
  (2010, 31, 1, 'St. Gallen',              'Lorenz Bauer',      'Felix Bauer',         '2025/26'),
  (2016, 31, 1, 'Gümligen',               'Adrian Stucki',     'Daniel Stempfel',     '2025/26'),
  (2017, 31, 1, 'Bassersdorf-Nürensdorf',  'Rolf Zemp',         'Markus Zemp',         '2025/26'),
  (2018, 31, 1, 'Schöftland/Liestal',      'Anna Affolter',     'Valerie Suter',       '2025/26');

-- ── Schweiz – U17/U19 (Liga 32) ──────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2001, 32, 1, 'Mosnang 1 U19',    'Luca Schönenberger', 'Dario Schönenberger', '2025/26'),
  (2001, 32, 2, 'Mosnang 2 U19',    'Tom Truniger',       'Adrian Schönenberger','2025/26'),
  (2001, 32, 3, 'Mosnang 3 U19',    'David Schnellmann',  'Mikka Roth',          '2025/26'),
  (2001, 32, 4, 'Mosnang U17',      'Loris Schönenberger','Marc Herach',         '2025/26'),
  (2002, 32, 1, 'Oftringen U17',    'Dario Eberhard',     'Marlon Frei',         '2025/26'),
  (2004, 32, 1, 'Winterthur 1 U17', 'Gulia Baumann',      'Renee Reichlin',      '2025/26'),
  (2004, 32, 2, 'Winterthur 2 U17', 'Neva Rüttimann',     'Emma Jentsch',        '2025/26'),
  (2005, 32, 1, 'Möhlin 1 U17',     'Manuel Schneider',   'Jesse Zimmermann',    '2025/26'),
  (2005, 32, 2, 'Möhlin 2 U17',     'Finn Frana',         'Giulio Petrilla',     '2025/26'),
  (2014, 32, 1, 'Frauenfeld 1 U19', 'Ben Wepf',           'Kilian Haslach',      '2025/26');

-- ── Schweiz – U15 (Liga 33) ──────────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2003, 33, 1, 'Altdorf 1',              'Leandro Arnold',    'Louis Albert',        '2025/26'),
  (2003, 33, 2, 'Altdorf 2',              'Nino Walker',       'Jonatan Walker',      '2025/26'),
  (2004, 33, 1, 'Winterthur 1',           'Anton Jentsch',     'Jonathan Mungenast',  '2025/26'),
  (2004, 33, 2, 'Winterthur 2',           'Seraina Kehl',      'Julen Rey',           '2025/26'),
  (2005, 33, 1, 'Möhlin 1',              'Miles Roth',        'Finn Bollinger',      '2025/26'),
  (2005, 33, 2, 'Möhlin 2',              'Finn Hilpert',      'Nico Battilana',      '2025/26'),
  (2005, 33, 3, 'Möhlin 3',              'Amelie Lauber',     'Saome Lauber',        '2025/26'),
  (2006, 33, 1, 'Schöftland',             'Florian Iten',      'Robin Hauri',         '2025/26'),
  (2007, 33, 1, 'Pfungen 1',              'Enea Donno',        'Milo Träger',         '2025/26'),
  (2007, 33, 2, 'Pfungen 2',              'Eleni Sedlacek',    'Heidi Wollnik',       '2025/26'),
  (2001, 33, 1, 'Mosnang',               'Tom Schnellmann',   'Silas Sieber',        '2025/26'),
  (2009, 33, 1, 'Liestal',               'Mayla Jullien',     'Anton Platter',       '2025/26'),  -- Platzhalter, Daten aus U11
  (2010, 33, 1, 'St. Gallen 1',           'Lionel Zeller',     'Luis Höhener',        '2025/26'),
  (2010, 33, 2, 'St. Gallen 2',           'Nino Ammann',       'Dario Kempter',       '2025/26'),
  (2014, 33, 1, 'Frauenfeld 1',           'Timael Fischer',    'Noel Engel',          '2025/26'),
  (2014, 33, 2, 'Frauenfeld 2',           'Philipp Wuhrmann',  'Severin Fahmi',       '2025/26'),
  (2015, 33, 1, 'Bremgarten 1',           'Bastien Sears',     'Lenny Stössel',       '2025/26'),
  (2015, 33, 2, 'Bremgarten 2',           'Thomas Peterlik',   'Aaron Peterhans',     '2025/26'),
  (2017, 33, 1, 'Bassersdorf-Nürensdorf', 'Fabian Hemmer',     'Jonas Hemmer',        '2025/26');

-- ── Schweiz – U11 (Liga 34) ──────────────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (2001, 34, 1, 'Mosnang 1',  'Ivo Schnellmann',  'Dario Schnellmann',  '2025/26'),
  (2001, 34, 2, 'Mosnang 2',  'Nevio König',      'Luca Sennhauser',    '2025/26'),
  (2002, 34, 1, 'Oftringen 1','Loan Finn Hug',    'Janick Berner',      '2025/26'),
  (2002, 34, 2, 'Oftringen 2','Silas Zaugg',      'Finn Stadelmann',    '2025/26'),
  (2003, 34, 1, 'Altdorf',    'Luca Walker',      'Jacob Marty',        '2025/26'),
  (2004, 34, 1, 'Winterthur', 'Lea Wölti',        'Matthias Mungeast',  '2025/26'),
  (2009, 34, 1, 'Liestal',    'Mayla Jullien',    'Anton Platter',      '2025/26'),
  (2019, 34, 1, 'Rothenburg', 'Finn Durrer',      'Manuel Boeglin',     '2025/26');

-- ── Österreich – 1. Liga (Liga 11) ──────────────────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (3001, 11, 1, 'Dornbirn 1',  'Patrick Schnetzer',      'Markus Brüll',            '2025/26'),
  (3001, 11, 2, 'Dornbirn 2',  'Pascal Fontain',         'Patrick Köck',            '2025/26'),
  (3002, 11, 1, 'Sulz 1',      'Kevin Bachmann',         'Michael Welte',           '2025/26'),
  (3002, 11, 2, 'Sulz 2',      'Philipp Schwendinger',   'Maximilian Schwendinger', '2025/26'),
  (3003, 11, 1, 'Höchst',      'Timo Lampert',           'Max Schallert',           '2025/26'),
  (3004, 11, 1, 'SV Schwechat','David Wondra',           'Charlie Förster',         '2025/26');

-- ── Österreich – LM Vorarlberg 1. Liga (Liga 20) ────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (3001, 20, 1, 'Dornbirn 1', 'Patrick Schnetzer',      'Markus Brüll',            '2025/26'),
  (3001, 20, 2, 'Dornbirn 2', 'Pascal Fontain',         'Patrick Köck',            '2025/26'),
  (3001, 20, 3, 'Dornbirn 4', 'Simon Buchhäusl',        'Mathias Maierhofer',      '2025/26'),
  (3002, 20, 1, 'Sulz 2',     'Philipp Schwendinger',   'Maximilian Schwendinger', '2025/26'),
  (3003, 20, 1, 'Höchst 1',   'Lukas Wimmer',           'Max Schallert',           '2025/26');

-- ── Österreich – LM Vorarlberg Junioren (Liga 21) ───────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (3001, 21, 1, 'Dornbirn 1',          'Alexander Birkel', 'Leon Ofner',        '2025/26'),
  (3003, 21, 1, 'SG Höchst/Dornbirn',  'Lukas Wimmer',     'Mathias Maierhofer','2025/26');

-- ── Österreich – LM Vorarlberg Jugend (Liga 22) ─────────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (3001, 22, 1, 'Dornbirn 2',             'Dominik Schwarzmann','Tobias Niederer', '2025/26'),
  (3001, 22, 2, 'Dornbirn 3',             'Bartholomäus Hagen', 'Leon Ofner',      '2025/26'),
  (3002, 22, 1, 'Sulz 1',                 'Joel Röthlin',       'Liam Konzett',    '2025/26'),
  (3002, 22, 2, 'Sulz 2',                 'Xaver Juli',         'Emil Müller',     '2025/26'),
  (3003, 22, 1, 'SG Höchst/Dornbirn 2',  'Sarah Kraller',      'Frieda Römmele',  '2025/26');

-- ── Frankreich – Championnat de France Elite (Liga 12) ──────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (4001, 12, 1, 'Grand Est 1 – VCE Dorlisheim 1', 'Mathias Seyfried', 'Quentin Seyfried', '2025/26'),
  (4001, 12, 2, 'Grand Est 3 – VCE Dorlisheim 2', 'Thomas Leclerc',   'David Luck',       '2025/26'),
  (4001, 12, 3, 'Grand Est 4 – VCE Dorlisheim 3', 'Romain Doell',     'Martin Knab',      '2025/26'),
  (4002, 12, 1, 'Grand Est 2 – VC Cronenbourg 1',  'Stephane Bauer',   'Frederic Doell',   '2025/26'),
  (4002, 12, 2, 'Grand Est 5 – VC Cronenbourg 2',  'Lucien Brucker',   'Francois Rieb',    '2025/26'),
  (4003, 12, 1, 'Aura – JCF Balbigny',             'Renaud Vial',      'Florian Fournier', '2025/26');

-- ── Frankreich – Championnat Grand Est Liga 1 (Liga 40) ─────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (4001, 40, 1, 'VCE Dorlisheim 1', 'Quentin Seyfried', 'Mathias Seyfried', '2025/26'),
  (4001, 40, 2, 'VCE Dorlisheim 2', 'Thomas Leclerc',   'David Luck',       '2025/26'),
  (4001, 40, 3, 'VCE Dorlisheim 3', 'Lucien Brucker',   'Francois Rieb',    '2025/26'),
  (4001, 40, 4, 'VCE Dorlisheim 4', 'Lionel Schmitt',   'Leo Backert',      '2025/26'),
  (4002, 40, 1, 'VC Cronenbourg 1', 'Frederic Doell',   'Stephane Bauer',   '2025/26'),
  (4002, 40, 2, 'VC Cronenbourg 2', 'Romain Doell',     'Michel Luther',    '2025/26');

-- ── Frankreich – Championnat de France U19 (Liga 41) ────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (4001, 41, 1, 'Grand Est 1 – VCE Dorlisheim 1',   'Aurel Morgenthaler','Amaury Engel',       '2025/26'),
  (4001, 41, 2, 'Grand Est 2 – VCE Dorlisheim 2',   'Antoine Dorgler',   'Alexandre Rosseaux', '2025/26'),
  (4004, 41, 1, 'Aura 2 – CCS Feurs',               'Quentin Momal',     'Baptiste Delille',   '2025/26'),
  (4005, 41, 1, 'Aura 1 – Entente JCF/CCS Feurs',   'Laszlo Guyonnet',   'Enzo de Freitas',    '2025/26'),
  (4006, 41, 1, 'Aura 3 – Entente CCS/EC Clermont', 'Ryan Vincent',      'Yannis Mathias',     '2025/26');

-- ── Frankreich – Championnat de France U15 (Liga 42) ────────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (4002, 42, 1, 'Grand Est 1 – VC Cronenbourg 1',      'Louis Knab',         'Louen Doell',        '2025/26'),
  (4002, 42, 2, 'Grand Est 2 – VC Cronenbourg 2',      'Martin Knab',        'Clement Schott',     '2025/26'),
  (4004, 42, 1, 'Aura 2 – CCS Feurs',                  'Wyatt Laval',        'Antoine Ade',        '2025/26'),
  (4005, 42, 1, 'Aura 1 – Entente JCF/CCS Feurs',      'Gauthier Sabot',     'Maxence Chamorro',   '2025/26'),
  (4007, 42, 1, 'Ile de France 1 – Pédale Combs 1',    'Gabriel Binet',      'Leo Musy',           '2025/26'),
  (4007, 42, 2, 'Ile de France 2 – Pédale Combs 2',    'Aarujan Sivalingam', 'Akash Sivalingam',   '2025/26');

-- ── Belgien – Kampioenschap van Belgie Elite (Liga 50) ───────
INSERT INTO teams (club_id, league_id, team_number, name, player1, player2, season) VALUES
  (5001, 50, 1, 'CB Genk ''68 1', 'Robby Gubbelmans', 'Koen Uitterhaegen', '2025/26'),
  (5001, 50, 2, 'CB Genk ''68 2', 'Marc Snoks',        'Kenny Michalik',    '2025/26'),
  (5001, 50, 3, 'CB Genk ''68 3', 'Jenthe Gielen',     'Luka Cops',         '2025/26'),
  (5001, 50, 4, 'CB Genk ''68 4', 'Maxim Marut',       'Arne Gabriels',     '2025/26'),
  (5002, 50, 1, 'SNA Gent 1',     'Dries Oosterlinck', 'Wout Oosterlinck',  '2025/26'),
  (5002, 50, 2, 'SNA Gent 2',     'Arnak Mkytarian',   'Artak Voskanyan',   '2025/26'),
  (5002, 50, 3, 'SNA Gent 3',     'Ruben Deraedt',     'Bram Lambrecht',    '2025/26'),
  (5002, 50, 4, 'SNA Gent 4',     'Niels Oosterlinck', 'Lorenzo Vandorpe',  '2025/26'),
  (5003, 50, 1, 'HZG Beringen 1', 'Maikel Moons',      'Patrick Dennis',    '2025/26');
