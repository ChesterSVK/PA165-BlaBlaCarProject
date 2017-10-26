package cz.fi.muni.pa165.teamred.dao;

import cz.fi.muni.pa165.teamred.entity.Ride;

import java.util.List;

/**
 * Created by Šimon on 26.10.2017.
 */
public interface RideDao {

    public void create(Ride r);

    public void delete(Ride r);

    public List<Ride> findAll();
}
