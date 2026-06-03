package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import util.ConnectDB;

public class CategoryDAO implements Accessible<Category> {

    @Override
    public List<Category> listAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setTypeId(rs.getInt("typeId"));
                c.setCategoryName(rs.getString("categoryName"));
                c.setMemo(rs.getString("memo"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Category getObjectById(String id) {
        String sql = "SELECT * FROM categories WHERE typeId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setTypeId(rs.getInt("typeId"));
                    c.setCategoryName(rs.getString("categoryName"));
                    c.setMemo(rs.getString("memo"));
                    return c;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public int insertRec(Category c) {
        String sql = "INSERT INTO categories(categoryName, memo) VALUES(?, ?)";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getMemo());
            return ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int updateRec(Category c) {
        String sql = "UPDATE categories SET categoryName=?, memo=? WHERE typeId=?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getMemo());
            ps.setInt(3, c.getTypeId());
            return ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int deleteRec(Category c) {
        String sql = "DELETE FROM categories WHERE typeId=?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, c.getTypeId());
            return ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
