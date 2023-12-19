package edu.hm.cs.buecherkreisel.spring;

public enum Category {
    INFORMATIK("Informatik"),
    MASCHINENBAU("Maschinenbau"),
    ELEKTROTECHNIK("Elektrotechnik"),
    MATHEMATIK("Mathematik"),
    PHYSIK("Physik"),
    WIRTSCHAFT("Wirtschaft"),
    POLITIK("Politik"),
    SONSTIGES("Sonstiges");

    public final String category;


    Category(String category) {
        this.category = category;
    }
}
