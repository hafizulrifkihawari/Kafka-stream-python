CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL
);

CREATE TABLE experiences (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES users (id),
    company_name VARCHAR NOT NULL,
    start_date timestamp NOT NULL,
    end_date timestamp,
    is_present BOOLEAN NOT NULL
);

ALTER TABLE users REPLICA IDENTITY FULL;
ALTER TABLE experiences REPLICA IDENTITY FULL;