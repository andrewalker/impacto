SET search_path = 'product';

CREATE OR REPLACE FUNCTION product_fix_stock_movement() RETURNS TRIGGER AS $$
BEGIN
    /* this is wrong but not our problem */
    IF (NEW.amount = 0) THEN
        RETURN NEW;
    END IF;

    /* this is wrong but we can fix it */
    IF (
        NEW.amount < 0 AND
        (
            NEW.type = 'buy' OR
            NEW.type = 'return'
        )
    ) THEN
        NEW.amount := -NEW.amount;
    END IF;

    /* same as above */
    IF (
        NEW.amount > 0 AND
        (
            NEW.type = 'sell'         OR
            NEW.type = 'donation'     OR
            NEW.type = 'consignation'
        )
    ) THEN
        NEW.amount := -NEW.amount;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION product_update_stock() RETURNS TRIGGER AS $$
DECLARE
    stock_change integer;
    my_amount    integer;
BEGIN
    stock_change := NEW.amount;

    IF TG_OP = 'UPDATE' THEN
        IF NEW.product <> OLD.product OR NEW.place <> OLD.place THEN
            UPDATE product.product_stock
                SET amount = amount - (OLD.amount)
            WHERE
                product = OLD.product AND
                place   = OLD.place;
        ELSE
            stock_change := NEW.amount - OLD.amount;
        END IF;
    END IF;

    SELECT
        amount INTO my_amount
    FROM
        product.product_stock
    WHERE
        product = NEW.product AND
        place   = NEW.place;

    IF FOUND THEN
        UPDATE product.product_stock
            SET amount = my_amount + stock_change
        WHERE
            product = NEW.product AND
            place   = NEW.place;
    ELSE
        INSERT INTO product.product_stock (    product,     place,     amount)
                                   VALUES (NEW.product, NEW.place, NEW.amount);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_fix_stock_movement ON product.stock_movement;
CREATE TRIGGER trigger_fix_stock_movement BEFORE INSERT OR UPDATE ON product.stock_movement
    FOR EACH ROW
    EXECUTE PROCEDURE product_fix_stock_movement();

DROP TRIGGER IF EXISTS trigger_update_stock ON product.stock_movement;
CREATE TRIGGER trigger_update_stock AFTER INSERT OR UPDATE ON product.stock_movement
    FOR EACH ROW
    EXECUTE PROCEDURE product_update_stock();
