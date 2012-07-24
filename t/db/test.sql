CREATE TABLE person (
    slug text NOT NULL,
    name text NOT NULL,
    birthday TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    phone text,
    email text,
    PRIMARY KEY(slug)
);

CREATE TABLE client (
    person text NOT NULL,
    PRIMARY KEY (person),
    FOREIGN KEY (person) REFERENCES person(slug)
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

CREATE TABLE category (
    slug text NOT NULL,
    name text NOT NULL,
    PRIMARY KEY (slug)
);

CREATE TABLE product_category (
    product integer NOT NULL,
    category text NOT NULL,
    FOREIGN KEY (product)  REFERENCES product(id),
    FOREIGN KEY (category) REFERENCES category(slug),
    PRIMARY KEY (product, category)
);

/*
 * this obviously makes no sense and is absurd
 * but it's here to allow tests for complex relationships
 * in Form::SensibleX::FieldFactory::BelongsTo
 */
CREATE TABLE product_category_comments (
    product integer NOT NULL,
    category text NOT NULL,
    comments text NOT NULL,
    FOREIGN KEY (product, category)  REFERENCES product_category(product, category),
    PRIMARY KEY (product, category)
);

CREATE TABLE product_tag (
    product integer NOT NULL,
    tag     text NOT NULL,
    FOREIGN KEY (product) REFERENCES product(id),
    PRIMARY KEY (product, tag)
);

CREATE TABLE product_meta (
    product integer NOT NULL,
    name    text NOT NULL,
    value   text NOT NULL,
    FOREIGN KEY (product) REFERENCES product(id),
    PRIMARY KEY (product, name)
);

INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person1', 'André Walker',     '01/05/1991', '1234-5678', 'me1@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person2', 'Mr. Walker',       '02/05/1991', '2234-5678', 'me2@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person3', 'Mr. André',        '03/05/1991', '3234-5678', 'me3@andrewalker.net');
INSERT INTO person (slug, name, birthday, phone, email) VALUES ('person4', 'Sir André Walker', '04/05/1991', '4234-5678', 'me4@andrewalker.net');

INSERT INTO supplier (person) VALUES ('person1');
INSERT INTO supplier (person) VALUES ('person4');

INSERT INTO client (person) VALUES ('person2');
INSERT INTO client (person) VALUES ('person3');

INSERT INTO product (id, name, supplier, cost, price) VALUES (1, 'Product 1', 'person1', 25, 50);
INSERT INTO product (id, name, supplier, cost, price) VALUES (2, 'Product 2', 'person1', 25, 50);
INSERT INTO product (id, name, supplier, cost, price) VALUES (3, 'Product 3', 'person4', 25, 50);

INSERT INTO category (slug, name) VALUES ('books', 'Books');
INSERT INTO category (slug, name) VALUES ('small', 'Small books');
INSERT INTO category (slug, name) VALUES ('big',   'Big books');
INSERT INTO category (slug, name) VALUES ('mag',   'Magazines');

INSERT INTO product_category (product, category) VALUES (1, 'books');
INSERT INTO product_category (product, category) VALUES (1, 'small');
INSERT INTO product_category (product, category) VALUES (2, 'books');
INSERT INTO product_category (product, category) VALUES (2, 'big');
INSERT INTO product_category (product, category) VALUES (3, 'mag');

INSERT INTO product_tag (product, tag) VALUES (3, 'beautiful');
INSERT INTO product_tag (product, tag) VALUES (3, 'cheap');

INSERT INTO product_meta (product, name, value) VALUES (1, 'brand', 'my fancy brand');
INSERT INTO product_meta (product, name, value) VALUES (1, 'color', 'white');
