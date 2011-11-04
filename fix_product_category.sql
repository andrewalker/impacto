DROP TABLE IF EXISTS product.product_category;

CREATE TABLE product.product_category (
    product INTEGER NOT NULL,
    category TEXT NOT NULL,
    PRIMARY KEY(product, category),
    FOREIGN KEY (product) REFERENCES product.product(id),
    FOREIGN KEY (category) REFERENCES product.category(slug)
);
