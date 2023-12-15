package edu.hm.cs.buecherkreisel.spring;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

class ListingTest {

    private List<MultipartFile> createMultipartFileList() {
        List<MultipartFile> multipartFileList = new ArrayList<>();

        MultipartFile multipartFile = new MockMultipartFile("TestName",
                "TestImage".getBytes());

        multipartFileList.add(multipartFile);
        return multipartFileList;
    }

    @Test
    public void testListingUpdateConstructor() {
        Listing listing = new Listing(
                1L,
                "TestBuch",
                9.99,
                Category.INFORMATIK,
                true,
                "TestBeschreibung",
                false,
                2L,
                "München",
                "gregor@samsa.pl",
                createMultipartFileList()
        );

        assertEquals(1L, listing.getId());
        assertEquals("TestBuch", listing.getTitle());
        assertEquals(9.99, listing.getPrice());
        assertEquals(Category.INFORMATIK, listing.getCategory());
        assertTrue(listing.isOffersDelivery());
        assertEquals("TestBeschreibung", listing.getDescription());
        assertFalse(listing.isReserved());
        assertEquals(2L, listing.getUserID());
        assertEquals("München", listing.getLocation());
        assertEquals(createMultipartFileList().size(),
                listing.getImages().size());
    }

    @Test
    public void testListingCreateConstructor() {
        Listing listing = new Listing(
                "TestBuch",
                9.99,
                Category.INFORMATIK,
                true,
                "TestBeschreibung",
                false,
                2L,
                "München",
                "gregor@samsa.pl",
                createMultipartFileList()
        );

        assertNull(listing.getId());
        assertEquals("TestBuch", listing.getTitle());
        assertEquals(9.99, listing.getPrice());
        assertEquals(Category.INFORMATIK, listing.getCategory());
        assertTrue(listing.isOffersDelivery());
        assertEquals("TestBeschreibung", listing.getDescription());
        assertFalse(listing.isReserved());
        assertEquals(2L, listing.getUserID());
        assertEquals("München", listing.getLocation());
        assertEquals(createMultipartFileList().size(),
                listing.getImages().size());
    }

    @Test
    public void testGettersAndSetters() {

        Listing listing = new Listing();

        listing.setId(1L);
        listing.setTitle("TestBuch");
        listing.setPrice(9.99);
        listing.setCategory(Category.INFORMATIK);
        listing.setOffersDelivery(true);
        listing.setDescription("TestBeschreibung");
        listing.setReserved(false);
        listing.setUserID(2L);
        listing.setLocation("München");
        listing.setContact("gregor@samsa.pl");
        listing.setImages(createMultipartFileList());

        assertEquals(1L, listing.getId());
        assertEquals("TestBuch", listing.getTitle());
        assertEquals(9.99, listing.getPrice());
        assertEquals(Category.INFORMATIK, listing.getCategory());
        assertTrue(listing.isOffersDelivery());
        assertEquals("TestBeschreibung", listing.getDescription());
        assertFalse(listing.isReserved());
        assertEquals(2L, listing.getUserID());
        assertEquals("München", listing.getLocation());
        assertEquals("gregor@samsa.pl", listing.getContact());
        assertEquals(createMultipartFileList().size(),
                listing.getImages().size());
    }

}