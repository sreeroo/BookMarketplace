package edu.hm.cs.buecherkreisel.spring;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private static final String TOKEN_BODY_TEMPLATE = "{\"token\":\"%s\"}";

    @Autowired
    UserRepository repo;

    @BeforeEach
    void setup() {
        repo.deleteAll();
    }


    /*
     * Erstellt Standardbenutzer zum Testen namens Tom mit Passwort test123
     */
    private MvcResult createTom() throws Exception {
        String body = "{\"username\":\"Tom\", \"password\":\"test123\"}";
        return mockMvc.perform(MockMvcRequestBuilders.post("/users/create")
                        .content(body)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andDo(print())
                .andReturn();
    }

    @Test
    public void testCreateUser() throws Exception {
        String body = "{\"username\":\"Bob\", \"password\":\"test123\"}";
        mockMvc.perform(MockMvcRequestBuilders.post("/users/create")
                .content(body)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.token").exists())
                .andDo(print());
    }

    @Test
    public void testCreateUserConflict() throws Exception {
        String body = "{\"username\":\"Tom\", \"password\":\"test123\"}";
        createTom();

        // Try to create new user with same username
        mockMvc.perform(MockMvcRequestBuilders.post("/users/create")
                        .content(body)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isConflict())
                .andDo(print());
    }

    @Test
    public void testLogin() throws Exception {
        String body = "{\"username\":\"Tom\", \"password\":\"test123\"}";
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        String id = jsonNode.get("id").asText();

        // Try to log in
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                    .content(body)
                    .contentType(MediaType.APPLICATION_JSON)
                    .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.token").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(id))
                .andExpect(MockMvcResultMatchers.jsonPath("$.token").value(token))
                .andDo(print());
    }

    @Test
    public void testLoginUnauthorized() throws Exception {
        createTom();

        String body = "{\"username\":\"Tom\", \"password\":\"test321\"}";
        // Try to log in with false credentials
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                        .content(body)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }

    @Test
    public void testLoginNotFound() throws Exception {
        String body = "{\"username\":\"Tom\", \"password\":\"test321\"}";
        // Try to log in to non-existent user
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                        .content(body)
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testGetUser() throws Exception {
        // Create new user
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        // Try to get all available data
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}", id)
                        .content(String.format(TOKEN_BODY_TEMPLATE, token))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").value("Tom"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").value(""))
                .andExpect(MockMvcResultMatchers.jsonPath("$.liked_listings").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.liked_listings").value("[]"))
                .andDo(print());
    }

    @Test
    public void testGetUserUnauthorized() throws Exception{
        // Create new user
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        // Try to get all available data with false credentials
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}", id)
                    .content(String.format(TOKEN_BODY_TEMPLATE, "falseToken"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void testGetUserNotFound() throws Exception {
        // Try to get data for non-existent user
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}", 1)
                        .content(String.format(TOKEN_BODY_TEMPLATE, "falseToken"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testGetUserPublic() throws Exception {
        // Create new user
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        // Get publicly available data
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}/public", id)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").value("Tom"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").value(""))
                .andExpect(MockMvcResultMatchers.jsonPath("$.liked_listings").doesNotExist())
                .andDo(print());
    }

    @Test
    public void testGetUserPublicNotFound() throws Exception {
        // Try to get public data of non-existent user
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}/public", 1)
                        .content("123")
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testEditLikes() throws Exception {
        // create new user
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        List<String> listOfLikes = new ArrayList<>();
        listOfLikes.add(String.valueOf(2));
        listOfLikes.add(String.valueOf(3));
        listOfLikes.add(String.valueOf(24));

        Map<String, String> content = new HashMap<>();
        content.put("token", token);
        content.put("liked_listings", listOfLikes.toString());

        // Try to edit the likes
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_likes/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(content))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent())
                .andDo(print());

        // Verify that likes were edited
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}", id)
                        .content(String.format(TOKEN_BODY_TEMPLATE, token))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").value("Tom"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").value(""))
                .andExpect(MockMvcResultMatchers.jsonPath("$.liked_listings").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.liked_listings").value("[2, 3, 24]"))
                .andDo(print());
    }

    @Test
    public void testEditLikesUnauthorized() throws Exception {
        //Create new user
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        List<String> listOfLikes = new ArrayList<>();
        listOfLikes.add(String.valueOf(2));
        listOfLikes.add(String.valueOf(3));
        listOfLikes.add(String.valueOf(24));

        Map<String, String> content = new HashMap<>();
        content.put("token", "FalscherToken");
        content.put("liked_listings", listOfLikes.toString());

        // Try to edit likes with false credentials
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_likes/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(content))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }

    @Test
    public void testEditLikesNotFound() throws Exception {
        // Try to edit likes of non-existent user
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_likes/{id}", 23)
                        .content(new ObjectMapper().writeValueAsString(new HashMap<>()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testEditAuth() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editAuthBody = new HashMap<>();
        editAuthBody.put("token", token);
        editAuthBody.put("old_password", "test123");
        editAuthBody.put("new_password", "newTest123");

        // Try to edit credentials
        MvcResult nextResult = mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_auth/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editAuthBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andDo(print())
                .andReturn();

        String response = nextResult.getResponse().getContentAsString();
        jsonNode = new ObjectMapper().readTree(response);
        assertNotEquals(jsonNode.get("token").asText(), token);

        // Verify that the password has been updated
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                        .content("{\"username\":\"Tom\", \"password\":\"newTest123\"}")
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(jsonPath("$.token").exists())
                .andDo(print());
    }

    @Test
    public void testEditAuthUnauthorized() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editAuthBody = new HashMap<>();
        editAuthBody.put("token", "InvalidToken");
        editAuthBody.put("old_password", "test123");
        editAuthBody.put("new_password", "newTest123");

        // Try to edit credentials with false credentials
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_auth/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editAuthBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }


    @Test
    public void testEditAuthNotFound() throws Exception {
        Map<String, String> editAuthBody = new HashMap<>();
        editAuthBody.put("token", "InvalidToken");
        editAuthBody.put("old_password", "test123");
        editAuthBody.put("new_password", "newTest123");

        // Try to edit credentials of non-existent user
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_auth/{id}", 23)
                        .content(new ObjectMapper().writeValueAsString(editAuthBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testEditAlias() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editAliasBody = new HashMap<>();
        editAliasBody.put("token", token);
        editAliasBody.put("new_alias", "NewTom");

        // Try to edit alias
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_alias/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editAliasBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent())
                .andDo(print());

        // Verify that alias has been updated
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}/public", id)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").value("NewTom"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").value(""))
                .andDo(print());
    }

    @Test
    public void testEditAliasUnauthorized() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editAliasBody = new HashMap<>();
        editAliasBody.put("token", "InvalidToken");
        editAliasBody.put("new_alias", "NewTom");

        // Try to edit alias using false credentials
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_alias/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editAliasBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }

    @Test
    public void testEditAliasNotFound() throws Exception {
        Map<String, String> editAliasBody = new HashMap<>();
        editAliasBody.put("token", "InvalidToken");
        editAliasBody.put("new_alias", "NewTom");

        // Try to edit alias of non-existent user
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_alias/{id}", 23)
                        .content(new ObjectMapper().writeValueAsString(editAliasBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testEditPicture() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editPictureBody = new HashMap<>();
        editPictureBody.put("token", token);
        editPictureBody.put("new_picture", "newProfilePicBaseString");

        // Try to edit pic
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_pic/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editPictureBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent())
                .andDo(print());

        // Verify that pic has been updated
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}/public", id)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(String.valueOf(id)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.username").value("Tom"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").exists())
                .andExpect(MockMvcResultMatchers.jsonPath("$.profile_picture").value("newProfilePicBaseString"))
                .andDo(print());
    }

    @Test
    public void testEditPictureUnauthorized() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        Map<String, String> editPictureBody = new HashMap<>();
        editPictureBody.put("token", "InvalidToken");
        editPictureBody.put("new_picture", "newProfilePic.jpg");

        // Try to edit pic using false credentials
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_pic/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(editPictureBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }

    @Test
    public void testEditPictureNotFound() throws Exception {
        Map<String, String> editPictureBody = new HashMap<>();
        editPictureBody.put("token", "InvalidToken");
        editPictureBody.put("new_picture", "newProfilePic.jpg");

        // Try to edit pic of non-existent user
        mockMvc.perform(MockMvcRequestBuilders.patch("/users/edit_pic/{id}", 23)
                        .content(new ObjectMapper().writeValueAsString(editPictureBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testDeleteUser() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        String token = jsonNode.get("token").asText();
        Long id = jsonNode.get("id").asLong();

        Map<String, String> deleteUserBody = new HashMap<>();
        deleteUserBody.put("token", token);
        deleteUserBody.put("password", "test123");

        // Try to delete user
        mockMvc.perform(MockMvcRequestBuilders.delete("/users/delete/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(deleteUserBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent())
                .andDo(print());

        // Verify that the user has been deleted
        mockMvc.perform(MockMvcRequestBuilders.get("/users/{id}", id)
                        .content(String.format(TOKEN_BODY_TEMPLATE, token))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }

    @Test
    public void testDeleteUserUnauthorized() throws Exception {
        MvcResult result = createTom();

        String jsonResponse = result.getResponse().getContentAsString();
        JsonNode jsonNode = new ObjectMapper().readTree(jsonResponse);
        Long id = jsonNode.get("id").asLong();

        Map<String, String> deleteUserBody = new HashMap<>();
        deleteUserBody.put("token", "InvalidToken");
        deleteUserBody.put("password", "test123");

        // Try to delete user using false credentials
        mockMvc.perform(MockMvcRequestBuilders.delete("/users/delete/{id}", id)
                        .content(new ObjectMapper().writeValueAsString(deleteUserBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andDo(print());
    }

    @Test
    public void testDeleteUserNotFound() throws Exception {
        Map<String, String> deleteUserBody = new HashMap<>();
        deleteUserBody.put("token", "InvalidToken");
        deleteUserBody.put("password", "test123");

        // Try to delete non-existent user
        mockMvc.perform(MockMvcRequestBuilders.delete("/users/delete/{id}", 23)
                        .content(new ObjectMapper().writeValueAsString(deleteUserBody))
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andDo(print());
    }
}
