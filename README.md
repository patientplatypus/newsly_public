# Newsly

# First things first...

# What is this project?

## Overview
  This project is a live updating Reddit clone. What this means is that it allows users to submit articles and comments to those articles, rate each others articles and comments, and have those comments broadcasted to all other users live using web sockets. In practice this means that the user sees their webpage update, without refreshing, live as they are on the page. This app also allows users to upload a picture to Amazon S3 where it will be stored for later retrieval, as well as having a dashboard that will show their "Karma" or total points that other users have given them, in a dashboard. This Karma total also live updates. Essentially this is a full REST api implementation in websockets. I think it is pretty cool!

# Programs I Use
## Why Vue
  1. For those coming from a React background Vue offers many advantages,
  * Redux is now Vuex and react-router-dom now is router-link. No more worrying about third party library support, or competing/outdated versioning, for these necessary tools.
  * Vuex contains stateful saving of objects whereas Redux reducers save objects inside Case/Switch statements. This can lead to edge case shadowing of Reducer objects and lead to very difficult reasoning for the developer.
  * Vue has an EventBus as a first level abstraction from the Vue object. This allows scoped sharing of variables between components without using Vuex or dealing with props callback hell. Incredibly useful!
  * Mapping subcomponents to be rendered as children can be awkward in React, and renderIf is not a native component (although this is more awkward than deal breaking). Now both of these features are intuitively defined as `v-for` and `v-if`
  2. For those coming from an Angular background,
  * No use of JSX, everything is in native HTML with javascript living in a object under the template.
  * [Vue is Gaining Popularity](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176)

## Why Phoenix
 - Phoenix is a cool functional programming language that is build on Elixir which is itself built on Erlang (which uses the BEAM vm). As Erlang was originally a routing language designed to be used for telephone routing in the early 70s it allows for high amounts of routing.
 - Phoenix is an opinionated framework, like Rails, which allows for neat generator functions which makes life easier, as well as a nice boilerplate structure tor work with.
 - Because the Rails ORM has high cost per read/write operation it does not scale as well as it could. It is a good language to learn on, but not necessarily to grow with in a modern approach. Phoenix has the benefit of the symantics of Rails without the cost.
 - Phoenix is growing in popularity.
 - Learning new languages is fun!


