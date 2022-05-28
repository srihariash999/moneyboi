import 'package:flutter/foundation.dart';

const String baseUrl = kDebugMode
    ? "http://192.168.0.133:3000/api"
    : "https://moneyboi-backend.herokuapp.com/api";

// const String baseUrl = "http://192.168.0.133:3000/api";

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

/*
POST

Auth Required : no,
example body:
{  
    "email": "person@email.com"   (requried)
}

*/

const String forgotPasswordOtpGetEndPoint =
    "/users/forgotpassword/otp/generate";

/*
POST

Auth Required : no,
example body:
{  
    "email"        : "person@email.com"   (requried),
    "otp"          : "1234"   (requried),
    "new_password" : "qwerty123"   (requried)
}

*/

const String forgotPasswordOtpVerifyEndPoint =
    "/users/forgotpassword/otp/verify";

/*
GET

Auth Required : yes,

query params: none.

*/

const String getFriendsListEndPoint = "/friends";

/*
GET

Auth Required : yes,

query params: none.

*/

const String getPendingActionsFriendsListEndPoint = "/friends/pending_action";

/*
POST

Auth Required : yes,

body {
  "id" : <String>  (required) 
}

*/

const String acceptFriendRequestEndPoint = "/friends/accept_request";

/*
POST

Auth Required : yes,

body {
  "email" : <Email>  (required) 
}

*/

const String sendFriendRequestEndPoint = "/friends/";

/*
DELETE

Auth Required : yes,

:id  = <String> (required)

*/

const String deleteFriendRequestEndPoint = "/friends/delete_request";
