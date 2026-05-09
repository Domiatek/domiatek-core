-- Migration 002: clients table
CREATE TABLE IF NOT EXISTS clients (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre     TEXT    NOT NULL,
  apellidos  TEXT    NOT NULL,
  telefono   TEXT    NOT NULL,
  email      TEXT,
  dni_nie    TEXT,
  direccion  TEXT,
  notas      TEXT,
  created_at TEXT    NOT NULL,
  updated_at TEXT    NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_clients_apellidos ON clients (apellidos);
CREATE INDEX IF NOT EXISTS idx_clients_telefono  ON clients (telefono);
