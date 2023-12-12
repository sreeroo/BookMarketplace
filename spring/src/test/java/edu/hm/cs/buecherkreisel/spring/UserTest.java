package edu.hm.cs.buecherkreisel.spring;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.Arrays;
import java.util.List;

public class UserTest {

    private User user;

    @BeforeEach
    public void setUp() {
        user = new User("user1", "pass1", "profilePic");
    }

    @Test
    public void testSetAndGetUsername() {
        user.setUsername("newUser");
        assertEquals("newUser", user.getUsername());
    }

    @Test
    public void testSetAndGetId() {
        user.setId(2L);
        assertEquals(2, user.getId());
    }

    @Test
    public void testSetAndGetToken() {
        user.setToken("newToken");
        assertEquals("newToken", user.getToken());
    }

    @Test
    public void testSetAndGetLikedListings() {
        List<Long> likedListings = Arrays.asList(1L, 2L, 3L);
        user.setLikedListings(likedListings);
        assertEquals(likedListings, user.getLikedListings());
    }

    @Test
    public void testSetAndGetPassword() {
        user.setPassword("newPass");
        assertEquals("newPass", user.getPassword());
    }

    @Test
    public void testSetAndGetProfilePicture() {
        user.setProfilePicture("newProfilePic");
        assertEquals("newProfilePic", user.getProfilePicture());
    }

    @Test
    public void testToString() {
        String expected = "User{id=null, username='user1', password='pass1', token='" + user.getToken() + "', profilePicture='profilePic'}";
        assertEquals(expected, user.toString());
    }

    @Test
    public void testEqualsAndHashCode() {
        User otherUser = new User("user1", "pass1", "profilePic");
        assertNotEquals(user, otherUser);
        assertNotEquals(user.hashCode(), otherUser.hashCode());

        otherUser.setToken(user.getToken());
        assertEquals(user, otherUser);
        assertEquals(user.hashCode(), otherUser.hashCode());

        otherUser.setProfilePicture("newPic");
        assertNotEquals(user, otherUser);
        assertNotEquals(user.hashCode(), otherUser.hashCode());
    }

    @Test
    public void testUpdateToken() {
        String oldToken = user.getToken();
        user.updateToken();
        String newToken = user.getToken();
        assertNotEquals(oldToken, newToken);
    }

    @Test
    public void testDefaultConstructor() {
        User user1 = new User();
        assertNotEquals(user, user1);
        assertNotEquals(user.hashCode(), user1.hashCode());
    }

    @Test
    public void testIncrementGetAndSetTotalListings() {
        assertEquals(0, user.getTotalListings());
        user.incrementTotalListings();
        assertEquals(1, user.getTotalListings());
        user.setTotalListings(10);
        assertEquals(10, user.getTotalListings());
        user.incrementTotalListings();
        assertEquals(11, user.getTotalListings());
    }
}

