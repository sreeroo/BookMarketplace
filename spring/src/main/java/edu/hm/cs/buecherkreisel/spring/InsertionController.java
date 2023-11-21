package edu.hm.cs.buecherkreisel.spring;

import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InsertionController {

    private final InsertionRepository repository;

    InsertionController(InsertionRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/insertions")
    List<Insertion> allInsertions() {
        return repository.findAll();
    }

    @PostMapping("/insertions")
    Insertion newInsertion(@RequestBody Insertion newInsertion) {
        return repository.save(newInsertion);
    }

    @DeleteMapping("insertions/{id}")
    ResponseEntity<?> deleteInsertion(@PathVariable Long id) {
        repository.deleteById(id);

        return ResponseEntity.noContent().build();
    }

    @PutMapping("insertions/{id}")
    Insertion updateInsertion(@RequestBody Insertion updateInsertion, @PathVariable Long id) {
        return repository.findById(id)
                .map(insertion -> {
                    updateInsertion.setTitle(updateInsertion.getTitle());
                    updateInsertion.setPrice(updateInsertion.getPrice());
                    updateInsertion.setCategory(updateInsertion.getCategory());
                    updateInsertion.setOffersDelivery(updateInsertion.offersDelivery());
                    updateInsertion.setDescription(updateInsertion.getDescription());
                    updateInsertion.setReserved(updateInsertion.isReserved());
                    return repository.save(insertion);
                })
                .orElseGet(() -> {
                    updateInsertion.setId(id);
                    return repository.save(updateInsertion);
                });
    }

}
