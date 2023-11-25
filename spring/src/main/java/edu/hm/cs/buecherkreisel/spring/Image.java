package edu.hm.cs.buecherkreisel.spring;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import java.util.Arrays;
import java.util.Objects;

@Entity
public class Image {

    private @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) Long id;

    @Lob
    private byte[] data;

    @ManyToOne
    @JoinColumn(name = "insertion_id")
    private Insertion insertion;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    @JsonIgnore
    public Insertion getInsertion() {
        return insertion;
    }

    @JsonIgnore
    public void setInsertion(Insertion insertion) {
        this.insertion = insertion;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Image image = (Image) o;
        return Arrays.equals(data, image.data) && Objects.equals(insertion,
                image.insertion);
    }

    @Override
    public int hashCode() {
        int result = Objects.hash(insertion);
        result = 31 * result + Arrays.hashCode(data);
        return result;
    }
}
