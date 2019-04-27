-- Example - 01: Updating a table with a trigger


CREATE TABLE widgetCustomer ( id SERIAL, name VARCHAR(255), last_order_id BIGINT );
CREATE TABLE widgetSale ( id SERIAL, item_id BIGINT, customer_id BIGINT, quan INT, price DECIMAL(9,2) );

INSERT INTO widgetCustomer (name) VALUES ('Bob');
INSERT INTO widgetCustomer (name) VALUES ('Sally');
INSERT INTO widgetCustomer (name) VALUES ('Fred');

SELECT * FROM widgetCustomer;

CREATE TRIGGER newWidgetSale AFTER INSERT ON widgetSale
    FOR EACH ROW
    UPDATE widgetCustomer SET last_order_id = NEW.id WHERE id = NEW.customer_id
;

INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (1, 3, 5, 19.95);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (2, 2, 3, 14.95);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (3, 1, 1, 29.95);
SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;