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
- Use `docker build -t weight-app . && docker run -d --name weight-app -p 8000:8000 -v $(pwd):/var/www weight-app
` to run test docker container
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
- GET `/api/users` (must be authenticated and must be admin)
    - Description:
        - Get all users
        - Authenticated user must be admin
        - Paginated via get parameters (`per_page` & `page`). Both are optional
    - Valid Request Response
        ```
        // http://127.0.0.1:8000/api/users?page=1&paginate=15
        // HTTP status 200
        {
            "current_page": 1,
            "data": [
                {
                    "id": 2,
                    "user_id": 1,
                    "kg": 102,
                    "notes": "My weight in Eid 2",
                    "created_at": "2024-06-12T18:31:10.000000Z",
                    "updated_at": "2024-06-12T18:45:04.000000Z"
                },
                {
                    "id": 3,
                    "user_id": 1,
                    "kg": 102,
                    "notes": "My weight in Eid",
                    "created_at": "2024-06-12T18:44:51.000000Z",
                    "updated_at": "2024-06-12T18:44:51.000000Z"
                }
            ],
            "first_page_url": "http://127.0.0.1:8000/api/weight-entries?page=1",
            "from": 1,
            "last_page": 1,
            "last_page_url": "http://127.0.0.1:8000/api/weight-entries?page=1",
            "links": [
                {
                    "url": null,
                    "label": "&laquo; Previous",
                    "active": false
                },
                {
                    "url": "http://127.0.0.1:8000/api/weight-entries?page=1",
                    "label": "1",
                    "active": true
                },
                {
                    "url": null,
                    "label": "Next &raquo;",
                    "active": false
                }
            ],
            "next_page_url": null,
            "path": "http://127.0.0.1:8000/api/weight-entries",
            "per_page": 15,
            "prev_page_url": null,
            "to": 2,
            "total": 2
        }
        ```
- GET `/api/weight-entries` (must be authenticated)
    - Description:
        - Get all weight entries for authenticated user
        - Paginated via get parameters (`per_page` & `page`). Both are optional
    - Valid Request Response
        ```
        // http://127.0.0.1:8000/api/weight-entries?page=1&paginate=15
        // HTTP status 200
        {
            "current_page": 1,
            "data": [
                {
                    "id": 2,
                    "user_id": 1,
                    "kg": 105.39,
                    "notes": "My weight in Eid 2",
                    "created_at": "2024-06-12T18:31:10.000000Z",
                    "updated_at": "2024-06-12T18:45:04.000000Z"
                },
                {
                    "id": 3,
                    "user_id": 1,
                    "kg": 102,
                    "notes": "My weight in Eid",
                    "created_at": "2024-06-12T18:44:51.000000Z",
                    "updated_at": "2024-06-12T18:44:51.000000Z"
                }
            ],
            "first_page_url": "http://127.0.0.1:8000/api/weight-entries?page=1",
            "from": 1,
            "last_page": 1,
            "last_page_url": "http://127.0.0.1:8000/api/weight-entries?page=1",
            "links": [
                {
                    "url": null,
                    "label": "&laquo; Previous",
                    "active": false
                },
                {
                    "url": "http://127.0.0.1:8000/api/weight-entries?page=1",
                    "label": "1",
                    "active": true
                },
                {
                    "url": null,
                    "label": "Next &raquo;",
                    "active": false
                }
            ],
            "next_page_url": null,
            "path": "http://127.0.0.1:8000/api/weight-entries",
            "per_page": 15,
            "prev_page_url": null,
            "to": 2,
            "total": 2
        }
        ```
- POST `/api/weight-entries` (must be authenticated)
    - Description:
        - Create a new weight entry for the authenticated user
    - Request Body
        ```
        {
            "kg": 76.31, // required
            "notes": "Was measured while at the university" // optional
        }
        ```
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "data": {
                "id": 2,
                "user_id": 1,
                "kg": 76.31,
                "notes": "Was measured while at the university",
                "created_at": "2024-06-12T18:31:10.000000Z",
                "updated_at": "2024-06-12T18:45:04.000000Z"
            }
        }
        ```
    - Invalid Request Response
        ```
        // HTTP status 422
        {
            "message": "The kg field is required.",
            "errors": {
                "kg": [
                    "The kg field is required."
                ]
            }
        }
        ```
- GET `/api/weight-entries/1` (must be authenticated)
    - Description:
        - Get the weight entry
        - If authenticated user is not the owner of the weight entry, a 403 Unauthorized response will be returned
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "data": {
                "id": 2,
                "user_id": 1,
                "kg": 76.31,
                "notes": "Was measured while at the university",
                "created_at": "2024-06-12T18:31:10.000000Z",
                "updated_at": "2024-06-13T18:45:04.000000Z"
            }
        }
        ```
- PATCH `/api/weight-entries/1` (must be authenticated)
    - Description:
        - Edit the weight entry
        - If authenticated user is not the owner of the weight entry, a 403 Unauthorized response will be returned
    - Request Body
        ```
        {
            "kg": 73.31, // required
            "notes": "Was measured while at the university. Corrected" // optional
        }
        ```
    - Valid Request Response
        ```
        // HTTP status 200
        {
            "data": {
                "id": 2,
                "user_id": 1,
                "kg": 73.31,
                "notes": "Was measured while at the university. Corrected",
                "created_at": "2024-06-12T18:31:10.000000Z",
                "updated_at": "2024-06-13T18:45:04.000000Z"
            }
        }
        ```
    - Invalid Request Response
        ```
        // HTTP status 422
        {
            "message": "The kg field is required.",
            "errors": {
                "kg": [
                    "The kg field is required."
                ]
            }
        }
        ```
- DELETE `/api/weight-entries/1` (must be authenticated)
    - Description:
        - Delete the weight entry
        - If authenticated user is not the owner of the weight entry, a 403 Unauthorized response will be returned
        - Empty response