CREATE TABLE person (
    slug text NOT NULL,
    name text NOT NULL,
    birthday TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
    cost integer NOT NULL,
    price integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (supplier) REFERENCES supplier(person)
);

INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person1', 'André Walker',     '01/05/1991', '1234-5678', 'me1@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person2', 'Mr. Walker',       '02/05/1991', '2234-5678', 'me2@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person3', 'Mr. André',        '03/05/1991', '3234-5678', 'me3@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person4', 'Sir André Walker', '04/05/1991', '4234-5678', 'me4@andrewalker.net');

INSERT INTO supplier (person) VALUES ('person1');
INSERT INTO supplier (person) VALUES ('person4');

INSERT INTO product (id, name, supplier, cost, price) VALUES (1, 'Product 1', 'person1', 25, 50);
INSERT INTO product (id, name, supplier, cost, price) VALUES (2, 'Product 2', 'person1', 25, 50);
INSERT INTO product (id, name, supplier, cost, price) VALUES (3, 'Product 3', 'person4', 25, 50);
