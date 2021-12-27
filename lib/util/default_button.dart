import 'package:flutter/material.dart';
import 'package:flutter_t_watch/util/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.text,
    required this.press,
  });
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      style: text == "Cancel" ? ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFFF31313)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            350,
            50,
          ),
        ),
      ) : ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF6776FF)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            350,
            50,
          ),
        ),
      )
    );
  }
}


class DefaultButtonPay extends StatelessWidget {
  const DefaultButtonPay({
    required this.text,
    required this.press,
  });
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF3E00FF)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            180,
            50,
          ),
        ),
      ),
    );
  }
}


class DefaultButtonCancel extends StatelessWidget {
  const DefaultButtonCancel({
    required this.text,
    required this.press,
  });
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFFF31313)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            180,
            50,
          ),
        ),
      ),
    );
  }
}


class DefaultButtonReceive extends StatelessWidget {
  const DefaultButtonReceive({
    required this.text,
    required this.press,
  });
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF1ED500)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            180,
            50,
          ),
        ),
      ),
    );
  }
}