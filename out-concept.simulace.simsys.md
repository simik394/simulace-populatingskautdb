# Why?
Lets say that I have a database containing prepared activities and educational content for boy scouts group. Its purpose is to serve as a source of inspiration and eventually of collection of high quality content appropriate for kids during our weekly meetings or other occasions. From which source should be easy to get precisely only the desired results based on defined properties on each activity (eg. time needed for preparation, minimal number of players, etc.)
BUT actually its currently more like a proof of concept and not a really operational tool. So accordingly there aren't yet any real records to speak about. 
This very early stage of development is exactly the reason why I think it is reasonable to  think about how will the database be populated with data. As this will be crucial for its future usability and success. Therefore, the simulation should focus on modeling this data population process.

# What?
To be precise, the simulation will be concerned with user behavior and related volume of stored records.
It is important to say that user interface for reading is only the default web gui of the database itself (Neo4j), so the users will have to use the Cypher query language. So after they go through such a way to access the records, there better be some decent amount of useful ones in the database. This is because otherwise their whole effort would be pointless and the user would be discouraged from using the database again.
Creating the records on the other hand will be easy and accessible as much as possible (user writes to google document in specified folder and with specified structure which enables then loading it programmaticaly into the database). This ease of creation is key to encouraging consistent contributions.
And here comes the question whether this "natural" way of data population is enough, or rather how long will it take for the database to be able to provide satisfactory results for the user in majority of the cases and as such could be called a useful tool. If the time required would be too long, the users could lose interest of even contributing new content .  
Therefore, the simulation will model the rate of content creation and the subsequent impact on database searchability and usability.
Additionally will be also evaluated the "batch population approach" to see weather it is worth considering to implement. This will involve creating a model of user behavior and content creation, simulating different scenarios, and analyzing the results. 
# Objectives of the simulation
This simulation aims to predict the growth of the database, determine the feasibility of the current data population strategy and evaluate the alternative.
1. Predict the time needed to reach a critical mass of data sufficient for effective use.
2. Evaluate the effectiveness of the current data population method relatively to alternative.
# users
Example User: me the database developer and admin.
How it would help:
Optimizing Data Population: By simulating different scenarios, I can determine the most efficient way to populate the database with valuable content.
Resource Allocation: The results will inform decisions on whether to prioritize developing a batch upload feature or focus on encouraging individual contributions.
Setting Expectations: The simulation will provide a realistic timeline for when the database will be sufficiently populated for effective use.

# methods/env
NetLogo because of the class requirements. I would rather like to try (learn to do simulations with) Julia because of its broader usability, but I guess it is what it is.

# variables
## deterministic
amount of records in db for each category
- without the batch upload the initial value is 0
number of contributors/agents
- this will be based on real number of leaders in our group
batch upload size
- values 0, 10, 20, 30, 50, 100 will be tried
expected probability of finding useful record by individual agents
- based on previous experiences of agent with searching the db
probability that an agent will try to look up a record
-  will be calculated from a combination of the agent’s past success rate and the current amount of records in db.
quality of record
- number from <1-10>
probability of using any of the found records in the upcoming meeting
- will be calculated from an amount of returned records and their quality
probability of creating new record
- for the sake of simplicity and simulation feasibility the probability will be set to a constant value same for all agents
probability of improving a records quality
- for the sake of simplicity and simulation feasibility the probability will be set to a constant value same for all agents

## random
category of recorded/seeked activity
- category means a certain combination of activity properties ( type{running, creative, thinking, discusion, history}, place{room, forest, city, playground}) 
- the category can combine max 2 types and 1 place
initial quality of created records 
- will be drawn from lognormal distribution with mean 3 and std 2


# simulation behavior
Each tick will represent a single week in real time, because the meeting for which are the activities prepared are realized every week once. Each agent has to prepare some activity for every meeting, so they has a choice to come up with something new or to look for usable activity or at least inspiration in the db. The agents can not use the same activity twice in a year or two.
So in the beginning of each week an agent will pick a random category of an activity which they will prepare for the meeting. 
When the agent decides to search the db, they will be given all records currently present in db that match the category they picked. From those will be calculated the probability of using any of the records in the upcoming meeting and then evaluated. If successful, the agent will pick a random one from them (the higher the quality, the higher probability of picking it). After that, there is a chance that the agent will improve the quality of the picked record (in reality it means for example adding a feedback from the kids).
If they are unsuccessful trying to find a suitable activity in the database, or they decide to not search the db at all, they has a chance of recording (with rnd initial quality) the activity that they created or found elsewhere.
The simulation will then run until the majority of searches in the db are successful.
And also the scenario with the initial batch upload will be simulated as well. 