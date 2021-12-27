import 'dart:async';
import 'dart:convert';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:intl/intl.dart';

import 'detail/detail_product_screen.dart';

class SearchScreen extends StatefulWidget {
   String query;
  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> list = [];
  List<Products> products = [];
  //List<Book> books = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    //init();
    getData(widget.query);
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }


  String replaceWhitespacesUsingRegex(String s, String replace) {
    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more
    var pattern = RegExp('\\s+');
    return s.replaceAll(pattern, replace);
  }



  Future<List<Products>> getData(String query) async {
    print("KEYWORD IS: "+query);
    query = query.trim().replaceAll(RegExp('\\s+'), ' ');
    print("query after replace: "+query);
    List<Product> list2 = [];
    List<Products> products2 = [];
    if(query.trim().isNotEmpty
        && query.contains(RegExp(r'^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$'))
    || query.contains(RegExp(r'^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$'))
        || query.contains(RegExp(r'^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$'))
        || query.contains(RegExp(r'^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+[T ]+[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$'))
        ) {
      final url = Uri.parse(
          '${AppUrl.baseUrl}/api/products?keyword=$query');
      print("URL  "+url.toString());


      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode("[${response.body}]");

        setState(() {
          for (Map<String, dynamic> i in data) {
            list2.add(Product.fromJson(i));
          }

          var result = list2[0];
          products2 = result.data.products;
        });
      }
      setState(() {
        list = list2;
        products = products2;
        widget.query = "";
      });

      return products;
    } else {
      setState(() {
        list = list2;
        products = products2;
        widget.query = "";
      });

      return products;
    }

  }

  //
  // Future init() async {
  //   print("ABCDUASIDHOADHAOD");
  //   final List<Products> books = await SearchApi.getBooks(query);
  //
  //   setState(() => this.products = books);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: widget.query.isNotEmpty ? Text("Search Result For '${widget.query}'", style: TextStyle(color: Colors.white),) : Text("Search Result For '${query}'", style: TextStyle(color: Colors.white),),
      centerTitle: true,
      backgroundColor: Colors.deepOrangeAccent,
    ),
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: products.isEmpty ? Text("No result for this keyword. Please type another keyword", style: TextStyle(color: Colors.black),)
              : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final book = products[index];

              return buildBook(book);
            },
          ),
        ),
      ],
    ),
  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Name of product...',
    onChanged: searchBook,
  );

  Future searchBook(String query) async => debounce(() async {
    final books = await getData(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.products = books;
    });
  });

  Widget buildBook(Products book) => ListTile(
    leading: img.Image.network(
      book.images[0].url,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(book.name),
    subtitle: Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(book.price)}"),
    onTap: () {
      PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
        data: book,
      ));
    },
  );
}



class SearchApi {
  static Future<List<Products>> getBooks(String query) async {
    final url = Uri.parse(
        '${AppUrl.baseUrl}/api/products?keyword=$query');
    final response = await http.get(url);

    List<Product> list = [];
    //List<Products> products = [];
    if (response.statusCode == 200) {
       List books = jsonDecode("[${response.body}]");
        for (Map<String, dynamic> i in books) {
          list.add(Product.fromJson(i));
        }
//print("LIST : "+list[0].toString());
        var result = list[0];
        List products = result.data.products;
        print("PRODUCT LIST: "+products[0].toString());
      return products.map((json) => Products.fromJson(json)).where((product) {
        final nameLower = product.name.toLowerCase();
        //final authorLower = book.author.toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}




class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    String validate(String value) {
      if (value.isNotEmpty && value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
        return value;
      }
      return "Invalid keyword. Please type another keyword valid";
    }

    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
            child: Icon(Icons.close, color: style.color),
            onTap: () {
              controller.clear();
              widget.onChanged('');
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
         // errorText: validate(controller.text)
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
