const String baseUrl = "https://moneyboi-backend.herokuapp.com/api";

// const String baseUrl = "http://192.168.0.123:3000/api";

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

/*
GET 
Auth Required : yes,
example body:
{
    "date_in": <utc date string> (optional),
    "date_out":<utc date string> (optional),
}
*/
const String expenseRecordsListingEndPoint = "/expenses";

/*
POST 
Auth Required : yes,
example body:
{
    "category": "Alcohol",
    "amount": 500,
    "record_date": <utc date string>
}
*/
const String expenseRecordCreateEndPoint = "/expenses";


/*
GET 
Auth Required : yes,
example body:

*/
const String profileGetEndPoint = "/users/me";
