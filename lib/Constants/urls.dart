const String baseUrl = "https://money-boi.herokuapp.com/api";

// const String baseUrl = "http://192.168.0.157:3000/api";

/*
POST 
example body:
 {
    "email": "email@gmail.com", (requried)
    "password": "password" (required)
}
*/
const String loginEndPoint = "/auth";

/*
POST 
example body:
{
    "name": "Person", (requried)
    "email": "person@gmail.com", (required)
    "password": "password" (required)
}
*/
const String signupEndPoint = "/users";
