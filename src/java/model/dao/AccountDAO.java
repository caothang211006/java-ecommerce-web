package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import util.ConnectDB;

public class AccountDAO implements Accessible<Account> {

    @Override
    public List<Account> listAll() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAccount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Account getObjectById(String id) {
        String sql = "SELECT * FROM accounts WHERE account = ?";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insertRec(Account acc) {
        String sql = "INSERT INTO accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem) VALUES(?,?,?,?,?,?,?,?,?)";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, acc.getAccount());
            ps.setString(2, acc.getPass());
            ps.setString(3, acc.getLastName());
            ps.setString(4, acc.getFirstName());
            ps.setDate(5, acc.getBirthday());
            ps.setBoolean(6, acc.isGender());
            ps.setString(7, acc.getPhone());
            ps.setBoolean(8, acc.isIsUse());
            ps.setInt(9, acc.getRoleInSystem());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateRec(Account acc) {
        String sql = "UPDATE accounts SET pass=?, lastName=?, firstName=?, birthday=?, gender=?, phone=?, isUse=?, roleInSystem=? WHERE account=?";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, acc.getPass());
            ps.setString(2, acc.getLastName());
            ps.setString(3, acc.getFirstName());
            ps.setDate(4, acc.getBirthday());
            ps.setBoolean(5, acc.isGender());
            ps.setString(6, acc.getPhone());
            ps.setBoolean(7, acc.isIsUse());
            ps.setInt(8, acc.getRoleInSystem());
            ps.setString(9, acc.getAccount());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteRec(Account acc) {
        String sql = "DELETE FROM accounts WHERE account=?";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, acc.getAccount());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Account> listByRole(int role) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE roleInSystem = ?";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, role);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAccount(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateSessionId(String account, String sessionId) {
        String sql = "UPDATE accounts SET sessionId = ? WHERE account = ?";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ps.setString(2, account);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int countActiveAdmins() {
        String sql = "SELECT COUNT(*) FROM accounts WHERE roleInSystem = 1 AND isUse = 1";
        try ( Connection con = new ConnectDB().getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Account mapAccount(ResultSet rs) throws Exception {
        Account acc = new Account();
        acc.setAccount(rs.getString("account"));
        acc.setPass(rs.getString("pass"));
        acc.setLastName(rs.getString("lastName"));
        acc.setFirstName(rs.getString("firstName"));
        acc.setBirthday(rs.getDate("birthday"));
        acc.setGender(rs.getBoolean("gender"));
        acc.setPhone(rs.getString("phone"));
        acc.setIsUse(rs.getBoolean("isUse"));
        acc.setRoleInSystem(rs.getInt("roleInSystem"));
        return acc;
    }
}
