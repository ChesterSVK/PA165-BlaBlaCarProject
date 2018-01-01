package cz.fi.muni.pa165.teamred.controllers;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import cz.fi.muni.pa165.teamred.config.UserSession;
import cz.fi.muni.pa165.teamred.dto.PlaceDTO;
import cz.fi.muni.pa165.teamred.dto.UserCreateDTO;
import cz.fi.muni.pa165.teamred.dto.UserDTO;
import cz.fi.muni.pa165.teamred.facade.PlaceFacade;
import cz.fi.muni.pa165.teamred.facade.UserFacade;
import cz.fi.muni.pa165.teamred.models.PlaceForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by jcibik on 12/4/17.
 */
@Controller
@RequestMapping(value = "/")
public class WelcomeController {

    @Autowired
    private UserSession userSession;

    @Autowired
    private UserFacade userFacade;

    @Autowired
    private PlaceFacade placeFacade;

    @Autowired
    private UserSession session;

    private static final JacksonFactory jacksonFactory = new JacksonFactory();
    private static final HttpTransport transport = new NetHttpTransport();
    private static final String clientId = "332736943859-mrr2173fc1kseq1l2i4h0na68mnpmbp3.apps.googleusercontent.com";

    //matches all url "/*"
    @RequestMapping
    public String doWelcome(Model model){

        if(session.isUserIsLoggedIn()) {
            return "homepage";
        }
        //Return to view
        return "welcome";
    }

    @RequestMapping(value = "/tokensignin", method = RequestMethod.POST, consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String doTokenSignIn(@RequestParam Map<String,String> paramMap,
                                ModelMap modelMap,
                                RedirectAttributes redirectAttributes,
                                UriComponentsBuilder uriBuilder){

        if(paramMap == null && paramMap.get("idtoken") == null) {
            throw new IllegalArgumentException("Token not provided");
        }

        String token = paramMap.get("idtoken");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jacksonFactory)
                .setAudience(Collections.singletonList(clientId))
                .build();

        GoogleIdToken idToken = null;
        try {
            idToken = verifier.verify(token);
        } catch (GeneralSecurityException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "welcome";
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "welcome";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "welcome";
        }

        if (idToken == null) {
            redirectAttributes.addFlashAttribute("alert_warning", "Seems like you are here for the first time..." +
                    "We can not create an account for you now. Try again later, please.");
            return "welcome";
        }
        GoogleIdToken.Payload payload = idToken.getPayload();

        //Get login ID = Google User identifier
        String googleId = payload.getSubject();
        UserDTO foundUser = null;
        try{
            foundUser = userFacade.findUserByLoginId(googleId);
        }catch (NullPointerException e) {
            //this means that user is null
        }

        //Create new user in our app
        if(foundUser == null) {
            try {
                String email = payload.getEmail();
                String familyName = (String) payload.get("family_name");
                String givenName = (String) payload.get("given_name");

                UserCreateDTO newUser = new UserCreateDTO();
                newUser.setName(givenName);
                newUser.setSurname(familyName);
                newUser.setNickname(email);
                newUser.setLoginId(googleId);

                userFacade.createUser(newUser);
                foundUser = userFacade.findUserByLoginId(googleId);

            } catch (Exception ex) {
                redirectAttributes.addFlashAttribute("alert_warning", "Seems like you are here for the first time..." +
                    "We can not create an account for you now. Try again later, please.");
                return "welcome";
            }
        }

        if(foundUser != null) {
            Long id = foundUser.getId();
            session.setUserId(foundUser.getId());
            session.setAdmin(foundUser.isAdmin());
            session.setUser(foundUser);
            session.setUserIsLoggedIn(true);
        }

        String givenName = (String) payload.get("given_name");
        redirectAttributes.addFlashAttribute("alert_success", "Hello " + givenName + "! You have been successfully logged in");

        return "redirect:/";
    }

    @RequestMapping(value = "/tokensignout", method = RequestMethod.POST, consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String doTokenSignOut(@RequestParam Map<String,String> paramMap,
                                 ModelMap modelMap,
                                 RedirectAttributes redirectAttributes,
                                 UriComponentsBuilder uriBuilder) {

        if(paramMap == null && paramMap.get("idtoken") == null) {
            //Allow to sign out without token - token verification is not possible
            session.setUserId(null);

            redirectAttributes.addFlashAttribute("alert_success", "You have been successfully signed out!");
            return "welcome";
        }

        String token = paramMap.get("idtoken");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jacksonFactory)
                .setAudience(Collections.singletonList(clientId))
                .build();

        GoogleIdToken idToken = null;

        try {
            idToken = verifier.verify(token);
        } catch (GeneralSecurityException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "redirect:" + uriBuilder.path("/user").buildAndExpand().encode().toUriString();
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "redirect:" + uriBuilder.path("/user").buildAndExpand().encode().toUriString();
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "redirect:" + uriBuilder.path("/user").buildAndExpand().encode().toUriString();
        }

        if (idToken == null) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "redirect:" + uriBuilder.path("/user").buildAndExpand().encode().toUriString();
        }
        GoogleIdToken.Payload payload = idToken.getPayload();

        //Get login ID = Google User identifier
        String googleId = payload.getSubject();
        UserDTO foundUser = null;
        try{
            foundUser = userFacade.findUserByLoginId(googleId);
        }catch (NullPointerException e) {
            //this means  that user is null
        }

        if (foundUser == null) {
            redirectAttributes.addFlashAttribute("alert_danger", "Token verification failed! Try again later...");
            return "redirect:" + uriBuilder.path("/user").buildAndExpand().encode().toUriString();
        }

        if(Objects.equals(session.getUserId(),foundUser.getId())) {
            //Token verification successful
            session.setUserId(null);

            redirectAttributes.addFlashAttribute("alert_success", "You have been successfully signed out!");

            userSession.setUserIsLoggedIn(false);
            userSession.setUser(null);
            userSession.setAdmin(false);

            return "welcome";

        }

        return "redirect:/";
    }

    @ModelAttribute(name = "placeForm")
    public PlaceForm addPlaceForm(){return new PlaceForm();}

    @ModelAttribute(name = "places")
    public List<PlaceDTO> addPlaces(){return placeFacade.getAllPlaces();}

    @ModelAttribute(name = "userSession")
    public UserSession addUserSession(){
        return userSession;
    }
}