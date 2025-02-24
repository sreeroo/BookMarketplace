package edu.hm.cs.buecherkreisel.spring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@RestController
public class UserController {

    @Autowired
    private UserRepository repository;

    @Autowired
    ListingRepository listRepo;

    /**
     * Retrieves user information based on the provided ID and token.
     *
     * @param id   The ID of the user to retrieve.
     * @param token String containing the user token for authentication.
     * @return ResponseEntity containing user information if successful, or an error response.
     */
    @GetMapping("/users/{id}")
    ResponseEntity<Map<String, String>> getUser(@PathVariable long id, @RequestParam("token") String token) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            if(Objects.equals(user.getToken(), token)) {
                Map<String, String> answer = new HashMap<>();
                answer.put("id", String.valueOf(user.getId()));
                answer.put("username", user.getUsername());
                answer.put("profile_picture", user.getProfilePicture());
                answer.put("liked_listings", user.getLikedListings().toString());
                answer.put("total_listings", Integer.toString(user.getTotalListings()));
                return new ResponseEntity<>(answer, HttpStatus.OK);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    /**
     * Retrieves public user information based on the provided ID.
     *
     * @param id The ID of the user to retrieve public information for.
     * @return ResponseEntity containing public user information if successful, or an error response.
     */
    @GetMapping("/users/{id}/public")
    ResponseEntity<Map<String, String>> getUserPublic(@PathVariable long id) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            Map<String, String> userElements = new HashMap<>();
            userElements.put("id", String.valueOf(user.getId()));
            userElements.put("username",user.getUsername());
            userElements.put("profile_picture",user.getProfilePicture());
            userElements.put("total_listings", Integer.toString(user.getTotalListings()));
            return new ResponseEntity<>(userElements, HttpStatus.OK);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Creates a new user with the provided username and password.
     *
     * @param body Map containing the username and password for the new user.
     * @return ResponseEntity containing the ID and token of the created user if successful, or an error response.
     */
    @PostMapping("/users/create")
    ResponseEntity<Map<String, String>> createUser(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        if(repository.findAll().stream()
                .anyMatch(user -> Objects.equals(user.getUsername(), username))) {
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        }
        String password = body.get("password");
        User user = repository.save(new User(username, password, ""));
        Map<String, String> answer = new HashMap<>();
        answer.put("id", String.valueOf(user.getId()));
        answer.put("token", user.getToken());
        return new ResponseEntity<>(answer, HttpStatus.CREATED);
    }

    /**
     * Authenticates a user based on the provided username and password.
     *
     * @param body Map containing the username and password for user authentication.
     * @return ResponseEntity containing the ID and token of the authenticated user if successful, or an error response.
     */
    @PostMapping("/login")
    ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        for(User user : repository.findAll()) {
            if(user.getUsername().equals(username)) {
                if(user.getPassword().equals(password)){
                    Map<String, String> answer = new HashMap<>();
                    answer.put("id", String.valueOf(user.getId()));
                    answer.put("token", user.getToken());
                    return new ResponseEntity<>(answer, HttpStatus.OK);
                } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Updates the liked listings of a user based on the provided token.
     *
     * @param id   The ID of the user to update.
     * @param body Map containing the user token and updated liked listings.
     * @return ResponseEntity indicating success or an error response.
     */
    @PatchMapping("/users/edit_likes/{id}")
    ResponseEntity<?> editLikes(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)) {
                String listOfLikesString = body.get("liked_listings");
                String[] stringArray = listOfLikesString.replaceAll("[\\[\\]\"]", "").split(", ");
                List<Long> listOfLikes = new ArrayList<>();
                for (String str : stringArray) {
                    if(!str.isEmpty())
                        listOfLikes.add(Long.parseLong(str));
                }
                user.setLikedListings(listOfLikes);
                repository.save(user);
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Updates the authentication details of a user based on the provided token.
     *
     * @param id   The ID of the user to update.
     * @param body Map containing the user token, old password, and new password.
     * @return ResponseEntity containing the updated token if successful, or an error response.
     */
    @PatchMapping("/users/edit_auth/{id}")
    ResponseEntity<Map<String, String>> editAuth(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String oldPassword = body.get("old_password");
            String token = body.get("token");
            if(user.getToken().equals(token) && user.getPassword().equals(oldPassword)) {
                user.setPassword(body.get("new_password"));
                user.updateToken();
                repository.save(user);
                Map<String,String> response = new HashMap<>();
                response.put("token", user.getToken());
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Updates the username of a user based on the provided token.
     *
     * @param id   The ID of the user to update.
     * @param body Map containing the user token and new username.
     * @return ResponseEntity indicating success or an error response.
     */
    @PatchMapping("/users/edit_alias/{id}")
    ResponseEntity<?> editAlias(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)){
                user.setUsername(body.get("new_alias"));
                repository.save(user);
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Updates the profile picture URL of a user based on the provided token.
     *
     * @param id   The ID of the user to update.
     * @param body Map containing the user token and new profile picture URL.
     * @return ResponseEntity indicating success or an error response.
     */
    @PatchMapping("/users/edit_pic/{id}")
    ResponseEntity<?> editPicture(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)) {
                user.setProfilePicture(body.get("new_picture"));
                repository.save(user);
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    /**
     * Deletes a user and associated listings based on the provided token and password.
     *
     * @param id   The ID of the user to delete.
     * @param body Map containing the user token and password for deletion authentication.
     * @return ResponseEntity indicating success or an error response.
     */
    @DeleteMapping("/users/delete/{id}")
    ResponseEntity<?> deleteUser(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            String password = body.get("password");
            if(user.getToken().equals(token) && user.getPassword().equals(password)) {
                repository.deleteById(id);
                List<Listing> userListings = listRepo.findAll().stream()
                        .filter(listing -> listing.getUserID().equals(id)).toList();
                userListings.forEach(listing -> listRepo.deleteById(listing.getId()));
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }
}
