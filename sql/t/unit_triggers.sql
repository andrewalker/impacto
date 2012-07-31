SET search_path = 'product', 'public';

/*
 * DON'T USE THIS ON A PRODUCTION DATABASE!
 */

DELETE FROM product WHERE id = 9000;
DELETE FROM product WHERE id = 9001;
DELETE FROM place WHERE place = 'my test place';

INSERT INTO product (id, name, cost, price) VALUES (9000, 'test product', 2, 2);
INSERT INTO product (id, name, cost, price) VALUES (9001, 'test product without corresponding product_stock row', 2, 2);
INSERT INTO place (place) VALUES ('my test place');
INSERT INTO product_stock (product, place, amount) VALUES (9000, 'my test place', 10);

BEGIN;
    SELECT plan(13);

    SELECT is( ps.amount, 10, 'amount is expected' ) FROM product_stock ps WHERE place = 'my test place' AND product = 9000;
    INSERT INTO stock_movement (id, datetime, amount, type, place, product) VALUES (9000, NOW(), 3, 'buy', 'my test place', 9000);

    SELECT is( type, 'buy', 'type is unchanged' ) FROM stock_movement WHERE id = 9000;
    SELECT is( amount, 3, 'amount is unchanged' ) FROM stock_movement WHERE id = 9000;

    SELECT is( ps.amount, 13, 'amount is updated' ) FROM product_stock ps WHERE place = 'my test place' AND product = 9000;

    UPDATE stock_movement SET type = 'sell' WHERE id = 9000;

    SELECT is( type, 'sell', 'type is updated' ) FROM stock_movement WHERE id = 9000;
    SELECT is( amount, -3, 'amount is automatically fixed' ) FROM stock_movement WHERE id = 9000;

    SELECT is( ps.amount, 7, 'amount is updated' ) FROM product_stock ps WHERE place = 'my test place' AND product = 9000;

    SELECT is( COUNT(*)::integer, 0, 'no stock yet for 9001' ) FROM product_stock WHERE place = 'my test place' AND product = 9001;

    INSERT INTO stock_movement (id, datetime, amount, type, place, product) VALUES (9001, NOW(), -30, 'buy', 'my test place', 9001);

    SELECT is( type,  'buy',        'type is still the same' ) FROM stock_movement WHERE id = 9001;
    SELECT is( amount,   30, 'amount is automatically fixed' ) FROM stock_movement WHERE id = 9001;

    SELECT is( amount, 30, 'stock is created' ) FROM product_stock WHERE place = 'my test place' AND product = 9001;

    UPDATE stock_movement SET product = 9001 WHERE id = 9000;

    SELECT is( amount, 27, 'stock is updated' ) FROM product_stock WHERE place = 'my test place' AND product = 9001;
    SELECT is( amount, 10, 'stock is updated' ) FROM product_stock WHERE place = 'my test place' AND product = 9000;

    SELECT * FROM finish();
ROLLBACK;

DELETE FROM product WHERE id = 9000;
DELETE FROM product WHERE id = 9001;
DELETE FROM place WHERE place = 'my test place';
