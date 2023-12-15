package edu.hm.cs.buecherkreisel.spring;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Base64;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.http.MediaType;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMultipartHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@SpringBootTest
@AutoConfigureMockMvc
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
class ListingControllerTest {

    @Autowired
    MockMvc mockMvc;

    @Autowired
    ApplicationContext context;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    public void setup() {
        userRepository.deleteAll();
    }

    /**
     * Test for creating a new listing
     */
    @Test
    public void testNewListing() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        // Wrong user id, throw 401 Status Code
        mockMvc.perform(MockMvcRequestBuilders
                        .multipart("/listings")
                        .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "Titel")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", "2")
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                ).andExpect(status().is(401));

        // All correct
        mockMvc.perform(MockMvcRequestBuilders
                        .multipart("/listings")
                        .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "Titel")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", String.valueOf(user.getId()))
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                ).andExpect(status().isCreated());

        // Checks if listing was created correctly
        mockMvc.perform(MockMvcRequestBuilders.get("/listings")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(jsonPath("$[0].id").exists())
                .andExpect(jsonPath("$[0].id").value("1"))
                .andExpect(jsonPath("$[0].title").exists())
                .andExpect(jsonPath("$[0].title").value("Titel"))
                .andExpect(jsonPath("$[0].price").exists())
                .andExpect(jsonPath("$[0].price").value("29.99"));
    }

    /**
     * Helper method for creating listing
     * @param user User the listing belongs to
     * @return MvcResult
     */
    private MvcResult createListing(User user) throws Exception {
        return mockMvc.perform(MockMvcRequestBuilders
                        .multipart("/listings")
                        .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "Titel")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", String.valueOf(user.getId()))
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                ).andReturn();
    }

    /**
     * Tests if Response of Get Request is correct
     */
    @Test
    public void testAllListings() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 201) {
            throw new RuntimeException("Unable to create Listing!");
        }

        mockMvc.perform(MockMvcRequestBuilders.get("/listings")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(jsonPath("$[0].id").exists())
                .andExpect(jsonPath("$[0].id").value("1"))
                .andExpect(jsonPath("$[0].title").exists())
                .andExpect(jsonPath("$[0].title").value("Titel"))
                .andExpect(jsonPath("$[0].price").exists())
                .andExpect(jsonPath("$[0].price").value("29.99"))
                .andExpect(jsonPath("$[0].category").exists())
                .andExpect(jsonPath("$[0].category").value("INFORMATIK"))
                .andExpect(jsonPath("$[0].offersDelivery").exists())
                .andExpect(jsonPath("$[0].offersDelivery").value("true"))
                .andExpect(jsonPath("$[0].description").exists())
                .andExpect(jsonPath("$[0].description").value("Beschreibung"))
                .andExpect(jsonPath("$[0].reserved").exists())
                .andExpect(jsonPath("$[0].reserved").value("false"))
                .andExpect(jsonPath("$[0].userID").exists())
                .andExpect(jsonPath("$[0].userID").value(user.getId()))
                .andExpect(jsonPath("$[0].location").exists())
                .andExpect(jsonPath("$[0].location").value("München"))
                .andExpect(jsonPath("$[0].contact").exists())
                .andExpect(jsonPath("$[0].contact").value("gregor@samsa.pl"))
                .andExpect(jsonPath("$[0].images").exists())
                .andExpect(jsonPath("$[0].images[0]").value("Bild"));
    }

    /**
     * Tests if Response of filtered Get Request is correct
     */
    @Test
    public void testFilterListing() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 201) {
            throw new RuntimeException("Unable to create Listing!");
        }

        mockMvc.perform(MockMvcRequestBuilders.get("/listings/search")
                .accept(MediaType.APPLICATION_JSON)
                .param("location", "München")
                .param("searchString", "Beschreibung"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0]").exists());
    }

    /**
     * Tests if listings are deleted correctly
     */
    @Test
    public void testDeleteListing() throws Exception {
        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 201) {
            throw new RuntimeException("Unable to create Listing!");
        }

        // Not existing id, throw 404 Status Code
        mockMvc.perform(MockMvcRequestBuilders.delete("/listings/2")
                .param("user_id", String.valueOf(user.getId()))
                .param("token", user.getToken()))
                .andExpect(status().isNotFound());

        // Wrong user id, throw 401 Status Code
        mockMvc.perform(MockMvcRequestBuilders.delete("/listings/1")
                .param("user_id", String.valueOf(user.getId()+1))
                .param("token", user.getToken()))
                .andExpect(status().is(401));

        // All correct
        mockMvc.perform(MockMvcRequestBuilders.delete("/listings/1")
                .param("user_id", String.valueOf(user.getId()))
                .param("token", user.getToken()))
                .andExpect(status().isNoContent());

        //Checks if listing was deleted correctly
        mockMvc.perform(MockMvcRequestBuilders.get("/listings")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(jsonPath("$").isEmpty());
    }

    /**
     * Helper method for creating PUT Builder
     * @param id ID of listing
     * @return MockMultipartHttpServletRequestBuilder of PUT Request
     */
    private MockMultipartHttpServletRequestBuilder createBuilder(Long id) {
        MockMultipartHttpServletRequestBuilder builder =
            MockMvcRequestBuilders.multipart("/listings/" + id);

        // Multipart does only support POST, so overwrite it with PUT
        builder.with(request -> {
            request.setMethod("PUT");
            return request;
        });

        return builder;
    }

    /**
     * Tests if listing is updated correctly
     */
    @Test
    public void testUpdateListing() throws Exception {
        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 201) {
            throw new RuntimeException("Unable to create Listing!");
        }

        // Check for wrong user id
        mockMvc.perform(createBuilder(1L)
                .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "UpdatedTitle")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", String.valueOf(user.getId()+1))
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                )
                .andExpect(status().is(401));

        // Check for wrong id - Listing should be created anyway
        mockMvc.perform(createBuilder(2L)
                .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "UpdatedTitle")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", String.valueOf(user.getId()))
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                )
                .andExpect(status().isCreated());

        // With correct parameters
        mockMvc.perform(createBuilder(1L)
                .file("images", Base64.getDecoder().decode("Bild"))
                        .param("title", "UpdatedTitle")
                        .param("price", "29.99")
                        .param("category", "INFORMATIK")
                        .param("offersDelivery", "true")
                        .param("description", "Beschreibung")
                        .param("isReserved", "false")
                        .param("user_id", String.valueOf(user.getId()))
                        .param("location", "München")
                        .param("contact", "gregor@samsa.pl")
                        .param("token", user.getToken())
                )
                .andExpect(status().isNoContent());


        // Check if values were updated correctly
        mockMvc.perform(MockMvcRequestBuilders.get("/listings")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").exists())
                .andExpect(jsonPath("$[0].id").exists())
                .andExpect(jsonPath("$[0].id").value("1"))
                .andExpect(jsonPath("$[0].title").exists())
                .andExpect(jsonPath("$[0].title").value("UpdatedTitle"))
                .andExpect(jsonPath("$[0].price").exists())
                .andExpect(jsonPath("$[0].price").value("29.99"));
    }

    @Test
    public void testPatchListing() throws Exception {
        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 201) {
            throw new RuntimeException("Unable to create Listing!");
        }

        // Check for wrong id
        mockMvc.perform(MockMvcRequestBuilders.patch("/listings/2")
                .param("user_id", String.valueOf(user.getId()))
                .param("token", user.getToken())
                .param("title", "PatchTitel"))
                .andExpect(status().isNotFound());

        //Check for wrong user id
        mockMvc.perform(MockMvcRequestBuilders.patch("/listings/1")
                .param("user_id", String.valueOf(user.getId() + 1))
                .param("token", user.getToken())
                .param("title", "PatchTitel"))
                .andExpect(status().is(401));

        // With correct parameters
        mockMvc.perform(MockMvcRequestBuilders.patch("/listings/1")
                .param("user_id", String.valueOf(user.getId()))
                .param("token", user.getToken())
                .param("title", "PatchTitel"))
                .andExpect(status().isNoContent());
    }

    /**
     * Tests if categories are returned correct
     */
    @Test
    public void testGetCategories() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/categories"))
                .andExpect(status().isOk());
    }
}