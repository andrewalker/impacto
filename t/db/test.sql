CREATE TABLE person (
    slug text NOT NULL,
    name text NOT NULL,
    phone text,
    email text,
    PRIMARY KEY(slug)
);

CREATE TABLE supplier (
    person text NOT NULL,
    PRIMARY KEY (person),
    FOREIGN KEY (person) REFERENCES person(slug)
);

CREATE TABLE product (
    id integer NOT NULL,
    name text NOT NULL,
    supplier text,
    cost money NOT NULL,
    price money NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (supplier) REFERENCES supplier(person)
);
