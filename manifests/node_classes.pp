class base(){
  include stdlib
  include common
}

class media_server(){ 
  include base
  include sabnzbd
  include couchpotato
  include sickbeard
  include headphones
}

class rabbit(){
  include rabbitmq
}
