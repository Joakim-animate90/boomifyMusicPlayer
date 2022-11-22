part of 'page.dart';


class PassWordField extends StatelessWidget {
  const PassWordField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
     // initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
}
