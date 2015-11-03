# The Scale-Up

Scale an existing Rails app, optimizing for performance and load. A few of the focuses of this project are:

 - Handle a database with large numbers of records
 - Handle heavy request volume/throughput
 - Diagnose and fix performance bottlenecks (without compromising existing features)
 - Moniter production (error and performance) behavior of an application

The original application is already deployed to production, and the goal is to keep them that way, add new features and improve performance while avoiding downtime.

## Production Deployment & Performance Monitering

This app is designed to comfortably handle hundreds of requests per minute with an average response time below 100ms with 600+ RPM (and below 200ms with 400+ RPM).

## Load Testing / User Scripting

In order to evaluate the performance of this application, it can be exposed to heavy load via a load-testing script which exercises as many of the application's endpoints as possible.

User paths include:

 - Anonymous user browses loan requests
 - User browses pages of loan requests
 - User browses categories
 - User browses pages of categories
 - User views individual loan request
 - New user signs up as lender
 - New user signs up as borrower
 - New borrower creates loan request
 - Lender makes loan

## Database Load

In addition to handling heavy request load from users, this application handles database load against a db with large numbers of records. To do this, the various tables in the DB was seeded with lots of records:

 - 500,000+ "Loan Request" records
 - 200,000+ "Borrower" records
 - 30,000+ "Lender" records
 - 50,000+ "Order/Purchase" records
 - Appropriate numbers of "associated records". So if each User has an associated address, then those records should be present in proportional numbers.

An additional goal for this project was to utilize multiple caching techniques along with sophisticated query optimizations and combinations.

----------

## The Original App: Keevahh

Keevahh is a micro-lending platform that allows both lenders and borrowers to interact. Borrowers are able to create a project or loan request and lenders are able to contribute to various projects.

The project specifications can be found [here](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/the_pivot.markdown)

[Find Us Here on Heroku](https://lendkeevahh.herokuapp.com/)

## Working With Data Dumps

### Loading the pre-seeded DB dump

This project includes a rake task to load a pre-seeded
DB dump with all the data you will need. It is currently
stored on Turing's dropbox. To download and import it,
use this rake task:

```
$ rake db:pg_restore
```

### Pushing Data to Heroku

Once you've populated your local DB, you can also push those
records to a heroku instance.

1. Create heroku instance (heroku create)
2. Use `heroku pg:push` to export your local data into
the instance. For example:

```
$ heroku pg:push the_pivot_development DATABASE_URL
```

### Keevahh Contributor Log

* [Markus Olsen](https://github.com/neslom),
* [Trey Tomlinson](https://github.com/treyx)
* [Valentino Espinoza](https://github.com/xvalentino)

## License

The MIT License (MIT)

Copyright (c) [2015]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
