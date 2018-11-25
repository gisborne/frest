CREATE TABLE IF NOT EXISTS
  types(
    id PRIMARY KEY DEFAULT (UUID()),
    name,
    abstract NOT NULL DEFAULT false
  );

CREATE TABLE IF NOT EXISTS
  contents(
    id PRIMARY KEY DEFAULT (UUID()),
    content,
    type NOT NULL REFERENCES types(id),
    created_at DEFAULT (NOW()),
    result_type
  );

CREATE TABLE IF NOT EXISTS
  types_inheritance (
  parent_id NOT NULL REFERENCES content (id),
  child_id  NOT NULL REFERENCES content (id),

  PRIMARY KEY (
    parent_id,
    child_id
  )
    ON CONFLICT
    IGNORE,

  CHECK (
    parent_id <> child_id
  )
);

DROP VIEW IF EXISTS content_types;
CREATE VIEW
    content_types AS
    SELECT
      c.id,
      c.type
    FROM
      contents c JOIN
      types t ON t.id = c.type;