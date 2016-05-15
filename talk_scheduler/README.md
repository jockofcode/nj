## Build Conference management software

You are orgnazing the next RubyConference Miami. Here are the rules.

1. Since it is a regional conference it will have only two parallel tracks.

2. Morning session for both tracks begins at 9 AM.

3. Lunch begins at 12 noon so talk should end by noon.

4. After lunch session begins at 1 PM.

5. The session cannot go after 5 PM since a networking session starts at
   5 PM.

6. You can assume that when one talk ends then immediately second talk
   starts and there is no break or loss of time.

7. Each ligntning talk is of 5 minutes. The lightning talks listed are the selected lightning talks.

8. All the lightning talks must have happen in a room (can't be split into two rooms)  one after another without any lunch break in between. While lightning talks are happening in track 1 then something else can happen in track 2.

9. This is a one day conference.

10. Typically, the 2 parallel tracks happen in two separate rooms and the lightning talks happen in a common room (often the 2 separate rooms are combined). For this exercise assume that lighting talk will take place in one of the two rooms and not in a separate common room.

11. Your attempt should be to try to fit as many talks as you can. If you are not able to fit some of the talks then print the list of talks that did not fit so that their speakers can be notified.

I'm looking for one possible solution. There are multiple solutions but we are looking for a solution.

Here are the talks which have been screened and have been qualified.

* Pryin open the black box 60min
* Migrating a huge production codebase from sinatra to Rails 45min
* How does bundler work 30min
* Sustainable Open Source 45min
* How to program with Accessiblity in Mind 45min
* Riding Rails for 10 years lightning
* Implementing a strong code review culture 60min
* Scaling Rails for Black Friday 45min
* Docker isn't just for deployment 30min
* Better callbacks in Rails 5 30min
* Microservices, a bittersweet symphony 45min
* Teaching github for poets 60min
* Test Driving your Rails Infrastucture with Chef 60min
* SVG charts and graphics with Ruby 45min
* Interviewing like a unicorn: How Great Teams Hire 30min
* How to talk to humans: a different approach to soft skills 30min
* Getting a handle on Legacy Code 60min
* Heroku: A year in review 30min
* Ansible : An alternative to chef lightning
* Ruby on Rails on Minitest 30min


#### Here is a sample output :

```
Track 1
09:00 AM Heroku: A year in review 30 min
09:30 AM Microservices, a bittersweet symphony 45 min
10:15 AM Implementing a strong code review culture 60 min
.....
.....

Track 2
09:00 AM Test Driving your Rails Infrastucture with Chef 60 min
......
.......

```


