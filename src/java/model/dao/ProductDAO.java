package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Category;
import model.Product;
import util.ConnectDB;

public class ProductDAO implements Accessible<Product> {

    public List<Product> listWithFilter(String typeId, String priceRange, String discountFilter, String sortPrice) {
        List<Product> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        if (typeId != null && !typeId.isEmpty()) {
            sql.append(" AND typeId = ?");
            try {
                params.add(Integer.valueOf(typeId));
            } catch (NumberFormatException ex) {
                return list;
            }
        }
        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "low":
                    sql.append(" AND price < ?");
                    params.add(5000000);
                    break;
                case "mid":
                    sql.append(" AND price >= ? AND price <= ?");
                    params.add(5000000);
                    params.add(15000000);
                    break;
                case "high":
                    sql.append(" AND price > ?");
                    params.add(15000000);
                    break;
            }
        }
        if (discountFilter != null && !discountFilter.isEmpty()) {
            switch (discountFilter) {
                case "yes":
                    sql.append(" AND discount > 0");
                    break;
                case "no":
                    sql.append(" AND discount = 0");
                    break;
            }
        }
        if ("asc".equals(sortPrice)) {
            sql.append(" ORDER BY price ASC");
        } else if ("desc".equals(sortPrice)) {
            sql.append(" ORDER BY price DESC");
        }

        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Product> listAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Category> listAllCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("typeId"), rs.getString("categoryName"), rs.getString("memo")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getLast() {
        String sql = "SELECT * FROM products ORDER BY postedDate DESC LIMIT 1";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Product getLastByCategory(String typeId) {
        String sql = "SELECT * FROM products WHERE typeId = ? ORDER BY postedDate DESC LIMIT 1";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, typeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> listProductByCategory(String typeId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE typeId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, typeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> listProductByAccount(String account) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE account = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> listProductByName(String txtSearch) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE productName LIKE ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + txtSearch.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Product getObjectById(String id) {
        String sql = "SELECT * FROM products WHERE productId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Loads several products in one round trip, preserving the order of the ids
     * given.
     *
     * Callers used to loop over a list of ids calling getObjectById for each
     * one. That is the classic N+1 problem: viewing five recently seen products
     * meant five separate queries, and every one of them paid the full network
     * latency to the database. This does the same work with a single
     * "WHERE productId IN (...)".
     *
     * The placeholders are generated from the list size and the values are still
     * bound through setString, so this stays a parameterised query -- no id is
     * ever concatenated into the SQL.
     */
    public List<Product> listByIds(List<String> ids) {
        List<Product> ordered = new ArrayList<>();
        if (ids == null || ids.isEmpty()) {
            return ordered;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            placeholders.append(i == 0 ? "?" : ",?");
        }
        String sql = "SELECT * FROM products WHERE productId IN (" + placeholders + ")";

        Map<String, Product> byId = new HashMap<>();
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setString(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapProduct(rs);
                    byId.put(p.getProductId(), p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // SQL gives no ordering guarantee for IN, and the caller cares about
        // the order (most recently viewed first), so reorder here. Ids with no
        // matching row -- a product deleted since it was viewed -- are skipped.
        for (String id : ids) {
            Product p = byId.get(id);
            if (p != null) {
                ordered.add(p);
            }
        }
        return ordered;
    }

    @Override
    public int insertRec(Product p) {
        String sql = "INSERT INTO products(productId, productName, productImage, brief, postedDate, typeId, account, unit, price, discount) VALUES(?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getProductId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getProductImage());
            ps.setString(4, p.getBrief());
            ps.setTimestamp(5, p.getPostedDate());
            ps.setInt(6, p.getType().getTypeId());
            ps.setString(7, p.getAccount().getAccount());
            ps.setString(8, p.getUnit());
            ps.setInt(9, p.getPrice());
            ps.setInt(10, p.getDiscount());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateRec(Product p) {
        String sql = "UPDATE products SET productName=?, productImage=?, brief=?, typeId=?, unit=?, price=?, discount=? WHERE productId=?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getProductImage());
            ps.setString(3, p.getBrief());
            ps.setInt(4, p.getType().getTypeId());
            ps.setString(5, p.getUnit());
            ps.setInt(6, p.getPrice());
            ps.setInt(7, p.getDiscount());
            ps.setString(8, p.getProductId());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteRec(Product p) {
        String sql = "DELETE FROM products WHERE productId=?";
        try (Connection con = new ConnectDB().getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getProductId());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private Product mapProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getString("productId"));
        p.setProductName(rs.getString("productName"));
        p.setProductImage(rs.getString("productImage"));
        p.setBrief(rs.getString("brief"));
        p.setPostedDate(rs.getTimestamp("postedDate"));
        p.setUnit(rs.getString("unit"));
        p.setPrice(rs.getInt("price"));
        p.setDiscount(rs.getInt("discount"));
        Category c = new Category();
        c.setTypeId(rs.getInt("typeId"));
        p.setType(c);
        model.Account acc = new model.Account();
        acc.setAccount(rs.getString("account"));
        p.setAccount(acc);
        return p;
    }
}
