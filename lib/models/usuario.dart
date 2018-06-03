class Usuario {

  int _id;
  String _nome;
  String _senha;

  //Construtor
  Usuario(this._nome,this._senha);

  Usuario.map(dynamic obj){
    this._nome = obj['nome'];
    this._senha = obj['senha'];
    this._id = obj['id'];
  }

  // Getters
  String get nome => _nome;
  String get senha => _senha;
  int get id => _id;

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['nome'] = _nome;
    map['senha'] = _senha;

    if(id != null){
      map['id'] = _id;
    }

    return map;
  }

  Usuario.fromMap(Map<String, dynamic> map){
    this._nome = map['nome'];
    this._senha = map['senha'];
    this._id = map['id'];
  }

}