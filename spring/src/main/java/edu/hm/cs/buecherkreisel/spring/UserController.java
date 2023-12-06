package edu.hm.cs.buecherkreisel.spring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@RestController
public class UserController {

    @Autowired
    private UserRepository repository;

    @GetMapping("/users/{id}")
    Map<String, String> getUser(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            if(Objects.equals(user.getToken(), body.get("token"))) {
                Map<String, String> answer = new HashMap<>();
                answer.put("id", String.valueOf(user.getId()));
                answer.put("username", user.getUsername());
                answer.put("profile_picture", user.getProfilePicture());
                answer.put("liked_listings", user.getLikedListings().toString());
                return answer;
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/users/{id}/public")
    Map<String, String> getUserPublic(@PathVariable long id) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            Map<String, String> userElements = new HashMap<>();
            userElements.put("id", String.valueOf(user.getId()));
            userElements.put("username",user.getUsername());
            userElements.put("profile_picture",user.getProfilePicture());
            return userElements;
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @PostMapping("/users/create")
    Map<String, String> createUser(@RequestBody Map<String, String> body) {
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
        return answer;
    }

    @PostMapping("/login")
    Map<String, String> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        for(User user : repository.findAll()) {
            if(user.getUsername().equals(username)) {
                if(user.getPassword().equals(password)){
                    Map<String, String> answer = new HashMap<>();
                    answer.put("id", String.valueOf(user.getId()));
                    answer.put("token", user.getToken());
                    return answer;
                } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @PutMapping("/users/edit_likes/{id}")
    void editLikes(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)) {
                String listOfLikesString = body.get("liked_listings");
                String[] stringArray = listOfLikesString.replaceAll("[\\[\\]\"]", "").split(", ");
                List<Long> listOfLikes = new ArrayList<>();
                for (String str : stringArray) {
                    listOfLikes.add(Long.parseLong(str));
                }
                user.setLikedListings(listOfLikes);
                repository.save(user);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @PutMapping("/users/edit_auth/{id}")
    Map<String, String> editAuth(@PathVariable long id, @RequestBody Map<String, String> body) {
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
                return response;
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @PutMapping("/users/edit_alias/{id}")
    void editAlias(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)){
                user.setUsername(body.get("new_alias"));
                repository.save(user);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @PutMapping("/users/edit_pic/{id}")
    void editPicture(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            if(user.getToken().equals(token)) {
                user.setProfilePicture(body.get("new_picture"));
                repository.save(user);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/users/delete/{id}")
    void deleteUser(@PathVariable long id, @RequestBody Map<String, String> body) {
        Optional<User> userCheck = repository.findById(id);
        if(userCheck.isPresent()) {
            User user = userCheck.get();
            String token = body.get("token");
            String password = body.get("password");
            if(user.getToken().equals(token) && user.getPassword().equals(password)) {
                repository.deleteById(id);
            } else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        } else throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }
}
