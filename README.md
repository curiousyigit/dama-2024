# Instituto Politécnico de Tomar
## Escola Superior de Tecnologia de Tomar
## Mestrado em Engenharia Informática-Internet das Coisas
## Desenvolvimento de Aplicações Móveis Avançadas
## Projeto de Aluno: Shoaib Feda 20895
<br><br>
# Backend (REST API)
- Built using Laravel 11
- Uses following packages:
    - Laravel Sanctum (for authentication)
## Endpoints
- POST `/api/auth/register` (must not be authenticated)
    - Description:
        - Create a new user
    - Request Body
        ```
        {
            "name": "Shoaib Feda", // required
            "email": "email@example.com", // required, valid email
            "password": "mypassword", // required, min 6 characters
            "password_confirmation": "mypassword" // required, must match "password"
        }
        ```
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "id": 1,
            "name": "Shoaib Feda",
            "email": "email@example.com",
            "is_admin": 0,
            "created_at": "2024-06-12T17:28:06.000000Z",
            "updated_at": "2024-06-12T17:28:06.000000Z"
        }
        ```
    - Invalid Request Response
        ```
        // HTTP status 422
        {
            "message": "The email has already been taken.",
            "errors": {
                "email": [
                    "The email has already been taken."
                ]
            }
        }
        ```
- POST `/api/auth/token` (must not be authenticated)
    - Description:
        - Create a new authentication token
    - Request Body
        ```
        {
            "email": "email@example.com", // required, valid email
            "password": "mypassword", // required, min 6 characters
            "device_name": "OnePlus 7T" // required
        }
        ```
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "token": "7|W1jW03AMOJ5saYMSvhWkWIE553Bei729K8UVO5KW1751d6fd"
        }
        ```
        You can then supply the token in the `Authorization` header with the "Bearer " prefix to maintain session and access authenticated user only routes. Example: "Bearer 7|W1jW03AMOJ5saYMSvhWkWIE553Bei729K8UVO5KW1751d6fd"
    - Invalid Request Response
        ```
        // HTTP status 422
        {
            "message": "The device name field is required.",
            "errors": {
                "device_name": [
                    "The device name field is required."
                ]
            }
        }
        ```
- GET `/api/auth/user` (must be authenticated)
    - Description:
        - Get currently authenticated user details
    - Request Body
        ```
        {
            "email": "email@example.com", // required, valid email
            "password": "mypassword", // required, min 6 characters
        }
        ```
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "id": 1,
            "name": "Shoaib Feda",
            "email": "email@example.com",
            "is_admin": 0,
            "created_at": "2024-06-12T17:28:06.000000Z",
            "updated_at": "2024-06-12T17:28:06.000000Z"
        }
        ```
- DELETE `/api/auth/tokens` (must not be authenticated)
    - Description:
        - Delete all tokens for the authenticated user (can be used as logout)
        - Does not required a request body
        - Empty response