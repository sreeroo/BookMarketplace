package edu.hm.cs.buecherkreisel.spring;

import org.springframework.data.jpa.repository.JpaRepository;

interface UserRepository extends JpaRepository<User, Long> {
}
