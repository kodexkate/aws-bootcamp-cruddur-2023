# Week 5 — DynamoDB and Serverless Caching

I focused on data modelling a direct messaging system using a single table design.
Here are the steps I took:

1. Identified the data entities: I started by identifying the data entities that are needed for a direct messaging system. These entities include users, messages, and conversations.
2. Determined the relationships between entities: I then determined the relationships between these entities. For instance, a user can send and receive messages, and a message can belong to a conversation.
3. Defined the attributes for each entity: After determining the relationships, I defined the attributes for each entity. For users, attributes may include username, password, and email address. For messages, attributes may include the message content, timestamp, and sender/receiver IDs. For conversations, attributes may include conversation ID, participants, and message IDs.
4. Designed a single table schema: Instead of creating separate tables for each entity, I designed a single table schema that includes all the entities and their respective attributes. This schema would eliminate the need for complicated joins across multiple tables.
5. Normalized the data: To ensure data integrity and consistency, I normalized the data by removing any redundant or duplicate data. I ensured that each column in the table represents a single data element.
6. Tested the data model: Finally, I tested the data model by inserting sample data and running queries to ensure that the data is being stored and retrieved correctly.

``` 
![Image 5-7-23 at 4 41 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/ae085e5a-f213-4366-9817-151a38fcd59c)
``` 


``` 
![Image 5-9-23 at 12 37 PM](https://github.com/kodexkate/aws-bootcamp-cruddur-2023/assets/122316410/51ba6792-44b2-4141-863e-7304265d8000)

```
