import 'package:flutter/material.dart';
import 'package:flutterr/models/user.model.dart';
import 'package:flutterr/services/image.dart';
import 'package:flutterr/services/userdao.dart';

class UserDetailPage extends StatelessWidget {
  final String id;
  final String photoTag;
  final String picturePath;

  UserDetailPage({@required this.id, this.picturePath, this.photoTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User\'s detail')),
        body: UserDetail(
            id: this.id,
            picturePath: this.picturePath,
            photoTag: this.photoTag));
  }
}

class UserDetail extends StatefulWidget {
  final String id;
  final String photoTag;
  final String picturePath;

  UserDetail({@required this.id, this.picturePath, this.photoTag});

  @override
  UserDetailState createState() => UserDetailState(
      id: this.id, picturePath: this.picturePath, photoTag: this.photoTag);
}

class UserDetailState extends State<UserDetail> {
  final String id;
  String picturePath = '';
  String photoTag = '';

  final _formKey = GlobalKey<FormState>();

  ImageService _imageService = ImageService();
  UserDao _dao = UserDao();
  User _user = User();

  UserDetailState({@required this.id, this.picturePath, this.photoTag}) {
    if (this.photoTag == null) {
      this.photoTag = '';
    }
  }

  @override
  void initState() {
    super.initState();
    if (this.id != 'new') {
      this._dao.getUserById(this.id).then((user) {
        _user.from(user);
        setState(() {
          picturePath = user.picture;
        });
      });
    }
  }

  Future pickImage() async {
    String url = await this._imageService.getImage();
    if (url != null) {
      setState(() {
        picturePath = url;
      });
    }
  }

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this._user.picture = this.picturePath;
      if (this.id != 'new') {
        this
            ._dao
            .updateUser(this.id, this._user)
            .then((res) => Navigator.pop(context));
      } else {
        this._dao.insertUser(this._user).then((res) => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                  onTap: pickImage,
                  child: Hero(
                      tag: 'photo' + this.photoTag,
                      child: Material(
                          child: Image.network(picturePath,
                              width: 64.0, height: 64.0)))),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                initialValue: _user.firstName,
                onSaved: (text) {
                  _user.firstName = text;
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                initialValue: _user.lastName,
                onSaved: (text) {
                  _user.lastName = text;
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                initialValue: _user.description,
                onSaved: (text) {
                  _user.description = text;
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                initialValue: _user.email,
                onSaved: (text) {
                  _user.email = text;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: this.submit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
