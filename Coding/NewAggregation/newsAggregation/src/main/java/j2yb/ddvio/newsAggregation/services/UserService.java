package j2yb.ddvio.newsAggregation.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import j2yb.ddvio.newsAggregation.entities.User;
import j2yb.ddvio.newsAggregation.repositories.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User register(User user) {
        return userRepository.save(user);
    }

    public User login(User userRequest) {
        User user = userRepository.findByUsernameAndPassword(userRequest.getUsername(), userRequest.getPassword());
        if (user != null) {
            return user;
        }
        return null;
    }
}