# Week 5 — DynamoDB and Serverless Caching

## DynamoDB shell commands for this week

   [`schema-load`]: this creates a table in my `dynamodb-local db`
   
   [`list-tables`]: after loading my schema, I wrote a script to list my tables
   
   [`seed`]: add items to ddb table
   
   [`drop`]: successfully deletes a ddb table when you provide the file name
   
   [`scan`]: to scan (_return all items in table_) the ddb table
   
   [`get-conversations`]: will show user's conversations
   
   [`list-conversations`]: shows user's conversation
   
   [`update-cognito-user-ids`]: uses the AWS SDK, boto3 to interact with Cognito and obtains the user's `UUID` then updates the user's table with that info.


## **Data Modelling a Direct Messaging System using Single Table Design**

**I identified the necessary data entities, determined their relationships, defined their attributes, and designed a single table schema. I normalized the data to ensure data integrity and tested the model by inserting sample data and running queries to verify that data was stored and retrieved correctly. I changed the usernames to the ones in both of my Cruddur accounts and changing these caused quite a bit of confusion! I had to change the preferred usernames via AWS and this allowed me to not get the accounts mixed up.** 

![Image 5-9-23 at 4 45 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/d5693adf-58f9-4bfa-881f-5179c93de780)

**Even after running ./bin/db/update_cognito_user_ids the cognito user id was not updating, so it remained to display 'MOCK'. I couldn't figure out why this was not updating,so I decides to return to this issue later.**


![Image 5-9-23 at 5 09 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/b70a623f-af4f-4678-8d05-2ab74afa9e2d)



A temp fix for the token error causing the app not to display any messages is due to the message token. I added the this line for the header to the [`MessageGroupsPage.js`], [`MessageGroupPage.js`], and the [`MessageForm.js`]

```js
headers: {
          Authorization: `Bearer ${localStorage.getItem("access_token")}`
        }
```


**I was finally able to see data on the homepage without any issues.**


![Image 5-9-23 at 5 35 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/4847158d-f808-4b54-9da0-dc02a6db593e)

![Image 5-9-23 at 4 57 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/e498071c-1d8f-4fd1-bf4a-851cd9dd4b05)

## Implementing DynamoDB query using Single Table Design

**I identified the required data entities, determined the relationships, defined their attributes, designed a single table schema, created indexes, and implemented the query using the DynamoDB API. The single table design simplified the data structure and made it easier to manage indexes, resulting in improved query performance.** 

- **I replaced codes in;**

`backend-flask/app.py` (mainly, instead of using `"/api/messages/@<string:handle>"`, use `"/api/messages/<string:message_group_uuid>"`)

`backend-flask/services/message_groups.py`

`backend-flask/services/messages.py`


**I created and changed codes in;**

Created `backend-flask/db/sql/users/uuid_from_cognito_user_id.sql`

Changed `backend_url` from using `${handle}` to `${params.message_group_uuid}` in `frontend-react-js/src/pages/MessageGroupPage.js`

Changed path from `"/messages/@:handle"` to `"/messages/:message_group_uuid"` in `frontend-react-js/src/App.js`

Change `params.handle` to `params.message_group_uuid` and `props.message_group.handle` to `props.message_group.uuid` in `frontend-react-js/src/components/MessageGroupItem.js`


**For this week I updated the code to the frontend file:**

created `frontend-react-js/src/lib/CheckAuth.js` 

`frontend-react-js/src/pages/HomeFeedPage.js`

`frontend-react-js/src/pages/MessageGroupPage.js`

`frontend-react-js/src/pages/MessageGroupsPage.js`

`frontend-react-js/src/components/MessageForm.js`

Updated the content for `body` in `frontend-react-js/src/components/MessageForm.js`

Updated function `data_create_message` in `backend-flask/app.py`

Updated `backend-flask/services/create_message.py` 

Created `backend-flask/db/sql/users/create_message_users.sql`

Imported `MessageGroupNewPage` from `./pages/MessageGroupNewPage` and add the corresponding router in `frontend-react-js/src/App.js`

Created `frontend-react-js/src/pages/MessageGroupNewPage.js`

Created `frontend-react-js/src/components/MessageGroupNewItem.js`

Add the endpoint and function for user short in `backend-flask/app.py`

Created `backend-flask/services/users_short.py`

Created `backend-flask/db/sql/users/short.sql`

Updated `frontend-react-js/src/components/MessageGroupFeed.js`

Updated `frontend-react-js/src/components/MessageForm.js`


## Provisioning DynamoDB tables with Provisioned Capacity

I identified the table's required read and write capacity and set the provisioned capacity accordingly. I monitored the table's capacity usage and adjusted it as needed to maintain optimal performance. Provisioning capacity enabled me to ensure that the table could handle the required traffic and maintain low latency.


## Utilizing a Global Secondary Index (GSI) with DynamoDB

I identified the table's access patterns and created a GSI that would enable me to query the data efficiently based on specific attributes. I configured the GSI to include the required attributes and provisioned read and write capacity to handle the expected traffic. I then tested the GSI by running queries and verified that the results were correct. The GSI allowed me to access the data quickly and reduced the complexity of the query process.

## Rapid data modelling and implementation of DynamoDB with DynamoDB Local

 I identified the required data entities, their relationships, and defined their attributes. I then designed a single table schema that would enable me to store and retrieve the data efficiently. I used DynamoDB Local to create a local development environment, which allowed me to test the data model and implementation without incurring any costs. I inserted sample data and ran queries to verify that data was stored and retrieved correctly. 


## Writing utility scripts to easily setup and teardown and debug DynamoDB data

I identified the required scripts, including scripts to create tables, insert sample data, query data, and delete tables. I used the AWS SDK to interact with DynamoDB and implemented error handling and logging to aid in debugging. The utility scripts allowed me to automate the setup and teardown process and enabled me to easily test and debug the data model and implementation. 






