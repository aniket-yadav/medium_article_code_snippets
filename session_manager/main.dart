
void main() {
  SessionManager().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: SessionManager().isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return HomePage();
            } else {
              return LoginPage();
            }
          } else {
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  // Call the login API here
                  final userName = "John Doe";
                  final token = "token123";
                  SessionManager().login(email, token, userName);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome'),
            FutureBuilder<Map<String, String>>(
              future: SessionManager().getUserDetails(),
                              builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Text('Email: ${snapshot.data['email']}'),
                        Text('Name: ${snapshot.data['userName']}'),
                      ],
                    );
                  } else {
                    return LoadingIndicator();
                  }
                },
              ),
            RaisedButton(
              onPressed: () {
                SessionManager().logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}


