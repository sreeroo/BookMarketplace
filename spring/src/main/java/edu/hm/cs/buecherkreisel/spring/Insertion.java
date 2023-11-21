package edu.hm.cs.buecherkreisel.spring;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import java.util.Objects;

@Entity
class Insertion {

    private @Id
    @GeneratedValue Long id;

    private String title;
    private Double price;
    private Category category;
    private boolean offersDelivery;
    private String description;
    private boolean isReserved;

    // TODO Bilder Attribut

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public boolean offersDelivery() {
        return offersDelivery;
    }

    public void setOffersDelivery(boolean offersDelivery) {
        this.offersDelivery = offersDelivery;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isReserved() {
        return isReserved;
    }

    public void setReserved(boolean reserved) {
        isReserved = reserved;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        // TODO Bilder hinzufügen
        Insertion insertion = (Insertion) o;
        return offersDelivery == insertion.offersDelivery && isReserved == insertion.isReserved
                && Objects.equals(id, insertion.id) && Objects.equals(title,
                insertion.title) && Objects.equals(price, insertion.price)
                && category == insertion.category && Objects.equals(description,
                insertion.description);
    }

    @Override
    public int hashCode() {
        // TODO Bilder hinzufügen
        return Objects.hash(id, title, price, category, offersDelivery, description, isReserved);
    }

    @Override
    public String toString() {
        // TODO Bilder hinzufügen
        return "Insertion{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", price=" + price +
                ", category=" + category +
                ", offersDelivery=" + offersDelivery +
                ", description='" + description + '\'' +
                ", isReserved=" + isReserved +
                '}';
    }
}
