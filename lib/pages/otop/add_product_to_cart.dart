import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/provider/product_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_otop.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductToCart extends StatefulWidget {
  double price;
  String productImage;
  String productId;
  String productName;
  String description;
  String otopId;
  String otopName;
  List<ProductCartModel> products;
  num width, weight, height, long;
  AddProductToCart({
    Key? key,
    required this.price,
    required this.productImage,
    required this.productId,
    required this.productName,
    required this.description,
    required this.otopId,
    required this.otopName,
    required this.products,
    required this.height,
    required this.long,
    required this.weight,
    required this.width,
  }) : super(key: key);

  @override
  State<AddProductToCart> createState() => _AddProductToCartState();
}

class _AddProductToCartState extends State<AddProductToCart> {
  TextEditingController addition = TextEditingController();
  String userId = AuthMethods.currentUser();
  int amountProduct = 1;
  double totalPrice = 0;
  @override
  void initState() {
    super.initState();
    checkOrderInCart();
  }

  onAddToCart() {
    ProductCartModel product = ProductCartModel(
      productId: widget.productId,
      productName: widget.productName,
      businessId: widget.otopId,
      amount: amountProduct,
      totalPrice: totalPrice,
      price: widget.price,
      businessName: widget.otopName,
      userId: userId,
      addtionMessage: addition.text,
      imageURL: widget.productImage,
      height: widget.height,
      long: widget.long,
      weight: widget.weight,
      width: widget.width,
    );
    SQLiteOtop().addProduct(product);
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.addNewProduct(product);
    Navigator.pop(context);
  }

  checkOrderInCart() {
    if (widget.products.isNotEmpty) {
      amountProduct = widget.products[0].amount;
      totalPrice = widget.price * widget.products[0].amount;
      addition.text = widget.products[0].addtionMessage;
    } else {
      totalPrice = widget.price;
    }
  }

  onUpdateCart() {
    ProductCartModel product = ProductCartModel(
      productId: widget.productId,
      productName: widget.productName,
      businessId: widget.otopId,
      amount: amountProduct,
      totalPrice: totalPrice,
      price: widget.price,
      businessName: widget.otopName,
      userId: userId,
      addtionMessage: addition.text,
      imageURL: widget.productImage,
      height: widget.height,
      long: widget.long,
      weight: widget.weight,
      width: widget.width,
    );
    SQLiteOtop().editProduct(widget.productId, product.userId, amountProduct,
        totalPrice, addition.text);
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.updateProduct(product);
    Navigator.pop(context);
  }

  onDeleteFoodInCart() {
    if (widget.products.isNotEmpty) {
      SQLiteOtop().deleteProduct(widget.productId, userId);
      var productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.deleteProductId(widget.productId, userId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyConstant.backgroudApp,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildImageMenu(width, height),
                buildMenuName(),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 20,
                      ),
                      child: const Text(
                        'รายละเอียดเพิ่มเติม',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        bottom: 20.0,
                        left: 20,
                      ),
                      width: width * .8,
                      child: TextFormField(
                        controller: addition,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'รายละเอียดเพิ่มเติม',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefix: Icon(
                              Icons.account_balance,
                              color: MyConstant.colorStore,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(5),
                            )),
                        style: TextStyle(
                          color: MyConstant.colorStore,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                addAmoutProduct(),
              ],
            ),
          ),
          buildButtonAddtoCart(height)
        ],
      ),
    );
  }

  Row addAmoutProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: amountProduct == 1 && widget.products.isEmpty
              ? null
              : () {
                  if (amountProduct == 1 && widget.products.isNotEmpty) {
                    onDeleteFoodInCart();
                  }
                  setState(() {
                    amountProduct -= 1;
                    totalPrice = widget.price * amountProduct;
                  });
                },
          icon: Icon(
            amountProduct == 1 && widget.products.isNotEmpty
                ? Icons.delete_outline
                : Icons.remove_circle_outline_rounded,
            color: amountProduct == 1 && widget.products.isEmpty
                ? Colors.grey[400]
                : Colors.red,
          ),
          iconSize: 40,
          disabledColor: Colors.grey[400],
        ),
        Text(
          amountProduct.toString(),
          style: TextStyle(
              fontSize: 26,
              color: MyConstant.themeApp,
              fontWeight: FontWeight.w700),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              amountProduct += 1;
              totalPrice = widget.price * amountProduct;
            });
          },
          icon: Icon(
            Icons.add_circle_outline,
            color: Colors.grey[700],
          ),
          iconSize: 40,
        ),
      ],
    );
  }

  Container buildButtonAddtoCart(double height) {
    return Container(
      height: height * 0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'ราคาทั้งหมด',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyConstant.themeApp,
                    ),
                  ),
                  Text(
                    '$totalPrice ฿',
                    style: TextStyle(
                      fontSize: 20,
                      color: MyConstant.themeApp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text(
                  'ใส่ในตะกร้า',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (widget.products.isEmpty) {
                    onAddToCart();
                  } else {
                    onUpdateCart();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: MyConstant.themeApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 6),
              blurRadius: 10,
            ),
          ]),
    );
  }

  Column buildMenuName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: Text(
            widget.productName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: Text(
            widget.description,
            style: const TextStyle(
              fontSize: 18,
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }

  SizedBox buildImageMenu(double width, double height) {
    return SizedBox(
      width: width * 1,
      height: height * 0.3,
      child: Stack(
        children: [
          SizedBox(
            width: width * 1,
            height: height * 0.28,
            child: ShowImageNetwork(
              pathImage: widget.productImage,
              colorImageBlank: MyConstant.themeApp,
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(6.0),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.26),
                width: width * 0.3,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '฿ ${widget.price}',
                      style: TextStyle(
                        color: MyConstant.themeApp,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      '/ชิ้น',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
