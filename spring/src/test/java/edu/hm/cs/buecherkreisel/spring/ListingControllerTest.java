package edu.hm.cs.buecherkreisel.spring;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.web.multipart.MultipartFile;

@SpringBootTest
@AutoConfigureMockMvc
class ListingControllerTest {

    @Autowired
    MockMvc mockMvc;

    @Autowired
    ListingRepository repository;

    @BeforeEach
    void setup() {
        repository.deleteAll();
    }

    private MvcResult createListing() throws Exception {
        return mockMvc.perform(MockMvcRequestBuilders.post("/listings")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .content(EntityUtils.toString(new UrlEncodedFormEntity(Arrays.asList(
                        new BasicNameValuePair("title", "Titel"),
                        new BasicNameValuePair("description", "Beschreibung")
                )))))
                .andDo(print())
                .andExpect(status().isOk())
                .andReturn();
    }

    @Test
    public void testCreateListing() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.multipart("/listings")
                .file(new MockMultipartFile("TestName", "TestImage".getBytes()))
                .param("title", "Titel")
                                .param("price", "29.99")
                                .param("category", "INFORMATIK")
                                .param("offersDelivery", "true")
                                .param("description", "Beschreibung")
                                .param("isReserved", "false")
                                .param("user_id", "1")
                )
                .andDo(print())
                .andExpect(status().isOk());
    }

    @Test
    public void testGetListing() throws Exception {

        // TODO Body überprüfen

        mockMvc.perform(MockMvcRequestBuilders.get("/listings"))
                .andDo(print())
                .andExpect(status().isOk());
    }

    /*
    @Test
    public void testCreateListing() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/listing")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .content(EntityUtils.toString(new UrlEncodedFormEntity(Arrays.asList(
                        new BasicNameValuePair("title", "Titel"),
                        new BasicNameValuePair("price", "29.99"),
                        new BasicNameValuePair("category", "INFORMATIK"),
                        new BasicNameValuePair("offersDelivery", "true"),
                        new BasicNameValuePair("description", "Beschreibung"),
                        new BasicNameValuePair("isReserved", "false"),
                        new BasicNameValuePair("user_id", "1"),
                        new BasicNameValuePair("images", )
                )))))
                .andDo(print())
                .andExpect(status().isOk());
    }
     */

}