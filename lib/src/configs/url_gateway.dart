
class Uri {
  String port;
  String host;
  String uri;

  Uri() {
    this.port = '3000';
    this.host = '104.154.23.227';
    this.uri = 'corrientazo/api/ms-gateway';

  }
  String getUri() {
    String url = 'http://$host/$uri';
    return url;

  }
  
  }
