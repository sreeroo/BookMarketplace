package edu.hm.cs.buecherkreisel.spring;

import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.web.multipart.MultipartFile;

@Entity
class Listing {

    private @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) Long id;

    private String title;
    private Double price;
    private Category category;
    private boolean offersDelivery;
    private String description;
    private boolean isReserved;

    private Long userID;

    private String location;

    @ElementCollection
    @Column(length = 15000000)
    private List<byte[]> images;

    public Listing() {
        // Empty constructor, because Spring wants it.
    }

    /**
     * Constructor for updating a listing.
     *
     * @param id ID of listing.
     * @param title Title of listing.
     * @param price Price of listing.
     * @param category Category of listing.
     * @param offersDelivery True, if seller offers delivery.
     * @param description Description of listing.
     * @param isReserved True, if item is reserved for another user.
     * @param userID UserID of listing's seller.
     * @param location Location of listing's item.
     * @param multipartFileList Images as MultipartFile list.
     */
    public Listing(Long id, String title, Double price, Category category, boolean offersDelivery,
            String description, boolean isReserved, Long userID, String location, List<MultipartFile> multipartFileList) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.category = category;
        this.offersDelivery = offersDelivery;
        this.description = description;
        this.isReserved = isReserved;
        this.userID = userID;
        this.location = location;

        this.images = multipartFileList.stream().map(
                image -> {
                    try {
                        return image.getBytes();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
        ).collect(Collectors.toList());
    }

    /**
     * Constructor for creating a listing.
     *
     * @param title Title of listing.
     * @param price Price of listing.
     * @param category Category of listing.
     * @param offersDelivery True, if seller offers delivery.
     * @param description Description of listing.
     * @param isReserved True, if item is reserved for another user.
     * @param userID UserID of listing's seller.
     * @param location Location of listing's item.
     * @param multipartFileList Images as MultipartFile list.
     */
     public Listing(String title, Double price, Category category, boolean offersDelivery,
            String description, boolean isReserved, Long userID, String location, List<MultipartFile> multipartFileList) {
        this.title = title;
        this.price = price;
        this.category = category;
        this.offersDelivery = offersDelivery;
        this.description = description;
        this.isReserved = isReserved;
        this.userID = userID;
        this.location = location;

         this.images = multipartFileList.stream().map(
                image -> {
                    try {
                        return image.getBytes();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
        ).collect(Collectors.toList());
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public boolean isOffersDelivery() {
        return offersDelivery;
    }

    public void setOffersDelivery(boolean offersDelivery) {
        this.offersDelivery = offersDelivery;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isReserved() {
        return isReserved;
    }

    public void setReserved(boolean reserved) {
        isReserved = reserved;
    }

    public Long getUserID() {
        return userID;
    }

    public void setUserID(Long userID) {
        this.userID = userID;
    }

    // Getter must not be removed, because of JPA.
    public List<byte[]> getImages() {
        return images;
    }

    public void setImages(List<byte[]> images) {
        this.images = images;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
