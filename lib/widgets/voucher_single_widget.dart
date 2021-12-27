import 'package:flutter/material.dart';

class VoucherSingleWidget extends StatefulWidget {
  final String discount;
  final String name;
  VoucherSingleWidget({required this.name, required this.discount});

  @override
  _VoucherSingleWidgetState createState() => _VoucherSingleWidgetState();
}

class _VoucherSingleWidgetState extends State<VoucherSingleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        //color: HexColor.fromHex("#336699"),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          leading:
          Image.asset(
            "./images/voucher.jpeg",
            width: 75,
            height: 50,
            //color: Colors.white,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.name,
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)

              ),
              const SizedBox(height: 4),
              Text(widget.discount.toUpperCase() + "%", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
              ),

            ],
          ),
          onTap: () {},
        ),
      ),
    );  }
}
