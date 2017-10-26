package cz.fi.muni.pa165.teamred.entity;

import javax.persistence.Entity;
import java.time.DateTimeException;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.Collections;

/**
 * Created by Šimon on 25.10.2017.
 */

@Entity
public class Ride {

    private LocalDateTime departure;
    private double price;
    private int availableSeats;
    private Driver driver;
    private Set<Passenger> passengers;
    private City sourceCity;
    private City destinationCity;
    private Set<Comment> comments;

    public Ride() {
    }


// setters
    public void setDeparture(LocalDateTime dep){
        this.departure = dep;
    }

    public void setPrice(double price){
        this.price = price;
    }

    public void setAvailableSeats(int seats){
        this.availableSeats = seats;
    }

    public void setDriver(Driver d){
        this.driver = d;
    }

    public void addPassenger(Passenger p){
        this.passengers.add(p);
    }

    public void setSourceCity(City city){
        this.sourceCity = city;
    }

    public void setDestinationCity(City city){
        this.destinationCity = city;
    }

    public void addComment(Comment c){
        this.comments.add(c);
    }

// getters
    public LocalDateTime getDeparture(){
        return this.departure
    }

    public double getPrice(){
        return this.price;
    }

    public int getAvailableSeats(){
        return this.availableSeats;
    }

    public Driver getDriver(){
       return this.driver;
    }

    public Set<Passenger> getPassengers(){
        return Collections.unmodifiableSet(passengers);
    }

    public City getSourceCity(){
        return this.sourceCity;
    }

    public City getDestinationCity(){
        return this.destinationCity;
    }

    public Set<Comment> getComments(){
        return Collections.unmodifiableSet(comments);
    }



    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (! (obj instanceof Ride))
            return false;
        Ride other = (Ride) obj;
        if (driver == null) {
            if (other.getDriver() != null)
                return false;
        } else if ((driver.equals(other.getDriver())) && (departure.equals(other.departure)))
            return true;
        return false;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime*result+((driver == null)? 0 : driver.hashCode())+((departure == null)? 0 : departure.hashCode());
        return result;
    }








}
