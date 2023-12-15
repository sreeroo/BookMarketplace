package edu.hm.cs.buecherkreisel.spring;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
class ListingController {

    private final ListingRepository repository;
    private final UserRepository userRepository;

    ListingController(ListingRepository repository, UserRepository userRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    /**
     * Respond with all listings
     * @return 200 HTTP status code and a list of all listings
     */
    @GetMapping("/listings")
    ResponseEntity<List<Listing>> allListings() {
        return ResponseEntity.ok(repository.findAll());
    }

    /**
     * Respond with filtered listings
     * @return 200 HTTP status code and a list of filtered listings
     */
    @GetMapping("/listings/search")
    ResponseEntity<List<Listing>> filterListings(
            // Optional required, so params can be null
            @RequestParam("minPrice") Optional<Double> minPrice,
            @RequestParam("maxPrice") Optional<Double> maxPrice,
            @RequestParam("category") Optional<Category> category,
            @RequestParam("offersDelivery") Optional<Boolean> offersDelivery,
            @RequestParam("searchString") Optional<String> searchString,
            @RequestParam("isReserved") Optional<Boolean> isReserved,
            @RequestParam("location") Optional<String> location,
            @RequestParam("user_id") Optional<Long> userID
            ) {
        List<Listing> allListings = repository.findAll();

        List<Listing> listings = new ArrayList<>();

        for (Listing listing : allListings) {
            // Some filtering action
            // If param is given, check if listing meets the asked criteria
            if ((minPrice.isEmpty() || minPrice.get() <= listing.getPrice())
                    && (maxPrice.isEmpty() || maxPrice.get() >= listing.getPrice())
                    && (category.isEmpty() || category.get().equals(listing.getCategory()))
                    && (offersDelivery.isEmpty() || offersDelivery.get() == listing.isOffersDelivery())
                    && (isReserved.isEmpty() || isReserved.get() == listing.isReserved())
                    && (location.isEmpty()
                        || location.get().isBlank()
                        || location.get().equals(listing.getLocation()))
                    && (userID.isEmpty() || userID.get().equals(listing.getUserID()))
                    && (searchString.isEmpty() || searchString.get().isBlank()
                        || listing.getTitle().toLowerCase().contains(searchString.get().toLowerCase())
                        || listing.getDescription().toLowerCase().contains(searchString.get().toLowerCase()))) {

                listings.add(listing);
            }
        }

        return ResponseEntity.ok(listings);
    }

    /**
     * Creates a new listing
     * @return 200 - listing created, 401 - user doesn't exist HTTP status code
     */
    @PostMapping("/listings")
    ResponseEntity<?> newListing(
            @RequestParam("title") String title,
            @RequestParam("price") Double price,
            @RequestParam("category") Category category,
            @RequestParam("offersDelivery") boolean offersDelivery,
            @RequestParam("description") String description,
            @RequestParam("isReserved") boolean isReserved,
            @RequestParam("user_id") Long userID,
            @RequestParam("location") String location,
            @RequestParam("token") String token,
            @RequestParam("images") List<MultipartFile> images) {


        Optional<User> optionalUser = userRepository.findById(userID);

        if (optionalUser.isEmpty() || !optionalUser.get().getToken().equals(token)) {
            return ResponseEntity.status(401).build();
        }

        repository.save(new Listing(title, price, category, offersDelivery,
                description, isReserved, userID, location, images));

        // Increment total listings counter of users
        User user = optionalUser.get();
        user.incrementTotalListings();
        userRepository.save(user);

        return ResponseEntity.ok().build();
    }

    /**
     * Deletes the listing by the given ID.
     * @return 200 - listing deleted, 401 - user isn't the owner, 404 - listing not found
     */
    @DeleteMapping("listings/{id}")
    ResponseEntity<?> deleteListing(@PathVariable Long id,
            @RequestParam("user_id") Long userID,
            @RequestParam("token") String token) {

        Optional<Listing> optionalListing = repository.findById(id);


        // True, if listing exists, else 404 HTTP Status Code
        if (optionalListing.isPresent()) {
            Long correctUserID = optionalListing.get().getUserID();

            // Get User Token
            Optional<User>  optionalUser = userRepository.findById(userID);

            // True, if user is owner of listing, else 401 HTTP Status Code
            if (correctUserID.equals(userID)
                    && (optionalUser.isPresent() && optionalUser.get().getToken().equals(token))) {
                repository.deleteById(id);
                return ResponseEntity.ok().build();
            }
            else {
                return ResponseEntity.status(401).build();
            }
        }

        return ResponseEntity.notFound().build();

    }

    /**
     * Updates listing by the given ID.
     * @return 200 - listing updated, 401 - user isn't the owner, 404 - listing not found
     */
    @PutMapping("listings/{id}")
    ResponseEntity<?> updateListing(
            @PathVariable Long id,
            @RequestParam("title") String title,
            @RequestParam("price") Double price,
            @RequestParam("category") Category category,
            @RequestParam("offersDelivery") boolean offersDelivery,
            @RequestParam("description") String description,
            @RequestParam("isReserved") boolean isReserved,
            @RequestParam("user_id") Long userID,
            @RequestParam("location") String location,
            @RequestParam("token") String token,
            @RequestParam("images") List<MultipartFile> images) {

        Optional<Listing> optionalListing = repository.findById(id);

        // True, if listing exists, else 404 HTTP Status Code
        if (optionalListing.isPresent()) {
            Listing listing = optionalListing.get();

            Long correctUserID = listing.getUserID();

             // Get User Token
            Optional<User>  optionalUser = userRepository.findById(userID);

            // True, if user is owner of listing, else 401 HTTP Status Code
            if (correctUserID.equals(userID)
                    && (optionalUser.isPresent() && optionalUser.get().getToken().equals(token))) {
                repository.save(new Listing(id, title, price, category, offersDelivery,
                        description, isReserved, correctUserID, location, images));

                return ResponseEntity.ok().build();
            }
            else {
                return ResponseEntity.status(401).build();
            }
        }

        return ResponseEntity.notFound().build();
    }

    @PatchMapping("listings/{id}")
    ResponseEntity<?> patchListing(
            @PathVariable Long id,
            @RequestParam("token") String token,
            @RequestParam("user_id") Long userID,
            @RequestParam("title") Optional<String> title,
            @RequestParam("price") Optional<Double> price,
            @RequestParam("category") Optional<Category> category,
            @RequestParam("offersDelivery") Optional<Boolean> offersDelivery,
            @RequestParam("description") Optional<String> description,
            @RequestParam("isReserved") Optional<Boolean> isReserved,
            @RequestParam("location") Optional<String> location,
            @RequestParam("images") Optional<List<MultipartFile>> images
    ) {

        Optional<Listing> optionalListing = repository.findById(id);

        // True, if listing exists, else 404 HTTP Status Code
        if (optionalListing.isPresent()) {
            Listing listing = optionalListing.get();

            Long correctUserID = listing.getUserID();

             // Get User Token
            Optional<User>  optionalUser = userRepository.findById(userID);

            // True, if user is owner of listing, else 401 HTTP Status Code
            if (correctUserID.equals(userID)
                    && (optionalUser.isPresent() && optionalUser.get().getToken().equals(token))) {

                title.ifPresent(listing::setTitle);
                price.ifPresent(listing::setPrice);
                category.ifPresent(listing::setCategory);
                offersDelivery.ifPresent(listing::setOffersDelivery);
                description.ifPresent(listing::setDescription);
                isReserved.ifPresent(listing::setReserved);
                location.ifPresent(listing::setLocation);
                images.ifPresent(listing::setImages);

                repository.save(listing);


                return ResponseEntity.status(204).build();
            }
            else {
                return ResponseEntity.status(401).build();
            }
        }

        return ResponseEntity.notFound().build();
    }

}
