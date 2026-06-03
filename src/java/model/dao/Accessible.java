package model.dao;

import java.util.List;

public interface Accessible<T> {
    int insertRec(T obj);
    int updateRec(T obj);
    int deleteRec(T obj);
    T getObjectById(String id);
    List<T> listAll();
}
