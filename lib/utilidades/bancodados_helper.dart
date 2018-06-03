import 'dart:async';
import 'dart:io';

import 'package:flutter_23_introducao_sqlite/models/usuario.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BancodadosHelper {
  static final BancodadosHelper _instancia = new BancodadosHelper.interno();

  // Toda a vez que essa classe for chamada, fara com que seja retornado o atributo _instancia
  factory BancodadosHelper() => _instancia;

  final String tabelaUsuario = "usuario";
  final String colunaId = "id";
  final String colunaNome = "nome";
  final String colunaSenha = "senha";

  static Database _bd;

  Future<Database> get bd async {
    if (_bd != null) {
      return _bd;
    }

    _bd = await inicializaBd();

    return _bd;
  }

  // Construtor privado
  BancodadosHelper.interno();

  inicializaBd() async {
    Directory diretorioDocumento = await getApplicationDocumentsDirectory();
    String caminho = join(diretorioDocumento.path,
        "bancoprincipal.bd"); // /home://directory/files/bancoprincipal.bd

    var nossoBd =
        await openDatabase(caminho, version: 1, onCreate: _quandoCriar);

    return nossoBd;
  }

  /**
   * Quando a tabela for criada, havera um tabela com id, usuario e senha
   */
  void _quandoCriar(Database bd, int versao) async {
    await bd.execute(
        "CREATE TABLE $tabelaUsuario($colunaId INTEGER PRIMARY KEY, $colunaNome TEXT, $colunaSenha TEXT)");
  }

  // salva o usuario
  Future<int> gravaUsuario(Usuario usuario) async {
    var clienteDb = await bd;

    int resultado = await clienteDb.insert("$tabelaUsuario", usuario.toMap());
    return resultado;
  }

  // Obtem todos os usuarios
  Future<List> obtemTodosUsuarios() async {
    var clienteDb = await bd;
    var resultado = await clienteDb.rawQuery("SELECT * FROM $tabelaUsuario");

    return resultado.toList();
  }

  Future<int> obtemQuantidade() async {
    var clienteDb = await bd;
    return Sqflite.firstIntValue(
      await clienteDb.rawQuery(
        "SELECT COUNT(*) FROM $tabelaUsuario"
      )
    );
  }

  Future<Usuario> obtemUsuario(int id) async {
    var clienteDb = await bd;

    var resultado = await clienteDb.rawQuery(
      "SELECT * FROM $tabelaUsuario WHERE $colunaId=$id"
    );
    
    if(resultado.length == 0){
      return null;
    }else{
      return new Usuario.fromMap(resultado.first);
    }
    
    
  }

  Future<int> removeUsuario(int id) async {
    var clienteDb = await bd;

    return await clienteDb.delete(tabelaUsuario,
        where: "$colunaId = ?",
        whereArgs: [id]);
  }

  Future<int> atualizaUsuario(Usuario usuario) async {
    var clienteDb = await bd;
    return await clienteDb.update(
        tabelaUsuario,
        usuario.toMap(),
          where: "$colunaId = ?",
          whereArgs: [usuario.id]
    );
  }

  Future finalizar() async {
    var clienteDb = await bd;
    return clienteDb.close();
  }
  
}
