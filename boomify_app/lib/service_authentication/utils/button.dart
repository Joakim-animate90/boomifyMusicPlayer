part of 'page.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
            textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, color: Colors.lightBlueAccent))),
        onPressed: () {},
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
