package edu.hm.cs.buecherkreisel.spring;

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
class InsertionController {

    private final InsertionRepository repository;

    InsertionController(InsertionRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/insertions")
    ResponseEntity<List<Insertion>> allInsertions() {
        return ResponseEntity.ok(repository.findAll());
    }

    /*@GetMapping("/insertions/{id}/images")
    ResponseEntity<Set<Image>> getPicturesByID(@PathVariable Long id) {
        Optional<Insertion> optionalInsertion = repository.findById(id);
        if (optionalInsertion.isPresent()) {
            Set<Image> images = optionalInsertion.get().getImages();
            return ResponseEntity.ok(images);
        }
        else {
            return ResponseEntity.notFound().build();
        }
    }*/

    @PostMapping("/insertions")
    ResponseEntity<?> newInsertion(@RequestParam("title") String title,
        @RequestParam("price") Double price,
        @RequestParam("category") Category category,
        @RequestParam("offersDelivery") boolean offersDelivery,
        @RequestParam("description") String description,
        @RequestParam("isReserved") boolean isReserved,
        @RequestParam("user_id") Long userID,
        @RequestParam("images") List<MultipartFile> images) {

        // TODO überprüfen ob UserID existiert - Error 401

        repository.save(new Insertion(title, price, category, offersDelivery,
                description, isReserved, userID, images));

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("insertions/{id}")
    ResponseEntity<?> deleteInsertion(@PathVariable Long id, @RequestParam("user_id") Long userID) {

        Optional<Insertion> optionalInsertion = repository.findById(id);

        if (optionalInsertion.isPresent()) {
            Long correctUserID = optionalInsertion.get().getUserID();

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

    @PutMapping("insertions/{id}")
    ResponseEntity<?> updateInsertion(@PathVariable Long id,
            @RequestParam("title") String title,
            @RequestParam("price") Double price,
            @RequestParam("category") Category category,
            @RequestParam("offersDelivery") boolean offersDelivery,
            @RequestParam("description") String description,
            @RequestParam("isReserved") boolean isReserved,
            @RequestParam("user_id") Long userID,
            @RequestParam("images") List<MultipartFile> images) {

        Optional<Insertion> optionalInsertion = repository.findById(id);

        if (optionalInsertion.isPresent()) {
            Insertion insertion = optionalInsertion.get();

            Long correctUserID = insertion.getUserID();

            if (correctUserID.equals(userID)) {
                repository.save(new Insertion(id, title, price, category, offersDelivery,
                        description, isReserved, correctUserID, images));

                return ResponseEntity.ok().build();
            }
            else {
                return ResponseEntity.status(401).build();
            }
        }

        return ResponseEntity.notFound().build();
    }

}
