package edu.hm.cs.buecherkreisel.spring;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Base64;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.ApplicationContext;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@SpringBootTest
@AutoConfigureMockMvc
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

    @Test
    public void testCreateListing() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

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
                        .param("token", user.getToken())
                ).andExpect(status().isOk());
    }

    @Test
    public void testCreateListingUserNotFound() throws Exception {

        UserRepository userRepository = context.getBean(UserRepository.class);

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

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
                        .param("token", user.getToken())
                ).andExpect(status().is(401));
    }

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
                        .param("token", user.getToken())
                ).andReturn();
    }

    @Test
    public void testGetListing() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        MvcResult mvcResult = createListing(user);
        if (mvcResult.getResponse().getStatus() != 200) {
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
                .andExpect(jsonPath("$[0].images").exists())
                .andExpect(jsonPath("$[0].images[0]").value("Bild"));

    }

}