# How this Program is Organized
## Programming Spec
![Screenshot](/NewslyProgramSpecs.jpg?raw=true "Program Specs")
1. The above may seem complicated at first, but treat it as a reference as you walk through the application. The entrypoint for the frontend is App.js, and the back should be the Router file or the User Socket/Room Channel. If you start at one of these two locations the above should point every component to every other component and allow you to step through the logic.
2. There are a few big picture takeaways that should be immediately apparent from the above organization
* Vue App is on the left, and Phoenix is on the right, separated by the HTTP/socket pipes connecting them.
* Vue diagram is program down by components on the top and Vuex (state management) on the bottom
* Phoenix is organized by MVC pattern and a link to AWS.
3. Remember this diagram is here as an aid to understanding. If it is not useful, do not use it!
##Deployment Spec
![Screenshot](/DeploymentDiagram.jpg?raw=true "Deployment Specs")
1. The first step to run this project is to run the Phoenix backend.
* First you build the dockerfile and send it to EC2 Container Service.
* Next you send the dockerrun file to EB ALB through a deploy or create command (make sure create commands have a timeout >10 minutes, if the project takes longer than that to load). You can choose to send the Dockerfile and the Dockerrun to the EB ALB if you don't want to store it, but this is ill advised (make sure that the Dockerfile is formatted for this). Also, make sure you turn off NGINX! It's a php router (seemingly), that is very powerful (I'm told), but it doesn't play nice with phoenix in this build.
2. Traffic is routed through my Digital Ocean DNS in the newsly.q8z8p.net CNAME, and then it goes to the EB ALB EC2 t2.micro instance, where the Docker image is now stored. In my phoenix code I called out RDS and S3 services. Since this code is now dockerized, the traffic coming from the frontend will hit the EC2 instance, see the docker route to those buckets and route back the information. Neat!

# Useful Bash Commands
## For the Phoenix Backend
1. To *typically* start a phoenix backend you would perform the following commands. (We don't do that in this case as we use a Dockerfile)

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
2. Generators!
- To get datatables in postgres (clear the database and remigrate all data models): `sudo mix do ecto.drop, ecto.create, ecto.migrate`
- To generate models (example): `mix phx.gen.schema Articles article user:string articleurl:string articletitle:string upvotes:integer downvotes:integer flaggedcount:integer`
- Another example: `mix phoenix.gen.html Comments comment body:string user:string upvotes:integer downvotes:integer flaggedcount:integer article_id:references:article`
- For further generator commands please see the Phoenix documentation.

## For the Vue.js Frontend
1. To install **a** vue project (from scratch):
* npm install -g vue-cli
* vue init webpack vueapp01
2. To spin up **this** frontend: `npm install, npm run dev`
3. [To move to production](https://stackoverflow.com/questions/42936588/how-to-deploy-vue-app)


# Programming Documentation
- Vue documentation is first in-class and an excellent resource: [Vue Docs](https://vuejs.org/v2/guide/)
- Phoenix Documentation as well: [Phoenix Docs](https://hexdocs.pm/phoenix/Phoenix.html)
- Because Phoenix is built on elixir it is useful to have a cheatsheet on how to use basic functionality. This will go from the basics of `IO.puts` to advanced GNServe models. [Elixir School](https://elixirschool.com/en/)
- Documentation for the Ecto model (the 'go-to' library that handles database storage in Phoenix): [Ecto Docs](https://hexdocs.pm/ecto/Ecto.html)


# Deployment
## Docker Commands
- [Docker Commands](https://github.com/dreamingechoes/docker-elixir-phoenix). This implementation is a little more verbose than docker packages that come with elixir pre-installed, but it has a few benefits. It allows you to have more granularity and less magic in the dockerfile as the image is a clean Ubuntu build (much less magical - allowing for easier hacking) and the repo has all the commands described very nicely.


# Other Useful Links on How to Do Things
- [Deploying Elixir to AWS Elastic Beanstalk with Docker](https://robots.thoughtbot.com/deploying-elixir-to-aws-elastic-beanstalk-with-docker). Generally speaking Docker documentation is *not* first class and the tooling has a very non-orthogonal topology (many ways to do many things), even though the tool is very useful and cool. For more help, it is advisable to ask on **IRC @ freenode#Docker**
- It is also possible to deploy using a service called [Nanobox](nanobox.io), which I have done in the past for a previous application [NotaHotdog](pennydrop.nanobox.io). You can learn more here:
[How to Deploy Phoenix Applications to AWS Using Nanobox](https://content.nanobox.io/how-to-deploy-phoenix-applications-to-aws-using-nanobox/)
- Somewhat surprisingly uploading pictures to S3 with Phoenix is a well documented problem. Here is one (of many) blog posts on the topic [Upload Files to S3 With Phoenix and Ex_Aws](https://alexgaribay.com/2017/01/20/upload-files-to-s3-with-phoenix-and-ex_aws-2/)
- Phoenix uses a non-intuitive approach to returning formatted json objects by using the views handlers. Radar on Github was extraordinarily kind enough to provide a working example (which is probably better than what is shown here). If you would like to learn more please see [Radar's Super Cool Example](https://github.com/radar/phoenix-views-example)


# What's Left to Do / Next Steps
1. Currently my picture S3 handling doesn't have an option to delete pictures, that needs to happen.
2. Secure authentication is not yet implemented. This should definitely be done to protect user data.
3. Some refactoring is definitely in order. Major planned revisions include:
* Defmodules in Phoenix Application need to be renamed to be as intuitive as possible
* Track scope of all sockets and see if some can be combined and others eliminated.
4. AWS Docker deployment - this may be a bit of a sticky wicket, so could take a little time.
