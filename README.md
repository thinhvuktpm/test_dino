# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  2.4.2
* System dependencies
  sidekiq, ftp,...
* Configuration FTP
  ```
  FTP:
  download:
    ftp:
      host: '127.0.0.1'
      username: 'thinhvu'
      password: '123456'
      dir: data_test_dino # th
    encoding: sjis
    linefeed: CRLF
  ```
* Database use
  postgresql
  
* Services (backgroud job)
  tải file từ ftp về sau đó tiến hành import và tính điểm cho player
* link API
- /api/v1/tournaments/import
  Method:POST
  Use param:
  ```
  {
	"admin": "name admin"
  }
  ```
- /api/v1/tournaments/search
  Method: GET
  use param:
  ```
  {
	"match_code": "tournament_9_ball",
	"player_name": "Douglas"
  }
  ```
- /api/v1/players/infor_player
  Method: GET
   ```
  {
  	"player_name": "Douglas"
  }
  ```
