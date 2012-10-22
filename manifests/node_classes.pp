class base(){
  include stdlib
  include common
}

class downloader(){ 
  include base
  include sabnzbd
}

class rabbit(){
  include rabbitmq
}
