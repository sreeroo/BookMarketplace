package edu.hm.cs.buecherkreisel.spring;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
class ListingController {

    private final ListingRepository repository;

    ListingController(ListingRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/listings")
    ResponseEntity<List<Listing>> allListings() {
        return ResponseEntity.ok(repository.findAll());
    }

    @GetMapping("/listings/search")
    ResponseEntity<List<Listing>> filterListings(
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
            @RequestParam("images") List<MultipartFile> images) {

        // TODO überprüfen ob UserID existiert - Error 401

        repository.save(new Listing(title, price, category, offersDelivery,
                description, isReserved, userID, location, images));

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("listings/{id}")
    ResponseEntity<?> deleteListing(@PathVariable Long id, @RequestParam("user_id") Long userID) {

        Optional<Listing> optionalListing = repository.findById(id);

        if (optionalListing.isPresent()) {
            Long correctUserID = optionalListing.get().getUserID();

            if (correctUserID.equals(userID)) {
                repository.deleteById(id);
                return ResponseEntity.ok().build();
            }
            else {
                return ResponseEntity.status(401).build();
            }
        }

        return ResponseEntity.notFound().build();

    }

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
            @RequestParam("images") List<MultipartFile> images) {

        Optional<Listing> optionalListing = repository.findById(id);

        if (optionalListing.isPresent()) {
            Listing listing = optionalListing.get();

            Long correctUserID = listing.getUserID();

            if (correctUserID.equals(userID)) {
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

}
