package edu.hm.cs.buecherkreisel.spring;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.web.multipart.MultipartFile;

@SpringBootTest
@AutoConfigureMockMvc
class ListingControllerTest {

    @Autowired
    MockMvc mockMvc;

    @Autowired
    private ListingRepository listingRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    public void testCreateListing() throws Exception {

        User user = userRepository.save(
                new User("Nutzername", "Password", "Profilbild"));

        mockMvc.perform(MockMvcRequestBuilders
                        .multipart("/listings")
                        .file("images", "Bilder".getBytes())
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
    public void testGetListing() throws Exception {

        // TODO Body überprüfen

        mockMvc.perform(MockMvcRequestBuilders.get("/listings"))
                .andDo(print())
                .andExpect(status().isOk());
    }

}