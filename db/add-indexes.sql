-- Adds the indexes introduced after the first deployment.
--
-- db/init.sql only runs against an empty database, so a server that is already
-- live (Aiven, or any local MySQL created earlier) will not pick these up. Run
-- this file once against such a server:
--
--   docker run --rm -i --dns 8.8.8.8 mysql:8.4 mysql \
--     -h <host> -P <port> -u <user> -p<password> \
--     --ssl-mode=REQUIRED <database> < db/add-indexes.sql
--
-- Run this ONCE. MySQL has no "CREATE INDEX IF NOT EXISTS", so a second run
-- stops at the first index that already exists with
-- "ERROR 1061 (42000): Duplicate key name". That error is harmless -- it means
-- the index is already in place -- but the statements after it will not run.

-- getLast(): ORDER BY postedDate DESC LIMIT 1
CREATE INDEX idx_products_posted ON products (postedDate DESC);

-- getLastByCategory(): WHERE typeId = ? ORDER BY postedDate DESC LIMIT 1
CREATE INDEX idx_products_type_posted ON products (typeId, postedDate DESC);

-- listWithFilter(): ORDER BY price
CREATE INDEX idx_products_price ON products (price);

-- loadViewHistory(): WHERE account = ? ORDER BY viewedAt DESC
CREATE INDEX idx_viewhistory_account_viewed ON viewhistory (account, viewedAt DESC);

-- listOrdersByAccount(): WHERE account = ? ORDER BY orderDate DESC
CREATE INDEX idx_orders_account_date ON orders (account, orderDate DESC);
