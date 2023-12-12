package edu.hm.cs.buecherkreisel.spring;

import jakarta.persistence.*;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Base64;

@Entity
@Table(name="\"user\"")
public class User {

    private @Id
    @GeneratedValue Long id;
    private String username;
    private String password;
    private String token;
    private int totalListings;

    @Column(length = 15_000_000)
    private String profilePicture;

    @ElementCollection(targetClass = Long.class)
    private List<Long> likedListings;

    public User() {}

    public User(String username, String password, String profilePicture) {
        this.username = username;
        this.password = password;
        this.profilePicture = profilePicture;
        this.totalListings = 0;
        likedListings = new ArrayList<>();
        updateToken(); // Generate first token
    }

    public String getUsername() {
        return username;
    }

    public long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public List<Long> getLikedListings() {
        return likedListings;
    }

    public void setLikedListings(List<Long> likedListings) {
        this.likedListings = likedListings;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getToken() {
        return token;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public int getTotalListings() {
        return totalListings;
    }

    public void setTotalListings(int totalListings) {
        this.totalListings = totalListings;
    }

    public void incrementTotalListings() {
        this.totalListings++;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return  Objects.equals(id, user.id) &&
                Objects.equals(getUsername(), user.getUsername()) &&
                Objects.equals(getPassword(), user.getPassword()) &&
                Objects.equals(getToken(), user.getToken()) &&
                Objects.equals(getProfilePicture(), user.getProfilePicture());
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, getUsername(), getPassword(), getToken(), getProfilePicture());
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", token='" + token + '\'' +
                ", profilePicture='" + profilePicture + '\'' +
                '}';
    }

    /*
     * Generates random token used for authentication
     *
     * Only gets called after password got changed
     */
    public void updateToken(){
        SecureRandom random = new SecureRandom();
        byte[] randomBytes = new byte[32];
        random.nextBytes(randomBytes);
        this.setToken(Base64.getUrlEncoder().encodeToString(randomBytes));
    }
}
