part of 'page.dart';

class ForgotLabel extends StatelessWidget{
  const ForgotLabel({super.key});

  @override
  Widget build(BuildContext context) {
      return TextButton(
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {},
      );
  }

}