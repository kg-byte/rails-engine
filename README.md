
<!-- ABOUT THE PROJECT -->
# Rails Engine
## About This Project
*Rails Engine* is a service-oriented E-Commerce Application that powers that exposes API endpoints for front-end consumption.

<p align="right">(<a href="#top">back to top</a>)</p>

## Features Implemented:

- [x] V1 Endpoints to render the following data serialized by items/merchants serializer:
    - [x] All merchants:
       - [x] ```GET http://localhost:3000/api/v1/merchants```
    - [x] One merchant:
       - [x] ```GET http://localhost:3000/api/v1/merchants/{{merchant_id}}```
    - [x] Items of a merchant:
       - [x] ```GET http://localhost:3000/api/v1/merchants/{{merchant_id}}/items```
    - [x] All items:
       - [x] ```GET http://localhost:3000/api/v1/items```
    - [x] One item:
       - [x] ```GET http://localhost:3000/api/v1/items/{{item_id}}```
    - [x] Create an item:
       - [x] ```POST http://localhost:3000/api/v1/items, params: item_params```
    - [x] Update an item:
       - [x] ```PUT http://localhost:3000/api/v1/items/{{item_id}}, params: item_params```
    - [x] Delete an item:
       - [x] ```DELETE http://localhost:3000/api/v1/items/{{item_id}}```
    - [x] Merchant of an item:
       - [x] ```GET http://localhost:3000/api/v1/items/{{item_id}}/merchant```
    - [x] Find one merchant by name(case insensitive):
       - [x] ```GET http://localhost:3000/api/v1/merchants/find?name=iLl```
    - [x] Find all merchant by name(case insensitive):
       - [x] ```GET http://localhost:3000/api/v1/merchants/find_all?name=iLl```
    - [x] Find one item by name(case insensitive):
       - [x] ```http://localhost:3000/api/v1/items/find?name=hArU```
    - [x] Find all items by name(case insensitive):
       - [x] ```http://localhost:3000/api/v1/items/find_all?name=hArU```
    - [x] Find one item by mininum price:
       - [x] ```http://localhost:3000/api/v1/items/find?min_price=50```
    - [x] Find one item by maximum price:
       - [x] ```http://localhost:3000/api/v1/items/find?max_price=50```
    - [x] Find one item by maximum and miniumprice:
       - [x] ```http://localhost:3000/api/v1/items/find_all?max_price=50&min_price=10```
    - [x] Find all items by mininum price:
       - [x] ```http://localhost:3000/api/v1/items/find_all?min_price=50```
    - [x] Find all items by maximum price:
       - [x] ```http://localhost:3000/api/v1/items/find_all?max_price=50```
    - [x] Find all items by maximum and miniumprice:
       - [x] ```http://localhost:3000/api/v1/items/find_all?max_price=50&min_price=10```
- [x] Edge cases addressed with error serializer:
    - [x] Invalid merchant/item id number
    - [x] No results found when searching all items by name
    - [x] Missing params when using find/find_all for both items/merchants
    - [x] Empty params when using find/find_all for both items/merchants
    - [x] min_price or max_price cannot be negative
    - [x] max_price cannot be less than min_price
 - [x] V2 endpoints:
    - [x] Implemented Users and ApiKeys classes
    - [x] Exposed all V1 endpoints and edgecases while authenticating request via a validAPI key token
    
<p align="right">(<a href="#top">back to top</a>)</p>

## Installation

1. Fork and/or Clone the repo 
  ```
  git clone git@github.com:kg-byte/viewing_party.git
  ```
2. Install gems and dependencies
  ```
   bundle install
  ```
3. Set up db/seed file with the following content:
  ```
  cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)
```
4. Run the following line and you may see lots of output including some warnings/errors from pg_restore that you can ignore. 
  ```
   db:{drop,create,migrate,seed}
  ```
5. Run the following line - Check to see that your schema.rb exists and has the proper tables/attributes that match the data
  ```
  rails db:schema:dump
  ```
7. Run run test suit 
  ```
  bundle exec rspec
  ```
8. Start the server to service API requests:
  ```
  rails s
  ```
  
<p align="right">(<a href="#top">back to top</a>)</p>

## Built With

* [RoR Framework](https://rubyonrails.org/)


<p align="right">(<a href="#top">back to top</a>)</p>

## Versions

- [Ruby 2.7.2](https://www.ruby-lang.org/en/news/2021/07/07/ruby-2-7-4-released/)
- [Rails 5.2.6](https://rubygems.org/gems/rails/versions/5.2.6)

<p align="right">(<a href="#top">back to top</a>)</p>

## Contributors
<p>
  <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" />
</p>

- Author: [Kim Guo](https://www.linkedin.com/in/kim-guo-5331b4158/)


<p>
  <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" />
</p>

- Author: [Kim Guo](https://github.com/kg-byte)


<p align="right">(<a href="#top">back to top</a>)</p>


