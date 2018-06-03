import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_23_introducao_sqlite/models/usuario.dart';
import 'package:flutter_23_introducao_sqlite/utilidades/bancodados_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

List _usuarios;

void main() async {

  var bd = new BancodadosHelper();


  // Adiciona um usuairo
  int usuarioCriado = await bd.gravaUsuario(new Usuario("deleteme", "123"));
  print("Usuario criado com id: $usuarioCriado" );

  int qtd = await bd.obtemQuantidade();
  print("Quantidade de usuarios cadastrados: $qtd");

  // Obtem todos os usuarios;
  _usuarios = await bd.obtemTodosUsuarios();

  for(int i = 0; i < _usuarios.length; i++){
    Usuario usuario = Usuario.map(_usuarios[i]);
    print("Usuario ${usuario.nome} possui o ID ${usuario.id}");
  }

  //print("Removendo ultimo usuario criado com o id $usuarioCriado");
  //print(await bd.removeUsuario(usuarioCriado));

  for(int i = 0; i < _usuarios.length; i++){
    Usuario usuario = Usuario.map(_usuarios[i]);
    print("Usuario ${usuario.nome} possui o ID ${usuario.id} mas seu nome sera a acresentado com 000");

    Usuario usuarioAtualizado = Usuario.fromMap({
      "nome" : "${usuario.nome}000",
      "senha": "${usuario.senha}",
      "id" : usuario.id
    });

    await bd.atualizaUsuario(usuarioAtualizado);
  }

  for(int i = 0; i < _usuarios.length; i++){
    Usuario usuario = Usuario.map(_usuarios[i]);
    print("Usuario ${usuario.nome} possui o ID ${usuario.id}");
  }


  runApp(new MaterialApp(
    title: 'Banco de Dados',
    home: new Inicio(),
  ));
}

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Banco de Dados"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,

      ),
      body: new ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (_,int posicao){
          return new Card(
            color: Colors.white,
            elevation: 2.0,
            child: new ListTile(
              title: new Text("Usuario: ${Usuario.fromMap(_usuarios[posicao]).nome}"),
              subtitle: new Text("Id: ${Usuario.fromMap(_usuarios[posicao]).id}"),
              onTap: () => debugPrint("senha:${Usuario.fromMap(_usuarios[posicao]).senha}"),
            ),
          );
        },
      ),
    );
  }
}
